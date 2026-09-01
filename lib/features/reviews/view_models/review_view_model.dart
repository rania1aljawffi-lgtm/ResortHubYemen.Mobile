import 'package:flutter/foundation.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/review_repository.dart';

class ReviewViewModel extends ChangeNotifier {
  final IReviewRepository _reviewRepository;

  ReviewViewModel({IReviewRepository? reviewRepository})
      : _reviewRepository = reviewRepository ?? ReviewRepository();

  List<ReviewModel> _reviews = [];
  bool _isLoading = false;
  AppException? _error;

  List<ReviewModel> get reviews => _reviews;
  bool get isLoading => _isLoading;
  AppException? get error => _error;
  bool get hasError => _error != null;

  Future<void> fetchReviews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _reviewRepository.getReviews();
    result.when(
      success: (data) {
        _reviews = data;
        _error = null;
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addReview(ReviewModel review) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _reviewRepository.createReview(review);
    var success = false;
    result.when(
      success: (created) {
        _reviews.add(created);
        success = true;
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
