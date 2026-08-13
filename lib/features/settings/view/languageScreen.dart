import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../model/settingsModel.dart';
import '../view model/settingsBloc.dart';
import '../view model/settingsEvent.dart';
import '../view model/settingsState.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.grey.shade800,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is LanguageChanged) {
            // Apply the new locale app-wide
            context.setLocale(_localeFromCode(state.languageCode));
          }
        },
        builder: (context, state) {
          if (state is LanguageSelectionState) {
            return _buildLanguageList(context, state.languages);
          }
          if (state is LanguageChanged) {
            // Briefly emitted; keep showing list if we have previous data
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsActionLoading && state.action == 'language') {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsError) {
            return Center(
              child: TextButton(
                onPressed:
                    () =>
                        context.read<SettingsBloc>().add(NavigateToLanguage()),
                child: const Text('Retry'),
              ),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<SettingsBloc>().add(NavigateToLanguage());
          });
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Locale _localeFromCode(String code) {
    // Map language codes to Locale (add script/country if needed later)
    switch (code) {
      case 'zh':
        return const Locale('zh', 'CN'); // Mandarin
      case 'fa':
        return const Locale('fa', 'IR');
      case 'ar':
        return const Locale('ar');
      default:
        return Locale(code);
    }
  }

  Widget _buildLanguageList(BuildContext context, List<Language> languages) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D1B2E),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Language',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        ...languages.map((lang) => _LanguageTile(language: lang)),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Language language;
  const _LanguageTile({required this.language});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!language.isSelected) {
          context.read<SettingsBloc>().add(SelectLanguage(language.code));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              language.isSelected
                  ? const Color(0xFFE8EAF6)
                  : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D1B2E),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    language.isSelected
                        ? const Color(0xFF3F51B5)
                        : const Color(0xFFF8BBD0),
                shape: BoxShape.circle,
              ),
              child:
                  language.isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
