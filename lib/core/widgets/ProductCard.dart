import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'ImageHelper.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final bool isNew;
  final bool hasDiscount;
  final VoidCallback? onTap;
  final double width;
  final int discountPercentage;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.isNew,
    required this.hasDiscount,
    required this.discountPercentage,
    this.onTap,
    this.width = 160,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(aspectRatio: 4 / 3, child: _buildImage()),
                // badges
                if (isNew)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _badge('NEW'.tr(), Colors.green.shade700),
                  ),
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _badge('$discountPercentage%', Colors.red.shade700),
                  ),
              ],
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${price.toStringAsFixed(2).tr()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label.tr(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = getImageUrl(imageUrl);
    if (url.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(Icons.image, size: 48, color: Colors.grey.shade400),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              value:
                  progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          (progress.expectedTotalBytes ?? 1)
                      : null,
              strokeWidth: 2.5,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: Icon(
            Icons.broken_image,
            size: 48,
            color: Colors.grey.shade400,
          ),
        );
      },
    );
  }
}
