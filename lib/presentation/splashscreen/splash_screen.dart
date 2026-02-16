import 'package:eazybot/constant/images.dart';
import 'package:eazybot/presentation/authontication/signin_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/route.dart';
import '../../cubits/security_auth/auth_cubit.dart';
import '../FebTabs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) {
            return BlocProvider(
                create: (context) => AuthCubit(),
                child: SignInScreen()
            );
          })
      );


      // Navigator.pushAndRemoveUntil(
      //   context, MaterialPageRoute(
      //   builder: (context) => FabTab(selectedIndex: 0),
      // ),
      //   ModalRoute.withName(RouteGenerator.fabTab),
      // );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(eazybotPNG)),
    );
  }
}
