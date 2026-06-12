import 'package:flutter/material.dart';

class OfflineFallbackWidget extends StatelessWidget {
  const OfflineFallbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront, size: 80, color: Color(0xFF6B2D5C)),
            SizedBox(height: 16),
            Text(
              'أهلا بك في دلني',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'يبدو أنك لا تملك اتصالاً بالإنترنت، يرجى التحقق من اتصالك والمحاولة مرة أخرى',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
