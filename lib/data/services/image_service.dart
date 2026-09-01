import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/image_model.dart';

abstract class IImageService {
  Future<List<ImageModel>> getAll();
  Future<ImageModel> getById(int id);
  Future<ImageModel> create(ImageModel image);
  Future<ImageModel> update(int id, ImageModel image);
  Future<void> delete(int id);
}

class ImageService implements IImageService {
  final ApiClient _apiClient;

  ImageService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<ImageModel>> getAll() async {
    final response = await _apiClient.get(ApiConstants.imagesEndpoint);
    if (response is List) {
      return response
          .map((item) => ImageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ImageModel> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.imagesEndpoint}/$id');
    return ImageModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ImageModel> create(ImageModel image) async {
    final response = await _apiClient.post(
      ApiConstants.imagesEndpoint,
      body: image.toJson(),
    );
    return ImageModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ImageModel> update(int id, ImageModel image) async {
    final response = await _apiClient.put(
      '${ApiConstants.imagesEndpoint}/$id',
      body: image.toJson(),
    );
    return ImageModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.delete('${ApiConstants.imagesEndpoint}/$id');
  }
}
