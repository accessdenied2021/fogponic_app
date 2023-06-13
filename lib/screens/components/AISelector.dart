import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fogponic_app/screens/leafAI.dart';

class PlantSelector extends StatefulWidget {
  @override
  _PlantSelectorState createState() => _PlantSelectorState();
}

class _PlantSelectorState extends State<PlantSelector> {
  List<String> plantItems = []; // List to store dropdown items
  String? selectedPlant;

  @override
  void initState() {
    super.initState();
    fetchPlantItems();
  }

  Future<void> fetchPlantItems() async {
    // Retrieve documents from Firestore collection "AI List"
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('AI List').get();

    List<String> items = [];
    querySnapshot.docs.forEach((doc) {
      // Add each document ID to the items list
      items.add(doc.id);
    });

    setState(() {
      plantItems = items;
    });
  }

  void navigateToLeafAI() {
    if (selectedPlant != null) {
      String? predictionAPI;
      String? predictionKey;

      // Fetch the selected document from Firestore
      FirebaseFirestore.instance
          .collection('AI List')
          .doc(selectedPlant)
          .get()
          .then((docSnapshot) {
        if (docSnapshot.exists) {
          predictionAPI = docSnapshot.get('predictionAPI') as String?;
          predictionKey = docSnapshot.get('predictionKey') as String?;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeafAI(
                  predictionAPI: predictionAPI, predictionKey: predictionKey),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Selection'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Please select the type of plant you want to check",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              DropdownButton<String>(
                value: selectedPlant,
                hint: Text('Select Plant'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPlant = newValue;
                  });
                },
                items: plantItems.map((String plant) {
                  return DropdownMenuItem<String>(
                    value: plant,
                    child: Text(plant),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: navigateToLeafAI,
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
