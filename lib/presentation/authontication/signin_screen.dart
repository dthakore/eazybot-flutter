import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../constant/colors.dart';
import '../../constant/fonts.dart';
import '../../constant/images.dart';
import '../../constant/string.dart';
import '../../core/route.dart';
import '../../cubits/security_auth/auth_cubit.dart';
import '../../cubits/security_auth/auth_state.dart';
import '../../extention/loading_screen.dart';
import '../../styles/text_styles.dart';
import '../FebTabs.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  var userNameText = TextEditingController();
  var passwordText = TextEditingController();
  bool _obscureText = false;
  String? fcmToken;

  Future<void> getToken() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      String? token = await FirebaseMessaging.instance.getToken();
      print("Token: $token");
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.requestPermission();
    getToken();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void showDialogLoader(context) {
    LoadingScreen.show(context, "");
  }

  void hideDialogLoader(context) {
    LoadingScreen.hide(context);
  }

  final GlobalKey<_SignInScreenState> _key = GlobalKey<_SignInScreenState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) {
        return AuthCubit();
      },
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            showDialogLoader(this.context);
          }
          if (state is AuthLoadedState) {
            hideDialogLoader(this.context);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FabTab(selectedIndex: 0)),
              ModalRoute.withName(RouteGenerator.fabTab),
            );
          }
          if (state is AuthErrorState) {
            print("state.error ${state.error}");
            hideDialogLoader(this.context);
            this.context.showMessageSnackBar(state.error, true);
          }
        },
        builder: (builderContext, state) {
          return Scaffold(
            key: _key,
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80),

                  if (fcmToken != null)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: SelectableText(
                        "FCM Token:\n$fcmToken",
                        style: TextStyle(fontSize: 11, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 80,
                        child: Image.asset(logoIconPng),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    cryptoTrading,
                    style: headerText,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: size.width - 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFECF4FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 20),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sign up with ',
                                style: TextStyle(
                                  color: const Color(0xFF444444),
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.27,
                                ),
                              ),
                              TextSpan(
                                text: 'Sagar Shah',
                                style: TextStyle(
                                  color: const Color(0xFF03ACEF) /* Primary */,
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.27,
                                ),
                              ),
                              TextSpan(
                                text: ' referral',
                                style: TextStyle(
                                  color: const Color(0xFF444444),
                                  fontSize: 11,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.27,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: size.width - 50,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFF2D57F8) /* Color */,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Container(
                          width: 19,
                          height: 19,
                          child: Image.asset(googleLogo),
                        ),
                        Text(
                          'Sign Up with Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xB71B2B41),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //width: 139.91,
                        width: size.width / 2.7,
                        decoration: ShapeDecoration(
                          color: color475569.withAlpha(30),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: color1C3454.withAlpha(30),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 24.43,
                        child: Text(
                          'OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: color1C3454.withAlpha(95),
                            fontSize: 14,
                            fontFamily: fontInter,
                            fontWeight: FontWeight.w400,
                            height: 1.34,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        //width: 139.91,
                        width: size.width / 2.7,
                        decoration: ShapeDecoration(
                          color: color475569.withAlpha(30),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: color1C3454.withAlpha(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: size.width - 50,
                    child: Text(
                      emailAddress,
                      textAlign: TextAlign.left,
                      style: titleStyle,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: size.width - 50,
                    height: 45,
                    //padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: TextField(
                      controller: this.userNameText,
                      textInputAction: TextInputAction.done,
                      //keyboardType: TextInputType.number,
                      style: signInISignUPTextStyle,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10.0, top: 10),
                        hintText: emailAddress,
                        hintStyle: TextStyle(
                          color: colorGray,
                          fontFamily: fontInter,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
                      onChanged: (value) {
                        //BlocProvider.of<AuthCubit>(context).verifyPhone(value, this.isNumber);
                      },
                    ),

                    /*TextField(
                  decoration: InputDecoration(
                    labelText: 'Custom Border Color',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                )
                  */
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: size.width - 50,
                    child: Text(
                      password,
                      textAlign: TextAlign.left,
                      style: titleStyle,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: size.width - 50,
                    height: 45,
                    //padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: TextField(
                      controller: this.passwordText,
                      obscureText: _obscureText,
                      textInputAction: TextInputAction.done,
                      //keyboardType: TextInputType.number,
                      style: signInISignUPTextStyle,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10.0, top: 10),
                        hintText: password,
                        hintStyle: TextStyle(
                          color: colorGray,
                          fontFamily: fontInter,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      onChanged: (value) {
                        //BlocProvider.of<AuthCubit>(context).verifyPhone(value, this.isNumber);
                      },
                    ),

                    /*TextField(
                  decoration: InputDecoration(
                    labelText: 'Custom Border Color',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                )
                  */
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: size.width - 50,
                    //height: 31,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          _obscureText ? Icons.check_box : Icons.check_box,
                          color: colorPrimary,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    color: const Color(0xB71B2B41),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.67,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Terms of services',
                                  style: TextStyle(
                                    color: const Color(0xFF185ADC),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.67,
                                  ),
                                ),
                                TextSpan(
                                  text: ' of EazyBot and acknowledge the ',
                                  style: TextStyle(
                                    color: const Color(0xB71B2B41),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.67,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: const Color(0xFF185ADC),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.67,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print("Login click");
                      //_key.currentContext?.read<AuthCubit>().userLogin(userNameText.text, passwordText.text);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FabTab(selectedIndex: 0),
                        ),
                        ModalRoute.withName(RouteGenerator.fabTab),
                      );
                    },
                    child: Container(
                      width: size.width - 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        'Already a member?  ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.22,
                        ),
                      ),
                      Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF2D57F8),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
