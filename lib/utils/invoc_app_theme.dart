import 'package:flutter/material.dart';

const double kDefaultPadding = 20.0;

class InvocAppTheme {
  InvocAppTheme._();

  //new
  static const Color lightWhite = Color(0xFFFBFAFA);

  //Old
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);

  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color spacer = Color(0xFFF2F2F2);
  static Color? ratingBG = Colors.yellow[600];

  static const Color textColor = Color(0xff2e2e2e);

  static Map<String, Color> nutriColor = {
    "a": Color.fromARGB(255, 0, 134, 15),
    "b": Color.fromARGB(255, 0, 193, 37),
    "c": Color.fromARGB(255, 234, 189, 0),
    "d": Color.fromARGB(255, 252, 144, 44),
    "e": Color.fromARGB(255, 234, 63, 0),
  };

  static int getNormalScore(int score) {
    if (score < 0) {
      return 0;
    } else if (score > 100) {
      return 100;
    } else {
      return score;
    }
  }

  static double getPosition(int score, String nutriGrade) {
    switch (nutriGrade) {
      case 'a':
        return 20.0 + score;
        break;
      case 'b':
        return 20.0 + score;
        break;
      case 'c':
        return 40.0 + score;
        break;
      case 'd':
        return 60.0 + score;
        break;
      case 'e':
        return 80.0 + score / 2.5;
        break;
      default:
        return 0;
        break;
    }
  }

  static const Color tagPositiveColor = Color(0x4d8fd96e);
  static const Color tagNegativeColor = Color(0x33eb1549);

  static const String fontName = 'Gilroy';

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline1: headline,
    subtitle1: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle textCaption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w100,
    fontSize: 28,
    letterSpacing: 0.8,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle display1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle subHeadline = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
  static const String lineSVG =
      '<svg viewBox="132.5 488.5 117.0 1.0" ><path transform="translate(132.5, 488.5)" d="M 0 0 L 117 0" fill="none" fill-opacity="0.12" stroke="#0b22d1" stroke-width="4" stroke-opacity="0.12" stroke-miterlimit="4" stroke-linecap="round" /></svg>';
}
