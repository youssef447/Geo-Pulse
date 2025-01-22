// Objectives: This file is responsible for providing the app colors that are used in the app.

import 'package:flutter/material.dart';

import 'app_theme.dart';

abstract class AppColors {
  static Map<String, Color> currentThemeColors = AppTheme.isDark ?? false
      ? AppTheme.darkThemeColors
      : AppTheme.lightThemeColors;

  // ----------------- Black & White Colors -----------------
  static Color get black => currentThemeColors['black']!;
  static Color get blackShadow => currentThemeColors['blackShadow']!;
  static Color get secondaryBlack => currentThemeColors['secondaryBlack']!;
  static Color get white => currentThemeColors['white']!;
  static Color get whiteShadow => currentThemeColors['whiteShadow']!;
  static Color get darkWhite => currentThemeColors['darkWhite']!;
  static Color get darkWhiteShadow => currentThemeColors['darkWhiteShadow']!;
  static Color get oddRowColor => currentThemeColors['oddRowColor']!;
  static Color get evenRowColor => currentThemeColors['evenRowColor']!;

  // ----------------- Primary Colors -----------------
  static Color primary = currentThemeColors['primary']!;
  static Color secondaryPrimary = currentThemeColors['secondaryPrimary']!;

  // ----------------- Components Colors -----------------
  static Color get header => currentThemeColors['header']!;
  static Color get text => currentThemeColors['text']!;
  static Color get inputColor => currentThemeColors['inputColor']!;
  static Color get button => currentThemeColors['button']!;
  static Color get textButton => AppTheme.contrastColor();
  static Color get icon => AppTheme.contrastColor();
  static Color get card => currentThemeColors['card']!;
  static Color get field => currentThemeColors['field']!;
  static Color get appBar => currentThemeColors['appBar']!;
  static Color get dropShadow => currentThemeColors['dropShadow']!;
  static Color get borderCard => currentThemeColors['borderCard']!;
  static Color get message => currentThemeColors['message']!;
  static Color get messageText => currentThemeColors['messageText']!;
  static Color get background => currentThemeColors['background']!;
  static Color get indicator => currentThemeColors['indicator']!;
  static Color get starredCard => currentThemeColors['starredCard']!;
  static Color get border => currentThemeColors['border']!;
  static Color get dialog => currentThemeColors['dialog']!;
  static Color get chatBackground => currentThemeColors['chatBackground']!;
  static Color get chatField => currentThemeColors['chatField']!;
  static Color get fieldBorder => currentThemeColors['fieldBorder']!;

  // ----------------- Grey Colors -----------------
  static Color get grey => currentThemeColors['grey']!;
  static Color get lightGrey => currentThemeColors['lightGrey']!;
  static Color get moreLightGrey => currentThemeColors['moreLightGrey']!;
  static Color get mediumGrey => currentThemeColors['mediumGrey']!;
  static Color get darkGrey => currentThemeColors['darkGrey']!;

  // ----------------- Basic Colors -----------------
  static Color get base => currentThemeColors[
      'base']!; // *** anything white and converted to secondary black in dark mode ***
  static Color get inverseBase => currentThemeColors[
      'inverseBase']!; // *** anything secondary black and converted to white in dark mode ***

  // ----------------- Secondary Colors -----------------
  static Color get lightGreen => currentThemeColors['lightGreen']!;
  static Color get green => currentThemeColors['green']!;
  static Color get darkRed => currentThemeColors['darkRed']!;
  static Color get red => currentThemeColors['red']!;
  static Color get blue => currentThemeColors['blue']!;
  static Color get orange => currentThemeColors['orange']!;
  static Color get yellow => currentThemeColors['yellow']!;
  static Color get warming => currentThemeColors['warming']!;
}
