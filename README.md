# Aplikasi Monitoring Kendaraan

Aplikasi Flutter untuk monitoring akses kendaraan dengan fitur scan e-KTP menggunakan kamera.

## Fitur Utama

- ✅ **Splash Screen** - Animasi loading yang menarik
- ✅ **Dashboard Monitoring** - Tampilan status akses dan kendaraan
- ✅ **Scan e-KTP** - Fitur kamera untuk memindai kartu e-KTP
- ✅ **Text Recognition** - Ekstraksi data dari hasil scan
- ✅ **Modern UI** - Design yang clean dan responsif
- ✅ **Real-time Updates** - Status yang diperbarui secara real-time

## Langkah Instalasi Lengkap

### 1. Prerequisites

Pastikan sudah menginstall:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.8.1+)
- [Android Studio](https://developer.android.com/studio) atau [VSCode](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

### 2. Setup Flutter

```bash
# Cek instalasi Flutter
flutter doctor

# Pastikan semua checklist hijau
```

### 3. Clone Project

```bash
# Clone repository (jika menggunakan git)
git clone <repository-url>
cd monitoring_kendaraan_app

# Atau buat project baru
flutter create monitoring_kendaraan_app
cd monitoring_kendaraan_app
```

### 4. Install Dependencies

```bash
# Install semua package yang diperlukan
flutter pub get
```

### 5. Setup Firebase (Opsional)

Jika ingin menggunakan Firebase:

1. Buat project di [Firebase Console](https://console.firebase.google.com/)
2. Download `google-services.json` dan letakkan di `android/app/`
3. Update konfigurasi sesuai project Firebase Anda

### 6. Setup Android

Pastikan file `android/app/src/main/AndroidManifest.xml` sudah memiliki permission:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### 7. Jalankan Aplikasi

```bash
# Pastikan device/emulator terhubung
flutter devices

# Jalankan aplikasi
flutter run

# Atau build APK
flutter build apk
```

## Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── pages/
│   ├── splash_screen.dart    # Halaman splash screen
│   ├── home_page.dart        # Dashboard utama
│   └── tambah_kartu.dart     # Halaman scan e-KTP
└── widgets/
    └── status_card.dart      # Widget status card
```

## Package yang Digunakan

- `camera: ^0.10.5+2` - Akses kamera
- `google_mlkit_text_recognition: ^0.7.0` - OCR untuk scan e-KTP
- `permission_handler: ^11.0.1` - Manajemen permission
- `shared_preferences: ^2.2.2` - Local storage
- `path_provider: ^2.1.2` - Akses file system
- `firebase_core: ^2.25.4` - Firebase core
- `cloud_firestore: ^4.14.0` - Firebase Firestore
- `intl: ^0.19.0` - Format tanggal/waktu

## Fitur Detail

### 1. Splash Screen
- Animasi fade dan slide
- Loading indicator
- Auto redirect ke dashboard setelah 3 detik

### 2. Dashboard
- Status akses kendaraan
- Total akses dan akses hari ini
- Jam terakhir akses (real-time)
- Tombol untuk scan e-KTP
- Pull-to-refresh functionality

### 3. Scan e-KTP
- Preview kamera real-time
- Frame overlay untuk posisi kartu
- Text recognition (OCR)
- Ekstraksi data NIK, Nama, Alamat
- Switch kamera (front/back)
- Flash control

## Troubleshooting

### Error Kamera
```bash
# Pastikan permission sudah diatur
flutter clean
flutter pub get
flutter run
```

### Error Firebase
```bash
# Update google-services.json dengan file yang benar
# Atau comment Firebase di main.dart jika tidak digunakan
```

### Error Build
```bash
# Clean dan rebuild
flutter clean
flutter pub get
flutter run
```

## Pengembangan Selanjutnya

- [ ] Integrasi dengan backend API
- [ ] Database lokal SQLite
- [ ] Push notification
- [ ] Export data ke Excel/PDF
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Biometric authentication

## License

Distributed under the MIT License.

---

**Note**: Pastikan untuk mengupdate konfigurasi Firebase dan permission sesuai kebutuhan aplikasi Anda.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
