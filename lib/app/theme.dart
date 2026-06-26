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
        inherit: false,
        fontFamily: 'CupertinoSystemText',
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: CupertinoColors.label,
        decoration: TextDecoration.none,
      ),
      navTitleTextStyle: TextStyle(
        inherit: false,
        fontFamily: 'CupertinoSystemText',
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: CupertinoColors.label,
        decoration: TextDecoration.none,
      ),
    ),
  );
}
