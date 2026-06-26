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
            ? _PosterFallback(title: title, width: width, height: height)
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _PosterFallback(
                    title: title,
                    width: width,
                    height: height,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return _PosterFallback(
                    title: title,
                    width: width,
                    height: height,
                    isLoading: true,
                  );
                },
              ),
      ),
    );
  }
}

class _PosterFallback extends StatelessWidget {
  const _PosterFallback({
    required this.title,
    required this.width,
    required this.height,
    this.isLoading = false,
  });

  final String title;
  final double width;
  final double height;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final palette = _PosterPalette.fromTitle(title);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.top, palette.bottom],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -width * 0.2,
            top: height * 0.08,
            child: Icon(
              CupertinoIcons.film_fill,
              size: width * 0.78,
              color: CupertinoColors.white.withValues(alpha: 0.12),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(width < 100 ? 8 : 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 0.35,
                  height: 3,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: width < 100 ? 4 : 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: width < 100 ? 12 : 18,
                    height: 1.05,
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (isLoading) ...[
                  const SizedBox(height: 8),
                  const CupertinoActivityIndicator(
                    color: CupertinoColors.white,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterPalette {
  const _PosterPalette({required this.top, required this.bottom});

  final Color top;
  final Color bottom;

  static _PosterPalette fromTitle(String title) {
    const palettes = [
      _PosterPalette(top: Color(0xFF234E70), bottom: Color(0xFF102A43)),
      _PosterPalette(top: Color(0xFF6B2D5C), bottom: Color(0xFF281235)),
      _PosterPalette(top: Color(0xFF1F7A5C), bottom: Color(0xFF12372A)),
      _PosterPalette(top: Color(0xFF9A3412), bottom: Color(0xFF431407)),
      _PosterPalette(top: Color(0xFF3B3C8F), bottom: Color(0xFF17153B)),
    ];

    final index =
        title.codeUnits.fold<int>(0, (sum, value) => sum + value) %
        palettes.length;
    return palettes[index];
  }
}
