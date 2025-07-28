
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monitoring_kendaraan_app/providers/data_provider.dart';
import 'package:provider/provider.dart';

class FormTambahKartuPage extends StatefulWidget {
  final Map<String, String> initialData;

  const FormTambahKartuPage({super.key, required this.initialData});

  @override
  State<FormTambahKartuPage> createState() => _FormTambahKartuPageState();
}

class _FormTambahKartuPageState extends State<FormTambahKartuPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController nikController;
  late TextEditingController tanggalLahirController;
  late TextEditingController alamatController;
  late TextEditingController uidController;
  late DataProvider dataProvider;
  late StreamSubscription<DatabaseEvent> _onHasilScanListener;

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    dataProvider = Provider.of<DataProvider>(context, listen: false);

    var instance = FirebaseDatabase.instance;
    instance.ref('tunggu_hasil_scan').set(true);
    _onHasilScanListener = instance.ref('hasil_scan').onValue.listen(_onHasilScanChanged);

    namaController = TextEditingController(text: widget.initialData['nama']);
    nikController = TextEditingController(text: widget.initialData['nik']);
    tanggalLahirController = TextEditingController(text: widget.initialData['tanggal_lahir']);
    alamatController = TextEditingController(text: widget.initialData['alamat']);
    uidController = TextEditingController(text: widget.initialData['uid']);

    // Add listeners for validation
    namaController.addListener(_validateForm);
    nikController.addListener(_validateForm);
    tanggalLahirController.addListener(_validateForm);
    alamatController.addListener(_validateForm);
    uidController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _onHasilScanListener.cancel();
    FirebaseDatabase.instance.ref('tunggu_hasil_scan').set(false);
    FirebaseDatabase.instance.ref('hasil_scan').remove();

    namaController.dispose();
    nikController.dispose();
    tanggalLahirController.dispose();
    alamatController.dispose();
    uidController.dispose();
    super.dispose();
  }

  void _onHasilScanChanged(DatabaseEvent event) {
    uidController.text = event.snapshot.value as String;
  }

  void _validateForm() {
    final isValid = namaController.text.trim().isNotEmpty &&
        nikController.text.trim().isNotEmpty &&
        tanggalLahirController.text.trim().isNotEmpty &&
        alamatController.text.trim().isNotEmpty &&
        uidController.text.trim().isNotEmpty;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var nav = Navigator.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data kartu berhasil disimpan'),
        backgroundColor: Colors.green,
      ),
    );

    await dataProvider.tambahKartu(DataKartu(
      "",
      namaController.text.trim(),
      nikController.text.trim(),
      uidController.text.trim(),
      tanggalLahirController.text.trim(),
      alamatController.text.trim(),
    ));

    nav.popUntil(ModalRoute.withName('/home'));
    nav.pushNamed('/data-kartu');
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(widget.initialData['tanggal_lahir'] ?? '') ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );

    if (picked != null) {
      final formatted = DateFormat('dd-MM-yyyy').format(picked);
      setState(() {
        tanggalLahirController.text = formatted;
      });
      _validateForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Data Kartu')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(labelText: 'Nama'),
                        validator: (value) => value!.trim().isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: nikController,
                        decoration: InputDecoration(labelText: 'NIK'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value!.trim().isEmpty ? 'NIK wajib diisi' : null,
                      ),
                      SizedBox(height: 16),

                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: tanggalLahirController,
                            decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                            validator: (value) => value!.trim().isEmpty ? 'Tanggal lahir wajib diisi' : null,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: alamatController,
                        decoration: InputDecoration(labelText: 'Alamat'),
                        validator: (value) => value!.trim().isEmpty ? 'Alamat wajib diisi' : null,
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        controller: uidController,
                        decoration: InputDecoration(labelText: 'UID'),
                        validator: (value) => value!.trim().isEmpty ? 'UID wajib diisi' : null,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '* Silahkan masukkan UID atau Scan e-KTP',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, size: 24),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      label: Text(
                        'Scan ulang',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: Icon(Icons.save, size: 24),
                      label: Text(
                        'Simpan Kartu',
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
            ),
          ],
        ),
      ),
    );
  }

}
