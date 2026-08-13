abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class NavigateToLanguage extends SettingsEvent {}

class NavigateToCurrency extends SettingsEvent {}

class NavigateToShippingAddress extends SettingsEvent {}

class NavigateToPaymentMethods extends SettingsEvent {}

class SelectLanguage extends SettingsEvent {
  final String languageCode;
  SelectLanguage(this.languageCode);
}

class SelectCurrency extends SettingsEvent {
  final String currencyCode;
  SelectCurrency(this.currencyCode);
}

class DeleteAccount extends SettingsEvent {}
