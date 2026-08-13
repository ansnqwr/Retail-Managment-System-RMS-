import 'package:delni_rms/features/stores/model/BranchModel.dart';

class RatingSummary {
  final double averageRating;
  final int totalCount;
  final Map<int, int> starsBreakdown;

  const RatingSummary({
    required this.averageRating,
    required this.totalCount,
    required this.starsBreakdown,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    final breakdown = json['starsBreakdown'] as Map<String, dynamic>? ?? {};

    final Map<int, int> starsMap = {};

    breakdown.forEach((key, value) {
      final star = int.tryParse(key);

      if (star != null) {
        starsMap[star] = (value as num?)?.toInt() ?? 0;
      }
    });

    return RatingSummary(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      starsBreakdown: starsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalCount': totalCount,
      'starsBreakdown': starsBreakdown.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    };
  }
}

class Review {
  final int id;
  final String userName;
  final int rating;
  final String comment;
  final String createdAt;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userName: json['userName'] as String? ?? 'Anonymous',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}

class StoreProfileModel {
  final String mainGovernorate;
  final String mainCity;
  final List<StoreBranchModel> branches;
  final RatingSummary? ratingSummary;
  final List<Review>? reviews;

  const StoreProfileModel({
    required this.mainGovernorate,
    required this.mainCity,
    required this.branches,
    this.ratingSummary,
    this.reviews,
  });

  factory StoreProfileModel.fromJson(Map<String, dynamic> json) {
    final mainBranch = json['mainBranch'] as Map<String, dynamic>?;

    final branchesList = json['branches'] as List? ?? [];

    final branches =
        branchesList
            .whereType<Map<String, dynamic>>()
            .map(StoreBranchModel.fromJson)
            .toList();

    RatingSummary? ratingSummary;

    if (json['ratingSummary'] is Map<String, dynamic>) {
      ratingSummary = RatingSummary.fromJson(
        json['ratingSummary'] as Map<String, dynamic>,
      );
    }

    List<Review>? reviews;

    if (json['reviews'] is List) {
      reviews =
          (json['reviews'] as List)
              .whereType<Map<String, dynamic>>()
              .map(Review.fromJson)
              .toList();
    }

    return StoreProfileModel(
      mainGovernorate: mainBranch?['governorate'] as String? ?? '',
      mainCity: mainBranch?['city'] as String? ?? '',
      branches: branches,
      ratingSummary: ratingSummary,
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mainBranch': {'governorate': mainGovernorate, 'city': mainCity},
      'branches': branches.map((branch) => branch.toJson()).toList(),
      'ratingSummary': ratingSummary?.toJson(),
      'reviews': reviews?.map((review) => review.toJson()).toList(),
    };
  }
}
