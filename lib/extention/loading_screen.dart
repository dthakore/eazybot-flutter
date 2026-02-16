import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constant/colors.dart';

class LoadingScreen {
  LoadingScreen._();

  static show(BuildContext context, String text) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: _customDialog(context, text),
          );
        });
  }

  static hide(BuildContext context) {
    Navigator.pop(context);
  }

  static _customDialog(BuildContext context, String text) {
    return Container(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation(colorPrimary),
                ),
                (text.length>0)?Padding(
                  padding: EdgeInsets.only(top: 20),
                ):Container(width: 0, height: 0,),
                (text.length>0)?Text(
                  text,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ):Container(width: 0, height: 0,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


extension BuildContextX on BuildContext {
  void showMessageSnackBar(String message, bool isError) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: (isError)?Colors.red:Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // ScaffoldMessenger.of(this).showSnackBar(
    //   SnackBar(
    //     backgroundColor: (isError)?Colors.grey:Colors.green,
    //     content: Text(message, style: TextStyle(color: Colors.white, fontSize: 16),),
    //     duration: const Duration(milliseconds: 1000),
    //   ),
    // );
  }

  void showMessageSnackBarTop(String message, String body, bool isError) {
    Fluttertoast.showToast(
        msg: "${message}:${body}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: (isError)?Colors.red:Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // ScaffoldMessenger.of(this).showSnackBar(
    //   SnackBar(
    //     backgroundColor: (isError)?Colors.grey:Colors.green,
    //     content: Text(message, style: TextStyle(color: Colors.white, fontSize: 16),),
    //     duration: const Duration(milliseconds: 1000),
    //   ),
    // );
  }
}