// ignore: file_names
import 'package:delni_rms/features/home/Model/BranchModel.dart';

class RatingSummary {
  final double averageRating;
  final int totalCount;
  final Map<int, int> starsBreakdown;

  RatingSummary({
    required this.averageRating,
    required this.totalCount,
    required this.starsBreakdown,
  });

  factory RatingSummary.fromJson(Map<String, dynamic> json) {
    final breakdown = json['starsBreakdown'] as Map<String, dynamic>?;
    Map<int, int> starsMap = {};
    if (breakdown != null) {
      breakdown.forEach((key, value) {
        starsMap[int.parse(key)] = value as int;
      });
    }

    return RatingSummary(
      averageRating: (json['averageRating'] as num).toDouble(),
      totalCount: json['totalCount'] as int,
      starsBreakdown: starsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'averageRating': averageRating,
      'totalCount': totalCount,
      'starsBreakdown': starsBreakdown,
    };
  }
}

class Review {
  final int id;
  final String userName;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      userName: json['userName'] as String? ?? 'Anonymous',
      rating: json['rating'] as int,
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
  StoreProfileModel({
    required this.mainGovernorate,
    required this.mainCity,
    required this.branches,
    this.ratingSummary,
    this.reviews, // 
  });

  factory StoreProfileModel.fromJson(Map<String, dynamic> json) {

    
    final mainBranch = json['mainBranch'] as Map<String, dynamic>?;

    final branchesList = json['branches'] as List? ?? [];
    final branches = branchesList.map((e) => StoreBranchModel.fromJson(e)).toList();

   RatingSummary? ratingSummary;
    if (json['ratingSummary'] != null) {
      ratingSummary = RatingSummary.fromJson(json['ratingSummary']);
    }

  List<Review>? reviews;
    if (json['reviews'] != null) {
      final reviewsList = json['reviews'] as List;
      reviews = reviewsList.map((e) => Review.fromJson(e)).toList();
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
      'branches': branches.map((e) => e.toJson()).toList(),
      'ratingSummary': ratingSummary?.toJson(), 
      'reviews': reviews?.map((e) => e.toJson()).toList(), 
    };
  }
}
