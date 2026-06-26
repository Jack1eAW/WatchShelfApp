import 'package:flutter/cupertino.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('About')),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            Text(
              'WatchShelf',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 12),
            Text(
              'A clean iOS-style movie and TV aggregator for discovery, '
              'watchlists, and personal ratings.',
            ),
            SizedBox(height: 24),
            AboutInfoTile(
              title: 'Data source',
              body:
                  'TMDB-style API integration with public no-key fallback '
                  'sources for movie and TV catalogs.',
            ),
            AboutInfoTile(title: 'Version', body: '1.0.0 placeholder'),
            AboutInfoTile(
              title: 'Privacy',
              body: 'Watchlist and ratings are stored locally on device.',
            ),
          ],
        ),
      ),
    );
  }
}

class AboutInfoTile extends StatelessWidget {
  const AboutInfoTile({required this.title, required this.body, super.key});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(color: CupertinoColors.label)),
        ],
      ),
    );
  }
}
