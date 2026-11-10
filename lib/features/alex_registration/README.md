# Alex — Pendaftaran / Ikut Kegiatan

Kerjakan alur pendaftaran atau ikut kegiatan di folder ini. Buat file utama `registration_page.dart` dan simpan komponen buatanmu di subfolder `widgets/`.

Target tugas: minimal 5 widget buatan sendiri. Contoh: formulir pendaftaran, pilihan jadwal, pilihan lokasi, ringkasan pendaftaran, dan tombol konfirmasi.

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

Data kegiatan demo dapat disesuaikan melalui `activityName`, `hostName`, dan `fee`. Isi `fee` dengan `0` untuk kegiatan gratis atau nominal rupiah untuk kegiatan berbayar. Data jadwal dan lokasi saat ini berupa dummy di `registration_page.dart`.
