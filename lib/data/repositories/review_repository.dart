import '../../core/errors/app_exception.dart';
import '../../core/utils/result.dart';
import '../models/review_model.dart';
import '../services/review_service.dart';

abstract class IReviewRepository {
  Future<Result<List<ReviewModel>>> getReviews();
  Future<Result<ReviewModel>> getReviewById(int id);
  Future<Result<ReviewModel>> createReview(ReviewModel review);
  Future<Result<ReviewModel>> updateReview(int id, ReviewModel review);
  Future<Result<void>> deleteReview(int id);
}

class ReviewRepository implements IReviewRepository {
  final IReviewService _reviewService;

  ReviewRepository({IReviewService? reviewService})
      : _reviewService = reviewService ?? ReviewService();

  @override
  Future<Result<List<ReviewModel>>> getReviews() async {
    try {
      final reviews = await _reviewService.getAll();
      return Success(reviews);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch reviews: $e'));
    }
  }

  @override
  Future<Result<ReviewModel>> getReviewById(int id) async {
    try {
      final review = await _reviewService.getById(id);
      return Success(review);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch review $id: $e'));
    }
  }

  @override
  Future<Result<ReviewModel>> createReview(ReviewModel review) async {
    try {
      final created = await _reviewService.create(review);
      return Success(created);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to create review: $e'));
    }
  }

  @override
  Future<Result<ReviewModel>> updateReview(int id, ReviewModel review) async {
    try {
      final updated = await _reviewService.update(id, review);
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to update review: $e'));
    }
  }

  @override
  Future<Result<void>> deleteReview(int id) async {
    try {
      await _reviewService.delete(id);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to delete review: $e'));
    }
  }
}
