import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/settingsModel.dart';
import '../view model/settingsBloc.dart';
import '../view model/settingsEvent.dart';
import '../view model/settingsState.dart';
import 'languageScreen.dart';
import 'currencyScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading || state is SettingsActionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SettingsLoaded) {
              return _buildSettingsList(context, state.options);
            }
            if (state is SettingsError) {
              return Center(
                child: TextButton(
                  onPressed:
                      () => context.read<SettingsBloc>().add(LoadSettings()),
                  child: const Text('Retry'),
                ),
              );
            }
            // Initial / unknown – trigger load
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, List<SettingOption> options) {
    final personal =
        options.where((o) => o.section == SettingSection.personal).toList();
    final shop =
        options.where((o) => o.section == SettingSection.shop).toList();
    final account =
        options.where((o) => o.section == SettingSection.account).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D1B2E),
          ),
        ),
        const SizedBox(height: 24),
        _buildSection('Personal', personal, context),
        const SizedBox(height: 24),
        _buildSection('Shop', shop, context),
        const SizedBox(height: 24),
        _buildSection('Account', account, context),
      ],
    );
  }

  Widget _buildSection(
    String title,
    List<SettingOption> items,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D1B2E),
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _SettingTile(option: item)),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final SettingOption option;
  const _SettingTile({required this.option});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option.title,
              style: TextStyle(
                fontSize: 15,
                color:
                    option.isDestructive
                        ? const Color(0xFFE57373)
                        : const Color(0xFF2D1B2E),
                fontWeight: FontWeight.w400,
              ),
            ),
            if (!option.isDestructive)
              Row(
                children: [
                  if (option.value != null)
                    Text(
                      option.value!,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    switch (option.id) {
      case 'shipping':
        context.read<SettingsBloc>().add(NavigateToShippingAddress());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const ShippingAddressScreen()),
        // );
        break;
      case 'payment':
        context.read<SettingsBloc>().add(NavigateToPaymentMethods());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()),
        // );
        break;
      case 'currency':
        context.read<SettingsBloc>().add(NavigateToCurrency());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: context.read<SettingsBloc>(),
                  child: const CurrencyScreen(), // or CurrencyScreen
                ),
          ),
        ).then((_) {
          context.read<SettingsBloc>().add(LoadSettings());
        });
        break;
      case 'language':
        context.read<SettingsBloc>().add(NavigateToLanguage());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: context.read<SettingsBloc>(),
                  child: const LanguageScreen(), // or CurrencyScreen
                ),
          ),
        ).then((_) {
          context.read<SettingsBloc>().add(LoadSettings());
        });
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Card
              Container(
                margin: const EdgeInsets.only(top: 28),
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'You are going to delete\nyour account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D1B2E),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You won't be able to restore your data",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3D2B3D),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<SettingsBloc>().add(
                                  DeleteAccount(),
                                );
                                Navigator.pop(ctx);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE57373),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Warning icon circle
              Positioned(
                top: 0,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Color(0xFFE57373),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
