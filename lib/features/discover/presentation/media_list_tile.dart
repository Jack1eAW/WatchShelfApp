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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.withValues(
                    alpha: 0.68,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: CupertinoColors.white.withValues(alpha: 0.72),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.black.withValues(
                              alpha: 0.18,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: MediaPoster(
                        imageUrl: item.posterPath,
                        title: item.title,
                        width: 90,
                        height: 135,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
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
                                letterSpacing: 0,
                                color: CupertinoColors.label,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              '${item.year}  ·  ${item.mediaType.label}',
                              style: const TextStyle(
                                color: CupertinoColors.secondaryLabel,
                                fontSize: 14,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _SourceRatingPill(item: item),
                                if (personalRating != null)
                                  _Pill(
                                    icon:
                                        CupertinoIcons.person_crop_circle_fill,
                                    text: '$personalRating/10',
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(width: 8),
                      trailing!,
                    ] else
                      const Padding(
                        padding: EdgeInsets.only(top: 56, right: 2),
                        child: Icon(
                          CupertinoIcons.chevron_forward,
                          size: 15,
                          color: CupertinoColors.tertiaryLabel,
                        ),
                      ),
                  ],
                ),
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
        color: CupertinoColors.systemBackground.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.7),
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
