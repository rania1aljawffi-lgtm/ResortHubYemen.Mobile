import '../../core/errors/app_exception.dart';
import '../../core/utils/result.dart';
import '../models/image_model.dart';
import '../services/image_service.dart';

abstract class IImageRepository {
  Future<Result<List<ImageModel>>> getImages();
  Future<Result<ImageModel>> getImageById(int id);
  Future<Result<ImageModel>> createImage(ImageModel image);
  Future<Result<ImageModel>> updateImage(int id, ImageModel image);
  Future<Result<void>> deleteImage(int id);
}

class ImageRepository implements IImageRepository {
  final IImageService _imageService;

  ImageRepository({IImageService? imageService})
      : _imageService = imageService ?? ImageService();

  @override
  Future<Result<List<ImageModel>>> getImages() async {
    try {
      final images = await _imageService.getAll();
      return Success(images);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch images: $e'));
    }
  }

  @override
  Future<Result<ImageModel>> getImageById(int id) async {
    try {
      final image = await _imageService.getById(id);
      return Success(image);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch image $id: $e'));
    }
  }

  @override
  Future<Result<ImageModel>> createImage(ImageModel image) async {
    try {
      final created = await _imageService.create(image);
      return Success(created);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to create image: $e'));
    }
  }

  @override
  Future<Result<ImageModel>> updateImage(int id, ImageModel image) async {
    try {
      final updated = await _imageService.update(id, image);
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to update image: $e'));
    }
  }

  @override
  Future<Result<void>> deleteImage(int id) async {
    try {
      await _imageService.delete(id);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to delete image: $e'));
    }
  }
}
