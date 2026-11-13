import 'package:flutter/material.dart';

/// Model data untuk merepresentasikan profil, lokasi, dan statistik Klub Olahraga.
class Club {
  const Club({
    required this.name,
    required this.category,
    required this.accentColor,
    required this.sportIcon,
    required this.bannerImagePath,
    required this.memberCount,
    required this.rating,
    required this.weeklySessions,
    required this.foundedYear,
    required this.skillLevel,
    required this.homebaseLocation,
    required this.venueAddress,
    required this.regularSchedule,
    required this.hostName,
    required this.hostRole,
    required this.bio,
    required this.highlights,
    required this.latitude,
    required this.longitude,
  });

  /// Factory untuk membuat objek [Club] baru dari input form pengguna.
  /// Secara otomatis menentukan warna tema, ikon olahraga, banner, dan koordinat
  /// berdasarkan [category] dan [homebaseLocation] dalam waktu O(1).
  factory Club.createNew({
    required String name,
    required String category,
    required String homebaseLocation,
    required String venueAddress,
    required String regularSchedule,
    required String hostName,
    required String bio,
    String skillLevel = 'Semua Level (Pemula - Mahir)',
    String weeklySessions = '1x / Minggu',
  }) {
    final (accentColor, sportIcon, bannerImagePath, defaultHighlights) =
        _themeForCategory(category);
    final (lat, lon) = _coordinatesForLocation(homebaseLocation);

    return Club(
      name: name.trim(),
      category: category,
      accentColor: accentColor,
      sportIcon: sportIcon,
      bannerImagePath: bannerImagePath,
      memberCount: 1,
      rating: 5.0,
      weeklySessions: weeklySessions,
      foundedYear: DateTime.now().year,
      skillLevel: skillLevel,
      homebaseLocation: homebaseLocation,
      venueAddress: venueAddress.trim(),
      regularSchedule: regularSchedule.trim(),
      hostName: hostName.trim().isEmpty ? 'Daniel (Kamu)' : hostName.trim(),
      hostRole: 'Founder & Host Komunitas',
      bio: bio.trim(),
      highlights: defaultHighlights,
      latitude: lat,
      longitude: lon,
    );
  }

  final String name;
  final String category;
  final Color accentColor;
  final IconData sportIcon;
  final String bannerImagePath;
  final int memberCount;
  final double rating;
  final String weeklySessions;
  final int foundedYear;
  final String skillLevel;
  final String homebaseLocation;
  final String venueAddress;
  final String regularSchedule;
  final String hostName;
  final String hostRole;
  final String bio;
  final List<String> highlights;
  final double latitude;
  final double longitude;

  /// Label ringkas untuk kartu daftar klub di Home (contoh: "Sepak bola · 128 anggota").
  String get sportSummary => '$category · $memberCount anggota';

