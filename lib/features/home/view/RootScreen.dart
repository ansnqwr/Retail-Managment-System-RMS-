import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../categories/View/Categories.dart';
import '../../orders/view%20model/orderBloc.dart';
import '../../orders/view%20model/orderEvent.dart';
import '../../orders/view%20model/ordersRepository.dart';
import '../../orders/view/ordersScreen.dart';
import '../../paymentcart/presentation/views/payment_cart_view.dart';
import '../../profiles/Model/profile_repository.dart';
import '../../profiles/View/profile_view.dart';
import '../../profiles/ViewModel/profile_bloc.dart';
import '/core/widgets/NavigationDestinationWidget.dart';
import 'HomeScreen.dart';

class RootScreen extends StatefulWidget {
  final bool isGuest;
  const RootScreen({super.key, required this.isGuest});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedIndex = 0;
  final Map<int, Widget> _pageCache = {};

  Widget _getPage(int index) {
    return _pageCache.putIfAbsent(index, () => _buildPage(index));
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen(isGuest: widget.isGuest);
      case 1:
        return Categories();
      case 2:
        return BlocProvider(
          create:
              (context) =>
                  OrdersBloc(repository: context.read<OrdersRepository>())
                    ..add(LoadOrders()),
          child: const OrdersScreen(),
        );
      case 3:
        // CartCubit is global — no local provider needed
        return const PaymentCartView();
      case 4:
        return BlocProvider(
          create: (context) {
            final bloc = ProfileBloc(ProfileRepository());
            if (!widget.isGuest) bloc.add(LoadProfileEvent());
            return bloc;
          },
          child: ProfileView(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(5, (i) => _getPage(i));

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: NavigationBar(
          destinations: [
            NavigationDestinationWidget(
              index: 0,
              selectedIndex: selectedIndex,
              label: 'Home'.tr(),
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
            ),
            NavigationDestinationWidget(
              index: 1,
              selectedIndex: selectedIndex,
              label: 'Categories'.tr(),
              icon: Icons.category_outlined,
              selectedIcon: Icons.category,
            ),
            NavigationDestinationWidget(
              index: 2,
              selectedIndex: selectedIndex,
              label: 'Orders'.tr(),
              icon: Icons.list_outlined,
              selectedIcon: Icons.list,
            ),
            NavigationDestinationWidget(
              index: 3,
              selectedIndex: selectedIndex,
              label: 'Cart'.tr(),
              icon: Icons.shopping_cart_outlined,
              selectedIcon: Icons.shopping_cart,
            ),
            NavigationDestinationWidget(
              index: 4,
              selectedIndex: selectedIndex,
              label: 'Profile'.tr(),
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
            ),
          ],
          animationDuration: const Duration(milliseconds: 300),
          selectedIndex: selectedIndex,
          onDestinationSelected:
              (value) => setState(() => selectedIndex = value),
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
        ),
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
    );
  }
}
