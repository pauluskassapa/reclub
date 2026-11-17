import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EventDatePicker extends StatelessWidget {
  const EventDatePicker({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeSelected,
  });

  final DateTime? selectedDateTime;
  final ValueChanged<DateTime> onDateTimeSelected;

  Future<void> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
      helpText: 'Pilih tanggal kegiatan',
      cancelText: 'Batal',
      confirmText: 'Lanjut',
    );

    if (selectedDate == null || !context.mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: selectedDateTime != null
          ? TimeOfDay.fromDateTime(selectedDateTime!)
          : TimeOfDay.now(),
      helpText: 'Pilih waktu kegiatan',
      cancelText: 'Batal',
      confirmText: 'Simpan',
    );

    if (selectedTime == null || !context.mounted) return;

    final result = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (result.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal kegiatan tidak boleh di waktu lampau.'),
        ),
      );
      return;
    }

    onDateTimeSelected(result);
  }

  String _formatDateTime(DateTime dateTime) {
    const days = [
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

    final day = days[dateTime.weekday - 1];
    final month = months[dateTime.month - 1];

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day, ${dateTime.day} $month ${dateTime.year} · $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal dan Waktu',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _selectDateTime(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDateTime == null
                        ? 'Pilih tanggal dan waktu'
                        : _formatDateTime(selectedDateTime!),
                    style: TextStyle(
                      color: selectedDateTime == null
                          ? AppColors.mutedText
                          : AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.mutedText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
