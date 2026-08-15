import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/settingsModel.dart';
import '../view model/settingsBloc.dart';
import '../view model/settingsEvent.dart';
import '../view model/settingsState.dart';
import 'languageScreen.dart';
import 'currencyScreen.dart';

class SettingsScreen extends StatefulWidget {
  // convert to StatefulWidget
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<SettingsBloc>();
      if (bloc.state is! SettingsLoaded) {
        bloc.add(LoadSettings());
      }
    });
  }

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
                  child: Text('Retry'.tr()),
                ),
              );
            }
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
        Text(
          'Settings'.tr(),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D1B2E),
          ),
        ),
        const SizedBox(height: 24),
        _buildSection('Personal'.tr(), personal, context),
        const SizedBox(height: 24),
        _buildSection('Shop'.tr(), shop, context),
        const SizedBox(height: 24),
        _buildSection('Account'.tr(), account, context),
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
          title.tr(),
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

class _SettingTile extends StatefulWidget {
  final SettingOption option;
  const _SettingTile({required this.option});

  @override
  State<_SettingTile> createState() => _SettingTileState();
}

class _SettingTileState extends State<_SettingTile> {
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
              widget.option.title.tr(),
              style: TextStyle(
                fontSize: 15,
                color:
                    widget.option.isDestructive
                        ? const Color(0xFFE57373)
                        : const Color(0xFF2D1B2E),
                fontWeight: FontWeight.w400,
              ),
            ),
            if (!widget.option.isDestructive)
              Row(
                children: [
                  if (widget.option.value != null)
                    Text(
                      widget.option.value!.tr(),
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
    // Capture the bloc reference BEFORE navigating. After Navigator.push the
    // original context may be deactivated, so we must not call
    // context.read<SettingsBloc>() inside .then().
    final bloc = context.read<SettingsBloc>();

    switch (widget.option.id) {
      case 'shipping':
        bloc.add(NavigateToShippingAddress());
        break;

      case 'payment':
        bloc.add(NavigateToPaymentMethods());
        break;

      case 'currency':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: bloc, // reuse the same bloc instance
                  child: const CurrencyScreen(),
                ),
          ),
        ).then((_) {
          // Use the captured bloc reference, NOT context.read — context may
          // be deactivated by the time .then() fires.
          if (mounted) bloc.add(LoadSettings());
        });
        break;

      case 'language':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: bloc, // reuse the same bloc instance
                  child: const LanguageScreen(),
                ),
          ),
        ).then((_) {
          if (mounted) bloc.add(LoadSettings());
        });
        break;

      case 'delete':
        _showDeleteDialog(context, bloc);
        break;
    }
  }

  void _showDeleteDialog(BuildContext context, SettingsBloc bloc) {
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
                    Text(
                      'You are going to delete\nyour account'.tr(),
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
                      "You won't be able to restore your data".tr(),
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
                              child: Text(
                                'Cancel'.tr(),
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
                                // Use captured bloc, not context.read
                                bloc.add(DeleteAccount());
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
                              child: Text(
                                'Delete'.tr(),
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
