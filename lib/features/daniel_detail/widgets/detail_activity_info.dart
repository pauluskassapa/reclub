import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DetailActivityInfo extends StatelessWidget {
  const DetailActivityInfo({
    super.key,
    required this.schedule,
    required this.location,
    required this.venueAddress,
    required this.fee,
    required this.participantCount,
    required this.capacity,
    required this.description,
    this.feeNote = 'Termasuk sewa lapangan, bola & rompi',
    this.quotaTitle = 'Kuota Pemain Futsal',
    this.courtType,
    this.onRouteTap,
  });

  final String schedule;
  final String location;
  final String venueAddress;
  final String fee;
  final int participantCount;
  final int capacity;
  final String description;
  final String feeNote;
  final String quotaTitle;
  final String? courtType;
  final VoidCallback? onRouteTap;

  ({String primary, String? secondary}) _splitSchedule(String raw) {
    final trimmed = raw.trim();
    final commaIndex = trimmed.indexOf(',');
    if (commaIndex > 0 && commaIndex < trimmed.length - 1) {
      return (
        primary: trimmed.substring(0, commaIndex).trim(),
        secondary: trimmed.substring(commaIndex + 1).trim(),
      );
    }
    return (primary: trimmed, secondary: null);
  }

  ({String amount, String? unit}) _splitFee(String raw) {
    final trimmed = raw.trim();
    final slashIndex = trimmed.indexOf('/');
    if (slashIndex > 0 && slashIndex < trimmed.length - 1) {
      return (
        amount: trimmed.substring(0, slashIndex).trim(),
        unit: '/${trimmed.substring(slashIndex + 1).trim()}',
      );
    }
    return (amount: trimmed, unit: null);
  }

  ({String title, String subtitle}) _splitVenue() {
    final trimmedAddress = venueAddress.trim();
    final trimmedLocation = location.trim();
    if (trimmedAddress.isEmpty || trimmedAddress == trimmedLocation) {
      return (title: trimmedLocation, subtitle: trimmedLocation);
    }
    final commaIndex = trimmedAddress.indexOf(',');
    if (commaIndex > 0 && commaIndex < trimmedAddress.length - 1) {
      final venueName = trimmedAddress.substring(0, commaIndex).trim();
      final street = trimmedAddress.substring(commaIndex + 1).trim();
      final subtitle = trimmedLocation.isNotEmpty
          ? '$street, $trimmedLocation'
          : street;
      return (title: venueName, subtitle: subtitle);
    }
    return (title: trimmedLocation, subtitle: trimmedAddress);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFE5E7EB)),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.05),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
        capacity > 0 ? (participantCount / capacity).clamp(0.0, 1.0) : 0.0;
    final int remainingSlots = (capacity - participantCount).clamp(0, capacity);

    final parsedSchedule = _splitSchedule(schedule);
    final parsedFee = _splitFee(fee);
    final parsedVenue = _splitVenue();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Bento Grid 2-Kolom: Jadwal Main & Patungan
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'JADWAL MAIN',
                          style: TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          parsedSchedule.primary,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (parsedSchedule.secondary != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            parsedSchedule.secondary!,
                            style: const TextStyle(
                              color: AppColors.mutedText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.payments_rounded,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'PATUNGAN',
                          style: TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: parsedFee.amount,
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (parsedFee.unit != null)
                                TextSpan(
                                  text: ' ${parsedFee.unit}',
                                  style: const TextStyle(
                                    color: AppColors.mutedText,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          feeNote,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF059669),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 2. Kartu Lokasi dengan Mini-Map Preview & Tombol Rute
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _cardDecoration(),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: AppColors.secondary,
                            size: 17,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              parsedVenue.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        parsedVenue.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (courtType != null && courtType!.trim().isNotEmpty)
                            _VenueTag(label: courtType!),
                          _VenueTag(label: location),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _MiniMapButton(
                  onTap: () {
                    if (onRouteTap != null) {
                      onRouteTap!();
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Membuka petunjuk arah ke ${parsedVenue.title}...',
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 3. Kartu Kuota Pemain
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        quotaTitle,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '$participantCount/$capacity',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: remainingSlots > 0
                                ? const Color(0xFFECFDF5)
                                : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            remainingSlots > 0
                                ? '$remainingSlots slot kosong'
                                : 'Kuota penuh',
                            style: TextStyle(
                              color: remainingSlots > 0
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFDC2626),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    height: 10,
                    width: double.infinity,
                    color: const Color(0xFFE5E7EB),
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.accent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),
          const Text(
            'Deskripsi Kegiatan',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Text(
              description,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 13.5,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueTag extends StatelessWidget {
  const _VenueTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.mutedText,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MiniMapButton extends StatelessWidget {
  const _MiniMapButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(74, 74),
                  painter: _MiniMapRoadPainter(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Rute',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniMapRoadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFF10B981).withValues(alpha: 0.28)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.30),
      Offset(size.width, size.height * 0.65),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.32, 0),
      Offset(size.width * 0.20, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, 0),
      Offset(size.width * 0.82, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
