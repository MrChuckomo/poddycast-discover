import 'package:flutter/material.dart';


const darkColor = Color(0xFF1B1B1B);
const primaryColor = Color(0xFF95E3F3);
const secondaryColor = Color(0xFFFD9A76);

final appTheme = ThemeData(
  // colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF95E3F3)),

  brightness: Brightness.dark,
  primaryColor: primaryColor,
  highlightColor: secondaryColor,
  focusColor: secondaryColor,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: secondaryColor,
    foregroundColor: Colors.white,
  ),

  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(fontSize: 18, color: darkColor),
    backgroundColor: primaryColor,
    foregroundColor: darkColor,
    scrolledUnderElevation: 0,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: primaryColor.withValues(alpha: .1),
    side: BorderSide(color: primaryColor.withValues(alpha: .3)),
    labelStyle: TextStyle(color:primaryColor),
  ),

  inputDecorationTheme: InputDecorationTheme(
    focusColor: primaryColor,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
    ),
    floatingLabelStyle: TextStyle(
      color: primaryColor
    )
  ),

  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: secondaryColor
  ),

  textSelectionTheme: TextSelectionThemeData(
    cursorColor: primaryColor,
  ),

  listTileTheme: ListTileThemeData(
    selectedTileColor: primaryColor,
    selectedColor: darkColor,
  ),

  sliderTheme: SliderThemeData(
    activeTrackColor: secondaryColor.withValues(alpha: 0.8),
    thumbColor: secondaryColor,
  ),

  primaryTextTheme: TextTheme(
    headlineLarge: TextStyle(color: darkColor),
    headlineMedium: TextStyle(color: darkColor),
    headlineSmall: TextStyle(color: darkColor),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  tabBarTheme: TabBarThemeData(
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: const Color(0xFF34274D),
    ),
    labelColor: Colors.white,
    indicatorSize: TabBarIndicatorSize.tab,
    dividerHeight: 0,
    unselectedLabelColor: Colors.black,
  ),
  extensions: <ThemeExtension<dynamic>>[
    BarChartExtension(topColor: Colors.white54, bottomColor: Colors.white12),
  ],
);

class BarChartExtension extends ThemeExtension<BarChartExtension> {
  final Color? topColor;
  final Color? bottomColor;

  BarChartExtension({this.topColor, this.bottomColor});

  @override
  BarChartExtension copyWith({Color? topColor, Color? bottomColor}) {
    return BarChartExtension(
      topColor: topColor ?? this.topColor,
      bottomColor: bottomColor ?? this.bottomColor,
    );
  }

  @override
  BarChartExtension lerp(BarChartExtension? other, double t) {
    if (other == null) return this;
    return BarChartExtension(
      topColor: Color.lerp(topColor, other.topColor, t),
      bottomColor: Color.lerp(bottomColor, other.bottomColor, t),
    );
  }
}
