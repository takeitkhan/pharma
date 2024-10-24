import 'dart:ui';

import 'package:flutter/material.dart';

const primaryColor = Color(0xff0073CF);
const secondaryColor = Color(0xff48CCB5);
const offWhite = Color(0xfff1f1f1);
const ddGray = Color(0xffDDDDDD);
const ashColor = Color(0xffB0B3B7); // Define ash color
const semiBlack = Color(0xFF555555);
const grayColor = Color(0xff808080); // Define gray color
const lightBlackColor = Color(0xff3C3C3C); // Define light black color

final Map<int, Color> _yellow700Map = {
  50:  primaryColor.withOpacity(0.1),
  100:  primaryColor.withOpacity(0.2),
  200:  primaryColor.withOpacity(0.3),
  300:  primaryColor.withOpacity(0.4),
  400:  primaryColor.withOpacity(0.5),
  500:  primaryColor.withOpacity(0.6),
  600:  primaryColor.withOpacity(0.7),
  700:  primaryColor.withOpacity(0.8),
  800:  primaryColor.withOpacity(0.9),
  900:  primaryColor.withOpacity(0.10),
};

final MaterialColor greenSwatch =
    MaterialColor( primaryColor.value, _yellow700Map);
