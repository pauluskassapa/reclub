import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/registration_option.dart';
import 'registration_section_card.dart';

class RegistrationSummary extends StatelessWidget {
  const RegistrationSummary({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.schedule,
    required this.location,
    required this.fee,
  });

  final String name;
  final String email;
  final String phone;
  final RegistrationSchedule schedule;
  final RegistrationLocation location;
  final int fee;

  String _formatRupiah(int value) {
    final digits = value.toString();
    final formatted = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) formatted.write('.');
      formatted.write(digits[i]);
    }
    return 'Rp${formatted.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return RegistrationSectionCard(
      title: 'Ringkasan pendaftaran',
      child: Column(
        children: [
          _SummaryRow(label: 'Peserta', value: name),
          _SummaryRow(label: 'Email', value: email),
          _SummaryRow(label: 'Kontak', value: phone),
          _SummaryRow(label: 'Jadwal', value: '${schedule.title}\n${schedule.label}'),
          _SummaryRow(label: 'Lokasi', value: '${location.name}\n${location.address}'),
          const Divider(height: 20),
          _SummaryRow(
            label: 'Total biaya',
            value: fee <= 0 ? 'Gratis' : _formatRupiah(fee),
            emphasize: true,
          ),
          const SizedBox(height: 12),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: AppColors.mutedText, size: 16),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Pastikan data dan pilihan kegiatan sudah benar sebelum konfirmasi.',
                  style: TextStyle(color: AppColors.mutedText, fontSize: 12, height: 1.35),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.emphasize = false});

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: emphasize ? AppColors.primary : AppColors.text,
                fontSize: emphasize ? 15 : 12,
                fontWeight: emphasize ? FontWeight.bold : FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
