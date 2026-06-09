import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/features/home/Model/profile_repository.dart';
import 'package:untitled/features/home/view%20model/profile_bloc.dart';
import 'package:untitled/features/home/view/profile_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(

                Icons.menu,
                size: 28,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(
                  context,
                ).openDrawer(); 
              },
            );
          },
        ),
        title: const Text(
          'متجر دلني الرئيسي',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6B2D5C),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم الضغط على زر الإشعارات',
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF6B2D5C)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'قائمة التحكم',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF6B2D5C)),
              title: const Text(
                'الملف الشخصي',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider(
                          create:
                              (context) =>
                                  ProfileBloc( ProfileRepository())
                                    ..add(LoadProfileEvent()),
                          child: const ProfileView(),
                        ),
                  ),
                );     

              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront, size: 80, color: Color(0xFF6B2D5C)),
              SizedBox(height: 16),
              Text(
                'مستودع المتاجر متاح الآن!',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تصفح الآن أفضل عروض التجزئة المخصصة لك في منطقتك.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
