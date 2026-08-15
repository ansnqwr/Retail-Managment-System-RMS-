import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/settingsModel.dart';

abstract class SettingsRepository {
  Future<List<SettingOption>> getSettings();
  Future<List<Language>> getLanguages();
  Future<List<Currency>> getCurrencies();
  Future<void> updateLanguage(String languageCode);
  Future<void> updateCurrency(String currencyCode);
  Future<String> getSavedLanguageCode();
  Future<String> getSavedCurrencyCode();
  Future<void> deleteAccount();
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const _keyLanguage = 'easy_localization';
  static const _keyCurrency = 'settings_currency';

  static const _defaultLanguage = 'en';
  static const _defaultCurrency = 'USD';

  /// All supported languages (code must match translation JSON filename)
  static const List<Language> allLanguages = [
    Language(code: 'en', name: 'English'),
    Language(code: 'ar', name: 'العربية'),
    Language(code: 'de', name: 'German'),
    Language(code: 'fr', name: 'French'),
    Language(code: 'es', name: 'Spanish'),
    Language(code: 'tr', name: 'Turkish'),
    Language(code: 'it', name: 'Italian'),
    Language(code: 'ru', name: 'Russian'),
    Language(code: 'zh', name: 'Mandarin'),
    Language(code: 'ja', name: 'Japanese'),
    Language(code: 'fa', name: 'فارسى'),
    Language(code: 'ko', name: 'Korean'),
    // Language(code: 'ga', name: 'Irish'),
    Language(code: 'nl', name: 'Dutch'),
    Language(code: 'sv', name: 'Swedish'),
    Language(code: 'el', name: 'Greek'),
  ];

  static List<Currency> allCurrencies = [
    Currency(code: 'USD', name: 'US Dollar'.tr(), symbol: '\$'),
    Currency(code: 'EUR', name: 'Euro'.tr(), symbol: '€'),
    Currency(code: 'GBP', name: 'British Pound'.tr(), symbol: '£'),
    Currency(code: 'TRY', name: 'Turkish Lira'.tr(), symbol: '₺'),
    Currency(code: 'LBP', name: 'Lebanese Lira'.tr(), symbol: 'ل.ل'),
    Currency(code: 'SYP', name: 'Syrian Pound'.tr(), symbol: '£S'),
  ];

  @override
  Future<List<SettingOption>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_keyLanguage) ?? _defaultLanguage;
    final currencyCode =
        (prefs.getString(_keyCurrency) ?? _defaultCurrency).toUpperCase();

    final language = allLanguages.firstWhere(
      (l) => l.code == langCode,
      orElse: () => allLanguages.first,
    );
    final currency = allCurrencies.firstWhere(
      (c) => c.code == currencyCode,
      orElse: () => allCurrencies.first,
    );

    return [
      SettingOption(
        id: 'shipping',
        title: 'Shipping Address'.tr(),
        section: SettingSection.personal,
      ),
      SettingOption(
        id: 'payment',
        title: 'Payment methods'.tr(),
        section: SettingSection.personal,
      ),
      SettingOption(
        id: 'currency',
        title: 'Currency'.tr(),
        value: currency.displayValue,
        section: SettingSection.shop,
      ),
      SettingOption(
        id: 'language',
        title: 'Language'.tr(),
        value: language.name,
        section: SettingSection.account,
      ),
      SettingOption(
        id: 'delete',
        title: 'Delete My Account'.tr(),
        section: SettingSection.account,
        isDestructive: true,
      ),
    ];
  }

  @override
  Future<List<Language>> getLanguages() async {
    final selected = await getSavedLanguageCode();
    return allLanguages
        .map((l) => l.copyWith(isSelected: l.code == selected))
        .toList();
  }

  @override
  Future<List<Currency>> getCurrencies() async {
    final selected = await getSavedCurrencyCode();
    return allCurrencies
        .map((c) => c.copyWith(isSelected: c.code == selected))
        .toList();
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  @override
  Future<void> updateCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, currencyCode.toUpperCase());
  }

  @override
  Future<String> getSavedLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage) ?? _defaultLanguage;
  }

  @override
  Future<String> getSavedCurrencyCode() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString(_keyCurrency) ?? _defaultCurrency).toUpperCase();
  }

  @override
  Future<void> deleteAccount() async {
    // TODO: replace with real DELETE /account API call
    // final response = await dio.delete('/account');
    // if (response.statusCode != 200 && response.statusCode != 204) {
    //   throw Exception('Failed to delete account');
    // }
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
