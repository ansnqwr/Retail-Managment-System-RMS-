class ProductReviewModel {
  final int id;
  final String userName;
  final double rating;
  final String comment;
  final String createdAt;
  final List<String> images;

  final String? fitTag;

  ProductReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images = const [],
    this.fitTag,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      id: json['id'] ?? 0,
      userName: json['user_name'] ?? json['userName'] ?? 'Anonymous',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? json['createdAt'] ?? '',
      images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
      fitTag: json['fit_tag'],
    );
  }
}

class ProductReviewsResponse {
  final double averageRating;
  final int verifiedBuyers;
  final int totalReviews;
  final List<ProductReviewModel> reviews;
  final bool hasMore;

  ProductReviewsResponse({
    required this.averageRating,
    required this.verifiedBuyers,
    required this.totalReviews,
    required this.reviews,
    this.hasMore = false,
  });

  ProductReviewsResponse copyWith({
    List<ProductReviewModel>? reviews,
    bool? hasMore,
  }) {
    return ProductReviewsResponse(
      averageRating: averageRating,
      verifiedBuyers: verifiedBuyers,
      totalReviews: totalReviews,
      reviews: reviews ?? this.reviews,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  factory ProductReviewsResponse.fromJson(Map<String, dynamic> json) {
    final reviews =
        (json['reviews'] as List? ?? [])
            .map((e) => ProductReviewModel.fromJson(e))
            .toList();
    return ProductReviewsResponse(
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      verifiedBuyers: json['verified_buyers'] ?? 0,
      totalReviews: json['total_reviews'] ?? 0,
      reviews: reviews,
      // Proposed pagination flag for the backend - see API spec.
      hasMore: json['has_more'] ?? false,
    );
  }
}
