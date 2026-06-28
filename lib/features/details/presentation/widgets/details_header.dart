import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../discover/domain/media_item.dart';
import '../../../discover/presentation/media_poster.dart';

class DetailsHeader extends StatelessWidget {
  const DetailsHeader({
    required this.item,
    required this.personalRating,
    super.key,
  });

  final MediaItem item;
  final int? personalRating;

  @override
  Widget build(BuildContext context) {
    final backdrop = item.backdropPath ?? item.posterPath;

    return SizedBox(
      height: 354,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _Backdrop(imageUrl: backdrop),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x08000000),
                  Color(0x44000000),
                  Color(0xF2F2F2F7),
                ],
                stops: [0.2, 0.56, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.black.withValues(alpha: 0.28),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: MediaPoster(
                    imageUrl: item.posterPath,
                    title: item.title,
                    width: 118,
                    height: 177,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 26,
                            height: 1.05,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          '${item.year}  ·  ${item.mediaType.label}',
                          style: const TextStyle(
                            color: CupertinoColors.secondaryLabel,
                            fontSize: 15,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _SourceRatingText(item: item),
                        if (personalRating != null) ...[
                          const SizedBox(height: 7),
                          _RatingBadge(
                            icon: CupertinoIcons.person_crop_circle_fill,
                            text: 'Your rating $personalRating/10',
                            color: CupertinoColors.systemPink,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const ColoredBox(color: CupertinoColors.systemGrey4);
    }

    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const ColoredBox(color: CupertinoColors.systemGrey4);
        },
      ),
    );
  }
}

class _SourceRatingText extends StatelessWidget {
  const _SourceRatingText({required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final rating = item.voteAverage;
    if (rating == null || rating <= 0) {
      return _RatingBadge(
        icon: CupertinoIcons.star,
        text: item.mediaType == MediaType.movie
            ? 'IMDb unavailable'
            : 'Rating unavailable',
        color: CupertinoColors.systemGrey,
      );
    }

    final source = switch (item.mediaType) {
      MediaType.movie => 'IMDb rating',
      MediaType.tv => 'TV rating',
    };
    return _RatingBadge(
      icon: CupertinoIcons.star_fill,
      text: '$source ${rating.toStringAsFixed(1)}/10',
      color: CupertinoColors.systemYellow,
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({
    required this.icon,
    required this.text,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.72),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12.5, letterSpacing: 0),
            ),
          ),
        ],
      ),
    );
  }
}
