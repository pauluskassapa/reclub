# Setup Feed — Paulus

1. Daniel membuka proyek Supabase yang sama dengan chat komunitas.
2. Buka SQL Editor → New query.
3. Salin seluruh isi feed_setup.sql, lalu Run.
4. Pastikan tabel public.feed_posts memiliki tiga postingan awal.
5. Jalankan aplikasi, buka Feed, lalu tarik ke bawah untuk memuat ulang.

SQL ini khusus feed_posts. Tabel chat komunitas tidak diubah.
Postingan dan jumlah suka awal adalah data contoh.
Menjalankan SQL kembali tidak menduplikasi atau menimpa isi postingan awal.

Aplikasi membaca postingan yang is_published = true. Kelola postingan lewat
Table Editor Supabase; aplikasi hanya mendapat izin baca.
image_path menunjuk aset yang sudah dibundel di aplikasi, bukan unggahan foto.
Gunakan path aset yang tersedia, misalnya assets/images/futsal.jpg.

Suka dan penanda simpan masih state lokal. Penyimpanan per pengguna membutuhkan
integrasi Supabase Auth dan tabel reaksi dengan kebijakan kepemilikan pengguna.
Tidak ada service_role atau secret key yang diperlukan di aplikasi.

Jika Feed gagal dimuat, periksa hasil eksekusi SQL, status proyek Supabase,
koneksi internet, dan kesesuaian kolom tabel. Aplikasi tidak mengganti kegagalan
database dengan postingan lokal.
