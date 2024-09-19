import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:relawan_pemilu_ui/task%202/detail_screen.dart';

// Data dummy yang telah dibuat sebelumnya
final List<Map<String, dynamic>> dataDummy = [
  {
    'Nama Kepala Keluarga': 'Budi Santoso',
    'Alamat': 'Jl. Sudirman No. 1, Balikpapan',
    'DPT': '123456',
    'Latitude': -1.269160,
    'Longitude': 116.825264,
    'Status': 'Yang memilih',
    'Anggota Keluarga': [
      {'nama': 'Siti Aisyah', 'telepon': '08123456789', 'posisi': 'Istri'},
      {'nama': 'Andi Santoso', 'telepon': '08198765432', 'posisi': 'Anak'},
    ],
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-27.png',
  },
  {
    'Nama Kepala Keluarga': 'Slamet Riyadi',
    'Alamat': 'Jl. Ahmad Yani No. 45, Balikpapan',
    'DPT': '654321',
    'Latitude': -1.275455,
    'Longitude': 116.833995,
    'Status': 'Yang ingin menjadi relawan',
    'Anggota Keluarga': [
      {'nama': 'Dewi Sartika', 'telepon': '08212345678', 'posisi': 'Istri'},
      {'nama': 'Rina Riyadi', 'telepon': '08398765432', 'posisi': 'Anak'},
    ],
    'Foto': 'https://i.ytimg.com/vi/ZZURVd_dmpY/sddefault.jpg',
  },
  {
    'Nama Kepala Keluarga': 'Ahmad Fauzi',
    'Alamat': 'Jl. Pupuk Raya No. 10, Balikpapan',
    'DPT': '789012',
    'Latitude': -1.282040,
    'Longitude': 116.837305,
    'Status': 'Yang tidak memilih',
    'Anggota Keluarga': [
      {'nama': 'Nurul Hidayah', 'telepon': '08124567890', 'posisi': 'Istri'},
      {'nama': 'Ali Fauzi', 'telepon': '08498765432', 'posisi': 'Anak'},
    ],
    'Foto': 'https://i.ytimg.com/vi/ZA8KjMqxqBQ/maxresdefault.jpg',
  },
];

class MapsLocationScreen2 extends StatefulWidget {
  const MapsLocationScreen2({super.key});

  @override
  State<MapsLocationScreen2> createState() => _MapsLocationScreen2State();
}

class _MapsLocationScreen2State extends State<MapsLocationScreen2> {
  final defaultAppLocation = const LatLng(-1.269160, 116.825264);
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  geo.Placemark? placemark;
  MapType selectedMapType = MapType.normal;
  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadMarkersFromDummyData();
  }

  // Fungsi untuk memuat marker dari data dummy
  void _loadMarkersFromDummyData() {
    for (var data in dataDummy) {
      final lat = data['Latitude'];
      final lng = data['Longitude'];
      final markerId = data['Nama Kepala Keluarga'];
      final status = data['Status'];

      // Set warna marker berdasarkan status
      BitmapDescriptor markerColor;
      switch (status) {
        case 'Yang ingin menjadi relawan':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
          break;
        case 'Yang memilih':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
          break;
        case 'Yang masih ragu':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
          break;
        case 'Yang tidak memilih':
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        default:
          markerColor = BitmapDescriptor.defaultMarker; // Default color
      }

      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId(markerId),
            position: LatLng(lat, lng),
            icon: markerColor,
            infoWindow: InfoWindow(
              title: data['Nama Kepala Keluarga'],
              snippet: '${data['Status']} - Klik untuk Detail',
              onTap: () {
                _showDetailScreen(data);
              },
            ),
          ),
        );
      });
    }
  }

  // Fungsi untuk menampilkan detail dari marker yang diklik
  void _showDetailScreen(Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              zoom: 14,
              target: defaultAppLocation,
            ),
            markers: markers,
            mapType: selectedMapType,
            onMapCreated: (controller) {
              mapController = controller;
            },
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              heroTag: null,
              onPressed: null,
              child: PopupMenuButton<MapType>(
                onSelected: (MapType item) {
                  setState(() {
                    selectedMapType = item;
                  });
                },
                offset: const Offset(0, 54),
                icon: const Icon(Icons.layers_outlined),
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<MapType>>[
                  const PopupMenuItem<MapType>(
                    value: MapType.normal,
                    child: Text('Normal'),
                  ),
                  const PopupMenuItem<MapType>(
                    value: MapType.satellite,
                    child: Text('Satelit'),
                  ),
                  const PopupMenuItem<MapType>(
                    value: MapType.terrain,
                    child: Text('Medan'),
                  ),
                  const PopupMenuItem<MapType>(
                    value: MapType.hybrid,
                    child: Text('Hybrid'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: null,
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton.small(
                  heroTag: null,
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          // Positioned untuk Legenda
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegendItem(Colors.blue, 'Ingin menjadi relawan'),
                  const SizedBox(height: 4),
                  _buildLegendItem(Colors.green, 'Memilih'),
                  const SizedBox(height: 4),
                  _buildLegendItem(Colors.yellow, 'Masih ragu'),
                  const SizedBox(height: 4),
                  _buildLegendItem(Colors.red, 'Tidak memilih'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun item legenda
// Fungsi untuk membangun item legenda
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
