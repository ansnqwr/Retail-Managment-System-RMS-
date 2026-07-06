// import 'package:flutter/material.dart';

// import '../../features/auth/data/models/Repository/signin_repository.dart';
// import 'ImageHelper.dart';

// class StoreCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String governorate;
//   final String city;
//   final bool isNew;
//   final bool isVerified;
//   final bool isBrand;
//   final VoidCallback? onTap;
//   final double width;
//   final int branchesCount;

//   const StoreCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.isNew,
//     this.onTap,
//     this.width = 160,
//     required this.governorate,
//     required this.city,
//     required this.isVerified,
//     required this.isBrand,
//     required this.branchesCount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = const Color(0xFF6B2D5C);
//     return SizedBox(
//       width: width,
//       child: InkWell(
//         onTap: onTap,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 AspectRatio(aspectRatio: 4 / 3, child: _buildImage()),
//                 // badges
//                 if (isNew)
//                   Positioned(
//                     top: 8,
//                     left: 8,
//                     child: _badge('NEW', Colors.green.shade700),
//                   ),
//                 if (isVerified && !isBrand)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Icon(Icons.verified, color: Colors.cyanAccent),
//                   ),
//                 if (isVerified && isBrand)
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: Icon(Icons.verified, color: Colors.amberAccent),
//                   ),
//               ],
//             ),
//             Container(
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 8,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: primaryColor,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     // Text(
//                     //   maxLines: 1,
//                     //   governorate,
//                     //   style: TextStyle(
//                     //     fontSize: 14,
//                     //     fontWeight: FontWeight.w400,
//                     //     color: primaryColor,
//                     //   ),
//                     // ),
//                     // const SizedBox(height: 2),
//                     // Text(
//                     //   maxLines: 1,
//                     //   city,
//                     //   style: TextStyle(
//                     //     fontSize: 14,
//                     //     fontWeight: FontWeight.w400,
//                     //     color: primaryColor,
//                     //   ),

//                     // ),
//                     // const SizedBox(),
//                     Text(
//                       branchesCount > 1
//                           ? '$governorate, $city (+${branchesCount - 1})'
//                           : '$governorate, $city',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: primaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _badge(String label, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildImage() {
//     final url = getImageUrl(imageUrl);
//     if (url.isEmpty) {
//       return Container(
//         color: Colors.grey.shade200,
//         alignment: Alignment.center,
//         child: Icon(Icons.image, size: 48, color: Colors.grey.shade400),
//       );
//     }

//     return Image.network(
//       url,
//       fit: BoxFit.cover,
//       loadingBuilder: (context, child, progress) {
//         if (progress == null) return child;
//         return Container(
//           color: Colors.grey.shade200,
//           alignment: Alignment.center,
//           child: SizedBox(
//             width: 28,
//             height: 28,
//             child: CircularProgressIndicator(
//               value:
//                   progress.expectedTotalBytes != null
//                       ? progress.cumulativeBytesLoaded /
//                           (progress.expectedTotalBytes ?? 1)
//                       : null,
//               strokeWidth: 2.5,
//             ),
//           ),
//         );
//       },
//       errorBuilder: (context, error, stackTrace) {
//         return Container(
//           color: Colors.grey.shade200,
//           alignment: Alignment.center,
//           child: Icon(
//             Icons.broken_image,
//             size: 48,
//             color: Colors.grey.shade400,
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'ImageHelper.dart';

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
  final int branchesCount;

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
    required this.branchesCount,
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
                if (isNew)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: _badge('NEW', Colors.green.shade700),
                  ),
                if (isVerified)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Icon(
                      Icons.verified,
                      size: 18,
                      color: isBrand ? Colors.amberAccent : Colors.cyanAccent,
                    ),
                  ),
              ],
            ),
            // FIXED: Remove outer Padding, use minimal spacing
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13, // Reduced from 14
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4), // Reduced from 8
                    // Location
                    Wrap(
                      children: [
                        Text(
                          branchesCount > 1
                              ? '$governorate, $city (+${branchesCount - 1})'
                              : '$governorate, $city',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12, // Reduced from 14
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                            height: 1.2,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
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
