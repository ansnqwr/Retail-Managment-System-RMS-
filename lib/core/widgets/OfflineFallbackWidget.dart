import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OfflineFallbackWidget extends StatelessWidget {
  const OfflineFallbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 80, color: Color(0xFF6B2D5C)),
            SizedBox(height: 16),
            Text(
              'Welcome to Delni'.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You are currently offline. Please check your internet connection.'
                  .tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
