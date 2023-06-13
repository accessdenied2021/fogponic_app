// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fogponic_app/screens/control.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  bool value = true;
  final dbRef = FirebaseDatabase.instance.ref();

  onUpdate() {
    setState(() {
      value = !value;
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
        title: Text('Dashboard'),
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
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Water Level:",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),

                        Text(
                          waterLevel.toString(),
                          style: TextStyle(fontSize: 20),
                        ),

                        SizedBox(
                          height: 30,
                        ),

                        // Water Temperature
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Air Humidity",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),

                        Text(
                          airHumidity.toString() + "%",
                          style: TextStyle(fontSize: 18),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SfLinearGauge(
                            animateAxis: true,
                            markerPointers: [
                              LinearShapePointer(
                                value: airHumidity + 0.05,
                              ),
                            ],
                            barPointers: [
                              LinearBarPointer(value: airHumidity + 0.05)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        // Air Temperature
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Air Temperature",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 260,
                                child: SfRadialGauge(axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 100,
                                      ranges: <GaugeRange>[
                                        GaugeRange(
                                            startValue: 0,
                                            endValue: 40,
                                            color: Colors.green),
                                        GaugeRange(
                                            startValue: 40,
                                            endValue: 60,
                                            color: Colors.orange),
                                        GaugeRange(
                                            startValue: 60,
                                            endValue: 100,
                                            color: Colors.red)
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(
                                            needleStartWidth: 0.2,
                                            needleEndWidth: 8,
                                            value: airTemperature + 0.01)
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            widget: Container(
                                                child: Text(
                                                    airTemperature.toString() +
                                                        '\u00B0C',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            angle: 90,
                                            positionFactor: 0.5)
                                      ])
                                ]))),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        // Water Temperature
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Water Temperature",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 260,
                                child: SfRadialGauge(axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 100,
                                      ranges: <GaugeRange>[
                                        GaugeRange(
                                            startValue: 0,
                                            endValue: 30,
                                            color: Colors.green),
                                        GaugeRange(
                                            startValue: 30,
                                            endValue: 50,
                                            color: Colors.orange),
                                        GaugeRange(
                                            startValue: 50,
                                            endValue: 100,
                                            color: Colors.red)
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(
                                            needleStartWidth: 0.2,
                                            needleEndWidth: 8,
                                            value: waterTemperature + 0.01)
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            widget: Container(
                                                child: Text(
                                                    waterTemperature
                                                            .toString() +
                                                        '\u00B0C',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            angle: 90,
                                            positionFactor: 0.5)
                                      ])
                                ]))),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
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
}
