import 'package:flutter_bloc/flutter_bloc.dart';
import 'settingsRepository.dart';
import 'settingsEvent.dart';
import 'settingsState.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _repository;

  SettingsBloc({required SettingsRepository repository})
    : _repository = repository,
      super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<NavigateToLanguage>(_onNavigateToLanguage);
    on<NavigateToCurrency>(_onNavigateToCurrency);
    on<SelectLanguage>(_onSelectLanguage);
    on<SelectCurrency>(_onSelectCurrency);
    on<DeleteAccount>(_onDeleteAccount);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final options = await _repository.getSettings();
      emit(SettingsLoaded(options));
    } catch (e) {
      emit(const SettingsError('Failed to load settings'));
    }
  }

  Future<void> _onNavigateToLanguage(
    NavigateToLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final languages = await _repository.getLanguages();
      emit(LanguageSelectionState(languages));
    } catch (e) {
      emit(const SettingsError('Failed to load languages'));
    }
  }

  Future<void> _onNavigateToCurrency(
    NavigateToCurrency event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final currencies = await _repository.getCurrencies();
      emit(CurrencySelectionState(currencies));
    } catch (e) {
      emit(const SettingsError('Failed to load currencies'));
    }
  }

  Future<void> _onSelectLanguage(
    SelectLanguage event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsActionLoading('language'));
    try {
      await _repository.updateLanguage(event.languageCode);
      final languages = await _repository.getLanguages();
      // Notify UI so it can call context.setLocale(...)
      emit(LanguageChanged(event.languageCode));
      emit(LanguageSelectionState(languages));
    } catch (e) {
      emit(const SettingsError('Failed to update language'));
    }
  }

  Future<void> _onSelectCurrency(
    SelectCurrency event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsActionLoading('currency'));
    try {
      await _repository.updateCurrency(event.currencyCode);
      final currencies = await _repository.getCurrencies();
      emit(CurrencySelectionState(currencies));
    } catch (e) {
      emit(const SettingsError('Failed to update currency'));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsActionLoading('delete'));
    try {
      await _repository.deleteAccount();
      final options = await _repository.getSettings();
      emit(SettingsLoaded(options));
    } catch (e) {
      emit(const SettingsError('Failed to delete account'));
    }
  }
}
