import 'package:flutter/cupertino.dart';

class DetailSection extends StatelessWidget {
  const DetailSection({
    required this.title,
    required this.child,
    this.topSpacing = 20,
    super.key,
  });

  final String title;
  final Widget child;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
