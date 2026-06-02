// import 'package:flutter/material';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'متجر دلني الرئيسي',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF6B2D5C),
        foregroundColor: Colors.white,
        centerTitle: true,
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
