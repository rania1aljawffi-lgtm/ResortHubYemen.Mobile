import '../../core/utils/date_formatter.dart';

/// Review model matching backend ReviewDto contract exactly.
class ReviewModel {
  final int reviewId;
  final int userId;
  final int chaletId;
  final int rating;
  final String comment;
  final DateTime reviewDate;

  const ReviewModel({
    required this.reviewId,
    required this.userId,
    required this.chaletId,
    required this.rating,
    required this.comment,
    required this.reviewDate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewId: json['reviewId'] is int
          ? json['reviewId'] as int
          : int.tryParse(json['reviewId']?.toString() ?? '0') ?? 0,
      userId: json['userId'] is int
          ? json['userId'] as int
          : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      chaletId: json['chaletId'] is int
          ? json['chaletId'] as int
          : int.tryParse(json['chaletId']?.toString() ?? '0') ?? 0,
      rating: json['rating'] is int
          ? json['rating'] as int
          : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      comment: json['comment'] as String? ?? '',
      reviewDate: DateFormatter.parseDateTimeSafe(json['reviewDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'userId': userId,
      'chaletId': chaletId,
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    int? reviewId,
    int? userId,
    int? chaletId,
    int? rating,
    String? comment,
    DateTime? reviewDate,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      userId: userId ?? this.userId,
      chaletId: chaletId ?? this.chaletId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      reviewDate: reviewDate ?? this.reviewDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewModel &&
          runtimeType == other.runtimeType &&
          reviewId == other.reviewId &&
          userId == other.userId &&
          chaletId == other.chaletId &&
          rating == other.rating &&
          comment == other.comment &&
          reviewDate == other.reviewDate;

  @override
  int get hashCode => Object.hash(
        reviewId,
        userId,
        chaletId,
        rating,
        comment,
        reviewDate,
      );
}
