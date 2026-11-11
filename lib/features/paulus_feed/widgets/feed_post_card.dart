import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FeedPostCard extends StatefulWidget {
  const FeedPostCard({
    super.key,
    required this.club,
    required this.initials,
    required this.category,
    required this.title,
    required this.message,
    required this.imagePath,
    required this.likes,
  });

  final String club;
  final String initials;
  final String category;
  final String title;
  final String message;
  final String imagePath;
  final int likes;

  @override
  State<FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<FeedPostCard> {
  bool _liked = false;
  bool _saved = false;

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
              child: Text(widget.initials),
            ),
            title: Text(
              widget.club,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.category),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.message,
                  style: const TextStyle(color: AppColors.text, height: 1.4),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.cover,
              semanticLabel: 'Foto olahraga ${widget.category}',
              errorBuilder: (_, _, _) => const ColoredBox(
                color: AppColors.background,
                child: Center(
                  child: Icon(Icons.sports, color: AppColors.primary, size: 40),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  tooltip: _liked ? 'Batal suka' : 'Sukai postingan',
                  isSelected: _liked,
                  selectedIcon: const Icon(Icons.favorite),
                  icon: const Icon(Icons.favorite_border),
                  color: _liked ? AppColors.primary : AppColors.mutedText,
                  onPressed: () => setState(() => _liked = !_liked),
                ),
                Expanded(
                  child: Text(
                    '${widget.likes + (_liked ? 1 : 0)} suka',
                    style: const TextStyle(color: AppColors.mutedText),
                  ),
                ),
                IconButton(
                  tooltip: _saved ? 'Hapus dari simpanan' : 'Simpan postingan',
                  isSelected: _saved,
                  selectedIcon: const Icon(Icons.bookmark),
                  icon: const Icon(Icons.bookmark_border),
                  color: _saved ? AppColors.primary : AppColors.mutedText,
                  onPressed: () => setState(() => _saved = !_saved),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
