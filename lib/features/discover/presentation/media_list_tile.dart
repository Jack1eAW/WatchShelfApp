import 'dart:ui';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemGroupedBackground
                    .withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: CupertinoColors.white.withValues(alpha: 0.68),
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
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
                            fontWeight: FontWeight.w700,
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
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _SourceRatingPill(item: item),
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
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SourceRatingPill extends StatelessWidget {
  const _SourceRatingPill({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final rating = item.voteAverage;
    final source = switch (item.mediaType) {
      MediaType.movie => 'IMDb',
      MediaType.tv => 'TV rating',
    };

    if (rating == null || rating <= 0) {
      return _Pill(
        icon: CupertinoIcons.star,
        iconColor: CupertinoColors.systemGrey,
        text: item.mediaType == MediaType.movie
            ? 'IMDb rating unavailable'
            : 'Rating unavailable',
      );
    }

    return _Pill(
      icon: CupertinoIcons.star_fill,
      text: '$source ${rating.toStringAsFixed(1)}',
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.text,
    this.iconColor = CupertinoColors.systemYellow,
  });

  final IconData icon;
  final String text;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.58),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
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
