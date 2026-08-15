import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'ImageHelper.dart';

class SubCategoryCircleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final double width;
  final String imageUrl;

  const SubCategoryCircleWidget({
    super.key,
    required this.title,
    this.onTap,
    required this.width,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6B2D5C);

    final double circleSize = 55.0;
    final double titleHeight = 36.0;
    final double totalHeight = circleSize + 6 + titleHeight;

    return SizedBox(
      width: width,
      height: totalHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(circleSize / 2),
            child: ClipOval(
              child: SizedBox(
                width: circleSize,
                height: circleSize,
                child: _buildImage(circleSize),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: titleHeight,
            child: Text(
              title.tr(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(double size) {
    final url = getImageUrl(imageUrl);
    if (url.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: Icon(
          Icons.image,
          size: size * 0.45,
          color: Colors.grey.shade400,
        ),
      );
    }

    return Image.network(
      url,
      fit: BoxFit.cover,
      width: size,
      height: size,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: SizedBox(
            width: size * 0.35,
            height: size * 0.35,
            child: CircularProgressIndicator(
              value:
                  progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          (progress.expectedTotalBytes ?? 1)
                      : null,
              strokeWidth: 2.0,
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
            size: size * 0.45,
            color: Colors.grey.shade400,
          ),
        );
      },
    );
  }
}
