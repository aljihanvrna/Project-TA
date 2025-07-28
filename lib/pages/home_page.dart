import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_kendaraan_app/providers/data_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/status_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard Monitoring',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          Consumer<DataProvider>(
            builder: (context, data, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () => Navigator.pushNamed(context, '/notifikasi'),
                  ),
                  if (data.jumlahNotifikasi > 0) Positioned(
                    right: 8,
                    top: 8,
                    child: IgnorePointer(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          data.jumlahNotifikasi.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ],
      ),
      body: Consumer<DataProvider>(
        builder: (context, data, _) {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[600]!, Colors.blue[800]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.dashboard,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Status Sistem',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatCard('Total Akses', data.totalAkses.toString(), Icons.access_time),
                          _buildStatCard('Hari Ini', data.jumlahAkses.toString(), Icons.today),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Status Cards Section
                Text(
                  'Status Monitoring',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                
                StatusCard(
                  title: "Status Akses",
                  value: data.statusAkses,
                  icon: data.statusAkses.toLowerCase().contains('diizinkan') ? Icons.verified_user : Icons.lock_person_sharp,
                  color: data.statusAkses.toLowerCase().contains('diizinkan') ? Colors.green : Colors.red,
                ),
                SizedBox(height: 12),
                
                StatusCard(
                  title: "Status Kendaraan",
                  value: data.statusKendaraan,
                  icon: Icons.directions_car,
                  color: data.statusKendaraan.toLowerCase().contains('aktif') ? Colors.blue : Colors.blueGrey,
                ),
                SizedBox(height: 12),
                
                StatusCard(
                  title: "Jam Terakhir Akses",
                  value: DateFormat.Hms().format(data.terakhirAkses),
                  icon: Icons.access_time,
                  color: Colors.orange,
                ),
                
                SizedBox(height: 32),
                
                // Action Button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/data-kartu');
                        },
                        icon: Icon(Icons.list_alt, size: 24),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        label: Text(
                          'Data Kartu',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12), // space between buttons
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/scan-kartu');
                        },
                        icon: Icon(Icons.add_a_photo, size: 24),
                        label: Text(
                          'Tambah Data Kartu',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
