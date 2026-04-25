import 'package:eazybot/constant/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/colors.dart';
import '../../constant/images.dart';
import '../../constant/string.dart';
import '../../core/route.dart';
import '../../styles/bot_ui_styles.dart';
import '../../styles/text_styles.dart';
import '../../util/myappbar.dart';
import '../../api/bot_api.dart';
import '../../models/bot_model.dart';
import '../../widgets/bot_badge.dart';

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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFBE9F8), // soft pink top-left
            Color(0xFFF3F0FF), // lavender mid
            Color(0xFFE8F4FF), // light blue bottom-right
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                  style: blackBoldTextStyle(BotUiFontSize.xl),
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
                    BorderRadius.all(Radius.circular(BotUiRadius.xxl)),
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
                                fontSize: BotUiFontSize.base,
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
                                          text: 'Active: ',
                                          style: TextStyle(
                                            color: const Color(
                                                0xFF475569),
                                            fontSize: BotUiFontSize.xs,
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
                                            fontSize: BotUiFontSize.xs,
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
                                          text: 'Sell Only: ',
                                          style: TextStyle(
                                            color: const Color(
                                                0xFF475569),
                                            fontSize: BotUiFontSize.xs,
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
                                            fontSize: BotUiFontSize.xs,
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
                                          text: 'Inactive: ',
                                          style: TextStyle(
                                            color: const Color(
                                                0xFF475569),
                                            fontSize: BotUiFontSize.xs,
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
                                            fontSize: BotUiFontSize.xs,
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
                                _buildInsightCard("Non-Deleted Bots Total", revenueInsights?['total']),
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
                            style: blackBoldTextStyle(BotUiFontSize.lg))),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: ShapeDecoration(
                        color: colorPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(BotUiRadius.sm)),
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
                              fontSize: BotUiFontSize.base,
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(BotUiRadius.xl),
                          border: Border.all(
                            color: bot.status == "Active"
                                ? const Color(0xFFBBF7D0)
                                : const Color(0xFFFFB3B3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                        children: [
                          /// ── HEADER (green strip) ──
                          Container(
                            width: double.infinity,
                            height: 36,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFD3EBE5),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(BotUiRadius.xl),
                                  topRight: Radius.circular(BotUiRadius.xl),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      Icon(Icons.check_box,
                                          size: 20, color: Colors.white),
                                      const SizedBox(width: 10),
                                      Text(bot.title,
                                          style: blackBoldTextStyle(BotUiFontSize.lg)),
                                    ],
                                  ),
                                ),
                                Text(
                                  bot.status,
                                  style: textStylew600(
                                    BotUiFontSize.base,
                                    bot.status == "Active"
                                        ? color26A17B
                                        : Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Icon(Icons.more_vert,
                                    size: 25, color: color475569),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                          /// ── BODY ──
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(BotUiRadius.xl),
                                bottomRight: Radius.circular(BotUiRadius.xl),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                      EdgeInsets.only(left: 10, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(bot.coinPair,
                                              style: textStylew600(
                                                  BotUiFontSize.base, color1E293B)),
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
                                                  fontSize: BotUiFontSize.xl,
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
                                                      fontSize: BotUiFontSize.base,
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
                                                BotUiFontSize.md,
                                                bot.todayProfit >= 0
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            Text(
                                              "Today's Profit",
                                              style: textStylew600(
                                                  BotUiFontSize.md, colorBlack),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),                                  width: double.infinity,
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
                                          BotBadge(
                                            text: "${bot.strategy} ${bot.strategyType}",
                                            icon: icBullseye,
                                            bgColor: const Color(0xFFFFF4D6),
                                            textColor: const Color(0xFFB54708),
                                            borderColor: const Color(0xFFFEC84B),
                                          ),
                                          BotBadge(
                                            text: "${bot.exchange}",
                                            icon: icBitcoin,
                                            bgColor: const Color(0xFFEDE9FE),
                                            textColor: const Color(0xFF6941C6),
                                            borderColor: const Color(0xFFD6BBFB),
                                          ),
                                          BotBadge(
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
                                        child: BotBadge(
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

                                /// REALIZED / UNREALIZED / NET P/L
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text("REALIZED",
                                              style: TextStyle(fontSize: BotUiFontSize.xs, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                                            SizedBox(height: 4),
                                            Text("₹674",
                                              style: TextStyle(fontSize: BotUiFontSize.value, fontWeight: FontWeight.w700, color: Color(0xFF22C55E))),
                                          ],
                                        ),
                                      ),
                                      Container(width: 1, height: 30, color: Color(0xFFE2E8F0)),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text("UNREALIZED",
                                              style: TextStyle(fontSize: BotUiFontSize.xs, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                                            SizedBox(height: 4),
                                            Text("₹-30482",
                                              style: TextStyle(fontSize: BotUiFontSize.value, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
                                          ],
                                        ),
                                      ),
                                      Container(width: 1, height: 30, color: Color(0xFFE2E8F0)),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text("NET P/L",
                                              style: TextStyle(fontSize: BotUiFontSize.xs, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                                            SizedBox(height: 4),
                                            Text("₹-29808",
                                              style: TextStyle(fontSize: BotUiFontSize.value, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),

                                capitalGrowthCard(bot),

                                const SizedBox(height: 6),

                                tradeInfoCard(
                                  label: "LAST:",
                                  type: type,
                                  description: description,
                                ),

                                const SizedBox(height: 6),

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
                                        bottomLeft: Radius.circular(BotUiRadius.xl),
                                        bottomRight: Radius.circular(BotUiRadius.xl),
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
                                          fontSize: BotUiFontSize.md,
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
        )));
  }

  Widget _buildInsightCard(String title, dynamic value, {bool isGrandTotal = false}) {
    return Container(
      // height: 75, // Controls the "bigness" of the card
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isGrandTotal ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(BotUiRadius.xl),
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
              fontSize: BotUiFontSize.sm,
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
              fontSize: BotUiFontSize.value,
              fontWeight: FontWeight.w700,
              color: isGrandTotal ? Colors.white : const Color(0xFF1E293B),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
      padding: BotUiCardStyle.contentPadding,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(BotUiRadius.card),
        border: Border.all(color: const Color(0xFF7DD3FC)),
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
                  fontSize: BotUiFontSize.base,
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
                      fontSize: BotUiFontSize.base,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${isPositive ? '+' : ''}${growthPercent.toStringAsFixed(2)}% from ₹${bot.initialCapital.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: BotUiFontSize.sm,
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

          const SizedBox(height: 10),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: Color(0xFF38BDF8),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    bot.runtime,
                    style: const TextStyle(
                      fontSize: BotUiFontSize.sm,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
              Text(
                "Available: ₹${bot.availableQuoteCoins.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: BotUiFontSize.sm,
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
      padding: BotUiCardStyle.contentPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BotUiRadius.card),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: BotUiFontSize.sm,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(width: 8),

          /// BUY / SELL chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isBuy ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(BotUiRadius.sm),
              border: Border.all(
                color: isBuy ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: BotUiFontSize.xs,
                fontWeight: FontWeight.w700,
                color: isBuy ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
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
                fontSize: BotUiFontSize.sm,
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