import 'package:flutter/cupertino.dart';

class WatchlistButton extends StatelessWidget {
  const WatchlistButton({
    required this.isSaved,
    required this.onPressed,
    super.key,
  });

  final bool isSaved;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: CupertinoColors.systemPink,
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
              size: 18,
              color: CupertinoColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isSaved ? 'Remove from Watchlist' : 'Add to Watchlist',
              style: const TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
