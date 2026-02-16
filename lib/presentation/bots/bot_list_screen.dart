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

class BotListScreen extends StatefulWidget {
  const BotListScreen({super.key});

  @override
  State<BotListScreen> createState() => _BotListScreenState();
}

class _BotListScreenState extends State<BotListScreen> {

  var namesArr = ["Mehul", "Sunil","Aswin", "Jayesh", "Kaushal","Mehul", "Sunil","Aswin", "Jayesh", "Kaushal", "Mehul", "Sunil","Aswin", "Jayesh", "Kaushal"];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        //key: blockKey,
        backgroundColor: colorF1F5F9,
        //drawer: SideMenu(),
        appBar: MyAppBar(title: "", isFirstScreen: true, actions: [
          Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: GestureDetector(
                onTap: () {
                  print("Notification");
                },
                child: Container(child: Image.asset(icNotification),height: 50, width: 50,),
              )
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
                                )
                              ],
                            ),

                          ),
                          SizedBox(width: 5,)
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
                      )
                      )
                    ],
                  ),
                )
              )
          ),
        ],),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Bots, style: blackBoldTextStyle(18), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Container(
                  width: size.width-40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 5,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Active : ',
                                          style: TextStyle(
                                            color: const Color(0xFF475569),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '12',
                                          style: TextStyle(
                                            color: const Color(0xFF039855) /* Success-600 */,
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
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
                                            color: const Color(0xFF475569),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '6',
                                          style: TextStyle(
                                            color: const Color(0xFFFF9500) /* Colors-Orange */,
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
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
                                            color: const Color(0xFF475569),
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '4',
                                          style: TextStyle(
                                            color: const Color(0xFFFF3B30) /* Colors-Red */,
                                            fontSize: 10,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
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
                      Container(
                        padding: const EdgeInsets.only(right: 48),
                        width: double.infinity,
                        height: 41,
                        color: const Color(0xFFF1F5F9),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: const Color(0xFF334155),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Deleted bots',
                              style: TextStyle(
                                color: const Color(0xFF334155),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Grand Total',
                              style: TextStyle(
                                color: const Color(0xFF334155),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            //SizedBox(width: 0,)
                          ],
                        ),
                      ),
                      Container(
                        //padding: const EdgeInsets.only(left: 10, right: 10),
                        width: double.infinity,
                        height: 41,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: const Border(
                            bottom: BorderSide(width: 1, color: colorE2E8F0),
                            top: BorderSide(width: 2, color: colorE2E8F0),
                          ),
                          //borderRadius: BorderRadius.circular(12), // Optional, if you want rounding
                        ),
                        child: Row(
                          children: [
                            //SizedBox(width: 10,),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 5,
                                children: [
                                  Row(
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 10,),
                                      Container(child: Image.asset(icUsdc),height: 20, width: 20,),
                                      SizedBox(width: 5,),
                                      Text(
                                        'USDC',
                                        style: TextStyle(
                                          color: const Color(0xFF334155),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '-',
                                    style: TextStyle(
                                      color: const Color(0xFF334155),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '-',
                                    style: TextStyle(
                                      color: const Color(0xFF334155),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 5,)
                                ],
                              ),
                            ),
                            Container(
                              height: 41,
                              width: 41,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: const Border(
                                  left: BorderSide(width: 1, color: colorE2E8F0),
                                ),
                                //borderRadius: BorderRadius.circular(12), // Optional, if you want rounding
                              ),
                              child: Center(child: Icon(Icons.keyboard_arrow_down, size: 30, color: color475569.withAlpha(95))),
                            )
                          ],
                        ),
                      ),
                      Container(
                        //padding: const EdgeInsets.only(left: 10, right: 10),
                        width: double.infinity,
                        height: 41,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: const Border(
                            bottom: BorderSide(width: 1, color: colorE2E8F0),
                          ),
                          //borderRadius: BorderRadius.circular(12), // Optional, if you want rounding
                        ),
                        child: Row(
                          children: [
                            //SizedBox(width: 10,),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 5,
                                children: [
                                  Row(
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(width: 10,),
                                      Container(child: Image.asset(icUsdcT),height: 20, width: 20,),
                                      SizedBox(width: 5,),
                                      Text(
                                        'USDC',
                                        style: TextStyle(
                                          color: const Color(0xFF334155),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '1520.65',
                                    style: TextStyle(
                                      color: const Color(0xFF334155),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '2227.60',
                                    style: TextStyle(
                                      color: const Color(0xFF334155),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 5,)
                                ],
                              ),
                            ),
                            Container(
                              height: 41,
                              width: 41,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: const Border(
                                  left: BorderSide(width: 1, color: colorE2E8F0),
                                ),
                                //borderRadius: BorderRadius.circular(12), // Optional, if you want rounding
                              ),
                              child: Center(child: Icon(Icons.keyboard_arrow_down, size: 30, color: color475569.withAlpha(95))),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 41,
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            //SizedBox(width: 10,),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 5,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      //Container(height: 20, width: 5,),
                                      //SizedBox(width: 5,),
                                      Text(
                                        'Total Profit',
                                        style: TextStyle(
                                          color: const Color(0xFF475569),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '1520.65',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF475569),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '2227.60',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: const Color(0xFF475569),
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 5,)
                                ],
                              ),
                            ),
                            Container(
                              height: 41,
                              width: 41,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: const Border(
                                  left: BorderSide(width: 0, color: Colors.white),
                                ),
                                //borderRadius: BorderRadius.circular(12), // Optional, if you want rounding
                              ),
                              //child: Center(child: Icon(Icons.keyboard_arrow_down, size: 30, color: color475569.withAlpha(95))),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text(BotCollection, style: blackBoldTextStyle(16))),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: ShapeDecoration(
                        color: colorPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //spacing: 6,
                        children: [
                          Icon(Icons.add, color: Colors.white,),
                          SizedBox(width: 3,),
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
                SizedBox(height: 20,),

                ///Table

                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var notificationInfo = namesArr[index];
                    double percentage = -50.15; // example value
                    double price = 1481.71;

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteGenerator.botInsightScreen,
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
                                Expanded(child: Row(
                                  children: [
                                    SizedBox(width: 10,),
                                    Icon(Icons.check_box, size: 20, color: Colors.white),
                                    SizedBox(width: 10,),
                                    Text("ETH", style: blackBoldTextStyle(16)),
                                  ],
                                )),
                                Text(Active, style: textStylew600(14,color26A17B)),
                                SizedBox(width: 15,),
                                Icon(Icons.more_vert, size: 25, color: color475569,),
                                SizedBox(width: 10,),
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
                                  offset: Offset(0, 1), // changes position of shadow
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
                                      padding: EdgeInsets.only(left: 10, top: 15),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(child: Image.asset(icUsdc, width: 35, height: 35)),
                                          ),
                                          Positioned(
                                            left: 20,
                                            top: 0,
                                            child: Container(child: Image.asset(icUsdcT, width: 35, height: 35)),
                                          ),


                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ETH/USDT', style: textStylew600(14,color1E293B)),
                                          // Text('1481.71', style: textStylew600(14,color94A3C1)),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                price.toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color(0xFF1E293B),
                                                ),
                                              ),
                                              SizedBox(width: 6),
                                              Row(
                                                children: [
                                                  Icon(
                                                    percentage < 0
                                                        ? Icons.arrow_downward
                                                        : Icons.arrow_upward,
                                                    size: 14,
                                                    color: percentage < 0
                                                        ? const Color(0xFFFD381E)
                                                        : const Color(0xFF26A17B),
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    '${percentage.abs().toStringAsFixed(2)}%',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: percentage < 0
                                                          ? const Color(0xFFFD381E)
                                                          : const Color(0xFF26A17B),
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
                                        padding: EdgeInsets.only(right: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text('N/A', style: textStylew600(12,color475569)),
                                            Text("Today's Profit", style: textStylew600(12,colorBlack)),
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
                                      Row(
                                        children: [
                                          Flexible(
                                            flex: 1, // 👈 Bigger width
                                            child: badge(
                                              text: "Custom MAS",
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
                                              text: "Upstox",
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
                                              text: "Single",
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
                                          text: "Hardik Bot",
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

                                /// SUMMARY CARDS WITH PROPER SIDE SPACING
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: summaryCard(
                                          title: "REALIZED",
                                          value: "₹674",
                                          valueColor: const Color(0xFF22C55E),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      Flexible(
                                        child: summaryCard(
                                          title: "UNREIZED",
                                          value: "₹-30482",
                                          valueColor: const Color(0xFFEF4444),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      Flexible(
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

                                capitalGrowthCard(),

                                const SizedBox(height: 12),

                                tradeInfoCard(
                                  label: "LAST:",
                                  type: "BUY",
                                  description: "C3 148D ago at Price ₹1322",
                                ),

                                const SizedBox(height: 12),

                                tradeInfoCard(
                                  label: "NEXT:",
                                  type: "BUY",
                                  description: "C4 at Price < ₹1295.76",
                                ),

                                // Container(
                                //   width: double.infinity,
                                //   padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                //   child: Row(
                                //     children: [
                                //       Expanded(
                                //         child: Container(
                                //           width: 107,
                                //           child: Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             mainAxisAlignment: MainAxisAlignment.start,
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             spacing: 4,
                                //             children: [
                                //               Text(
                                //                 'Profit',
                                //                 style: TextStyle(
                                //                   color: const Color(0x99475569),
                                //                   fontSize: 12,
                                //                   fontFamily: 'Inter',
                                //                   fontWeight: FontWeight.w400,
                                //                 ),
                                //               ),
                                //               Text(
                                //                 '166.30',
                                //                 textAlign: TextAlign.right,
                                //                 style: TextStyle(
                                //                   color: const Color(0xFF26A17B),
                                //                   fontSize: 20,
                                //                   fontFamily: 'Inter',
                                //                   fontWeight: FontWeight.w600,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //       Column(
                                //         mainAxisSize: MainAxisSize.min,
                                //         mainAxisAlignment: MainAxisAlignment.start,
                                //         crossAxisAlignment: CrossAxisAlignment.end,
                                //         spacing: 6,
                                //         children: [
                                //           Text(
                                //             'Market Vs Average',
                                //             style: TextStyle(
                                //               color: const Color(0x99475569) /* Sidebar-icon */,
                                //               fontSize: 11,
                                //               fontFamily: 'Inter',
                                //               fontWeight: FontWeight.w400,
                                //             ),
                                //           ),
                                //           Row(
                                //             mainAxisSize: MainAxisSize.min,
                                //             mainAxisAlignment: MainAxisAlignment.start,
                                //             crossAxisAlignment: CrossAxisAlignment.center,
                                //             spacing: 5,
                                //             children: [
                                //               Container(child: Image.asset(icRedArrow, width: 23, height: 16)),
                                //               Text(
                                //                 '-50.15%',
                                //                 style: TextStyle(
                                //                   color: const Color(0xFFFD381E),
                                //                   fontSize: 18,
                                //                   fontFamily: 'Inter',
                                //                   fontWeight: FontWeight.w500,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),

                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                  color: colorFAFAFA,
                                  child: Column(
                                    children: [
                                      Row(
                                        // children: [
                                        //   Expanded(
                                        //     child:
                                        //     Text('${TodayProfit} (9h:19m)', style: blackNormalTextStyle(12,color475569)),
                                        //   ),
                                        //   Row(
                                        //     spacing: 5,
                                        //     children: [
                                        //       Container(child: Image.asset(icUsdcT),height: 15, width: 15,),
                                        //       Text('-', style: blackNormalTextStyle(12,color334155)),
                                        //     ],
                                        //   ),
                                        // ],
                                      ),
                                      // divider(),
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: Text(InitialCapital, style: blackNormalTextStyle(12,color475569)),
                                      //     ),
                                      //     Row(
                                      //       spacing: 5,
                                      //       children: [
                                      //         Container(child: Image.asset(icUsdcT),height: 15, width: 15,),
                                      //         Text('2000.00', style: blackNormalTextStyle(12,color334155)),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                      // divider(),
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: Text(CurrentCapital, style: blackNormalTextStyle(12,color475569)),
                                      //     ),
                                      //     Row(
                                      //       spacing: 5,
                                      //       children: [
                                      //         Container(child: Image.asset(icUsdcT),height: 15, width: 15,),
                                      //         Text('2166.30', style: blackNormalTextStyle(12,color334155)),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                      // divider(),
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: Text(AvailableQuoteCoins, style: blackNormalTextStyle(12,color475569)),
                                      //     ),
                                      //     Row(
                                      //       spacing: 5,
                                      //       children: [
                                      //         Container(child: Image.asset(icUsdcT),height: 15, width: 15,),
                                      //         Text('993.62', style: blackNormalTextStyle(12,color334155)),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                      // divider(),
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: Text(Runtime, style: blackNormalTextStyle(12,color475569)),
                                      //     ),
                                      //     Row(
                                      //       spacing: 5,
                                      //       children: [
                                      //         Icon(Icons.access_time, size: 17, color: Colors.grey,),
                                      //         Text('144D 23H 17M', style: blackNormalTextStyle(12,color334155)),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                      // divider(),
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: Text(LastTrade, style: blackNormalTextStyle(12,color475569)),
                                      //     ),
                                      //     Row(
                                      //       spacing: 5,
                                      //       children: [
                                      //         //Container(child: Image.asset(icUsdcT),height: 15, width: 15,),
                                      //         Text('BUY C9 15D ago', style: blackNormalTextStyle(12,color334155)),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                      // SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 10, right: 10),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        'Bot ID: 107543',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: const Color(0x99475569),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Icon(Icons.copy, size: 14, color: Colors.grey,)
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
                  itemCount: namesArr.length,
                  //reverse: true,
                  //itemExtent: 100,
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.transparent,
                      height: 10,
                      //thickness: 0.5,
                    );
                  },
                ),

              ],
            ),
          ),
        )
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
      //width: double.infinity,
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
              const Icon(Icons.info_outline,
                  size: 14, color: Color(0xFF94A3B8)),
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
  Widget capitalGrowthCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10), // 👈 OUTER SPACING
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
        // crossAxisAlignment: CrossAxisAlignment.start,
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
                children: const [
                  Text(
                    "₹4.01L",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+0.17% from ₹4L",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF22C55E),
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
                children: const [
                  Icon(
                    Icons.access_time,
                    size: 18,
                    color: Color(0xFF38BDF8),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "418D 5H 32M",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ],
              ),
              const Text(
                "Available: ₹3,21,074.35",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10), // 👈 OUTER SPACING
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 8),

          const Chip(
            label: Text("BUY"),
            backgroundColor: Color(0xFFD1FAE5),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // 👈 keeps single line
            ),
          ),
        ],
      ),

    );
  }


}
