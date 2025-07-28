import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataKartu {
  String key;
  String nama;
  String nik;
  String uid;
  String tanggalLahir;
  String alamat;

  DataKartu(
    this.key,
    this.nama,
    this.nik,
    this.uid,
    this.tanggalLahir,
    this.alamat,
  );
}

class DataNotifikasi {
  String key;
  String pesan;
  DateTime waktu;
  bool dibaca;

  DataNotifikasi(this.key, this.pesan, this.waktu, this.dibaca);
}

class DataProvider with ChangeNotifier {
  final List<StreamSubscription<DatabaseEvent>> _listeners = [];
  final GlobalKey<NavigatorState> _navigatorKey;
  DateTime _notifTerakhir = DateTime.now();

  int jumlahAkses = 0;
  int totalAkses = 0;
  String statusKendaraan = "Nonaktif";
  String statusAkses = "Ditolak";
  DateTime terakhirAkses = DateTime.fromMillisecondsSinceEpoch(0);
  List<DataKartu> dataKartu = [];
  List<DataNotifikasi> notifikasi = [];
  int jumlahNotifikasi = 0;

  DataProvider(this._navigatorKey) {
    var instance = FirebaseDatabase.instance;
    _listeners.add(
      instance.ref('total_akses').onValue.listen(_onTotalAccessChanged),
    );
    _listeners.add(
      instance
          .ref('jumlah_akses/${DateFormat('y-M-d').format(DateTime.now())}')
          .onValue
          .listen(_onJumlahAksesChanged),
    );
    _listeners.add(
      instance
          .ref('status_kendaraan')
          .onValue
          .listen(_onStatusKendaraanChanged),
    );
    _listeners.add(
      instance.ref('status_akses').onValue.listen(_onStatusAksesChanged),
    );
    _listeners.add(
      instance.ref('terakhir_akses').onValue.listen(_onTerakhirAksesChanged),
    );
    _listeners.add(
      instance.ref('notifikasi').onValue.listen(_onNotifikasiChanged),
    );

    instance.ref('data_kartu').get().then((DataSnapshot snapshot) {
      for (var item in snapshot.children) {
        dataKartu.add(
          DataKartu(
            item.key!,
            item.child('nama').value as String,
            item.child('nik').value as String,
            item.child('uid').value as String,
            item.child('tanggal_lahir').value as String,
            item.child('alamat').value as String,
          ),
        );
      }
      dataKartu.sort((a, b) {
        return a.nama.compareTo(b.nama);
      });
      notifyListeners();
    });
  }

  Future<void> tandaiSemuaDibaca() async {
    if (jumlahNotifikasi != 0) {
      for (var item in notifikasi) {
        if (!item.dibaca) {
          await FirebaseDatabase.instance
              .ref('notifikasi/${item.key}/dibaca')
              .set(true);
          item.dibaca = true;
        }
      }
      jumlahNotifikasi = 0;
      notifyListeners();
    }
  }

  Future<void> tandaiDibaca(DataNotifikasi notif) async {
    if (!notif.dibaca) {
      notif.dibaca = true;
      await FirebaseDatabase.instance
          .ref('notifikasi/${notif.key}/dibaca')
          .set(true);
    }
  }

  Future<void> tambahKartu(DataKartu kartu) async {
    var ref = await FirebaseDatabase.instance.ref('data_kartu').push();
    ref.set({
      'nama': kartu.nama,
      'nik': kartu.nik,
      'uid': kartu.uid,
      'tanggal_lahir': kartu.tanggalLahir,
      'alamat': kartu.alamat,
    });
    kartu.key = ref.key!;
    dataKartu.add(kartu);
    dataKartu.sort((a, b) {
      return a.nama.compareTo(b.nama);
    });
    notifyListeners();
  }

  Future<void> hapusKartu(DataKartu kartu) async {
    await FirebaseDatabase.instance.ref('data_kartu/${kartu.key}').remove();
    dataKartu.remove(kartu);
    notifyListeners();
  }

  @override
  void dispose() {
    for (var listener in _listeners) {
      listener.cancel();
    }
    super.dispose();
  }

  void _onTotalAccessChanged(DatabaseEvent event) {
    totalAkses = event.snapshot.value as int;
    notifyListeners();
  }

  void _onJumlahAksesChanged(DatabaseEvent event) {
    jumlahAkses = event.snapshot.value as int;
    notifyListeners();
  }

  void _onStatusKendaraanChanged(DatabaseEvent event) {
    statusKendaraan = event.snapshot.value as String;
    notifyListeners();
  }

  void _onStatusAksesChanged(DatabaseEvent event) {
    statusAkses = event.snapshot.value as String;
    notifyListeners();
  }

  void _onTerakhirAksesChanged(DatabaseEvent event) {
    terakhirAkses = DateTime.fromMillisecondsSinceEpoch(
      event.snapshot.value as int,
    );
    notifyListeners();
  }

  void _onNotifikasiChanged(DatabaseEvent event) {
    notifikasi.clear();
    jumlahNotifikasi = 0;
    for (var item in event.snapshot.children) {
      var notif = DataNotifikasi(
        item.key!,
        item.child('pesan').value as String,
        DateTime.fromMillisecondsSinceEpoch(item.child('waktu').value as int),
        item.child('dibaca').value == true,
      );
      if (!notif.dibaca) {
        jumlahNotifikasi++;
      }
      notifikasi.add(notif);
    }
    notifikasi.sort((a, b) {
      return b.waktu.compareTo(a.waktu);
    });

    var notif = notifikasi[0];
    if (!notif.dibaca &&
        notif.waktu.difference(_notifTerakhir).inMilliseconds > 0 &&
        notif.waktu.difference(DateTime.now()).inSeconds < 30) {
      _notifTerakhir = notif.waktu;

      final context = _navigatorKey.currentContext;
      if (context == null) return;

      final currentRoute = ModalRoute.of(context)?.settings.name;
      if (currentRoute != '/peringatan') {
        _navigatorKey.currentState?.pushNamed('/peringatan');
      }
    }
    notifyListeners();
  }
}
