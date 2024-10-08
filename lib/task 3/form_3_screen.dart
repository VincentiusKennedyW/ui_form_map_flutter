import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class Form3Screen extends StatefulWidget {
  const Form3Screen({super.key});

  @override
  _Form3ScreenState createState() => _Form3ScreenState();
}

class _Form3ScreenState extends State<Form3Screen> {
  XFile? _image;
  final _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false; // Status untuk loading saat mengambil lokasi

  // Function to pick image from camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = pickedFile;
    });
  }

  // Function to get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true; // Set status loading menjadi true
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
          _isLoading = false; // Set status loading menjadi false jika gagal
        });
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _isLoading = false; // Set status loading menjadi false jika gagal
        });
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _isLoading = false; // Set status loading menjadi false setelah selesai
    });

    // Print output to console
    _printFormOutput(locationData.latitude, locationData.longitude);
  }

  // Function to print the form output
  void _printFormOutput(double? latitude, double? longitude) {
    print('Deskripsi: ${_descriptionController.text}');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Foto: ${_image?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Gambar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImageFromCamera,
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
                          File(_image!.path),
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
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Gambar',
                border: OutlineInputBorder(),
              ),
              maxLines: 3, // Menambahkan multi-line input
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _getCurrentLocation, // Memanggil fungsi getLocation saat tombol ditekan
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
