import 'package:eazybot/constant/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../constant/colors.dart';
import '../../constant/images.dart';
import '../../constant/string.dart';
import '../../core/route.dart';
import '../../styles/text_styles.dart';

class OTPVerify extends StatefulWidget {
  const OTPVerify({super.key});

  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {

  bool isValid = true;

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: (isValid)?Colors.grey:Colors.red, width: 1),
        borderRadius: BorderRadius.circular(4), // Rounded border
        color: Colors.transparent, // No fill
      ),
    );
    final size = MediaQuery.of(context).size;
    return Scaffold (
        body: SingleChildScrollView(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      width: 40,
                      height: 40,
                      child: Image.asset(back),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,),
              Text(VerifyYourAccount, style: headerText, textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: ShapeDecoration(
                  color: const Color(0xFFECF4FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    SizedBox(
                      width: 322,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Enter the 6-digit code sent to you at ',
                              style: TextStyle(
                                color: color444444,
                                fontSize: 13,
                                fontFamily: fontInter,
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                            ),
                            TextSpan(
                              text: 'acco****unt@email.com',
                              style: TextStyle(
                                color: color03ACEF,
                                fontSize: 13,
                                fontFamily: fontInter,
                                fontWeight: FontWeight.w400,
                                height: 1.43,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                showCursor: true, // Show the blinking cursor
                separatorBuilder: (index) => const SizedBox(width: 10), // <-- spacing

                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: colorPrimary, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  )
                ),
              ),
              if(!isValid)SizedBox(height: 15,),
              if(!isValid)SizedBox(
                width: 341,
                child: Text(
                  incorrectCode,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorD20000,
                    fontSize: 14,
                    fontFamily: fontInter,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: () {
                    if(isValid) {
                      isValid = false;
                      setState(() {});
                    } else {
                      //redirect on home screen
                      // Navigator.pushNamed(
                      //   context,
                      //   RouteGenerator.botListScreen,
                      // );

                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   RouteGenerator.botListScreen,
                      //       (route) => false,
                      // );

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RouteGenerator.splashScreen,
                            (route) => false,
                      );

                    }
                },
                child: Container(
                  width: size.width-50,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: ShapeDecoration(
                    color: colorPrimary,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFF2D57F8) /* Color */,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    createAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: fontInter,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(
                'Resend code (82s)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF2D57F8),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        )
    );
  }
}
