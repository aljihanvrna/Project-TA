import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_kendaraan_app/pages/akses_ditolak.dart';
import 'package:monitoring_kendaraan_app/pages/data_kartu.dart';
import 'package:monitoring_kendaraan_app/pages/notifikasi.dart';
import 'package:monitoring_kendaraan_app/providers/data_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'pages/scan_kartu.dart';
import 'pages/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final navigatorKey = GlobalKey<NavigatorState>();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider(navigatorKey)),
      ],
      child: MonitoringKendaraanApp(navigatorKey: navigatorKey),
    ),
  );
}

class MonitoringKendaraanApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MonitoringKendaraanApp({
    super.key, 
    required this.navigatorKey,
  });
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoring Kendaraan',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomePage(),
        '/peringatan': (context) => AksesDitolakPage(),
        '/scan-kartu': (context) => ScanKartuPage(),
        '/data-kartu': (context) => DataKartuPage(),
        '/notifikasi': (context) => NotifikasiPage(),
      },
    );
  }
}
