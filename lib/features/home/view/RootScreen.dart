import 'package:delni_rms/core/widgets/NavigationDestinationWidget.dart';

import '/features/home/Model/profile_repository.dart';
import '/features/home/view%20model/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/home/view/profile_view.dart';
import '/features/home/view/Cart.dart';
import '/features/home/view/Favorites.dart';
import '/features/home/view/HomeScreen.dart';
import '/features/home/view/Categories.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(),
      Favorites(),
      Categories(),
      Cart(),
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
