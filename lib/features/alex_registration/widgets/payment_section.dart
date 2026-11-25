import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/registration_event_type.dart';
import 'registration_section_card.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({
    super.key,
    required this.fee,
    required this.eventType,
    required this.isClubMember,
    required this.hasPaid,
  });

  final int fee;
  final RegistrationEventType eventType;
  final bool isClubMember;
  final bool hasPaid;

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
    final isClubActivity = eventType == RegistrationEventType.clubOnly;
    final isRestricted = isClubActivity && !isClubMember;
    final isFree = isClubActivity && isClubMember;
    final isPriceMissing = !isClubActivity && fee <= 0;
    final heading = isRestricted
        ? 'Khusus anggota club'
        : isFree
        ? 'Gratis'
        : isPriceMissing
        ? 'Biaya belum ditentukan'
        : _formatRupiah(fee);
    final description = isRestricted
        ? 'Kegiatan ini khusus anggota club. Akun ini belum tercatat sebagai anggota.'
        : isClubActivity
        ? 'Kegiatan khusus club ini tidak dipungut biaya untuk anggota.'
        : isPriceMissing
        ? 'Penyelenggara perlu menetapkan biaya fun match sebelum pendaftaran dapat dikonfirmasi.'
        : hasPaid
        ? 'Pembayaran telah diselesaikan. Pendaftaran siap dikonfirmasi.'
        : 'Fun match untuk umum. Pembayaran sebesar ${_formatRupiah(fee)} perlu diselesaikan sebelum slot dikonfirmasi.';
    return RegistrationSectionCard(
      title: 'Pembayaran',
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isRestricted
              ? const Color(0xFFFFF1F0)
              : isFree
              ? AppColors.primary.withValues(alpha: 0.08)
              : const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isRestricted
                  ? Icons.lock_outline
                  : isFree
                  ? Icons.check_circle_outline
                  : Icons.account_balance_wallet_outlined,
              color: isRestricted
                  ? const Color(0xFFB42318)
                  : isFree
                  ? AppColors.primary
                  : const Color(0xFFB7791F),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    heading,
                    style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
