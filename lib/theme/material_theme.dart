import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff446732),
      surfaceTint: Color(0xff446732),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffc4efab),
      onPrimaryContainer: Color(0xff2d4f1d),
      secondary: Color(0xff7d570e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdeac),
      onSecondaryContainer: Color(0xff604100),
      tertiary: Color(0xff48672e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc9eea7),
      onTertiaryContainer: Color(0xff314e19),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff8faf0),
      onSurface: Color(0xff191d16),
      onSurfaceVariant: Color(0xff43483e),
      outline: Color(0xff74796d),
      outlineVariant: Color(0xffc3c8bb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e312b),
      inversePrimary: Color(0xffa9d292),
      primaryFixed: Color(0xffc4efab),
      onPrimaryFixed: Color(0xff062100),
      primaryFixedDim: Color(0xffa9d292),
      onPrimaryFixedVariant: Color(0xff2d4f1d),
      secondaryFixed: Color(0xffffdeac),
      onSecondaryFixed: Color(0xff281900),
      secondaryFixedDim: Color(0xfff0be6d),
      onSecondaryFixedVariant: Color(0xff604100),
      tertiaryFixed: Color(0xffc9eea7),
      onTertiaryFixed: Color(0xff0c2000),
      tertiaryFixedDim: Color(0xffaed18d),
      onTertiaryFixedVariant: Color(0xff314e19),
      surfaceDim: Color(0xffd9dbd1),
      surfaceBright: Color(0xfff8faf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5ea),
      surfaceContainer: Color(0xffedefe5),
      surfaceContainerHigh: Color(0xffe7e9df),
      surfaceContainerHighest: Color(0xffe1e4d9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1c3e0d),
      surfaceTint: Color(0xff446732),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff527740),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4a3100),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8d661d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff213d09),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff57763c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8faf0),
      onSurface: Color(0xff0f120c),
      onSurfaceVariant: Color(0xff33382e),
      outline: Color(0xff4f544a),
      outlineVariant: Color(0xff696f64),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e312b),
      inversePrimary: Color(0xffa9d292),
      primaryFixed: Color(0xff527740),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3a5e2a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8d661d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff724e02),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff57763c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3f5d26),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5c8be),
      surfaceBright: Color(0xfff8faf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f5ea),
      surfaceContainer: Color(0xffe7e9df),
      surfaceContainerHigh: Color(0xffdbded4),
      surfaceContainerHighest: Color(0xffd0d3c9),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff123304),
      surfaceTint: Color(0xff446732),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2f521f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3d2800),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff634300),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff173301),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff34511b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8faf0),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292e25),
      outlineVariant: Color(0xff464b41),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e312b),
      inversePrimary: Color(0xffa9d292),
      primaryFixed: Color(0xff2f521f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff193a0a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff634300),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff462e00),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff34511b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1e3905),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb7bab0),
      surfaceBright: Color(0xfff8faf0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff2e7),
      surfaceContainer: Color(0xffe1e4d9),
      surfaceContainerHigh: Color(0xffd3d5cc),
      surfaceContainerHighest: Color(0xffc5c8be),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa9d292),
      surfaceTint: Color(0xffa9d292),
      onPrimary: Color(0xff163808),
      primaryContainer: Color(0xff2d4f1d),
      onPrimaryContainer: Color(0xffc4efab),
      secondary: Color(0xfff0be6d),
      onSecondary: Color(0xff432c00),
      secondaryContainer: Color(0xff604100),
      onSecondaryContainer: Color(0xffffdeac),
      tertiary: Color(0xffaed18d),
      onTertiary: Color(0xff1c3704),
      tertiaryContainer: Color(0xff314e19),
      onTertiaryContainer: Color(0xffc9eea7),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff11140f),
      onSurface: Color(0xffe1e4d9),
      onSurfaceVariant: Color(0xffc3c8bb),
      outline: Color(0xff8d9286),
      outlineVariant: Color(0xff43483e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e4d9),
      inversePrimary: Color(0xff446732),
      primaryFixed: Color(0xffc4efab),
      onPrimaryFixed: Color(0xff062100),
      primaryFixedDim: Color(0xffa9d292),
      onPrimaryFixedVariant: Color(0xff2d4f1d),
      secondaryFixed: Color(0xffffdeac),
      onSecondaryFixed: Color(0xff281900),
      secondaryFixedDim: Color(0xfff0be6d),
      onSecondaryFixedVariant: Color(0xff604100),
      tertiaryFixed: Color(0xffc9eea7),
      onTertiaryFixed: Color(0xff0c2000),
      tertiaryFixedDim: Color(0xffaed18d),
      onTertiaryFixedVariant: Color(0xff314e19),
      surfaceDim: Color(0xff11140f),
      surfaceBright: Color(0xff373a33),
      surfaceContainerLowest: Color(0xff0c0f0a),
      surfaceContainerLow: Color(0xff191d16),
      surfaceContainer: Color(0xff1d211a),
      surfaceContainerHigh: Color(0xff282b24),
      surfaceContainerHighest: Color(0xff32362f),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffbee8a6),
      surfaceTint: Color(0xffa9d292),
      onPrimary: Color(0xff0b2c00),
      primaryContainer: Color(0xff759b60),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffd697),
      onSecondary: Color(0xff352200),
      secondaryContainer: Color(0xffb5893e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffc3e8a1),
      onTertiary: Color(0xff132b00),
      tertiaryContainer: Color(0xff799a5c),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff11140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd9ded1),
      outline: Color(0xffafb4a7),
      outlineVariant: Color(0xff8d9286),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e4d9),
      inversePrimary: Color(0xff2e501e),
      primaryFixed: Color(0xffc4efab),
      onPrimaryFixed: Color(0xff031500),
      primaryFixedDim: Color(0xffa9d292),
      onPrimaryFixedVariant: Color(0xff1c3e0d),
      secondaryFixed: Color(0xffffdeac),
      onSecondaryFixed: Color(0xff1a0f00),
      secondaryFixedDim: Color(0xfff0be6d),
      onSecondaryFixedVariant: Color(0xff4a3100),
      tertiaryFixed: Color(0xffc9eea7),
      onTertiaryFixed: Color(0xff061500),
      tertiaryFixedDim: Color(0xffaed18d),
      onTertiaryFixedVariant: Color(0xff213d09),
      surfaceDim: Color(0xff11140f),
      surfaceBright: Color(0xff42463e),
      surfaceContainerLowest: Color(0xff060804),
      surfaceContainerLow: Color(0xff1b1f18),
      surfaceContainer: Color(0xff252922),
      surfaceContainerHigh: Color(0xff30342d),
      surfaceContainerHighest: Color(0xff3b3f38),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd2fcb8),
      surfaceTint: Color(0xffa9d292),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa5ce8e),
      onPrimaryContainer: Color(0xff020e00),
      secondary: Color(0xffffedd7),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffecbb6a),
      onSecondaryContainer: Color(0xff130900),
      tertiary: Color(0xffd6fcb3),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffaacd89),
      onTertiaryContainer: Color(0xff040e00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff11140f),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffedf2e4),
      outlineVariant: Color(0xffbfc4b7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e4d9),
      inversePrimary: Color(0xff2e501e),
      primaryFixed: Color(0xffc4efab),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa9d292),
      onPrimaryFixedVariant: Color(0xff031500),
      secondaryFixed: Color(0xffffdeac),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xfff0be6d),
      onSecondaryFixedVariant: Color(0xff1a0f00),
      tertiaryFixed: Color(0xffc9eea7),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffaed18d),
      onTertiaryFixedVariant: Color(0xff061500),
      surfaceDim: Color(0xff11140f),
      surfaceBright: Color(0xff4e514a),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d211a),
      surfaceContainer: Color(0xff2e312b),
      surfaceContainerHigh: Color(0xff393c35),
      surfaceContainerHighest: Color(0xff444841),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
