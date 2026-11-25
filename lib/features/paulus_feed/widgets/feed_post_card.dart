import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FeedPostCard extends StatelessWidget {
  const FeedPostCard({
    super.key,
    required this.club,
    required this.initials,
    required this.category,
    required this.title,
    required this.message,
    required this.imagePath,
    this.imageUrl,
    required this.likes,
    required this.liked,
    required this.saved,
    required this.onLike,
    required this.onSave,
  });

  final String club;
  final String initials;
  final String category;
  final String title;
  final String message;
  final String imagePath;
  final String? imageUrl;
  final int likes;

  final bool liked;
  final bool saved;
  final VoidCallback onLike;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              foregroundColor: AppColors.primary,
              child: Text(initials),
            ),
            title: Text(
              club,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(category),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: const TextStyle(color: AppColors.text, height: 1.4),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imageUrl == null || imageUrl!.isEmpty
                ? Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    semanticLabel: 'Foto olahraga $category',
                    errorBuilder: (_, _, _) => _fallbackImage(),
                  )
                : Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    semanticLabel: 'Foto postingan $category',
                    errorBuilder: (_, _, _) => _fallbackImage(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: liked ? 'Batal suka' : 'Sukai postingan',
                  isSelected: liked,
                  selectedIcon: const Icon(Icons.favorite),
                  icon: const Icon(Icons.favorite_border),
                  color: liked ? AppColors.primary : AppColors.mutedText,
                  onPressed: onLike,
                ),
                Expanded(
                  child: Text(
                    '${likes + (liked ? 1 : 0)} suka',
                    style: const TextStyle(color: AppColors.mutedText),
                  ),
                ),
                IconButton(
                  tooltip: saved ? 'Hapus dari simpanan' : 'Simpan postingan',
                  isSelected: saved,
                  selectedIcon: const Icon(Icons.bookmark),
                  icon: const Icon(Icons.bookmark_border),
                  color: saved ? AppColors.primary : AppColors.mutedText,
                  onPressed: onSave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() => const ColoredBox(
    color: AppColors.background,
    child: Center(
      child: Icon(Icons.sports, color: AppColors.primary, size: 40),
    ),
  );
}
