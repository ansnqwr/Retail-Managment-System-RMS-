import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/settingsModel.dart';
import '../view model/settingsBloc.dart';
import '../view model/settingsEvent.dart';
import '../view model/settingsState.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safe place to trigger the load (only once)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      final bloc = context.read<SettingsBloc>();
      if (bloc.state is! CurrencySelectionState) {
        bloc.add(NavigateToCurrency());
      }
    });

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
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is CurrencySelectionState) {
            return _buildCurrencyList(context, state.currencies);
          }

          if (state is SettingsActionLoading && state.action == 'currency') {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(
              child: TextButton(
                onPressed:
                    () =>
                        context.read<SettingsBloc>().add(NavigateToCurrency()),
                child: const Text('Retry'),
              ),
            );
          }

          // Initial / loading
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCurrencyList(BuildContext context, List<Currency> currencies) {
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
          'Currency',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        ...currencies.map((c) => _CurrencyTile(currency: c)),
      ],
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;
  const _CurrencyTile({required this.currency});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!currency.isSelected) {
          context.read<SettingsBloc>().add(SelectCurrency(currency.code));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:
              currency.isSelected
                  ? const Color(0xFFE8EAF6)
                  : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${currency.code}  ·  ${currency.name}',
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
                    currency.isSelected
                        ? const Color(0xFF3F51B5)
                        : const Color(0xFFF8BBD0),
                shape: BoxShape.circle,
              ),
              child:
                  currency.isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
