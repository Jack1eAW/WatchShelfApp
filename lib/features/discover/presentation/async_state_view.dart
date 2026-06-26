import 'package:flutter/cupertino.dart';

enum LoadingViewStyle { mediaList, details }

class LoadingView extends StatelessWidget {
  const LoadingView({this.style = LoadingViewStyle.mediaList, super.key});

  final LoadingViewStyle style;

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      LoadingViewStyle.mediaList => const MediaListShimmer(),
      LoadingViewStyle.details => const DetailsShimmer(),
    };
  }
}

class MediaListShimmer extends StatelessWidget {
  const MediaListShimmer({this.itemCount = 6, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: itemCount,
        itemBuilder: (context, index) => const MediaListSkeletonTile(),
      ),
    );
  }
}

class MediaListSkeletonTile extends StatelessWidget {
  const MediaListSkeletonTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonBox(width: 88, height: 132, borderRadius: 7),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 4),
                SkeletonBox(width: 170, height: 18, borderRadius: 5),
                SizedBox(height: 10),
                SkeletonBox(width: 110, height: 14, borderRadius: 5),
                SizedBox(height: 14),
                SkeletonBox(width: 86, height: 22, borderRadius: 7),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsShimmer extends StatelessWidget {
  const DetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 130, height: 195, borderRadius: 8),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    SkeletonBox(width: 190, height: 28, borderRadius: 6),
                    SizedBox(height: 12),
                    SkeletonBox(width: 120, height: 16, borderRadius: 5),
                    SizedBox(height: 14),
                    SkeletonBox(width: 140, height: 18, borderRadius: 5),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 28),
          SkeletonBox(width: 80, height: 22, borderRadius: 5),
          SizedBox(height: 12),
          Row(
            children: [
              SkeletonBox(width: 72, height: 30, borderRadius: 15),
              SizedBox(width: 8),
              SkeletonBox(width: 88, height: 30, borderRadius: 15),
            ],
          ),
          SizedBox(height: 28),
          SkeletonBox(width: double.infinity, height: 52, borderRadius: 8),
          SizedBox(height: 28),
          SkeletonBox(width: 120, height: 22, borderRadius: 5),
          SizedBox(height: 12),
          SkeletonBox(width: double.infinity, height: 16, borderRadius: 5),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 16, borderRadius: 5),
          SizedBox(height: 8),
          SkeletonBox(width: 260, height: 16, borderRadius: 5),
        ],
      ),
    );
  }
}

class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final width = bounds.width == 0 ? 1.0 : bounds.width;
            final slidePercent = _controller.value * 2 - 1;
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                CupertinoColors.systemGrey5,
                CupertinoColors.systemGrey4,
                CupertinoColors.systemGrey5,
              ],
              stops: const [0.25, 0.5, 0.75],
              transform: _SlidingGradientTransform(
                slidePercent: slidePercent,
                width: width,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
    required this.width,
  });

  final double slidePercent;
  final double width;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(width * slidePercent, 0, 0);
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: CupertinoColors.secondaryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            CupertinoButton.filled(
              onPressed: onRetry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
