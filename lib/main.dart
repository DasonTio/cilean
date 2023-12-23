import 'package:cilean/constants/config/route_config.dart';
import 'package:cilean/constants/config/theme_config.dart';
import 'package:cilean/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Status Bar Transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  if (FirebaseAuth.instance.currentUser != null) {
    runApp(const Main(
      initialRoute: '/',
    ));
  } else {
    runApp(const Main(
      initialRoute: '/auth',
    ));
  }
}

class Main extends StatefulWidget {
  const Main({
    Key? key,
    required this.initialRoute,
  }) : super(key: key);
  final String initialRoute;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final ThemeConfig _themeConfig = ThemeConfig();
  final RouteConfig _routeConfig = RouteConfig();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// Routes
      initialRoute: widget.initialRoute,
      onGenerateRoute: _routeConfig.onGenerateRoute,

      /// Theme
      theme: _themeConfig.genData(),

      /// Debug
      debugShowCheckedModeBanner: false,
    );
  }
}
