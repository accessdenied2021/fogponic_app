import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fogponic_app/screens/dashboard.dart';

import 'screens/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{'/nav': (BuildContext context) => Nav()},
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: Nav(),
    );
  }
}
