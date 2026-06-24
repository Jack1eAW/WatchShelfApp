import 'package:flutter/cupertino.dart';

import '../domain/media_item.dart';
import 'media_poster.dart';

class MediaListTile extends StatelessWidget {
  const MediaListTile({
    required this.item,
    required this.onTap,
    this.personalRating,
    this.trailing,
    super.key,
  });

  final MediaItem item;
  final VoidCallback onTap;
  final int? personalRating;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaPoster(imageUrl: item.posterPath, title: item.title),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.year} • ${item.mediaType.label}',
                    style: const TextStyle(
                      color: CupertinoColors.secondaryLabel,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Pill(
                        icon: CupertinoIcons.star_fill,
                        text: item.voteAverage.toStringAsFixed(1),
                      ),
                      if (personalRating != null)
                        _Pill(
                          icon: CupertinoIcons.person_crop_circle_fill,
                          text: '$personalRating/10',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: CupertinoColors.systemYellow),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: CupertinoColors.label),
          ),
        ],
      ),
    );
  }
}
