import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'ImageHelper.dart';

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool? isExpanded;
  final VoidCallback? onTap;
  final double width;
  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.isExpanded,
    this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);
    return Container(
      width: width,
      height: 70,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: AspectRatio(aspectRatio: 4 / 3, child: _buildImage()),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Text(
                    title.tr(),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    isExpanded == true
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 25,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
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
