import 'package:eazybot/api/bot_api.dart';
import 'package:eazybot/constant/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/images.dart';
import '../../constant/string.dart';
import '../../styles/text_styles.dart';
import '../../util/myappbar.dart';
import '../../util/utils.dart';
import 'package:intl/intl.dart';

class BotInsightScreen extends StatefulWidget {
  final int botId;

  const BotInsightScreen({Key? key, required this.botId}) : super(key: key);

  @override
  State<BotInsightScreen> createState() => _BotInsightScreenState();
}

class _BotInsightScreenState extends State<BotInsightScreen> {
  bool isCurrentSession = false;

  Map<String, dynamic>? botData;
  List<dynamic>? botsessionData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([fetchBotDetails(), fetchBotSession()]);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchBotDetails() async {
    try {
      final response = await BotApi().getBotDetails(widget.botId);
      print("API Response: $response");
      setState(() {
        botData = response["data"];
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBotSession() async {
    try {
      final response = await BotApi().getBotSession(
        botId: widget.botId,
        status: "OPEN",
      );
      print("API Response: $response");
      setState(() {
        botsessionData = response["data"];
      });
    } catch (e) {
      print(e);
    }
  }

  String getCurrentISTTime() {
    final nowUtc = DateTime.now().toUtc();
    final istTime = nowUtc.add(const Duration(hours: 5, minutes: 30));

    final hour = istTime.hour.toString().padLeft(2, '0');
    final minute = istTime.minute.toString().padLeft(2, '0');

    return "Today (${hour}h:${minute}m)";
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);

    String day = DateFormat('d').format(date);
    String suffix = getDaySuffix(int.parse(day));

    String formatted = DateFormat("MMM d', yyyy HH:mm").format(date);

    return formatted.replaceFirst(day, "$day$suffix");
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return "th";

    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  Color getStatusColor(String status, String sellOnly) {
    if (status.toLowerCase() == "active" && sellOnly.toLowerCase() == "yes") {
      return const Color(0xFFFACC15); // Yellow
    } else if (status.toLowerCase() == "active") {
      return const Color(0xFF12B76A); // Green
    } else {
      return const Color(0xFFEF4444); // Red
    }
  }

  Color getStatusBgColor(String status, String sellOnly) {
    if (status.toLowerCase() == "active" && sellOnly.toLowerCase() == "yes") {
      return const Color(0xFFFEF9C3); // Light Yellow
    } else if (status.toLowerCase() == "active") {
      return const Color(0xFFD1FADF); // Light Green
    } else {
      return const Color(0xFFFEE2E2); // Light Red
    }
  }

  Color profitColor(dynamic value) {
    double val = double.tryParse(value.toString()) ?? 0;
    return val >= 0 ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text(error!)));
    }

    final size = MediaQuery.of(context).size;

    /// SAFE DATA EXTRACTION
    final bottitle = botData?["title"] ?? "";
    final status = botData?["status"] ?? "";
    final mcr = botData?["mcr"] ?? "";
    final sell_only = botData?["sell_only"] ?? "";
    final cycle_type = botData?["cycle_type"] ?? "";
    final strategy = botData?["strategy"] ?? "";
    final strategy_type = botData?["strategy_type"] ?? "";

    final coin_pair = botData?["coin_pair"] ?? "";
    final base_currency = botData?["base_currency"] ?? "";
    final quote_currency = botData?["quote_currency"] ?? "";
    final exchange = botData?["exchange"] ?? "";
    final exchange_name = botData?["exchange_name"] ?? "";
    final category = botData?["category"] ?? "";
    final created_at = botData?["created_at"] ?? "";
    final runtime = botData?["runtime"] ?? "";
    final active_session_id = botData?["active_session_id"] ?? "";

    final profit = botData?["profit"] ?? {};
    final tradingInfo = botData?["trading_info"] ?? {};

    final today = profit["today"] ?? 'NA';
    final yesterday = profit["yesterday"] ?? 'NA';
    final last_7_days = profit["last_7_days"] ?? 'NA';
    final last_30_days = profit["last_30_days"] ?? 'NA';
    final total = profit["total"] ?? 0;

    final sessions_closed = tradingInfo["sessions_closed"] ?? 0;
    final trades_closed = tradingInfo["trades_closed"] ?? 0;
    final open_orders_amount = tradingInfo["open_orders_amount"] ?? 0;
    final open_orders_quantity = tradingInfo["open_orders_quantity"] ?? 0;
    final marketprice = tradingInfo["market_price"] ?? 746.3;
    final unrealized = open_orders_quantity * marketprice - open_orders_amount;

    double realizedValue = double.tryParse(total.toString()) ?? 0.0;

    double unrealizedValue = double.tryParse(unrealized.toString()) ?? 0.0;

    double netPL = realizedValue + unrealizedValue;

    print("Bot Data: $botData");

    print("Bot Session Data: $botsessionData");

    int sessionid = 0;
    var session_created_at = "";
    var updated_at = "";
    int session_trades_closed = 0;
    int opening_price = 0;
    double session_profit = 0;
    int total_volume = 0;
    double moving_average_percentage = 0;
    double profit_to_ap = 0;
    double average_price = 0;
    double balance_assigned = 0;
    double balance_available = 0;
    double balance_in_trade = 0;
    int mcr_balance_assigned = 0;
    double market_vs_moving_difference = 0;

    var sessionruntime = "";
    if (botsessionData != null && botsessionData!.isNotEmpty) {
      final session = botsessionData![0];
      sessionid = session["id"] ?? 0;

      session_created_at = session["created_at"] ?? "";
      updated_at = session["updated_at"] ?? "";
      session_trades_closed = session["trades_closed"] ?? 0;
      opening_price = session["opening_price"] ?? 0;
      session_profit = session["session_profit"] ?? 0;
      total_volume = session["total_volume"] ?? 0;
      moving_average_percentage = session["moving_average_percentage"] ?? 0;
      profit_to_ap = session["profit_to_ap"] ?? 0;
      average_price = session["average_price"] ?? 0;
      balance_assigned = session["balance_assigned"] ?? 0;
      balance_available = session["balance_available"] ?? 0;
      balance_in_trade = session["balance_in_trade"] ?? 0;
      mcr_balance_assigned = session["mcr_balance_assigned"] ?? 0;
      market_vs_moving_difference = session["market_vs_moving_difference"] ?? 0;
      sessionruntime = session["runtime"] ?? "";
    }
    return Scaffold(
      //key: blockKey,
      backgroundColor: colorF1F5F9,
      //drawer: SideMenu(),
      appBar: MyAppBar(
        title: "",
        isFirstScreen: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child: GestureDetector(
              onTap: () {
                print("Notification");
              },
              child: Container(
                child: Image.asset(icNotification),
                height: 50,
                width: 50,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                print("My photo");
              },
              child: Container(
                height: 40,
                child: Stack(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 6,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              //image: NetworkImage("https://picsum.photos/id/64/60/60"), https://picsum.photos/200
                              image: NetworkImage("https://picsum.photos/100"),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(100),
                                topRight: Radius.circular(100),
                                bottomLeft: Radius.circular(100),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0xFFCAD4E8),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                    Positioned(
                      right: 6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF48C884),
                          shape: OvalBorder(
                            side: BorderSide(width: 1, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                BotInsight,
                style: blackBoldTextStyle(18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              Container(
                width: size.width - 40,

                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x2D94A3B8),
                      blurRadius: 12,
                      offset: Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF039855) /* Success-600 */,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "$bottitle",
                          style: textStylew600(16, Colors.black),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3,
                          ),
                          decoration: ShapeDecoration(
                            color: getStatusBgColor(
                              status,
                              sell_only,
                            ) /* Success-100 */,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 6,
                            children: [
                              Container(
                                width: 9,
                                height: 9,
                                decoration: ShapeDecoration(
                                  color: getStatusColor(status, sell_only),
                                  shape: OvalBorder(),
                                ),
                              ),
                              Text(
                                status,
                                style: textStylew600(
                                  14,
                                  getStatusColor(status, sell_only),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 39,
                          height: 32,
                          padding: EdgeInsets.all(5),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: colorPrimary),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Image.asset(icArrowDown),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 39,
                          height: 32,
                          padding: EdgeInsets.all(5),
                          decoration: ShapeDecoration(
                            color: colorPrimary,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: colorPrimary),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Image.asset(icEdit),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 65,
                          height: 60,
                          padding: EdgeInsets.only(left: 10, top: 15),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  child: Image.asset(
                                    icUsdc,
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 20,
                                top: 0,
                                child: Container(
                                  child: Image.asset(
                                    icUsdcT,
                                    width: 35,
                                    height: 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$bottitle',
                                style: textStylew600(14, color1E293B),
                              ),
                              Text(
                                '₹${marketprice.toStringAsFixed(2)}',
                                style: textStylew600(14, color94A3C1),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  SessionsClosed,
                                  style: textStylew400(11, color64748B),
                                ),
                                Text(
                                  '$sessions_closed',
                                  style: textStylew600(12, colorBlack),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                flex: 1, // 👈 Bigger width
                                child: badge(
                                  text: "$strategy  $strategy_type",
                                  icon: icBullseye,
                                  bgColor: const Color(0xFFFFF4D6),
                                  textColor: const Color(0xFFB54708),
                                  borderColor: const Color(0xFFFEC84B),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 0, // 👈 Smaller
                                child: badge(
                                  text: "$exchange",
                                  icon: icBitcoin,
                                  bgColor: const Color(0xFFEDE9FE),
                                  textColor: const Color(0xFF6941C6),
                                  borderColor: const Color(0xFFD6BBFB),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                flex: 0, // 👈 Smaller
                                child: badge(
                                  text: "$cycle_type",
                                  icon: icArrowsRotate,
                                  bgColor: const Color(0xFFE0F2FE),
                                  textColor: const Color(0xFF0369A1),
                                  borderColor: const Color(0xFFBAE6FD),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// SECOND ROW (Full Width)
                          SizedBox(
                            width: double.infinity,
                            child: badge(
                              text: "$category",
                              icon: icBullseyeArrow,
                              bgColor: const Color(0xFFF2F4F7),
                              textColor: const Color(0xFF344054),
                              borderColor: const Color(0xFFD0D5DD),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.5,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: colorE2E8F0,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          /// 🔹 First Row (3 items)
                          Row(
                            children: [
                              Expanded(
                                child: summaryCard(
                                  title: "Symbol",
                                  value: "$base_currency",
                                  valueColor: colorE2E8F0,
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: summaryCard(
                                  title: "Runtime",
                                  value: "$runtime",
                                  valueColor: colorE2E8F0,
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: summaryCard(
                                  title: "Sessions",
                                  value: "$sessions_closed",
                                  valueColor: colorE2E8F0,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// 🔹 Second Row (3 items)
                          Row(
                            children: [
                              Expanded(
                                child: summaryCard(
                                  title: "REALIZED",
                                  value: "₹${total.toStringAsFixed(2)}",
                                  valueColor: const Color(0xFF22C55E),
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: summaryCard(
                                  title: "UNREALIZED",
                                  value: "₹${unrealized.toStringAsFixed(2)}",
                                  valueColor: const Color(0xFFEF4444),
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: summaryCard(
                                  title: "NET P/L",
                                  value: "₹ ${netPL.toStringAsFixed(2)}",
                                  valueColor: netPL >= 0
                                      ? const Color(
                                          0xFF22C55E,
                                        ) // Green if profit
                                      : const Color(0xFFEF4444), // Red if loss
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colorE2E8F0),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor:
                              Colors.transparent, // remove default line
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          childrenPadding: const EdgeInsets.only(bottom: 10),

                          initiallyExpanded: true, // open by default
                          /// HEADER (SESSION ROW)
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Profit Summary',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),

                              Text(
                                "₹${total.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          trailing: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),

                          children: [
                            /// Divider
                            Container(height: 0.5, color: colorE2E8F0),

                            /// First Row
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: summaryCard(
                                      title: getCurrentISTTime(),
                                      value: "$today",
                                      valueColor: colorE2E8F0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Realized",
                                      value: "$yesterday",
                                      valueColor: colorE2E8F0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Last 7 Days",
                                      value: "$last_7_days",
                                      valueColor: colorE2E8F0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Divider
                            Container(height: 0.5, color: colorE2E8F0),

                            /// Second Row
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: summaryCard(
                                      title: "Last 30 Days",
                                      value: "$last_30_days",
                                      valueColor: colorE2E8F0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Total",
                                      value: "$total",
                                      valueColor: const Color(0xFF22C55E),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Trades Closed",
                                      value: "$trades_closed",
                                      valueColor: colorE2E8F0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 20),
                //height: 60,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            this.isCurrentSession = true;
                          });
                        },
                        child: Container(
                          height: 50,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    CurrentSession,
                                    style: TextStyle(
                                      color: (isCurrentSession == true)
                                          ? colorPrimary
                                          : color717680,
                                      fontSize: 14,
                                      fontFamily: fontInter,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: (this.isCurrentSession == true)
                                    ? 2
                                    : 0.5,
                                color: (isCurrentSession == true)
                                    ? colorPrimary
                                    : color717680,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            this.isCurrentSession = false;
                          });
                        },
                        child: Container(
                          height: 50,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //SizedBox(width:20),
                                  Text(
                                    PreviousSessions,
                                    style: TextStyle(
                                      color: (isCurrentSession == true)
                                          ? color717680
                                          : colorPrimary,
                                      fontSize: 14,
                                      fontFamily: fontInter,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: Colors.grey.withAlpha(60),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '20',
                                              style: blackNormalTextStyle(
                                                12,
                                                color414651,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                height: (this.isCurrentSession == true)
                                    ? 0.5
                                    : 2,
                                color: (isCurrentSession)
                                    ? color717680
                                    : colorPrimary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: size.width - 40,

                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x2D94A3B8),
                      blurRadius: 12,
                      offset: Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),

                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),

                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 10),
                    childrenPadding: EdgeInsets.only(bottom: 10),
                    iconColor: Colors.grey,
                    collapsedIconColor: Colors.grey,
                    title: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                'Session',
                                style: textStylew600(14, color64748B),
                              ),
                              SizedBox(width: 3),
                              Text(
                                '$sessionid',
                                style: textStylew600(16, color475569),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$ $session_profit',
                          style: TextStyle(
                            color: Color(0xFF039855),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    children: [
                      SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text(
                                    Tradesclosed,
                                    style: textStylew400(10, colorCC475569),
                                  ),
                                  Text(
                                    '$trades_closed',
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            width: 1,
                            color: colorCC475569.withAlpha(80),
                            height: 25,
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 4,
                                children: [
                                  Text(
                                    OpeningPrice,
                                    style: textStylew400(10, colorCC475569),
                                  ),
                                  Text(
                                    '${opening_price.toStringAsFixed(2)}',
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            width: 1,
                            color: colorCC475569.withAlpha(80),
                            height: 25,
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 4,
                                children: [
                                  Text(
                                    'Profit To AP',
                                    style: textStylew400(10, colorCC475569),
                                  ),
                                  Text(
                                    '${profit_to_ap.toStringAsFixed(2)}',
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      devider(),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text(
                                    'Session Profit',
                                    style: textStylew400(10, colorCC475569),
                                  ),
                                  Text(
                                    '${session_profit.toStringAsFixed(2)}',
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            width: 1,
                            color: colorCC475569.withAlpha(80),
                            height: 25,
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 4,
                                children: [
                                  Text(
                                    'Total Volume',
                                    style: textStylew400(10, colorCC475569),
                                  ),
                                  Text(
                                    '${total_volume.toStringAsFixed(2)}',
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            width: 1,
                            color: colorCC475569.withAlpha(80),
                            height: 25,
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 4,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        Runtime,
                                        style: textStylew400(10, colorCC475569),
                                      ),
                                      SizedBox(width: 2),
                                      Icon(
                                        Icons.info_outline,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$sessionruntime',
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      devider(),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Market Price',
                                        style: textStylew400(10, colorCC475569),
                                      ),
                                      SizedBox(width: 2),
                                      Icon(
                                        Icons.info_outline,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$marketprice',
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            width: 1,
                            color: colorCC475569.withAlpha(80),
                            height: 25,
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 4,
                                children: [
                                  Text(
                                    Runtime,
                                    style: textStylew400(10, colorCC475569),
                                  ),
                                  Text(
                                    sessionruntime,
                                    style: textStylew700(12, color475569),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    formatDate(created_at),
                                    style: textStylew700(12, color475569),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            /// 🔹 First Row (3 items)
                            Row(
                              children: [
                                Expanded(
                                  child: summaryCard(
                                    title: "Moving Average",
                                    value:
                                        "${average_price.toStringAsFixed(2)}",
                                    valueColor: colorE2E8F0,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                Expanded(
                                  child: summaryCard(
                                    title: "Moving Average %",
                                    value:
                                        "${moving_average_percentage.toStringAsFixed(2)}%",
                                    valueColor: moving_average_percentage >= 0
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFFEF4444),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: summaryCard(
                                    title: "Market vs Moving",
                                    value:
                                        "${market_vs_moving_difference.toStringAsFixed(2)}%",
                                    valueColor: market_vs_moving_difference >= 0
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// 🔹 Second Row (3 items)
                            Row(
                              children: [
                                Expanded(
                                  child: summaryCard(
                                    title: "INR Assigned",
                                    value:
                                        "${balance_assigned.toStringAsFixed(2)}",
                                    valueColor: colorE2E8F0,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                Expanded(
                                  child: summaryCard(
                                    title: "INR In Trade",
                                    value:
                                        "${balance_in_trade.toStringAsFixed(2)}",
                                    valueColor: colorE2E8F0, // Red if loss
                                  ),
                                ),

                                Expanded(
                                  child: summaryCard(
                                    title: "INR Available",
                                    value:
                                        "${balance_available.toStringAsFixed(2)}",
                                    valueColor: balance_available >= 0
                                        ? const Color(0xFF22C55E)
                                        : const Color(0xFFEF4444),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        //margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.5,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: colorE2E8F0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Session Trades - 12 Open',
                          style: textStylew600(14, color475569),
                        ),
                      ),

                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(8),
                            height: 100,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF7FFF5),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: const Color(0x9948C884),
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          spacing: 8,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                spacing: 8,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                          vertical: 2,
                                                        ),
                                                    decoration: ShapeDecoration(
                                                      color: colorFF12B76A,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      Buy,
                                                      style: textStylew500(
                                                        10,
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Cover 3',
                                                    style: textStylew700(
                                                      12,
                                                      colorFF333333,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: ShapeDecoration(
                                                color: colorFFDFEDFF,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                '-2% X1',
                                                style: textStylew400(
                                                  10,
                                                  color444444,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Open:',
                                              style: TextStyle(
                                                color: color444444,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Dec 10, 2024 - 22:17',
                                              style: TextStyle(
                                                color: color444444,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              TradeID,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '50242660',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Amount,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '105.75',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Quantity,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '0.0291',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Price,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '3634.04',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(8),
                            height: 100,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFFEDED),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: const Color(0x4CFF4848),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          spacing: 8,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                spacing: 8,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                          vertical: 2,
                                                        ),
                                                    decoration: ShapeDecoration(
                                                      color: Colors.red,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      Sell,
                                                      style: textStylew500(
                                                        10,
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Cover 3',
                                                    style: textStylew700(
                                                      12,
                                                      colorFF333333,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: ShapeDecoration(
                                                color: colorFFDFEDFF,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                '-2% X1',
                                                style: textStylew400(
                                                  10,
                                                  color444444,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Open:',
                                              style: TextStyle(
                                                color: color444444,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Dec 10, 2024 - 22:17',
                                              style: TextStyle(
                                                color: color444444,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              TradeID,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '50242660',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Amount,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '105.75',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Quantity,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '0.0291',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Price,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '3634.04',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(8),
                            height: 100,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF8FBFF),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: const Color(0xFFCBD5E1),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    spacing: 15,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          //width: 140,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 60,
                                            children: [
                                              Text(
                                                GrossProfit,
                                                style: textStylew400(
                                                  10,
                                                  colorCC475569,
                                                ),
                                              ),
                                              Text(
                                                '2.50',
                                                style: textStylew600(
                                                  12,
                                                  color475569,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 140,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 60,
                                            children: [
                                              Text(
                                                Profit,
                                                style: textStylew400(
                                                  10,
                                                  colorCC475569,
                                                ),
                                              ),
                                              Text(
                                                '2.02%',
                                                style: textStylew600(
                                                  12,
                                                  color475569,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    spacing: 15,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          //width: 140,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 10,
                                            children: [
                                              Text(
                                                '${Fees}:',
                                                style: textStylew400(
                                                  10,
                                                  colorCC475569,
                                                ),
                                              ),
                                              Text(
                                                '0.47372728',
                                                style: textStylew600(
                                                  12,
                                                  color475569,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: 140,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            spacing: 10,
                                            children: [
                                              Text(
                                                '${ProfitAvgPrice}:',
                                                style: textStylew400(
                                                  10,
                                                  colorCC475569,
                                                ),
                                              ),
                                              Text(
                                                '1.01%',
                                                style: textStylew600(
                                                  12,
                                                  color475569,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${NetProfit}:',
                                          style: textStylew600(14, colorBlack),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: color1929C004,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 10,
                                          children: [
                                            Text(
                                              '1.01(0.98%)',
                                              style: textStylew700(
                                                12,
                                                color444444,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: 35,
                            decoration: ShapeDecoration(
                              color: colorFFFFDB6B,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: colorFFF0B90B,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                AccountHasInsufficientBalance,
                                style: textStylew500(12, colorBlack),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(8),
                            height: 100,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: colorFFF0B90B,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          spacing: 8,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                spacing: 8,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                          vertical: 2,
                                                        ),
                                                    decoration: ShapeDecoration(
                                                      color: colorFF12B76A,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      Buy,
                                                      style: textStylew500(
                                                        10,
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Cover 2',
                                                    style: textStylew700(
                                                      12,
                                                      colorFF333333,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: ShapeDecoration(
                                                color: colorFFDFEDFF,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Text(
                                                '-2% X1',
                                                style: textStylew400(
                                                  10,
                                                  color444444,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Open:',
                                              style: TextStyle(
                                                color: color444444,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Dec 10, 2024 - 22:17',
                                              style: TextStyle(
                                                color: color444444,
                                                fontSize: 9,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              TradeID,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '50242660',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Amount,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '105.75',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Quantity,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '0.0291',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          spacing: 4,
                                          children: [
                                            Text(
                                              Price,
                                              style: textStylew400(
                                                10,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '3634.04',
                                              style: textStylew600(
                                                12,
                                                color475569,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget devider() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: colorE2E8F0,
          ),
        ),
      ),
    );
  }
}

Widget badge({
  required String text,
  required String icon,
  required Color bgColor,
  required Color textColor,
  required Color borderColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: borderColor),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon, width: 16, height: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

Widget summaryCard({
  required String title,
  required String value,
  required Color valueColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF3B82F6).withOpacity(0.15),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.info_outline, size: 14, color: Color(0xFF94A3B8)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}
