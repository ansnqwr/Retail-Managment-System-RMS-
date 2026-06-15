import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String governorate;
  final String city;
  final bool isNew;
  final bool isVerified;
  final bool isBrand;
  final VoidCallback? onTap;
  final double width;

  const StoreCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.isNew,
    this.onTap,
    this.width = 160,
    required this.governorate,
    required this.city,
    required this.isVerified,
    required this.isBrand,
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
                    child: _badge('NEW', Colors.green.shade700),
                  ),
                if (isVerified && !isBrand)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.verified, color: Colors.cyanAccent),
                  ),
                if (isVerified && isBrand)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.verified, color: Colors.amberAccent),
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
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      maxLines: 1,
                      governorate,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      maxLines: 1,
                      city,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: primaryColor,
                      ),
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
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImage() {
    final url = imageUrl.trim();
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
