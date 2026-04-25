import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import '../../api/auth_api.dart';
import '../../core/token_storage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final userNameText = TextEditingController();
  final passwordText = TextEditingController();
  bool _obscureText = true;
  bool _agreeToTerms = true;

  Future<void> getToken() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await FirebaseMessaging.instance.getToken();
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    getToken();
  }

  @override
  void dispose() {
    userNameText.dispose();
    passwordText.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void showDialogLoader(BuildContext ctx) => LoadingScreen.show(ctx, "");
  void hideDialogLoader(BuildContext ctx) => LoadingScreen.hide(ctx);

  Future<void> _onSignIn(BuildContext ctx) async {
    final email = userNameText.text.trim();
    final pass = passwordText.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    showDialogLoader(ctx);

    try {
      final token = await AuthApi().login(email, pass);
      hideDialogLoader(ctx);

      if (token != null) {
        await TokenStorage.saveToken(token);
        Navigator.pushAndRemoveUntil(
          ctx,
          MaterialPageRoute(builder: (_) => FabTab(selectedIndex: 0)),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text("Login failed. Please check credentials")),
        );
      }
    } catch (e) {
      hideDialogLoader(ctx);
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) showDialogLoader(context);
          if (state is AuthLoadedState) {
            hideDialogLoader(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => FabTab(selectedIndex: 0)),
              ModalRoute.withName(RouteGenerator.fabTab),
            );
          }
          if (state is AuthErrorState) {
            hideDialogLoader(context);
            context.showMessageSnackBar(state.error, true);
          }
        },
        builder: (builderContext, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    /// Logo
                    SizedBox(
                      width: 130,
                      height: 70,
                      child: Image.asset(logoIconPng),
                    ),
                    const SizedBox(height: 16),

                    /// Tagline
                    Text(
                      cryptoTrading,
                      style: headerText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    /// Sign In with Google
                    _googleButton(size),
                    const SizedBox(height: 20),

                    /// OR divider
                    _orDivider(size),
                    const SizedBox(height: 20),

                    /// Email field
                    _fieldLabel(emailAddress),
                    const SizedBox(height: 8),
                    _emailField(),
                    const SizedBox(height: 16),

                    /// Password field
                    _fieldLabel(password),
                    const SizedBox(height: 8),
                    _passwordField(),
                    const SizedBox(height: 8),

                    /// Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF2D57F8),
                            fontSize: 12,
                            fontFamily: fontInter,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Terms checkbox
                    _termsRow(),
                    const SizedBox(height: 24),

                    /// Sign In button
                    GestureDetector(
                      onTap: () => _onSignIn(builderContext),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          signIn,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: fontInter,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// Footer: Don't have account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?  ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontFamily: fontInter,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Color(0xFF2D57F8),
                              fontSize: 13,
                              fontFamily: fontInter,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: titleStyle),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: userNameText,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      style: signInISignUPTextStyle,
      decoration: _inputDecoration(emailAddress),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: passwordText,
      obscureText: _obscureText,
      textInputAction: TextInputAction.done,
      style: signInISignUPTextStyle,
      decoration: _inputDecoration(password).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20,
            color: Colors.grey,
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintText: hint,
      hintStyle: TextStyle(
        color: colorGray,
        fontFamily: fontInter,
        fontSize: 14,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Color(0xFF2D57F8), width: 1.5),
      ),
    );
  }

  Widget _termsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
          child: Icon(
            _agreeToTerms ? Icons.check_box : Icons.check_box_outline_blank,
            color: colorPrimary,
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(
                    color: Color(0xB71B2B41),
                    fontSize: 12,
                    fontFamily: fontInter,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: Color(0xFF185ADC),
                    fontSize: 12,
                    fontFamily: fontInter,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(
                  text: ' of EazyBot and acknowledge the ',
                  style: TextStyle(
                    color: Color(0xB71B2B41),
                    fontSize: 12,
                    fontFamily: fontInter,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Color(0xFF185ADC),
                    fontSize: 12,
                    fontFamily: fontInter,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _googleButton(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Image.asset(googleLogo),
          ),
          const SizedBox(width: 12),
          const Text(
            'Sign In with Google',
            style: TextStyle(
              color: Color(0xFF1B2B41),
              fontSize: 14,
              fontFamily: fontInter,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orDivider(Size size) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              fontFamily: fontInter,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ],
    );
  }
}
