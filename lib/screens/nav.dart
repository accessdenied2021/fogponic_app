// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fogponic_app/screens/components/AISelector.dart';
import 'package:fogponic_app/screens/control.dart';
import 'package:fogponic_app/screens/dashboard.dart';
import 'package:fogponic_app/screens/leafAI.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Nav extends StatefulWidget {
  Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  @override
  bool value = true;
  final dbRef = FirebaseDatabase.instance.ref();

  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  int _selectedTab = 0;

  final List _pages = [
    Dashboard(),
    Control(),
    PlantSelector(),
    Center(
      child: Text("Settings"),
    ),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
      if (_selectedTab == 1) {
        Control();
      } else if (_selectedTab == 2) {
        PlantSelector();
      }
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => _changeTab(index),
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.games), label: "Control"),
            BottomNavigationBarItem(
                icon: Icon(Icons.coronavirus), label: "Disease"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
        ),
        body: _pages[_selectedTab]);
  }
}
