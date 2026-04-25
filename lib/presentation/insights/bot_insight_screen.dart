import 'package:eazybot/api/bot_api.dart';
import 'package:eazybot/constant/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant/colors.dart';
import '../../constant/images.dart';
import '../../constant/string.dart';
import '../../styles/bot_ui_styles.dart';
import '../../styles/text_styles.dart';
import '../../widgets/bot_badge.dart';
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
  int? sessionId;
  Map<String, dynamic>? botData;
  List<dynamic>? botsessionData;
  List<dynamic>? tradesData;

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([fetchBotDetails(), fetchBotSession()]);

    if (sessionId != null) {
      await fetchBotTrades();
    }
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
      print("Session API Response: $response");

      botsessionData = response["data"];

      if (botsessionData != null && botsessionData!.isNotEmpty) {
        sessionId = botsessionData![0]["id"]; // get session id
        print("Session ID: $sessionId");
      }

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchBotTrades() async {
    try {
      if (botsessionData == null || botsessionData!.isEmpty) {
        print("No session found, skipping trades API");
        return;
      }

      int sessionId = botsessionData![0]["id"];

      print("Calling Trades API with Session ID: $sessionId");

      final response = await BotApi().getBotTrades(
        botId: widget.botId,
        sessionId: sessionId,
      );

      print("Trades API Response: $response");

      setState(() {
        tradesData = response["data"];
      });
    } catch (e) {
      print("Trades API Error: $e");
    }
  }

  String getCurrentISTTime() {
    final nowUtc = DateTime.now().toUtc();
    final istTime = nowUtc.add(const Duration(hours: 5, minutes: 30));

    final hour = istTime.hour.toString().padLeft(2, '0');
    final minute = istTime.minute.toString().padLeft(2, '0');

    return "Today (${hour}h:${minute}m)";
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return "-";
    }

    try {
      DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      print("Date parsing error: $date");
      return date;
    }
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

  String formatNumber(num value) {
    final formatter = NumberFormat('#,##,##0.00', 'en_IN');
    return formatter.format(value);
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
    double opening_price = 0.0;
    double session_profit = 0.0;
    int total_volume = 0;
    double moving_average_percentage = 0.0;
    double profit_to_ap = 0.0;
    double average_price = 0.0;
    double balance_assigned = 0.0;
    double balance_available = 0.0;
    double balance_in_trade = 0.0;
    int mcr_balance_assigned = 0;
    double market_vs_moving_difference = 0.0;

    var sessionruntime = "";

    int tradeId = 0;
    int totalTrades = 0;
    int buyTrades = 0;
    int sellTrades = 0;

    double totalBuyAmount = 0.0;
    double totalSellAmount = 0.0;

    double totalFees = 0.0;
    double totalNetProfit = 0.0;

    int rejectedTrades = 0;
    int completedTrades = 0;

    double toDouble(value) => (value as num?)?.toDouble() ?? 0.0;
    int toInt(value) => (value as num?)?.toInt() ?? 0;

    if (botsessionData != null && botsessionData!.isNotEmpty) {
      final session = botsessionData![0];

      sessionid = toInt(session["id"]);

      session_created_at = session["created_at"] ?? "";
      updated_at = session["updated_at"] ?? "";

      session_trades_closed = toInt(session["trades_closed"]);
      opening_price = toDouble(session["opening_price"]);
      session_profit = toDouble(session["session_profit"]);
      total_volume = toInt(session["total_volume"]);
      moving_average_percentage = toDouble(
        session["moving_average_percentage"],
      );
      profit_to_ap = toDouble(session["profit_to_ap"]);
      average_price = toDouble(session["average_price"]);
      balance_assigned = toDouble(session["balance_assigned"]);
      balance_available = toDouble(session["balance_available"]);
      balance_in_trade = toDouble(session["balance_in_trade"]);
      mcr_balance_assigned = toInt(session["mcr_balance_assigned"]);
      market_vs_moving_difference = toDouble(
        session["market_vs_moving_difference"],
      );

      sessionruntime = session["runtime"] ?? "";
    }

    if (tradesData != null && tradesData!.isNotEmpty) {
      totalTrades = tradesData!.length;

      for (var trade in tradesData!) {
        tradeId = toInt(trade["id"]);

        String side = trade["side"] ?? "";
        String status = trade["trade_status"] ?? "";

        double amount = (trade["amount"] as num?)?.toDouble() ?? 0.0;
        double fees = (trade["fees"] as num?)?.toDouble() ?? 0.0;
        double netProfit = (trade["net_profit"] as num?)?.toDouble() ?? 0.0;

        /// BUY / SELL COUNT
        if (side == "BUY") {
          buyTrades++;
          totalBuyAmount += amount;
        }

        if (side == "SELL") {
          sellTrades++;
          totalSellAmount += amount;
        }

        /// STATUS COUNT
        if (status == "REJECTED") {
          rejectedTrades++;
        }

        if (status == "COMPLETE") {
          completedTrades++;
        }

        /// PROFIT + FEES
        totalFees += fees;
        totalNetProfit += netProfit;
      }
    }
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFBE9F8),
            Color(0xFFF3F0FF),
            Color(0xFFE8F4FF),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Scaffold(
      backgroundColor: Colors.transparent,
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
                                topLeft: Radius.circular(BotUiRadius.avatar),
                                topRight: Radius.circular(BotUiRadius.avatar),
                                bottomLeft: Radius.circular(BotUiRadius.avatar),
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
                style: blackBoldTextStyle(BotUiFontSize.xl),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              Container(
                width: size.width - 40,

                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(BotUiRadius.xl),
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
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 24,
                          decoration: ShapeDecoration(
                            color: getStatusColor(status, sell_only),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(BotUiRadius.md),
                                bottomRight: Radius.circular(BotUiRadius.md),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "$bottitle",
                            style: const TextStyle(
                              color: Color(0xFF0EA5E9),
                              fontSize: BotUiFontSize.xl,
                              fontWeight: FontWeight.w700,
                            ),
                            softWrap: true,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusBgColor(status, sell_only),
                            border: Border.all(
                              color: getStatusColor(status, sell_only),
                            ),
                            borderRadius: BorderRadius.circular(BotUiRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 4,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: getStatusColor(status, sell_only),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                status,
                                style: textStylew600(
                                  BotUiFontSize.xs,
                                  getStatusColor(status, sell_only),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$bottitle',
                                style: textStylew600(BotUiFontSize.base, color1E293B),
                              ),
                              Text(
                                '₹${marketprice.toStringAsFixed(2)}',
                                style: textStylew600(BotUiFontSize.base, color1E293B),
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
                                  style: textStylew400(BotUiFontSize.xs, color64748B),
                                ),
                                Text(
                                  '$sessions_closed',
                                  style: textStylew600(BotUiFontSize.sm, colorBlack),
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
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              BotBadge(
                                text: "$strategy  $strategy_type",
                                icon: icBullseye,
                                bgColor: const Color(0xFFFFF4D6),
                                textColor: const Color(0xFFB54708),
                                borderColor: const Color(0xFFFEC84B),
                              ),
                              BotBadge(
                                text: "$exchange",
                                icon: icBitcoin,
                                bgColor: const Color(0xFFEDE9FE),
                                textColor: const Color(0xFF6941C6),
                                borderColor: const Color(0xFFD6BBFB),
                              ),
                              BotBadge(
                                text: "$cycle_type",
                                icon: icArrowsRotate,
                                bgColor: const Color(0xFFE0F2FE),
                                textColor: const Color(0xFF0369A1),
                                borderColor: const Color(0xFFBAE6FD),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// SECOND ROW (Full Width)
                          SizedBox(
                            width: double.infinity,
                            child: BotBadge(
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
                            color: colorCC475569,
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
                                  valueColor: colorCC475569,
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: summaryCard(
                                  title: "Runtime",
                                  value: "$runtime",
                                  valueColor: colorCC475569,
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: summaryCard(
                                  title: "Sessions",
                                  value: "$sessions_closed",
                                  valueColor: colorCC475569,
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
                                  value: "₹${formatNumber(unrealized)}",
                                  valueColor: const Color(0xFFEF4444),
                                ),
                              ),
                              const SizedBox(width: 8),

                              Expanded(
                                child: summaryCard(
                                  title: "NET P/L",
                                  value: "₹ ${formatNumber(netPL)}",
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
                        borderRadius: BorderRadius.circular(BotUiRadius.xxl),
                        border: Border.all(color: colorCC475569),
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
                                'Bot Revenue Insights',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: BotUiFontSize.base,
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
                            Container(height: 0.5, color: colorCC475569),

                            /// First Row
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: summaryCard(
                                      title: getCurrentISTTime(),
                                      value: "$today",
                                      valueColor: colorCC475569,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Yesterday",
                                      value: "$yesterday",
                                      valueColor: colorCC475569,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Last 7 Days",
                                      value: "$last_7_days",
                                      valueColor: colorCC475569,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Divider
                            Container(height: 0.5, color: colorCC475569),

                            /// Second Row
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: summaryCard(
                                      title: "Last 30 Days",
                                      value: "$last_30_days",
                                      valueColor: colorCC475569,
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Total",
                                      value: "${total.toStringAsFixed(2)}",
                                      valueColor: const Color(0xFF22C55E),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                  Flexible(
                                    child: summaryCard(
                                      title: "Trades Closed",
                                      value: "$trades_closed",
                                      valueColor: colorCC475569,
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
                                      fontSize: BotUiFontSize.base,
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
                                      fontSize: BotUiFontSize.base,
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
                                              BotUiRadius.chip,
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
                                                BotUiFontSize.md,
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
                    borderRadius: BorderRadius.circular(BotUiRadius.xl),
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
                                style: textStylew600(BotUiFontSize.base, color64748B),
                              ),
                              SizedBox(width: 3),
                              Text(
                                '$sessionid',
                                style: textStylew600(BotUiFontSize.lg, color475569),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$ ${session_profit.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Color(0xFF039855),
                            fontSize: BotUiFontSize.xl,
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
                                    "Trades Closed",
                                    style: textStylew400(BotUiFontSize.xs, colorCC475569),
                                  ),
                                  Text(
                                    '$trades_closed',
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                                    style: textStylew400(BotUiFontSize.xs, colorCC475569),
                                  ),
                                  Text(
                                    '${opening_price.toStringAsFixed(2)}',
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                                    style: textStylew400(BotUiFontSize.xs, colorCC475569),
                                  ),
                                  Text(
                                    '${profit_to_ap.toStringAsFixed(2)}',
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                                    style: textStylew400(BotUiFontSize.xs, colorCC475569),
                                  ),
                                  Text(
                                    '${session_profit.toStringAsFixed(2)}',
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                                    style: textStylew400(BotUiFontSize.xs, colorCC475569),
                                  ),
                                  Text(
                                    '${total_volume.toStringAsFixed(2)}',
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                                        style: textStylew400(BotUiFontSize.xs, colorCC475569),
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
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                                        style: textStylew400(BotUiFontSize.xs, colorCC475569),
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
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatDate(created_at),
                                    style: textStylew700(BotUiFontSize.sm, color475569),
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
                                    value: "${formatNumber(average_price)}",
                                    valueColor: colorCC475569,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                Expanded(
                                  child: summaryCard(
                                    title: "Moving Average %",
                                    value:
                                        "${formatNumber(moving_average_percentage)}%",
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
                                        "${formatNumber(market_vs_moving_difference)}%",
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
                                    value: "${formatNumber(balance_assigned)}",
                                    valueColor: colorCC475569,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                Expanded(
                                  child: summaryCard(
                                    title: "INR In Trade",
                                    value: "${formatNumber(balance_in_trade)}",
                                    valueColor: colorCC475569, // Red if loss
                                  ),
                                ),

                                Expanded(
                                  child: summaryCard(
                                    title: "INR Available",
                                    value: "${formatNumber(balance_available)}",
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
                              color: colorCC475569,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Session Trades - ${tradesData?.length ?? 0} Open',
                          style: textStylew600(BotUiFontSize.base, color475569),
                        ),
                      ),

                      Column(
                        children: (tradesData ?? []).map((trade) {
                          final tradeId = trade["id"] ?? "";
                          final side = trade["side"] ?? "";
                          final label = trade["trade_type_label"] ?? "";
                          final createdAt = trade["created_at"] ?? "";
                          final amount = trade["amount"] ?? 0;
                          final quantity = trade["quantity"] ?? 0;
                          final price = trade["price"] ?? 0;
                          final grossProfit = trade["gross_profit"] ?? 0;
                          final fees = trade["fees"] ?? 0;
                          final netProfit = trade["net_profit"] ?? 0;

                          bool isBuy = side == "BUY";

                          return Column(
                            children: [
                              /// BUY / SELL CARD
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(8),
                                height: 100,
                                decoration: ShapeDecoration(
                                  color: isBuy
                                      ? const Color(0xFFF7FFF5)
                                      : const Color(0xFFFFEDED),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: isBuy
                                          ? const Color(0x9948C884)
                                          : const Color(0x4CFF4848),
                                    ),
                                    borderRadius: BorderRadius.circular(BotUiRadius.md),
                                  ),
                                ),

                                child: Column(
                                  children: [
                                    /// HEADER
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isBuy
                                                ? const Color(0xFFD1FAE5)
                                                : const Color(0xFFFEE2E2),
                                            borderRadius: BorderRadius.circular(
                                              BotUiRadius.sm,
                                            ),
                                            border: Border.all(
                                              color: isBuy
                                                  ? const Color(0xFF22C55E)
                                                  : const Color(0xFFEF4444),
                                            ),
                                          ),
                                          child: Text(
                                            side,
                                            style: textStylew700(
                                              BotUiFontSize.xs,
                                              isBuy
                                                  ? const Color(0xFF16A34A)
                                                  : const Color(0xFFDC2626),
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 8),

                                        Expanded(
                                          child: Text(
                                            label,
                                            style: textStylew700(
                                              BotUiFontSize.md,
                                              colorFF333333,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 5),

                                    /// DATE
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Open: $createdAt",
                                        style: textStylew400(BotUiFontSize.xxs, color444444),
                                      ),
                                    ),

                                    Spacer(),

                                    /// TRADE INFO
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _tradeColumn(
                                            "Trade ID",
                                            tradeId.toString(),
                                          ),
                                        ),

                                        Expanded(
                                          child: _tradeColumn(
                                            "Amount",
                                            amount.toString(),
                                          ),
                                        ),

                                        Expanded(
                                          child: _tradeColumn(
                                            "Quantity",
                                            quantity.toString(),
                                          ),
                                        ),

                                        Expanded(
                                          child: _tradeColumn(
                                            "Price",
                                            price.toString(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /// PROFIT CARD
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(8),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF8FBFF),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1,
                                      color: const Color(0xFFCBD5E1),
                                    ),
                                    borderRadius: BorderRadius.circular(BotUiRadius.md),
                                  ),
                                ),

                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _profitRow(
                                            "Gross Profit",
                                            grossProfit.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: _profitRow(
                                            "Profit/AP",
                                            trade["profit_to_ap"].toString(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: _profitRow(
                                            "Fees",
                                            fees.toString(),
                                          ),
                                        ),
                                        Expanded(
                                          child: _profitRow(
                                            "Profit",
                                            trade["profit"].toString(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Net Profit:",
                                            style: textStylew600(
                                              BotUiFontSize.base,
                                              colorBlack,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: color1929C004,
                                            borderRadius: BorderRadius.circular(
                                              BotUiRadius.pill,
                                            ),
                                          ),
                                          child: Text(
                                            netProfit.toString(),
                                            style: textStylew700(
                                              BotUiFontSize.md,
                                              color444444,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
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
                                  topLeft: Radius.circular(BotUiRadius.xl),
                                  topRight: Radius.circular(BotUiRadius.xl),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                AccountHasInsufficientBalance,
                                style: textStylew500(BotUiFontSize.md, colorBlack),
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
                                  bottomLeft: Radius.circular(BotUiRadius.md),
                                  bottomRight: Radius.circular(BotUiRadius.md),
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
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFFD1FAE5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            BotUiRadius.sm,
                                                          ),
                                                      border: Border.all(
                                                        color: const Color(0xFF22C55E),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      Buy,
                                                      style: textStylew700(
                                                        BotUiFontSize.xs,
                                                        const Color(0xFF16A34A),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Cover 2',
                                                    style: textStylew700(
                                                      BotUiFontSize.md,
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
                                                      BorderRadius.circular(BotUiRadius.sm),
                                                ),
                                              ),
                                              child: Text(
                                                '-2% X1',
                                                style: textStylew400(
                                                  BotUiFontSize.xs,
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
                                                fontSize: BotUiFontSize.xxs,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: BotUiFontSize.xxs,
                                                fontFamily: fontInter,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Dec 10, 2024 - 22:17',
                                              style: TextStyle(
                                                color: color444444,
                                                fontSize: BotUiFontSize.xxs,
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
                                                BotUiFontSize.xs,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '50242660',
                                              style: textStylew600(
                                                BotUiFontSize.md,
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
                                                BotUiFontSize.xs,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '105.75',
                                              style: textStylew600(
                                                BotUiFontSize.md,
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
                                                BotUiFontSize.xs,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '0.0291',
                                              style: textStylew600(
                                                BotUiFontSize.md,
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
                                                BotUiFontSize.xs,
                                                color99475569,
                                              ),
                                            ),
                                            Text(
                                              '3634.04',
                                              style: textStylew600(
                                                BotUiFontSize.md,
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
    ));
  }

  Widget devider() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: colorCC475569,
          ),
        ),
      ),
    );
  }
}



Widget _tradeColumn(String title, String value) {
  return Column(
    children: [
      Text(title, style: textStylew400(BotUiFontSize.xs, color99475569)),
      SizedBox(height: 4),
      Text(value, style: textStylew600(BotUiFontSize.md, color475569)),
    ],
  );
}

Widget _profitRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: textStylew400(BotUiFontSize.xs, colorCC475569)),
      Text(value, style: textStylew600(BotUiFontSize.md, color475569)),
    ],
  );
}

Widget summaryCard({
  required String title,
  required String value,
  required Color valueColor,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(BotUiRadius.xl),
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
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: BotUiFontSize.xs,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.info_outline, size: 12, color: Color(0xFF94A3B8)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: BotUiFontSize.value,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}
