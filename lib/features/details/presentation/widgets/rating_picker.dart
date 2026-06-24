import 'package:flutter/cupertino.dart';

class RatingPicker extends StatelessWidget {
  const RatingPicker({required this.value, required this.onChanged, super.key});

  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final rating = index + 1;
          final selected = rating == value;
          return RatingButton(
            rating: rating,
            selected: selected,
            onPressed: () => onChanged(rating),
          );
        },
      ),
    );
  }
}

class RatingButton extends StatelessWidget {
  const RatingButton({
    required this.rating,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final int rating;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(42, 42),
      onPressed: onPressed,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? CupertinoColors.systemIndigo
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '$rating',
          style: TextStyle(
            color: selected ? CupertinoColors.white : CupertinoColors.label,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
