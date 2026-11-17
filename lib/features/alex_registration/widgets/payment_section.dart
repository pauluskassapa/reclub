import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'registration_section_card.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key, required this.fee});

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
    final isFree = fee <= 0;
    return RegistrationSectionCard(
      title: 'Pembayaran',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isFree ? AppColors.primary.withValues(alpha: 0.08) : const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isFree ? Icons.check_circle_outline : Icons.account_balance_wallet_outlined,
              color: isFree ? AppColors.primary : const Color(0xFFB7791F),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFree ? 'Gratis' : _formatRupiah(fee),
                    style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isFree
                        ? 'Kegiatan ini tidak dipungut biaya.'
                        : 'Pembayaran dilakukan langsung kepada penyelenggara. Belum ada transaksi yang diproses di aplikasi.',
                    style: const TextStyle(color: AppColors.mutedText, fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
