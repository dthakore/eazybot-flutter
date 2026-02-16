import 'package:eazybot/presentation/authontication/signin_screen.dart';
import 'package:flutter/material.dart';

import 'core/route.dart';

final GlobalKey<NavigatorState> navigatorMainKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorMainKey,
      debugShowCheckedModeBanner: false,
      title: "Eazybot",
      /*
      theme: ThemeData(
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        // ⛔ Disable ripple animation
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        // ⛔ Disable splash color
        fontFamily: fontDMSans,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: colorPrimary,
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey; // Disabled state
            }
            if (states.contains(MaterialState.selected)) {
              return colorPrimary; // Selected color
            }
            return colorD4D4D8; // Unselected color
          }),
          overlayColor: WidgetStateProperty.all(Colors.blue.withOpacity(0.1)),
          visualDensity: VisualDensity.standard,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        switchTheme: SwitchThemeData(
          padding: EdgeInsetsGeometry.zero,
          thumbColor: WidgetStateProperty.all(colorWhite),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorPrimary;
            }
            return color838383;
          }),
          trackOutlineWidth: WidgetStateProperty.all(0.0),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.all(Colors.white), // Tick color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: const BorderSide(width: 1.5, color: color9CA4AB), // Outline
        ),
        colorScheme: const ColorScheme.light(
          primary: colorPrimary,
          secondary: colorPrimary,
        ),
      ),
      */
      onGenerateRoute: RouteGenerator.generateRoute,
      home: SignInScreen(),
    );
  }
}
