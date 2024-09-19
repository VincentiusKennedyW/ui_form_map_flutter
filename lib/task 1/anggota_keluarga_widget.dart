import 'package:flutter/material.dart';

class AnggotaKeluargaData {
  TextEditingController namaController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  TextEditingController posisiController = TextEditingController();
}

class AnggotaKeluarga extends StatelessWidget {
  final int index;
  final AnggotaKeluargaData data;
  final VoidCallback onRemove;

  const AnggotaKeluarga({
    super.key,
    required this.index,
    required this.data,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Anggota Keluarga ${index + 1}'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onRemove,
                ),
              ],
            ),
            TextField(
              controller: data.namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: data.teleponController,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
            ),
            TextField(
              controller: data.posisiController,
              decoration: const InputDecoration(labelText: 'Posisi'),
            ),
          ],
        ),
      ),
    );
  }
}
