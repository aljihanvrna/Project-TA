import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_kendaraan_app/providers/data_provider.dart';
import 'package:provider/provider.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifikasi')),
      body: Consumer<DataProvider>(builder: (context, data, _) {
        return Column(
          children: [
            if (data.jumlahNotifikasi > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => data.tandaiSemuaDibaca(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                        // border: Border.all(
                        //   color: Colors.blue,
                        //   width: 1,
                        // ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          Text(
                            'Tandai Semua Sudah Dibaca',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: data.notifikasi.length,
                itemBuilder: (context, index) {
                  final notif = data.notifikasi[index];
                  return GestureDetector(
                    onTap:() => data.tandaiDibaca(notif),
                    child: Card(
                      margin: EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(Icons.lock_person, color: Colors.red),
                        title: Text(
                          notif.pesan,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(DateFormat('H:m:s d-M-y').format(notif.waktu)),
                        trailing: notif.dibaca
                          ? null
                          : Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
