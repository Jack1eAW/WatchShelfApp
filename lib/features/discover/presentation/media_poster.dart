import 'package:flutter/cupertino.dart';

class MediaPoster extends StatelessWidget {
  const MediaPoster({
    required this.imageUrl,
    required this.title,
    this.width = 88,
    this.height = 132,
    super.key,
  });

  final String? imageUrl;
  final String title;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: width,
        height: height,
        color: CupertinoColors.systemGrey5,
        child: imageUrl == null || imageUrl!.isEmpty
            ? _PosterFallback(title: title)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _PosterFallback(title: title);
                },
              ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: CupertinoColors.label),
        ),
      ),
    );
  }
}
