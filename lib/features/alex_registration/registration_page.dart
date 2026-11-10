import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'models/registration_option.dart';
import 'widgets/location_selector.dart';
import 'widgets/participant_form.dart';
import 'widgets/schedule_selector.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
    this.activityName = 'Latihan voli santai',
    this.hostName = 'Jakarta Volley Community',
    this.participantName = '',
    this.participantEmail = '',
    this.participantPhone = '',
  });

  final String activityName;
  final String hostName;
  final String participantName;
  final String participantEmail;
  final String participantPhone;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  int _selectedSchedule = 0;
  int _selectedLocation = 0;

  static const _schedules = [
    RegistrationSchedule(title: 'Sabtu pagi', date: 'Sabtu, 14 November 2026', time: '08.00–10.00 WIB'),
    RegistrationSchedule(title: 'Minggu sore', date: 'Minggu, 15 November 2026', time: '16.00–18.00 WIB'),
    RegistrationSchedule(title: 'Rabu malam', date: 'Rabu, 18 November 2026', time: '19.00–21.00 WIB'),
  ];

  static const _locations = [
    RegistrationLocation(name: 'GOR Sunter', address: 'Jl. Danau Sunter Selatan, Jakarta Utara'),
    RegistrationLocation(name: 'Lapangan Voli Kelapa Gading', address: 'Jl. Boulevard Raya, Jakarta Utara'),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.participantName);
    _emailController = TextEditingController(text: widget.participantEmail);
    _phoneController = TextEditingController(text: widget.participantPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
        ),
        title: const Text(
          'Daftar kegiatan',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            _ActivityIntro(activityName: widget.activityName, hostName: widget.hostName),
            const SizedBox(height: 16),
            ParticipantForm(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
            ),
            const SizedBox(height: 12),
            ScheduleSelector(
              schedules: _schedules,
              selectedIndex: _selectedSchedule,
              onSelected: (index) => setState(() => _selectedSchedule = index),
            ),
            const SizedBox(height: 12),
            LocationSelector(
              locations: _locations,
              selectedIndex: _selectedLocation,
              onSelected: (index) => setState(() => _selectedLocation = index),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityIntro extends StatelessWidget {
  const _ActivityIntro({required this.activityName, required this.hostName});

  final String activityName;
  final String hostName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.sports_volleyball, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activityName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Diselenggarakan oleh $hostName', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
