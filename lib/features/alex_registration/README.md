# Alex — Pendaftaran / Ikut Kegiatan

Kerjakan alur pendaftaran atau ikut kegiatan di folder ini. Buat file utama `registration_page.dart` dan simpan komponen buatanmu di subfolder `widgets/`.

Tahap awal mencakup formulir peserta, pilihan jadwal, dan pilihan lokasi.

Jangan mengubah `main.dart` atau file fitur anggota lain tanpa koordinasi. Integrasi navigasi dilakukan bersama setelah halaman tersedia.

## Menggunakan halaman

Halaman siap dipanggil dari navigasi aplikasi tanpa mengubah `main.dart`:

```dart
import 'package:reclub/features/alex_registration/registration_page.dart';

Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => const RegistrationPage(),
  ),
);
```

Data kegiatan demo dapat disesuaikan melalui `activityName` dan `hostName`. Data jadwal dan lokasi saat ini berupa dummy di `registration_page.dart`.
