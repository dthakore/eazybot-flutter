import 'package:flutter/material.dart';
import '../constant/colors.dart';
import '../constant/fonts.dart';

final TextStyle headerText = TextStyle(
  color: colorBlack,
  fontSize: 22,
  fontFamily: fontInter,
  fontWeight: FontWeight.w700,
  //height: 1.50,
);

TextStyle blackNormalTextStyle(double size, [Color color = colorBlack]) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: fontInter,
    fontWeight: FontWeight.w400
  );
}

TextStyle blackBoldTextStyle(double size) {
  return TextStyle(
    color: colorBlack,
    fontSize: size,
    fontFamily: fontInter,
    fontWeight: FontWeight.w700,
  );
}

TextStyle textStylew700(double size, [Color color = colorBlack]) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: fontInter,
    fontWeight: FontWeight.w700,
  );
}

TextStyle textStylew600(double size, [Color color = colorBlack]) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: fontInter,
    fontWeight: FontWeight.w600,
  );
}

TextStyle textStylew500(double size, [Color color = colorBlack]) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: fontInter,
    fontWeight: FontWeight.w500,
  );
}

TextStyle textStylew400(double size, [Color color = colorBlack]) {
  return TextStyle(
    color: color,
    fontSize: size,
    fontFamily: fontInter,
    fontWeight: FontWeight.w400,
  );
}

final TextStyle signInISignUPTextStyle = TextStyle(
    color: color18273A,
    fontFamily: fontInter,
    letterSpacing: 2,
    fontSize: 14
);

final TextStyle titleStyle = TextStyle(
  color: color1E293B,
  fontSize: 12,
  fontFamily: fontInter,
  fontWeight: FontWeight.w500,
);