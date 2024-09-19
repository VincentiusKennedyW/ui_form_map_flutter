import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:relawan_pemilu_ui/task%201/anggota_keluarga_widget.dart';
import 'package:relawan_pemilu_ui/task%201/map_screen.dart';
import 'package:relawan_pemilu_ui/task%202/map_screen_2.dart';

class FormKeluarga extends StatefulWidget {
  const FormKeluarga({super.key});

  @override
  _FormKeluargaState createState() => _FormKeluargaState();
}

class _FormKeluargaState extends State<FormKeluarga> {
  XFile? _image;
  final _picker = ImagePicker();

  final _namaKKController = TextEditingController();
  final _alamatController = TextEditingController();
  final _dptController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  List<AnggotaKeluargaData> anggotaKeluargaList = [];
  String? selectedStatus;

  Future<void> _pickImage() async {
    final pickedFile = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.pop(context,
                      await _picker.pickImage(source: ImageSource.gallery));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.pop(context,
                      await _picker.pickImage(source: ImageSource.camera));
                },
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      _image = pickedFile;
    });
  }

  void _navigateToMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MapsLocationScreen(),
      ),
    );

    if (result != null && result is List && result.isNotEmpty) {
      final selectedLocation = result[0] as LatLng;

      setState(() {
        _latController.text = selectedLocation.latitude.toString();
        _longController.text = selectedLocation.longitude.toString();
      });
    }
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _latController.text = locationData.latitude.toString();
      _longController.text = locationData.longitude.toString();
    });
  }

  void _addAnggotaKeluarga() {
    setState(() {
      anggotaKeluargaList.add(AnggotaKeluargaData());
    });
  }

  void _removeAnggotaKeluarga(int index) {
    setState(() {
      anggotaKeluargaList.removeAt(index);
    });
  }

  void _submitForm() {
    String namaKK = _namaKKController.text;
    String alamat = _alamatController.text;
    String dpt = _dptController.text;
    String latitude = _latController.text;
    String longitude = _longController.text;

    List<Map<String, String>>? anggotaKeluargaData;

    if (anggotaKeluargaList.isNotEmpty) {
      anggotaKeluargaData = [];
      for (var anggota in anggotaKeluargaList) {
        String nama = anggota.namaController.text;
        String telepon = anggota.teleponController.text;
        String posisi = anggota.posisiController.text;

        anggotaKeluargaData.add({
          'nama': nama,
          'telepon': telepon,
          'posisi': posisi,
        });
      }
    } else {
      anggotaKeluargaData = null;
    }

    print('Nama Kepala Keluarga: $namaKK');
    print('Alamat: $alamat');
    print('DPT: $dpt');
    print('Latitude: $latitude');
    print('Longitude: $longitude');
    print('Status: $selectedStatus');
    print('Anggota Keluarga: $anggotaKeluargaData');
    print('Foto: ${_image?.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Keluarga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.moving_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MapsLocationScreen2(),
              ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
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
                        child:
                            Image.file(File(_image!.path), fit: BoxFit.cover),
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
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _namaKKController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Kepala Keluarga',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _alamatController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _dptController,
                      decoration: const InputDecoration(
                        labelText: 'DPT',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedStatus,
                      items: const [
                        DropdownMenuItem(
                          value: 'Ingin Menjadi Relawan',
                          child: Text('Ingin Menjadi Relawan'),
                        ),
                        DropdownMenuItem(
                          value: 'Ingin Memilih',
                          child: Text('Ingin Memilih'),
                        ),
                        DropdownMenuItem(
                          value: 'Masih Ragu',
                          child: Text('Masih Ragu'),
                        ),
                        DropdownMenuItem(
                          value: 'Tidak Memilih',
                          child: Text('Tidak Memilih'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _latController,
                            decoration: const InputDecoration(
                              labelText: 'Latitude',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _longController,
                            decoration: const InputDecoration(
                              labelText: 'Longitude',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _navigateToMap,
                            icon: const Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Pilih di Peta',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Lokasi Saat Ini',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addAnggotaKeluarga,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                'Tambah Anggota Keluarga',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: anggotaKeluargaList.length,
              itemBuilder: (context, index) {
                return AnggotaKeluarga(
                  index: index,
                  data: anggotaKeluargaList[index],
                  onRemove: () => _removeAnggotaKeluarga(index),
                );
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.blueAccent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
