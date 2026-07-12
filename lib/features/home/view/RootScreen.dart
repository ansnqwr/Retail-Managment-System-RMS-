import '/core/widgets/NavigationDestinationWidget.dart';

import '../../profiles/Model/profile_repository.dart';
import '../../profiles/ViewModel/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profiles/View/profile_view.dart';
import '/features/home/view/Cart.dart';
import '/features/home/view/Favorites.dart';
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
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(isGuest: widget.isGuest),
      Favorites(),
      Categories(),
      CartScreen(),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create:
                        (context) =>
                            ProfileBloc(ProfileRepository())
                              ..add(LoadProfileEvent()),
                    child: const ProfileView(),
                  ),
            ),
          );
        },
      ),
    ];
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
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: Colors.transparent,
        ),
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
    );
  }
}
