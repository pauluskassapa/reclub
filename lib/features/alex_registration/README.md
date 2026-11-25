# Alex — Pendaftaran / Ikut Kegiatan

Kerjakan alur pendaftaran atau ikut kegiatan di folder ini. Buat file utama `registration_page.dart` dan simpan komponen buatanmu di subfolder `widgets/`.

Fitur mencakup formulir peserta, pilihan jadwal, pilihan lokasi, informasi pembayaran, ringkasan, dan konfirmasi pendaftaran.

Jangan mengubah `main.dart` atau file fitur anggota lain tanpa koordinasi. Integrasi navigasi dilakukan bersama setelah halaman tersedia.

## Menggunakan halaman

Halaman siap dipanggil dari navigasi aplikasi tanpa mengubah `main.dart`:

```dart
import 'package:reclub/features/alex_registration/registration_page.dart';
import 'package:reclub/features/alex_registration/models/registration_event_type.dart';
import 'package:reclub/features/defrigo_manage_event/models/managed_event.dart';

Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => RegistrationPage(
      event: event,
      hostName: 'Nama penyelenggara',
      eventType: RegistrationEventType.funMatch,
      fee: 50000,
    ),
  ),
);
```

`event` memakai objek `ManagedEvent` dari kegiatan yang dipilih. Nama, kategori, deskripsi, tanggal, waktu, dan lokasi ditampilkan dari objek tersebut. Nilai `fee`, `eventType`, dan `isClubMember` dikirim terpisah karena `ManagedEvent` belum menyimpan biaya, tipe kegiatan, atau status keanggotaan. Fun match umum dengan biaya di atas nol membuka halaman pembayaran demo; setelah simulasi pembayaran selesai, peserta dapat mengonfirmasi pendaftaran. Kegiatan khusus club gratis untuk anggota (`eventType: RegistrationEventType.clubOnly`, `isClubMember: true`), sedangkan nonanggota tidak bisa mengonfirmasi pendaftaran. Halaman pembayaran belum memproses transaksi nyata.
