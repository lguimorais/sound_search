import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  // Retorna um valor diferente dependendo do tamanho da tela
  static T value<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  // Atalhos úteis para padding e font size (fé que vai funcionar em tudo)
  static double horizontalPadding(BuildContext context) =>
      value(context, mobile: 16.0, tablet: 32.0, desktop: 64.0);

  static double cardFontSize(BuildContext context) =>
      value(context, mobile: 14.0, tablet: 15.0, desktop: 16.0);

  static double artworkSize(BuildContext context) =>
      value(context, mobile: 56.0, tablet: 68.0, desktop: 80.0);
}