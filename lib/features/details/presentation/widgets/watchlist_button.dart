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
    return CupertinoButton.filled(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSaved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(isSaved ? 'Remove from Watchlist' : 'Add to Watchlist'),
        ],
      ),
    );
  }
}
