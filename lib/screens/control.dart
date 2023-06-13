// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fogponic_app/screens/control.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Control extends StatefulWidget {
  Control({Key? key}) : super(key: key);

  @override
  State<Control> createState() => _ControlState();
}

class _ControlState extends State<Control> {
  @override
  bool value = true;
  bool fogger_value = true;
  final dbRef = FirebaseDatabase.instance.ref();

  onUpdate() {
    setState(() {
      value = !value;
    });
  }

  onUpdate2() {
    setState(() {
      fogger_value = !fogger_value;
    });
  }

  int _selectedTab = 0;

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
      if (_selectedTab == 1) {
        Control();
      }
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Control'),
      ),
      body: StreamBuilder(
          stream: dbRef.child("Data").onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data?.snapshot.value != null) {
              Map<dynamic, dynamic> data = snapshot.data!.snapshot.value;

              var airTemperature = data["Air_Temperature"];
              var airHumidity = data["Air_Humidity"];

              var waterTemperature = data["Water_Temperature"];
              var waterLevel = data["Water_Level"];

              // Use the variables in your UI
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Grow Light Switch",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          onUpdate();
                          //Firebase
                          writeData();
                        },
                        label: value
                            ? Text("Grow Light OFF")
                            : Text("Grow Light ON"),
                        elevation: 20,
                        backgroundColor: value
                            ? Color.fromARGB(255, 119, 107, 0)
                            : Colors.yellow,
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      /** Fogger Switch */
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Fogger Switch",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      FloatingActionButton.extended(
                        onPressed: () {
                          onUpdate2();
                          //Firebase
                          FoggerData();
                        },
                        label: fogger_value
                            ? Text("Fogger OFF")
                            : Text("Fogger ON"),
                        elevation: 20,
                        backgroundColor: fogger_value
                            ? Color.fromARGB(255, 119, 107, 0)
                            : Colors.yellow,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  Future<void> writeData() async {
    String status = "";
    if (!value == true) {
      status = "ON";
    } else if (!value == false) {
      status = "OFF";
    }
    dbRef.child("Data/GrowLightState").set({"GROW_LIGHT": status});
  }

  Future<void> FoggerData() async {
    String status = "";
    if (!fogger_value == true) {
      status = "ON";
    } else if (!fogger_value == false) {
      status = "OFF";
    }
    dbRef.child("Data/Fogger").set({"Fogger1": status});
  }
}
