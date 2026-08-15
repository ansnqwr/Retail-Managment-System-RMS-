import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../model/settingsModel.dart';
import '../view model/settingsBloc.dart';
import '../view model/settingsEvent.dart';
import '../view model/settingsState.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<SettingsBloc>();
      if (bloc.state is! LanguageSelectionState) {
        bloc.add(NavigateToLanguage());
      }
    });
  }

  Locale _localeFromCode(String code) {
    return Locale(code);
  }

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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is LanguageSelectionState) {
            return _buildLanguageList(context, state.languages);
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
                child: Text('Retry'),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLanguageList(BuildContext context, List<Language> languages) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D1B2E),
          ),
        ),
        const SizedBox(height: 4),
        Text('Language', style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
        ...languages.map(
          (lang) => _LanguageTile(
            language: lang,
            onTap: () {
              if (!lang.isSelected) {
                context.setLocale(_localeFromCode(lang.code));
                context.read<SettingsBloc>().add(SelectLanguage(lang.code));
              }
            },
          ),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final Language language;
  final VoidCallback onTap;

  const _LanguageTile({required this.language, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
