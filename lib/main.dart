import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:relawan_pemilu_ui/task%201/form_keluarga_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission(); // Panggil izin lokasi di sini
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FormKeluarga(),
    );
  }
}

// Fungsi untuk meminta izin lokasi
Future<void> requestLocationPermission() async {
  final Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  // Memeriksa apakah layanan lokasi aktif
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  // Memeriksa status izin lokasi
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}
