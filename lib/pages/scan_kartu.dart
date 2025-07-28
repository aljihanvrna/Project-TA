import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:monitoring_kendaraan_app/pages/form_tambah_kartu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ScanKartuPage extends StatefulWidget {
  const ScanKartuPage({super.key});
  
  @override
  State<ScanKartuPage> createState() => _ScanKartuPageState();
}

class _ScanKartuPageState extends State<ScanKartuPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraReady = false;
  bool _isScanning = false;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    // Request camera permission
    var status = await Permission.camera.request();
    if (status.isDenied) {
      _showPermissionDialog();
      return;
    }

    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        _controller = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        
        await _controller!.initialize();
        
        if (mounted) {
          setState(() {
            _isCameraReady = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      _showErrorDialog('Gagal menginisialisasi kamera');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Izin Kamera Diperlukan'),
        content: Text('Aplikasi memerlukan izin kamera untuk memindai kartu e-KTP.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _takePicture() async {
    if (!_isCameraReady || _controller == null) return;

    setState(() {
      _isScanning = true;
    });

    try {
      final XFile image = await _controller!.takePicture();
      _capturedImage = File(image.path);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormTambahKartuPage(
            initialData: {
              'nama': '',
              'nik': '',
              'tanggal_lahir': '',
              'alamat': '',
              'uid': '',
            },
          ),
        ),
      );
      
    } catch (e) {
      print('Error taking picture: $e');
      _showErrorDialog('Gagal mengambil foto');
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan e-KTP'),
      ),
      body: _isCameraReady
          ? Column(
              children: [
                // Camera Preview
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        child: CameraPreview(_controller!),
                      ),
                      
                      // Scanning overlay
                      if (_isScanning)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Memproses gambar...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                      // Scan frame overlay
                      Center(
                        child: Container(
                          width: 280,
                          height: 180,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              // Corner indicators
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.blue, width: 3),
                                      left: BorderSide(color: Colors.blue, width: 3),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Colors.blue, width: 3),
                                      right: BorderSide(color: Colors.blue, width: 3),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.blue, width: 3),
                                      left: BorderSide(color: Colors.blue, width: 3),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.blue, width: 3),
                                      right: BorderSide(color: Colors.blue, width: 3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Control buttons
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Posisikan kartu e-KTP dalam kotak',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isScanning ? null : () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back),
                            label: Text('Kembali'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: _isScanning ? null : _takePicture,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.camera_alt, size: 30),
                          ),
                          Container()
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Menginisialisasi kamera...'),
                ],
              ),
            ),
    );
  }

}
