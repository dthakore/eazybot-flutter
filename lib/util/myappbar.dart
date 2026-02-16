import 'package:eazybot/constant/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/colors.dart';
import '../constant/images.dart';


class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  bool isBack = false;
  bool isFirstScreen = true;
  final List<Widget>? actions;
  MyAppBar({
    required this.title,
    this.isBack = false,
    this.isFirstScreen = true,
    this.actions,
  });
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: (this.isBack) ? IconButton(
        icon: Icon(Icons.arrow_back), // Different icon for back button
        onPressed: () {
          Navigator.pop(context);
        },
      ) : null,
      //title: Text(this.title, style: TextStyle(fontFamily: "DMSans", color: Colors.black, fontWeight: FontWeight.bold),),
        //Container(width: 19,height: 19,child: Image.asset(googleLogo,),)
      title: (this.isFirstScreen) ?
      //(this.title.length>0) ? Text(this.title, style: TextStyle(fontFamily: fontInter, color: Colors.black, fontWeight: FontWeight.bold,),) : Container(child: SvgPicture.asset(icAlarm), alignment: Alignment.centerLeft,) :
      (this.title.length>0) ? Text(this.title, style: TextStyle(fontFamily: fontInter, color: Colors.black, fontWeight: FontWeight.bold,),) : Container(child: Image.asset(eazybotPNG),height: 40, alignment: Alignment.centerLeft,) :
      Text(this.title, style: TextStyle(fontFamily: fontInter, color: Colors.black, fontWeight: FontWeight.bold,),),
      backgroundColor: colorF1F5F9,
      iconTheme: IconThemeData(color: Colors.black),
      actions: actions,
/*
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorDDE7FF, Colors.white], // Set the colors for the gradient
            begin: Alignment.topCenter, // Set the gradient's starting point
            end: Alignment.bottomCenter, // Set the gradient's end point
          ),
        ),
      ),
*/
    );
  }

  @override
  //Size get preferredSize => Size.fromHeight(bottom == null ? kToolbarHeight : kToolbarHeight + bottom.preferredSize.height);
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

