// Core/utils/styles.dart
import 'package:delni_rms/constants.dart';
import 'package:flutter/material.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline24Bold => TextStyle(
    color: appTheme.writecolor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
}
