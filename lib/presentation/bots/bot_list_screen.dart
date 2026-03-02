import 'package:eazybot/constant/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/colors.dart';
import '../../constant/images.dart';
import '../../constant/string.dart';
import '../../core/route.dart';
import '../../styles/text_styles.dart';
import '../../util/myappbar.dart';
import '../../api/bot_api.dart';
import '../../models/bot_model.dart';

class BotListScreen extends StatefulWidget {
  const BotListScreen({super.key});

  @override
  State<BotListScreen> createState() => _BotListScreenState();
}

class _BotListScreenState extends State<BotListScreen> {
  final BotApi _api = BotApi();

  List<BotModel> bots = [];

  bool isLoading = true;
  String error = "";

  Map<String, dynamic>? statsInfo;
  Map<String, dynamic>? revenueInsights;

  @override
  void initState() {
    super.initState();
    fetchBots();
  }

  Future<void> fetchBots() async {
    try {
      final response = await _api.getBots();

      final data = response['data'];

      final List botList = data['data'];

      bots = botList.map((e) => BotModel.fromJson(e)).toList();

      statsInfo = data['stats_info'];
      revenueInsights = data['revenue_insights'];

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = "Failed to load bots";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: colorF1F5F9,
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
                )),
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
                                    image: NetworkImage(
                                        "https://picsum.photos/100"),
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
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              )
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
                                    side: BorderSide(
                                        width: 1, color: Colors.white),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ))),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(child: Text(error))
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 8, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Bots,
                  style: blackBoldTextStyle(18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: size.width - 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(
                            0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bot Revenue Insights',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                spacing: 5,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Active : ',
                                          style: TextStyle(
                                            color: const Color(
                                                0xFF475569),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight:
                                            FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: statsInfo?['active'] ??
                                              "0",
                                          style: TextStyle(
                                            color: const Color(
                                                0xFF039855), /* Success-600 */
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  Container(
                                    width: 1,
                                    color: Colors.grey,
                                    height: 20,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Sell only : ',
                                          style: TextStyle(
                                            color: const Color(
                                                0xFF475569),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight:
                                            FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: statsInfo?['sell_only'] ??
                                              "0",
                                          style: TextStyle(
                                            color: const Color(
                                                0xFFFF9500), /* Colors-Orange */
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  Container(
                                    width: 1,
                                    color: Colors.grey,
                                    height: 20,
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Inactive : ',
                                          style: TextStyle(
                                            color: const Color(
                                                0xFF475569),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight:
                                            FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: statsInfo?['inactive'] ??
                                              "0",
                                          style: TextStyle(
                                            color: const Color(
                                                0xFFFF3B30), /* Colors-Red */
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // ... existing title "Bot Revenue Insights"
                      SizedBox(height: 10),


// NEW GRID VIEW REPLACING OLD TABLE
            // NEW GRID VIEW REPLACING OLD TABLE
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10), // Adds the "Outer Space"
                        child: Column(
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              childAspectRatio: 2.4, // Adjust this to make cards shorter or taller
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: [
                                _buildInsightCard("Today", revenueInsights?['today']),
                                _buildInsightCard("Yesterday", "-"),
                                _buildInsightCard("Last 7 Days", revenueInsights?['last_7_days']),
                                _buildInsightCard("Last 30 Days", revenueInsights?['last_30_days']),
                                _buildInsightCard("Non-Deleted Total", revenueInsights?['total']),
                                _buildInsightCard("Deleted Bots Total", revenueInsights?['deleted_bots_total']),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Full width Grand Total Card
                            SizedBox(
                              width: double.infinity,
                              child: _buildInsightCard(
                                  "Grand Total",
                                  revenueInsights?['grand_total'],
                                  isGrandTotal: true
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(BotCollection,
                            style: blackBoldTextStyle(16))),
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset(icTableCells),
                    ),
                    SizedBox(width: 20),
                    Container(
                      width: 20,
                      height: 20,
                      child: Image.asset(icSliders),
                    ),
                    SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: ShapeDecoration(
                        color: colorPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //spacing: 6,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            CreateBot,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: fontInter,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),

                ///Table

                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final bot = bots[index];

                    double price = bot.totalProfit;
                    double percentage = bot.todayProfit;
                    String lastTrade = bot.lastTrade;

                    String type = "";
                    String description = "";

                    if (lastTrade.isNotEmpty) {
                      final parts = lastTrade.split(" ");
                      type = parts.first; // BUY or SELL
                      description =
                          lastTrade.replaceFirst("$type ", "");
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteGenerator.botInsightScreen,
                          arguments: bot.id,
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD3EBE5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Color(0x1994A3B8),
                                  blurRadius: 14,
                                  offset: Offset(0, 3),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(Icons.check_box,
                                            size: 20,
                                            color: Colors.white),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(bot.title,
                                            style:
                                            blackBoldTextStyle(16)),
                                      ],
                                    )),
                                Text(
                                  bot.status,
                                  style: textStylew600(
                                    14,
                                    bot.status == "Active"
                                        ? color26A17B
                                        : Colors.red,
                                  ),
                                ),
                                SizedBox(width: 15),
                                Icon(
                                  Icons.more_vert,
                                  size: 25,
                                  color: color475569,
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0,
                                      1), // changes position of shadow
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 65,
                                      height: 60,
                                      padding: EdgeInsets.only(
                                          left: 10, top: 15),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                                child: Image.asset(
                                                    icUsdc,
                                                    width: 35,
                                                    height: 35)),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 0,
                                            child: Container(
                                                child: Image.asset(
                                                    icUsdcT,
                                                    width: 35,
                                                    height: 35)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(bot.coinPair,
                                              style: textStylew600(
                                                  14, color1E293B)),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .end,
                                            children: [
                                              Text(
                                                bot.totalProfit
                                                    .toStringAsFixed(
                                                    2),
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  color: const Color(
                                                      0xFF1E293B),
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Row(
                                                children: [
                                                  Icon(
                                                    percentage < 0
                                                        ? Icons
                                                        .arrow_downward
                                                        : Icons
                                                        .arrow_upward,
                                                    size: 14,
                                                    color: percentage <
                                                        0
                                                        ? const Color(
                                                        0xFFFD381E)
                                                        : const Color(
                                                        0xFF26A17B),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    '${percentage.abs().toStringAsFixed(2)}%',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      color: percentage <
                                                          0
                                                          ? const Color(
                                                          0xFFFD381E)
                                                          : const Color(
                                                          0xFF26A17B),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                        EdgeInsets.only(right: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              bot.todayProfit
                                                  .toStringAsFixed(2),
                                              style: textStylew600(
                                                12,
                                                bot.todayProfit >= 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            Text(
                                              "Today's Profit",
                                              style: textStylew600(
                                                  12, colorBlack),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      // ====================================
                                      // SYNCED BADGES USING WRAP
                                      // Prevents overflow by intelligently wrapping
                                      // ====================================
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        alignment: WrapAlignment.start,
                                        children: [
                                          badge(
                                            text: "${bot.strategy} ${bot.strategyType}",
                                            icon: icBullseye,
                                            bgColor: const Color(0xFFFFF4D6),
                                            textColor: const Color(0xFFB54708),
                                            borderColor: const Color(0xFFFEC84B),
                                          ),
                                          badge(
                                            text: "${bot.exchange}",
                                            icon: icBitcoin,
                                            bgColor: const Color(0xFFEDE9FE),
                                            textColor: const Color(0xFF6941C6),
                                            borderColor: const Color(0xFFD6BBFB),
                                          ),
                                          badge(
                                            text: "${bot.cycleType}",
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
                                        child: badge(
                                          text: bot.category.isNotEmpty
                                              ? "${bot.category}"
                                              : bot.category,
                                          icon: icBullseyeArrow,
                                          bgColor: const Color(0xFFF2F4F7),
                                          textColor: const Color(0xFF344054),
                                          borderColor: const Color(0xFFD0D5DD),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                divider(),

                                /// SUMMARY CARDS WITH SYNCED SPACING
                                /// Replaced Flexible with Expanded to strictly divide by 3
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: summaryCard(
                                          title: "REALIZED",
                                          value: "₹674",
                                          valueColor: const Color(0xFF22C55E),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: summaryCard(
                                          title: "UNREIZED",
                                          value: "₹-30482",
                                          valueColor: const Color(0xFFEF4444),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      Expanded(
                                        child: summaryCard(
                                          title: "NET P/L",
                                          value: "₹-29808",
                                          valueColor: const Color(0xFFEF4444),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                capitalGrowthCard(bot),

                                const SizedBox(height: 12),

                                tradeInfoCard(
                                  label: "LAST:",
                                  type: type,
                                  description: description,
                                ),

                                const SizedBox(height: 12),

                                tradeInfoCard(
                                  label: "NEXT:",
                                  type: "BUY",
                                  description: "C4 at Price < ₹1295.76",
                                ),

                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  color: colorFAFAFA,
                                  child: Column(
                                    children: [],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        'Bot ID: ${bot.id}',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0x99475569),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Icon(
                                        Icons.copy,
                                        size: 14,
                                        color: Colors.grey,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: bots.length,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.transparent,
                      height: 10,
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
  Widget _buildInsightCard(String title, dynamic value, {bool isGrandTotal = false}) {
    return Container(
      // height: 75, // Controls the "bigness" of the card
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isGrandTotal ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(10), // Matches your primary UI rounding
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isGrandTotal ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toString() ?? '0',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isGrandTotal ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
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
        mainAxisSize: MainAxisSize.min, // Added to play nicely with Wrap
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

  Widget divider() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
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
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12, // Adjusted slightly for smaller screens
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.info_outline, size: 14, color: Color(0xFF94A3B8)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Ensures large numbers don't break layout
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

  Widget capitalGrowthCard(BotModel bot) {
    double growthPercent = 0;

    if (bot.initialCapital > 0) {
      growthPercent =
          ((bot.currentCapital - bot.initialCapital) / bot.initialCapital) *
              100;
    }

    bool isPositive = growthPercent >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Capital Growth",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF38BDF8),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "₹${bot.currentCapital.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${isPositive ? '+' : ''}${growthPercent.toStringAsFixed(2)}% from ₹${bot.initialCapital.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: isPositive
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 18),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 18,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    bot.runtime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
              Text(
                "Available: ₹${bot.availableQuoteCoins.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: bot.availableQuoteCoins >= 0
                      ? Colors.black
                      : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tradeInfoCard({
    required String label,
    required String type,
    required String description,
  }) {
    bool isBuy = type.toUpperCase() == "BUY";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ====================================
          // FIXED WIDTH LABEL FOR ALIGNMENT
          // Forces the following chips to start precisely at the same spot
          // ====================================
          SizedBox(
            width: 50,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(width: 8),

          /// Dynamic Chip
          Container(
            width: 55, // Fixed width so text descriptions follow cleanly
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: isBuy ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isBuy ? const Color(0xFF065F46) : const Color(0xFF991B1B),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }
}