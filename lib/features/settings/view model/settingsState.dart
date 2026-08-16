import 'package:equatable/equatable.dart';
import '../model/settingsModel.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final List<SettingOption> options;
  const SettingsLoaded(this.options);

  @override
  List<Object?> get props => [options];
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AccountDeleted extends SettingsState {
  const AccountDeleted();
}

class LanguageSelectionState extends SettingsState {
  final List<Language> languages;
  const LanguageSelectionState(this.languages);

  @override
  List<Object?> get props => [languages];
}

class CurrencySelectionState extends SettingsState {
  final List<Currency> currencies;
  const CurrencySelectionState(this.currencies);

  @override
  List<Object?> get props => [currencies];
}

class SettingsActionLoading extends SettingsState {
  final String action;
  const SettingsActionLoading(this.action);

  @override
  List<Object?> get props => [action];
}

/// Emitted after language is saved to prefs – UI should call context.setLocale
class LanguageChanged extends SettingsState {
  final String languageCode;
  const LanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
