import 'package:flutter/material.dart';
import 'size_config.dart';

//BASE SPACING FOR A APP
const double _baseSpacing = 8;

//RELATIVE SPACING

//1X SPACING
const double space1x = _baseSpacing;

//2X SPACING
const double space2x = 2 * _baseSpacing;

//3X SPACING
const double space3x = 3 * _baseSpacing;

//4X SPACING
const double space4x = 4 * _baseSpacing;

//5X SPACING
const double space5x = 5 * _baseSpacing;

//SCREEN MULTIPLIERS
double get rWidthMultiplier => SizeConfig.widthMultiplier;
double get rHeightMultiplier => SizeConfig.heightMultiplier;

double rw(double width) => SizeConfig.setWidth(width);
double rh(double height) => SizeConfig.setHeight(height);
double rf(double size) => SizeConfig.setSp(size);

class Gap {
  static SizedBox get w4 => SizedBox(width: rw(4));
  static SizedBox get w8 => SizedBox(width: rw(8));
  static SizedBox get w12 => SizedBox(width: rw(12));
  static SizedBox get w16 => SizedBox(width: rw(16));
  static SizedBox get w20 => SizedBox(width: rw(20));

  static SizedBox get h4 => SizedBox(height: rh(4));
  static SizedBox get h8 => SizedBox(height: rh(8));
  static SizedBox get h10 => SizedBox(height: rh(10));
  static SizedBox get h12 => SizedBox(height: rh(12));
  static SizedBox get h16 => SizedBox(height: rh(16));
  static SizedBox get h20 => SizedBox(height: rh(20));
  static SizedBox get h24 => SizedBox(height: rh(24));
  static SizedBox get h32 => SizedBox(height: rh(32));
}
