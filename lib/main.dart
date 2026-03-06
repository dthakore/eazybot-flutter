import 'package:eazybot/presentation/authontication/signin_screen.dart';
import 'package:eazybot/presentation/FebTabs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/route.dart';
import 'firebase_options.dart';
import 'core/token_storage.dart';

final GlobalKey<NavigatorState> navigatorMainKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb) {
    await NotificationService.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _startScreen = const SignInScreen();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    String? token = await TokenStorage.getToken();

    if (token != null && token.isNotEmpty) {
      setState(() {
        _startScreen = FabTab(selectedIndex: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorMainKey,
      debugShowCheckedModeBanner: false,
      title: "Eazybot",

      onGenerateRoute: RouteGenerator.generateRoute,

      home: _startScreen,
    );
  }
}
