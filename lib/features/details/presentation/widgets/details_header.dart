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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediaPoster(
          imageUrl: item.posterPath,
          title: item.title,
          width: 130,
          height: 195,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${item.year} • ${item.mediaType.label}',
                style: const TextStyle(color: CupertinoColors.secondaryLabel),
              ),
              const SizedBox(height: 12),
              _SourceRatingText(item: item),
              if (personalRating != null) ...[
                const SizedBox(height: 6),
                Text('Your rating $personalRating/10'),
              ],
            ],
          ),
        ),
      ],
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
      return Text(
        item.mediaType == MediaType.movie
            ? 'IMDb rating unavailable'
            : 'Rating unavailable',
        style: const TextStyle(color: CupertinoColors.secondaryLabel),
      );
    }

    final source = switch (item.mediaType) {
      MediaType.movie => 'IMDb rating',
      MediaType.tv => 'TV rating',
    };
    return Text('$source ${rating.toStringAsFixed(1)}/10');
  }
}
