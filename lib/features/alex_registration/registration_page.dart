import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../defrigo_manage_event/models/managed_event.dart';
import 'models/registration_option.dart';
import 'widgets/confirmation_button.dart';
import 'widgets/location_selector.dart';
import 'widgets/participant_form.dart';
import 'widgets/payment_section.dart';
import 'widgets/registration_summary.dart';
import 'widgets/schedule_selector.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({
    super.key,
    this.event,
    this.activityName = 'Latihan voli santai',
    this.hostName,
    this.fee = 0,
    this.participantName = '',
    this.participantEmail = '',
    this.participantPhone = '',
  });

  final ManagedEvent? event;
  final String activityName;
  final String? hostName;
  final int fee;
  final String participantName;
  final String participantEmail;
  final String participantPhone;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  int _selectedSchedule = 0;
  int _selectedLocation = 0;

  RegistrationSchedule get _schedule => _availableSchedules[_selectedSchedule];
  RegistrationLocation get _location => _availableLocations[_selectedLocation];

  static const _demoSchedules = [
    RegistrationSchedule(title: 'Sabtu pagi', date: 'Sabtu, 28 November 2026', time: '08.00–10.00 WIB'),
    RegistrationSchedule(title: 'Minggu sore', date: 'Minggu, 29 November 2026', time: '16.00–18.00 WIB'),
    RegistrationSchedule(title: 'Rabu malam', date: 'Rabu, 2 Desember 2026', time: '19.00–21.00 WIB'),
  ];

  static const _demoLocations = [
    RegistrationLocation(name: 'GOR Sunter', address: 'Jl. Danau Sunter Selatan, Jakarta Utara'),
    RegistrationLocation(name: 'Lapangan Voli Kelapa Gading', address: 'Jl. Boulevard Raya, Jakarta Utara'),
  ];

  List<RegistrationSchedule> get _availableSchedules {
    final event = widget.event;
    if (event == null) return _demoSchedules;

    return [
      RegistrationSchedule(
        title: event.category,
        date: _formatDate(event.dateTime),
        time: '${_formatTime(event.dateTime)} WIB',
      ),
    ];
  }

  List<RegistrationLocation> get _availableLocations {
    final event = widget.event;
    if (event == null) return _demoLocations;

    return [RegistrationLocation(name: event.location, address: '')];
  }

  String _formatDate(DateTime dateTime) {
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${weekdays[dateTime.weekday - 1]}, ${dateTime.day} '
        '${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) =>
      '${dateTime.hour.toString().padLeft(2, '0')}.${dateTime.minute.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.participantName);
    _emailController = TextEditingController(text: widget.participantEmail);
    _phoneController = TextEditingController(text: widget.participantPhone);
    _nameController.addListener(_refreshSummary);
    _emailController.addListener(_refreshSummary);
    _phoneController.addListener(_refreshSummary);
  }

  @override
  void dispose() {
    _nameController.removeListener(_refreshSummary);
    _emailController.removeListener(_refreshSummary);
    _phoneController.removeListener(_refreshSummary);
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _refreshSummary() => setState(() {});

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
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          children: [
            _ActivityIntro(
              activityName: widget.event?.name ?? widget.activityName,
              hostName: widget.hostName ?? 'Penyelenggara kegiatan',
              category: widget.event?.category,
              description: widget.event?.description,
              date: widget.event == null ? null : _formatDate(widget.event!.dateTime),
              time: widget.event == null ? null : '${_formatTime(widget.event!.dateTime)} WIB',
              location: widget.event?.location,
            ),
            const SizedBox(height: 16),
            ParticipantForm(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
            ),
            const SizedBox(height: 12),
            ScheduleSelector(
              schedules: _availableSchedules,
              selectedIndex: _selectedSchedule,
              onSelected: (index) => setState(() => _selectedSchedule = index),
            ),
            const SizedBox(height: 12),
            LocationSelector(
              locations: _availableLocations,
              selectedIndex: _selectedLocation,
              onSelected: (index) => setState(() => _selectedLocation = index),
            ),
            const SizedBox(height: 12),
            PaymentSection(fee: widget.fee),
            const SizedBox(height: 12),
            RegistrationSummary(
              name: _valueOrDash(_nameController.text),
              email: _valueOrDash(_emailController.text),
              phone: _valueOrDash(_phoneController.text),
              schedule: _schedule,
              location: _location,
              fee: widget.fee,
            ),
            const SizedBox(height: 16),
            ConfirmationButton(onPressed: _confirmRegistration),
          ],
        ),
      ),
    );
  }

  String _valueOrDash(String value) => value.trim().isEmpty ? '—' : value.trim();

  void _confirmRegistration() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: AppColors.primary, size: 40),
        title: const Text('Pendaftaran berhasil'),
        content: Text(
          '${_nameController.text.trim()}, kamu terdaftar untuk ${widget.event?.name ?? widget.activityName} pada ${_schedule.label}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).maybePop();
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }
}

class _ActivityIntro extends StatelessWidget {
  const _ActivityIntro({
    required this.activityName,
    required this.hostName,
    this.category,
    this.description,
    this.date,
    this.time,
    this.location,
  });

  final String activityName;
  final String hostName;
  final String? category;
  final String? description;
  final String? date;
  final String? time;
  final String? location;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          if (category != null || description != null || date != null || location != null) ...[
            const SizedBox(height: 14),
            if (category != null) _EventDetailLine(icon: Icons.sports, value: category!),
            if (description != null && description!.trim().isNotEmpty) ...[
              const SizedBox(height: 7),
              Text(
                description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 12, height: 1.35),
              ),
            ],
            if (date != null) ...[
              const SizedBox(height: 8),
              _EventDetailLine(icon: Icons.calendar_month_outlined, value: '$date · $time'),
            ],
            if (location != null) ...[
              const SizedBox(height: 7),
              _EventDetailLine(icon: Icons.location_on_outlined, value: location!),
            ],
          ],
        ],
      ),
    );
  }
}

class _EventDetailLine extends StatelessWidget {
  const _EventDetailLine({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.white),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 12),
          ),
        ),
      ],
    );
  }
}
