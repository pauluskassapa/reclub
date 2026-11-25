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

## Form buat postingan

Setelah feed_setup.sql, jalankan feed_submit_setup.sql di SQL Editor.
Jika feed_setup.sql dijalankan ulang, jalankan kembali feed_submit_setup.sql
karena setup awal mengembalikan izin tabel menjadi baca saja.

Form menerima pengajuan tanpa login dengan is_published = false.
Pengajuan tidak tampil di API publik. Daniel membuka Table Editor → feed_posts,
memeriksa isi lalu mengubah is_published menjadi true untuk menyetujui.
Nama pengirim adalah input pengguna, belum identitas akun terverifikasi.
Aplikasi tidak memiliki izin mengubah atau menghapus postingan.

Form juga dapat memakai foto dari galeri. Jalankan `feed_submit_setup.sql`
setelah `feed_setup.sql`: SQL tersebut membuat bucket publik `feed-images`
dan membatasi unggahan anonim ke folder `pending/`. Foto yang dipilih akan
tampil setelah postingan disetujui.

Alur ini untuk demo kelompok. Sebelum dibuka luas, hubungkan Supabase Auth
serta pembatasan pengiriman untuk mencegah spam pengajuan anonim.
