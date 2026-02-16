import 'package:eazybot/constant/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constant/colors.dart';


class CustomButton extends StatelessWidget {
  final String name;
  final VoidCallback callBack;

  const CustomButton({super.key, required this.name, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        callBack();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 10,
        color: colorPrimary,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                    color: Colors.white, fontSize: 16, fontFamily: fontInter),
              ),
              const SizedBox(
                width: 5,
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}
