enum SettingSection { personal, shop, account }

class SettingOption {
  final String id;
  final String title;
  final String? value;
  final SettingSection section;
  final bool isDestructive;

  SettingOption({
    required this.id,
    required this.title,
    this.value,
    required this.section,
    this.isDestructive = false,
  });

  SettingOption copyWith({
    String? id,
    String? title,
    String? value,
    SettingSection? section,
    bool? isDestructive,
  }) {
    return SettingOption(
      id: id ?? this.id,
      title: title ?? this.title,
      value: value ?? this.value,
      section: section ?? this.section,
      isDestructive: isDestructive ?? this.isDestructive,
    );
  }
}

class Language {
  final String code;
  final String name;
  final bool isSelected;

  const Language({
    required this.code,
    required this.name,
    this.isSelected = false,
  });

  Language copyWith({bool? isSelected}) {
    return Language(
      code: code,
      name: name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class Currency {
  final String code; // abbreviation stored in prefs, e.g. USD, SYP
  final String name;
  final String symbol; // visual symbol for UI if needed
  final bool isSelected;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    this.isSelected = false,
  });

  Currency copyWith({bool? isSelected}) {
    return Currency(
      code: code,
      name: name,
      symbol: symbol,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  /// Shown on the settings row — the abbreviation (USD, SYP, ...)
  String get displayValue => code;
}
