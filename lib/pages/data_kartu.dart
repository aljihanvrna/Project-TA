import 'package:flutter/material.dart';
import 'package:monitoring_kendaraan_app/providers/data_provider.dart';
import 'package:provider/provider.dart';

class DataKartuPage extends StatefulWidget {
  const DataKartuPage({super.key});
  
  @override
  State<DataKartuPage> createState() => _DataKartuPageState();
}

class _DataKartuPageState extends State<DataKartuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Kartu'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, data, _) {
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: data.dataKartu.length,
            itemBuilder: (context, index) {
              final kartu = data.dataKartu[index];

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dummy icon (picture)
                          Icon(
                            Icons.account_circle,
                            size: 64,
                            color: Colors.grey[700],
                          ),
                          SizedBox(width: 16),

                          // Card content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama: ${kartu.nama}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text('NIK: ${kartu.nik}'),
                                Text('UID: ${kartu.uid}'),
                                Text('Tanggal Lahir: ${kartu.tanggalLahir}'),
                                Text('Alamat: ${kartu.alamat}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text('Yakin ingin menghapus kartu ${kartu.nama}?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Batal'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Hapus'),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close dialog
                                        data.hapusKartu(kartu);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
