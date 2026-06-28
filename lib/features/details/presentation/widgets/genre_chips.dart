import 'package:flutter/cupertino.dart';

class GenreChips extends StatelessWidget {
  const GenreChips({required this.genres, super.key});

  final List<String> genres;

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return const Text(
        'No genres listed',
        style: TextStyle(color: CupertinoColors.secondaryLabel),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) => GenreChip(label: genre)).toList(),
    );
  }
}

class GenreChip extends StatelessWidget {
  const GenreChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.white.withValues(alpha: 0.72),
          width: 0.7,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, letterSpacing: 0),
      ),
    );
  }
}
