import 'package:flutter/cupertino.dart';

class WatchShelfTheme {
  const WatchShelfTheme._();

  static const Color primary = CupertinoColors.systemIndigo;
  static const Color surface = CupertinoColors.systemGroupedBackground;
  static const Color card = CupertinoColors.secondarySystemGroupedBackground;
  static const Color textMuted = CupertinoColors.secondaryLabel;

  static const light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: surface,
    barBackgroundColor: CupertinoColors.systemBackground,
    textTheme: CupertinoTextThemeData(
      navLargeTitleTextStyle: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: CupertinoColors.label,
      ),
      navTitleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.label,
      ),
    ),
  );
}
