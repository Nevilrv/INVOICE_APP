import 'package:flutter/material.dart';

//Hex Opacity Values:
// 100% — FF
// 95% — F2
// 90% — E6
// 85% — D9
// 80% — CC
// 75% — BF
// 70% — B3
// 65% — A6
// 60% — 99
// 55% — 8C
// 50% — 80
// 45% — 73
// 40% — 66
// 35% — 59
// 30% — 4D
// 25% — 40
// 20% — 33
// 15% — 26
// 10% — 1A
// 5% — 0D
// 0% — 00

class ColorsConst{
  static const Color themeColor = Color(0xFF7A6FBE);
  static const Color whiteColor = Color(0xFFF6F6F7);
  static const Color bgColor = Color(0xFFE5E5E5);
  static const Color textColor = Color(0xFF575757);
}

const kDefaultShadow =
BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12, // Black color with 12% opacity
);