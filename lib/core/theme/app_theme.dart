import 'package:flutter/material.dart';

/// Paleta de baja saturación, sin animaciones llamativas (principio sensorial).
class AppColors {
  static const background = Color(0xFFF7F3EC);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF2E3440);
  static const accent = Color(0xFF6E8FA8);

  /// Pasteles sugeridos por categoría; el texto siempre es [ink].
  static const pastels = <String, Color>{
    'necesidades': Color(0xFFCFE0EC),
    'comida': Color(0xFFF2DDC4),
    'bebida': Color(0xFFCDE6E3),
    'juegos': Color(0xFFE3D6EC),
    'emociones': Color(0xFFF2D5D9),
    'cuerpo': Color(0xFFF0E3C6),
    'personas': Color(0xFFD9E7CF),
    'acciones': Color(0xFFDADDE6),
  };
}

/// Transición sin animación entre pantallas.
class _NoTransitions extends PageTransitionsBuilder {
  const _NoTransitions();
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context,
          Animation<double> animation, Animation<double> secondary, Widget child) =>
      child;
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    surface: AppColors.background,
    onSurface: AppColors.ink,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    splashFactory: NoSplash.splashFactory,
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: _NoTransitions(),
    }),
    textTheme: Typography.blackMountainView.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
  );
}
