import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:relawan_pemilu_ui/bloc/list_dummy_bloc.dart';
import 'package:relawan_pemilu_ui/task%202/detail_screen.dart';
import 'package:relawan_pemilu_ui/task%203/form_3_screen.dart';
import 'package:relawan_pemilu_ui/task%203/form_gubernur_screen.dart';
import 'package:relawan_pemilu_ui/task%203/form_wali_kota_screen.dart';

final List<Map<String, dynamic>> dataDummy = [
  {
    'status': 'Kondisi',
    'timestamp': '2022-01-01 08:00:00',
    'Latitude': -1.275455,
    'Longitude': 116.833995,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-27.png',
  },
  {
    'status': 'Rekapitulasi',
    'timestamp': '2022-01-02 09:15:00',
    'Latitude': -1.256788,
    'Longitude': 116.789632,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-26.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-03 10:30:00',
    'Latitude': -1.289000,
    'Longitude': 116.802345,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-28.png',
  },
  {
    'status': 'Rekapitulasi',
    'timestamp': '2022-01-04 11:45:00',
    'Latitude': -1.272345,
    'Longitude': 116.812345,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-29.png',
  },
  {
    'status': 'Kondisi',
    'timestamp': '2022-01-05 12:00:00',
    'Latitude': -1.278900,
    'Longitude': 116.825678,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-30.png',
  },
  {
    'status': 'Rekapitulasi',
    'timestamp': '2022-01-06 13:15:00',
    'Latitude': -1.267890,
    'Longitude': 116.834567,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-31.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-07 14:30:00',
    'Latitude': -1.260000,
    'Longitude': 116.841234,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-32.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-08 15:45:00',
    'Latitude': -1.275678,
    'Longitude': 116.850000,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-33.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-09 16:00:00',
    'Latitude': -1.270123,
    'Longitude': 116.860987,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-34.png',
  },
  {
    'status': 'Dokumen C1',
    'timestamp': '2022-01-10 17:15:00',
    'Latitude': -1.280234,
    'Longitude': 116.870123,
    'Foto':
        'https://www.ruparupa.com/blog/wp-content/uploads/2021/04/image-35.png',
  }
];

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  void showCustomDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Silakan pilih salah satu opsi di bawah ini:',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FormGubernurScreen(), // Form untuk Gubernur
                        ),
                      );
                    },
                    child: const Text('Gubernur'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const FormWaliKotaScreen(), // Form untuk Wali Kota
                        ),
                      );
                    },
                    child: const Text('Wali Kota'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListDummyBloc()..add(LoadDataEvent(data: dataDummy)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Relawan'),
          centerTitle: true,
        ),
        body: BlocBuilder<ListDummyBloc, ListDummyState>(
          builder: (context, state) {
            if (state is ListDummyInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ListDummyLoaded) {
              return ListView.separated(
                itemCount: state.data.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final item = state.data[index];
                  return ListTile(
                    title: Text(item['status']),
                    subtitle: Text(item['timestamp']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(data: item),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('Data tidak tersedia.'));
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  showCustomDialog(context, 'Rekapitulasi');
                },
                icon: const Icon(Icons.summarize),
                label: const Text('Rekapitulasi'),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.extended(
                onPressed: () {
                  showCustomDialog(context, 'Dokumen C1');
                },
                icon: const Icon(Icons.document_scanner),
                label: const Text('Dokumen C1'),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Form3Screen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Kondisi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
