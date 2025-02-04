import 'package:flutter/material.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/appbar_theme.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/checkbox_theme.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/chip.theme.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/outline_button_theme.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/text_fiel_theme.dart';
import 'package:gluco_care/src/Utils/theme/custom_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  /// light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.ligthElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFielTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFielTheme.darkInputDecorationTheme,
  );
}
