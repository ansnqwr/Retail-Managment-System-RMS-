// constants.dart
import 'package:delni_rms/cache/cache_healper.dart';
import 'package:flutter/material.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

class ThemeHelper {
  // نجيب الثيم من CacheHelper مباشرة
  final String _appTheme = CacheHelper.getThemeData();

  final Map<String, LightCodeColors> _supportedCustomColors = {
    'lightCode': LightCodeColors(),
  };

  final Map<String, ColorScheme> _supportedColorSchemes = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  LightCodeColors _getThemeColors() {
    return _supportedCustomColors[_appTheme] ?? LightCodeColors();
  }

  ThemeData _getThemeData() {
    final colorScheme =
        _supportedColorSchemes[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
    );
  }

  LightCodeColors themeColor() => _getThemeColors();

  ThemeData themeData() => _getThemeData();
}

class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light();
}

class LightCodeColors {
  Color get primarycolor => const Color(0xFF73366F);
  Color get writecolor => const Color(0xFF40193d);
  Color get secondcolor => const Color(0xFFf2a488);
  Color get backgroundcolor => Color(0xFFEFE8EF);
  Color get whitecolor => Colors.white;
  Color get greycolor => Colors.grey;
  Color get redcolor => Colors.red;
}
