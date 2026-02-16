import 'package:eazybot/constant/colors.dart';
import 'package:eazybot/presentation/affiliate/affiliate_screen.dart';
import 'package:eazybot/presentation/bots/bot_list_screen.dart';
import 'package:eazybot/presentation/insights/insights_screen.dart';
import 'package:eazybot/presentation/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';

import '../constant/images.dart';


class FabTab extends StatefulWidget {
  //const FabTab({super.key});
  int selectedIndex = 0;
  FabTab({required this.selectedIndex});

  @override
  State<FabTab> createState() => _FabTabState();
}

class _FabTabState extends State<FabTab> {

  int currentIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      widget.selectedIndex = index;
      currentIndex = widget.selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onItemTapped(widget.selectedIndex);
  }

  final List<Widget> page = [
    BotListScreen(),
    InsightsScreen(),
    WalletScreen(),
    AffiliateScreen(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = currentIndex == 0 ? BotListScreen() : currentIndex == 1 ? InsightsScreen() : currentIndex == 2 ? WalletScreen():  AffiliateScreen();
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      /*
      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
        backgroundColor: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(child: Image.asset("assets/stockwiz.png"),),
        ),
        onPressed: () {
          print("add fab button");
          setState(() {
            AppConstant.isStockwiz = true;
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => SelectYourApp()
                )
            );
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
*/
      bottomNavigationBar:  BottomAppBar(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        color: Colors.grey.withOpacity(0.03),
        //surfaceTintColor: Colors.grey.withOpacity(0.5),
        height: 60,
        shape: CircularNotchedRectangle(),
        //notchMargin: 10,
        child:  Container (
          //color: Colors.red,
          //height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,      //floating button spaceBetween
            children: [
              Expanded(
                child: MaterialButton(
                  //minWidth: 50,   //add floating button
                  onPressed: (){
                    setState(() {
                      currentScreen = BotListScreen();
                      currentIndex = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //home_unselected

                      (currentIndex == 0)?
                      Container(
                        //width: 40,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                        decoration: ShapeDecoration(
                          //color: const Color(0x7F2D57F8).withAlpha(10),
                          shape: OvalBorder(),
                          shadows: [
                            BoxShadow(
                              color: Color(0x7F2D57F8).withAlpha(30),
                              blurRadius:8,
                              offset: Offset(0, 0),
                              spreadRadius: 3,
                            )
                          ],
                        ),
                        // decoration: ShapeDecoration(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        // ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Container(
                              width: 25,
                              height: 20,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(),
                              child: Image.asset(botsSelected),
                            ),
                          ],
                        ),
                      ) :
                      Container(child: Image.asset(currentIndex == 0 ? walleteSelected : walleteUnselected),height: 30, width: 30,),
                      // Icon(Icons.home_filled,
                      //   color: currentIndex == 0 ? Colors.blue : Colors.grey,
                      // ),
                      Flexible(
                        child: Text(
                          "Bots",
                          style: TextStyle(color: currentIndex == 0 ? colorPrimary : Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                
                ),
              ),
              Expanded(
                child: MaterialButton(
                  // minWidth: 50,   //add floating button
                  onPressed: (){
                    setState(() {
                      currentScreen = InsightsScreen();
                      currentIndex = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child: Image.asset(currentIndex == 1 ? walleteSelected : walleteUnselected),height: 30, width: 30,),
                      // Icon(Icons.person,
                      //   color: currentIndex == 1 ? Colors.purple : Colors.grey,
                      // ),
                      Flexible(
                        child: Text(
                          "Insights",
                          style: TextStyle(color: currentIndex == 1 ? colorPrimary : Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                
                ),
              ),
              Expanded(
                child: MaterialButton(
                  //minWidth: 50,   //add floating button
                  onPressed: (){
                    setState(() {
                      currentScreen = WalletScreen();
                      currentIndex = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child: Image.asset(currentIndex == 2 ? walleteSelected : walleteUnselected),height: 30, width: 30,),
                      // Icon(Icons.person_pin_outlined,
                      //   color: currentIndex == 2 ? Colors.green : Colors.grey,
                      // ),
                      Flexible(
                        child: Text(
                          "Wallet",
                          style: TextStyle(color: currentIndex == 2 ? colorPrimary : Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                
                ),
              ),
              Expanded(
                child: MaterialButton(
                  //minWidth: 50,   //add floating button
                  onPressed: (){
                    setState(() {
                      currentScreen = AffiliateScreen();
                      currentIndex = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(child: Image.asset(currentIndex == 3 ? walleteSelected : walleteUnselected),height: 30, width: 30,),
                      // Icon(Icons.more_horiz_outlined,
                      //   color: currentIndex == 3 ? Colors.blueAccent : Colors.grey,
                      // ),
                      Flexible(
                        child: Text(
                          "Affiliate",
                          style: TextStyle(color: currentIndex == 3 ? colorPrimary : Colors.grey, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                
                ),
              )
            ],
          ),
        ),

      ),

    );
  }
}
