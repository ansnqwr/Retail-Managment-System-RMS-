import 'package:http/http.dart' as http;

import '../../cart/view model/CartBloc.dart';
import '../../cart/view model/CartRepository.dart';
import '../../favorites/view model/FavoritesRepository.dart';
import '../../favorites/view model/favorites_bloc.dart';
import '../../favorites/view model/favorites_event.dart';
import '../../orders/view model/orderBloc.dart';
import '../../orders/view model/orderEvent.dart';
import '../../orders/view model/ordersRepository.dart';
import '../../orders/view/ordersScreen.dart';
import '/core/widgets/NavigationDestinationWidget.dart';

import '../../profiles/Model/profile_repository.dart';
import '../../profiles/ViewModel/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profiles/View/profile_view.dart';
import '../../cart/view/Cart.dart';
import '../../favorites/view/Favorites.dart';
import '/features/home/view/HomeScreen.dart';
import '../../categories/View/Categories.dart';

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
        return BlocProvider(
          create:
              (_) =>
                  FavoritesBloc(FavoritesRepository(http.Client()))
                    ..add(const FavoritesStarted()),
          child: const Favorites(),
        );
      case 2:
        return Categories();
      // case 3:
      //   return BlocProvider(
      //     create: (_) => CartBloc(CartRepository(http.Client())),
      //     child: const CartScreen(),
      //   );
      case 3:
        return BlocProvider(
          create:
              (context) =>
                  OrdersBloc(repository: context.read<OrdersRepository>())
                    ..add(LoadOrders()),
          child: const OrdersScreen(),
        );
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
    // Build all 5 pages using the cache so IndexedStack has them all
    final pages = List.generate(5, (i) => _getPage(i));

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: NavigationBar(
          destinations: [
            NavigationDestinationWidget(
              index: 0,
              selectedIndex: selectedIndex,
              label: 'Home',
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
            ),
            NavigationDestinationWidget(
              index: 1,
              selectedIndex: selectedIndex,
              label: 'Favorites',
              icon: Icons.favorite_border,
              selectedIcon: Icons.favorite,
            ),
            NavigationDestinationWidget(
              index: 2,
              selectedIndex: selectedIndex,
              label: 'Categories',
              icon: Icons.category_outlined,
              selectedIcon: Icons.category,
            ),
            NavigationDestinationWidget(
              index: 3,
              selectedIndex: selectedIndex,
              label: 'Cart',
              icon: Icons.shopping_cart_outlined,
              selectedIcon: Icons.shopping_cart,
            ),
            NavigationDestinationWidget(
              index: 4,
              selectedIndex: selectedIndex,
              label: 'Profile',
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
