import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeafAI extends StatefulWidget {
  final String? predictionAPI;
  final String? predictionKey;

  LeafAI({required this.predictionAPI, required this.predictionKey});

  @override
  _LeafAIState createState() => _LeafAIState();
}

class _LeafAIState extends State<LeafAI> {
  File? _image;
  List<dynamic>? _predictions;

  Future<void> _getImageFromGallery() async {
    var status = await Permission.photos.request();
    if (status.isGranted) {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print(
            'Image path: ${_image?.path}'); // Add this line to print the image path

        await runObjectDetection();
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Required'),
            content: const Text(
                'Please enable access to the photo library in the app settings.'),
            actions: [
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> runObjectDetection() async {
    if (_image != null) {
      final Uint8List imageBytes = await _image!.readAsBytes();
      final response = await sendImageToCustomVisionAPI(imageBytes);

      if (response != null) {
        final List<dynamic> predictions = response['predictions'];

        setState(() {
          _predictions = predictions;
        });

        if (_predictions != null) {
          for (final prediction in _predictions!) {
            final tagName = prediction['tagName'];
            final confidence = prediction['probability'];
            print('Tag: $tagName, Confidence: $confidence');
          }
        }
      }
    }
  }

  Future<Map<String, dynamic>?> sendImageToCustomVisionAPI(
      Uint8List imageBytes) async {
    final apiUrl = widget.predictionAPI;
    final predictionKey = widget.predictionKey;

    final headers = {
      'Prediction-Key': predictionKey!,
      'Content-Type': 'application/octet-stream',
    };

    final response =
        await http.post(Uri.parse(apiUrl!), headers: headers, body: imageBytes);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final decodedResponse = jsonDecode(responseBody);
      return decodedResponse;
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomato Leaf Disease AI'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _getImageFromGallery,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 16),
            if (_image != null)
              Container(
                margin: const EdgeInsets.all(10),
                child: Image.file(_image!),
              ),
            const SizedBox(height: 16),
            if (_predictions != null && _predictions!.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Highest Confidence:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(_predictions![0]['tagName']),
                      subtitle: Text(
                          'Confidence: ${(_predictions![0]['probability'] * 100).toStringAsFixed(2)} %'),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'All Predictions:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _predictions!.length,
                        itemBuilder: (context, index) {
                          final prediction = _predictions![index];
                          final tagName = prediction['tagName'];
                          final confidence = prediction['probability'];

                          return ListTile(
                            title: Text(tagName),
                            subtitle: Text(
                                'Confidence: ${(confidence * 100).toStringAsFixed(2)} %'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (_predictions == null || _predictions!.isEmpty) const SizedBox(),
          ],
        ),
      ),
    );
  }
}
