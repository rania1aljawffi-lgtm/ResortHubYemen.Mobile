import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/review_model.dart';

abstract class IReviewService {
  Future<List<ReviewModel>> getAll();
  Future<ReviewModel> getById(int id);
  Future<ReviewModel> create(ReviewModel review);
  Future<ReviewModel> update(int id, ReviewModel review);
  Future<void> delete(int id);
}

class ReviewService implements IReviewService {
  final ApiClient _apiClient;

  ReviewService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<ReviewModel>> getAll() async {
    final response = await _apiClient.get(ApiConstants.reviewsEndpoint);
    if (response is List) {
      return response
          .map((item) => ReviewModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ReviewModel> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.reviewsEndpoint}/$id');
    return ReviewModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ReviewModel> create(ReviewModel review) async {
    final response = await _apiClient.post(
      ApiConstants.reviewsEndpoint,
      body: review.toJson(),
    );
    return ReviewModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ReviewModel> update(int id, ReviewModel review) async {
    final response = await _apiClient.put(
      '${ApiConstants.reviewsEndpoint}/$id',
      body: review.toJson(),
    );
    return ReviewModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.delete('${ApiConstants.reviewsEndpoint}/$id');
  }
}
