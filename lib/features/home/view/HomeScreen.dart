import 'package:delni_rms/core/widgets/CategorySliderItem.dart';

import '/core/widgets/OfflineFallbackWidget.dart';
import 'package:flutter/material.dart';
import '/core/widgets/IconCircleWidget.dart';
import '/core/widgets/BadgeIconWidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);

    List<Map<String, String>> categories = [
      {
        'label': 'All',
        // 'image': 'assets/images/all.png',
      },
      {
        'label': 'Clothing',
        // 'image': 'assets/images/clothing.png',
      },
      {
        'label': 'Electronics',
        // 'image': 'assets/images/electronics.png',
      },
      {
        'label': 'Sports',
        // 'image': 'assets/images/sports.png',
      },
      {
        'label': 'Home',
        // 'image': 'assets/images/home.png',
      },
      {
        'label': 'Jewelry',
        // 'image': 'assets/images/jewelry.png',
      },
    ];
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Row(
            children: [
              const SizedBox(width: 10),
              Text(
                'Hello, User!',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: IconCircleWidget(
                  icon: Icons.settings,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              // todo: edit the notifications number (label)
              InkWell(
                onTap: () {},
                child: BadgeIconWidget(
                  context: context,
                  label: '3',
                  icon: Icons.notifications_outlined,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),

          SizedBox(height: 30),

          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              children: List.generate(categories.length, (index) {
                return CategorySliderItem(
                  label: categories[index]['label']!,
                  //  image: categories[index]['image']!,
                );
              }),
            ),
          ),
        ],
        //  Center(child: const OfflineFallbackWidget())
      ),
    );
  }
}
