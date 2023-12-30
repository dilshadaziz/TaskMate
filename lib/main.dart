// ignore_for_file: no_leading_underscores_for_local_identifiers, constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/screens/splash.dart';
// import 'package:taskmate/services/notify_helper.dart';
// import 'package:timezone/timezone.dart' as tz;

const SAVE_KEY = 'userLoggedIn';
const CATEGORY_KEY = 'alreadyAdded';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the database
  await DBHelper.initializeDatabase();

  // Run the Flutter application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      // Debug banner is disabled
      debugShowCheckedModeBanner: false,
      

      // App title
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),

      // Initial screen is the Splash widget
      home: const Splash(),
    );
  }
}