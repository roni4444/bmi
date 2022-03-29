import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mybmi/firebase_options.dart';
import 'package:mybmi/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool initialized = false;
  void initializeFlutterFire() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
    setState(() {
      initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF0A0E21),
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
        ),
        home: (initialized)
            ? const Splash()
            : const Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Center(
                    child: Image(
                      image: AssetImage('images/MY BMI.png'),
                    ),
                  ),
                ),
              ));
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }
}