  /// Menghasilkan inisial 2 huruf dari nama klub secara otomatis.
  String get initials => name
      .split(' ')
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word[0])
      .join()
      .toUpperCase();

  /// Daftar 10 klub olahraga bawaan di RECLUB.
  static const List<Club> _initialClubs = [
    Club(
      name: 'Jakarta Futsal Club',
      category: 'Sepak bola',
      accentColor: Color(0xFF146B4A),
      sportIcon: Icons.sports_soccer_rounded,
      bannerImagePath: 'assets/images/futsal.jpg',
      memberCount: 128,
      rating: 4.9,
      weeklySessions: '2x / Minggu',
      foundedYear: 2022,
      skillLevel: 'Semua Level (Pemula - Mahir)',
      homebaseLocation: 'Jakarta Selatan',
      venueAddress: 'Cilandak Sport Center, Jl. TB Simatupang No. 45',
      regularSchedule: 'Rabu 19.30 WIB & Minggu 08.00 WIB',
      hostName: 'Paulus Kassapa',
      hostRole: 'Founder & Host Komunitas',
      bio:
          'Komunitas futsal dan mini soccer terbesar di Jakarta Selatan yang mengutamakan '
          'sportivitas, rotasi bermain yang adil, serta suasana pertemanan yang hangat. '
          'Cocok untuk mahasiswa maupun pekerja yang ingin rutin berkeringat setiap pekan.',
      highlights: [
        'Bola & Rompi Tersedia',
        'Sistem Rotasi Adil',
        'Terbuka untuk Pemula',
        'Sparring Bulanan',
      ],
      latitude: -6.2615,
      longitude: 106.8106,
    ),
    Club(
      name: 'Badminton Weekend',
      category: 'Badminton',
      accentColor: Color(0xFF6847C7),
      sportIcon: Icons.sports_tennis_rounded,
      bannerImagePath: 'assets/images/badminton.jpg',
      memberCount: 86,
      rating: 4.8,
      weeklySessions: '2x / Minggu',
      foundedYear: 2023,
      skillLevel: 'Pemula & Menengah',
      homebaseLocation: 'Jakarta Pusat',
      venueAddress: 'GOR Tanah Abang, Jl. K.H. Mas Mansyur No. 18',
      regularSchedule: 'Sabtu 16.00 - 19.00 WIB',
      hostName: 'Joan Natasya',
      hostRole: 'Koordinator Lapangan',
      bio:
          'Komunitas bulutangkis santai akhir pekan bagi kamu yang ingin belajar teknik dasar '
          'hingga bermain ganda campuran (mix double). Shuttlecock kualitas turnamen sudah '
          'disiapkan di setiap sesi latihan.',
      highlights: [
        'Shuttlecock Disediakan',
        'Sesi Ganda & Mix',
        'Ramah Pemula',
        '3 Lapangan Karpet',
      ],
      latitude: -6.1865,
      longitude: 106.8342,
    ),
    Club(
      name: 'Basket Sore Jakarta',
      category: 'Basket',
      accentColor: Color(0xFFDB6B22),
      sportIcon: Icons.sports_basketball_rounded,
      bannerImagePath: 'assets/images/basket.jpg',
      memberCount: 64,
      rating: 4.9,
      weeklySessions: '2x / Minggu',
      foundedYear: 2021,
      skillLevel: 'Semua Level',
      homebaseLocation: 'Jakarta Selatan',
      venueAddress: 'GOR Bulungan Blok M, Jl. Bulungan No. 1, Kebayoran Baru',
      regularSchedule: 'Jumat 17.00 - 19.00 WIB & Minggu 16.00 WIB',
      hostName: 'Defrigo Pratama',
      hostRole: 'Head Captain & Host',
      bio:
          'Komunitas pick-up game basket 5v5 dan 3x3 di Jakarta Selatan (terafiliasi dengan '
          'South Jakarta Hoops Club). Menggunakan lapangan kayu indoor standar FIBA dengan '
          'sistem game cepat 12 menit agar semua tim kebagian jam terbang.',
      highlights: [
        'Lapangan Kayu Indoor',
        'Bola Molten GG7X',
        'Pick-up Game 5v5',
        'Wasit & Scoreboard',
      ],
      latitude: -6.244,
      longitude: 106.800,
    ),
    Club(
      name: 'Jakarta Morning Runners',
      category: 'Lari',
      accentColor: Color(0xFF087F8C),
      sportIcon: Icons.directions_run_rounded,
      bannerImagePath: 'assets/images/running.jpg',
      memberCount: 92,
      rating: 4.9,
      weeklySessions: '3x / Minggu',
      foundedYear: 2022,
      skillLevel: 'Semua Pace (Easy Run - Tempo)',
      homebaseLocation: 'GBK Senayan, Jakarta',
      venueAddress: 'Pintu 6 Gelora Bung Karno (GBK), Senayan, Jakarta Pusat',
      regularSchedule: 'Selasa, Kamis & Minggu Pukul 06.00 WIB',
      hostName: 'Alex Wijaya',
      hostRole: 'Pacer Utama & Co-Founder',
      bio:
          'Komunitas lari pagi yang dibagi berdasarkan kelompok pace (pace 6, 7, hingga 8+) '
          'sehingga tidak ada pelari yang tertinggal. Setiap sesi diawali pemanasan dinamis '
          'dan diakhiri pendinginan bersama serta dokumentasi foto gratis.',
      highlights: [
        'Pacer Tiap Kelompok',
        'Titik Penitipan Tas',
        'Fotografer Komunitas',
        'Persiapan Marathon',
      ],
      latitude: -6.218,
      longitude: 106.802,
    ),
    Club(
      name: 'Voli Seru Jakarta Barat',
      category: 'Voli',
      accentColor: Color(0xFF2455A6),
      sportIcon: Icons.sports_volleyball_rounded,
      bannerImagePath: 'assets/images/volleyball.jpg',
      memberCount: 48,
      rating: 4.7,
      weeklySessions: '1x / Minggu',
      foundedYear: 2023,
      skillLevel: 'Semua Level',
      homebaseLocation: 'Jakarta Barat',
      venueAddress: 'GOR Grogol Petamburan, Jl. Dr. Susilo Raya No. 12',
      regularSchedule: 'Sabtu 16.00 - 18.30 WIB',
      hostName: 'Rizky Ramadhan',
      hostRole: 'Koordinator Klub',
      bio:
          'Wadah berkumpulnya pecinta olahraga bola voli di Jakarta Barat. Sesi latihan '
          'mencakup drill passing, servis, spike, dilanjutkan fun match 6v6 yang seru dan '
          'penuh semangat kebersamaan.',
      highlights: [
        'Bola Mikasa Standar',
        'Drill Teknik Dasar',
        'Lapangan Indoor',
        'Komunitas Solid',
      ],
      latitude: -6.168,
      longitude: 106.758,
    ),
    Club(
      name: 'Jaksel Tennis Crew',
      category: 'Tenis',
      accentColor: Color(0xFF638C27),
      sportIcon: Icons.sports_tennis_rounded,
      bannerImagePath: 'assets/images/tennis.jpg',
      memberCount: 35,
      rating: 4.8,
      weeklySessions: '2x / Minggu',
      foundedYear: 2023,
      skillLevel: 'Beginner & Intermediate',
      homebaseLocation: 'Jakarta Selatan',
      venueAddress: 'Lapangan Tenis Kemang, Jl. Kemang Selatan VIII No. 9',
      regularSchedule: 'Minggu 07.00 - 10.00 WIB',
      hostName: 'Kevin Sanjaya',
      hostRole: 'Club Manager',
      bio:
          'Komunitas tenis lapangan modern di Jakarta Selatan dengan sesi coaching clinic '
          'dan rally santai. Tersedia ballboy dan keranjang bola penuh untuk memaksimalkan '
          'waktu latihan pukulan forehand maupun backhand.',
      highlights: [
        'Ballboy Tersedia',
        'Sesi Coaching & Rally',
        'Raket Pinjaman',
        'Hard Court Terawat',
      ],
      latitude: -6.275,
      longitude: 106.817,
    ),
    Club(
      name: 'Gowes Bareng Timur',
      category: 'Sepeda',
      accentColor: Color(0xFFB24C19),
      sportIcon: Icons.directions_bike_rounded,
      bannerImagePath: 'assets/images/cycling.jpg',
      memberCount: 57,
      rating: 4.8,
      weeklySessions: '2x / Minggu',
      foundedYear: 2021,
      skillLevel: 'Semua Jenis Sepeda (Roadbike / Folding)',
      homebaseLocation: 'Jakarta Timur',
      venueAddress: 'Velodrome Rawamangun, Jl. Balap Sepeda No. 35',
      regularSchedule: 'Sabtu & Minggu Pukul 06.00 WIB',
      hostName: 'Bagas Saputra',
      hostRole: 'Road Captain',
      bio:
          'Komunitas bersepeda pagi menjelajahi rute-rute asri Jakarta Timur hingga Bekasi '
          'dengan pengawalan road captain dan sweeper. Mengutamakan keselamatan berkendara '
          'di jalan raya serta silaturahmi sambil ngopi pagi usai gowes.',
      highlights: [
        'Road Captain & Sweeper',
        'Toolkit Darurat',
        'Rute Aman & Variatif',
        'Coffee Stop Mingguan',
      ],
      latitude: -6.219,
      longitude: 106.900,
    ),
    Club(
      name: 'Swim Buddies Jakarta',
      category: 'Renang',
      accentColor: Color(0xFF087DAB),
      sportIcon: Icons.pool_rounded,
      bannerImagePath: 'assets/images/swimming.jpg',
      memberCount: 41,
      rating: 4.7,
      weeklySessions: '2x / Minggu',
      foundedYear: 2024,
      skillLevel: 'Semua Level',
      homebaseLocation: 'Jakarta Utara',
      venueAddress: 'Kolam Renang Kelapa Gading Sport Club, Jakarta Utara',
      regularSchedule: 'Sabtu 08.00 - 10.00 WIB',
      hostName: 'Dimas Aditya',
      hostRole: 'Swim Coordinator',
      bio:
          'Komunitas renang pagi untuk meningkatkan kebugaran kardio dan memperbaiki teknik '
          'gaya bebas maupun gaya dada. Kolam ukuran semi-olympic yang bersih dan nyaman '
          'untuk latihan ketahanan (endurance).',
      highlights: [
        'Kolam Semi-Olympic',
        'Sharing Teknik Renang',
        'Pelampung & Kickboard',
        'Shower Air Hangat',
      ],
      latitude: -6.128,
      longitude: 106.856,
    ),
    Club(
      name: 'Yoga Pagi Pusat',
      category: 'Yoga',
      accentColor: Color(0xFFAC3978),
      sportIcon: Icons.self_improvement_rounded,
      bannerImagePath: 'assets/images/yoga.jpg',
      memberCount: 62,
      rating: 4.9,
      weeklySessions: '2x / Minggu',
      foundedYear: 2022,
      skillLevel: 'Semua Level (Ramah Pemula)',
      homebaseLocation: 'Jakarta Pusat',
      venueAddress: 'Taman Suropati Menteng, Jakarta Pusat',
      regularSchedule: 'Rabu 07.00 WIB & Sabtu 07.00 WIB',
      hostName: 'Joan Natasya',
      hostRole: 'Certified Yoga Instructor',
      bio:
          'Komunitas yoga ruang terbuka (outdoor) di bawah rindangnya pepohonan Menteng. '
          'Fokus pada fleksibilitas tubuh, pernapasan mindfulness, dan relaksasi pikiran '
          'sebelum memulai aktivitas harian.',
      highlights: [
        'Instruktur Bersertifikat',
        'Suasana Taman Asri',
        'Matras Cadangan',
        'Sesi Meditasi & Relaksasi',
      ],
      latitude: -6.1865,
      longitude: 106.8342,
    ),
    Club(
      name: 'Pingpong Fun Club',
      category: 'Pingpong',
      accentColor: Color(0xFF62552B),
      sportIcon: Icons.sports_tennis_rounded,
      bannerImagePath: 'assets/images/pingpong.jpg',
      memberCount: 29,
      rating: 4.8,
      weeklySessions: '2x / Minggu',
      foundedYear: 2023,
      skillLevel: 'Semua Level',
      homebaseLocation: 'Jakarta Selatan',
      venueAddress: 'PTM Kemang Table Tennis Hall, Jl. Kemang Raya No. 14',
      regularSchedule: 'Jumat 18.00 - 21.00 WIB',
      hostName: 'Paulus Kassapa',
      hostRole: 'Koordinator Komunitas',
      bio:
          'Komunitas tenis meja (pingpong) sepulang kerja untuk melatih refleks, kelincahan, '
          'dan melepas penat. Tersedia 4 meja standar ITTF dengan pencahayaan terang dan '
          'sistem king of the table yang seru.',
      highlights: [
        '4 Meja Standar ITTF',
        'Bola Bintang 3 Tersedia',
        'Ruangan Full AC',
        'Turnamen Mini Bulanan',
      ],
      latitude: -6.251,
      longitude: 106.823,
    ),
  ];

  /// Menyimpan klub tambahan yang dibuat oleh pengguna selama aplikasi berjalan.
  static final List<Club> _customClubs = [];

  /// Map indeks nama klub (lowercase) ke objek [Club] untuk pencarian O(1).
  static final Map<String, Club> _clubsByName = {
    for (final club in _initialClubs) club.name.toLowerCase(): club,
    // Alias untuk penyelenggara kegiatan Basket Sore di DetailPage:
    'south jakarta hoops club': _initialClubs[2],
  };

  /// Mengembalikan seluruh daftar klub (klub baru buatan pengguna + 10 klub bawaan).
  static List<Club> get allClubs => List.unmodifiable([
        ..._customClubs,
        ..._initialClubs,
      ]);

  /// Mendaftarkan klub baru buatan pengguna ke dalam daftar dan indeks pencarian O(1).
  static void registerClub(Club newClub) {
    final key = newClub.name.trim().toLowerCase();
    _customClubs.removeWhere((c) => c.name.trim().toLowerCase() == key);
    _customClubs.insert(0, newClub);
    _clubsByName[key] = newClub;
  }

  /// Mencari data [Club] berdasarkan nama klub dengan kompleksitas waktu O(1).
  static Club findByName(String clubName) {
    final normalized = clubName.trim().toLowerCase();
    return _clubsByName[normalized] ?? _initialClubs.first;
  }

  static (Color, IconData, String, List<String>) _themeForCategory(
    String category,
  ) {
    return switch (category.toLowerCase()) {
      'sepak bola' || 'futsal' => (
          const Color(0xFF146B4A),
          Icons.sports_soccer_rounded,
          'assets/images/futsal.jpg',
          const [
            'Bola & Rompi Tersedia',
            'Terbuka untuk Pemula',
            'Sparring Rutin',
          ],
        ),
      'badminton' => (
          const Color(0xFF6847C7),
          Icons.sports_tennis_rounded,
          'assets/images/badminton.jpg',
          const [
            'Shuttlecock Disediakan',
            'Ramah Pemula',
            'Sesi Ganda & Mix',
          ],
        ),
      'basket' => (
          const Color(0xFFDB6B22),
          Icons.sports_basketball_rounded,
          'assets/images/basket.jpg',
          const [
            'Pick-up Game 5v5',
            'Bola Standar Tersedia',
            'Semua Level',
          ],
        ),
      'lari' => (
          const Color(0xFF087F8C),
          Icons.directions_run_rounded,
          'assets/images/running.jpg',
          const [
            'Semua Pace',
            'Pemanasan Bersama',
            'Dokumentasi Komunitas',
          ],
        ),
      'voli' => (
          const Color(0xFF2455A6),
          Icons.sports_volleyball_rounded,
          'assets/images/volleyball.jpg',
          const [
            'Bola Standar Tersedia',
            'Drill & Fun Match',
            'Komunitas Solid',
          ],
        ),
      'tenis' => (
          const Color(0xFF638C27),
          Icons.sports_tennis_rounded,
          'assets/images/tennis.jpg',
          const [
            'Sesi Rally & Game',
            'Bola Tenis Tersedia',
            'Ramah Pemula',
          ],
        ),
      'sepeda' => (
          const Color(0xFFB24C19),
          Icons.directions_bike_rounded,
          'assets/images/cycling.jpg',
          const [
            'Rute Aman Bersama',
            'Semua Jenis Sepeda',
            'Coffee Stop',
          ],
        ),
      'renang' => (
          const Color(0xFF087DAB),
          Icons.pool_rounded,
          'assets/images/swimming.jpg',
          const [
            'Latihan Endurance',
            'Sharing Teknik',
            'Semua Level',
          ],
        ),
      'yoga' => (
          const Color(0xFFAC3978),
          Icons.self_improvement_rounded,
          'assets/images/yoga.jpg',
          const [
            'Ramah Pemula',
            'Sesi Relaksasi',
            'Komunitas Positif',
          ],
        ),
      'pingpong' => (
          const Color(0xFF62552B),
          Icons.sports_tennis_rounded,
          'assets/images/pingpong.jpg',
          const [
            'Meja Standar',
            'Bola Tersedia',
            'Fun Match',
          ],
        ),
      _ => (
          const Color(0xFF43556E),
          Icons.groups_rounded,
          'assets/images/futsal.jpg',
          const [
            'Terbuka untuk Umum',
            'Jadwal Rutin',
            'Komunitas Ramah',
          ],
        ),
    };
  }

  static (double, double) _coordinatesForLocation(String location) {
    final normalized = location.toLowerCase();
    if (normalized.contains('pusat')) return (-6.1865, 106.8342);
    if (normalized.contains('barat')) return (-6.168, 106.758);
    if (normalized.contains('timur')) return (-6.219, 106.900);
    if (normalized.contains('utara')) return (-6.128, 106.856);
    if (normalized.contains('gbk') || normalized.contains('senayan')) {
      return (-6.218, 106.802);
    }
    return (-6.2615, 106.8106); // Default: Jakarta Selatan
  }
}