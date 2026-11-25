import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/registration_section_card.dart';

class RegistrationPaymentPage extends StatelessWidget {
  const RegistrationPaymentPage({
    super.key,
    required this.activityName,
    required this.fee,
    required this.schedule,
    required this.location,
  });

  final String activityName;
  final int fee;
  final String schedule;
  final String location;

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
          'Pembayaran',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                const Text('Total pembayaran', style: TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  _formatRupiah(fee),
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                Text(
                  activityName,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RegistrationSectionCard(
            title: 'Detail kegiatan',
            child: Column(
              children: [
                _PaymentDetailRow(label: 'Jadwal', value: schedule),
                _PaymentDetailRow(label: 'Lokasi', value: location),
                _PaymentDetailRow(label: 'Tipe', value: 'Fun match untuk umum'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          RegistrationSectionCard(
            title: 'Pembayaran demo',
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Payment gateway belum terhubung. Tombol di bawah hanya menyimulasikan pembayaran berhasil dan tidak memproses transaksi nyata.',
                    style: TextStyle(color: AppColors.mutedText, fontSize: 12, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Simulasikan pembayaran selesai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentDetailRow extends StatelessWidget {
  const _PaymentDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
