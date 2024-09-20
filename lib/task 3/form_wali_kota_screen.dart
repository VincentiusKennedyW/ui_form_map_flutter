import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:io';

final List<String> waliKotaNames = [
  'Wali Kota 1',
  'Wali Kota 2',
  'Wali Kota 3',
  'Wali Kota 4',
  'Wali Kota 5',
];

class FormWaliKotaScreen extends StatefulWidget {
  const FormWaliKotaScreen({Key? key}) : super(key: key);

  @override
  _FormWaliKotaScreenState createState() => _FormWaliKotaScreenState();
}

class _FormWaliKotaScreenState extends State<FormWaliKotaScreen> {
  File? _image;
  final picker = ImagePicker();
  final List<TextEditingController> suaraControllers = List.generate(
    waliKotaNames.length,
    (index) => TextEditingController(),
  );
  bool _isLoading = false;

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Function to get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _isLoading = false;
    });

    // Print output to console
    _printFormOutput(locationData.latitude, locationData.longitude);
  }

  // Function to print the form output
  void _printFormOutput(double? latitude, double? longitude) {
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    for (int i = 0; i < waliKotaNames.length; i++) {
      print('${waliKotaNames[i]}: ${suaraControllers[i].text}');
    }
    print('Foto: ${_image?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Wali Kota'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _getImage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                width: double.infinity,
                height: 200,
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(waliKotaNames.length, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    waliKotaNames[index],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: suaraControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Jumlah Suara',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                backgroundColor: Colors.blueAccent,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
