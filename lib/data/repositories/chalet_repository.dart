import '../../core/errors/app_exception.dart';
import '../../core/utils/result.dart';
import '../models/chalet_model.dart';
import '../services/chalet_service.dart';

abstract class IChaletRepository {
  Future<Result<List<ChaletModel>>> getChalets();
  Future<Result<ChaletModel>> getChaletById(int id);
  Future<Result<ChaletModel>> createChalet(ChaletModel chalet);
  Future<Result<ChaletModel>> updateChalet(int id, ChaletModel chalet);
  Future<Result<void>> deleteChalet(int id);
}

class ChaletRepository implements IChaletRepository {
  final IChaletService _chaletService;

  ChaletRepository({IChaletService? chaletService})
      : _chaletService = chaletService ?? ChaletService();

  @override
  Future<Result<List<ChaletModel>>> getChalets() async {
    try {
      final chalets = await _chaletService.getAll();
      return Success(chalets);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch chalets: $e'));
    }
  }

  @override
  Future<Result<ChaletModel>> getChaletById(int id) async {
    try {
      final chalet = await _chaletService.getById(id);
      return Success(chalet);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch chalet $id: $e'));
    }
  }

  @override
  Future<Result<ChaletModel>> createChalet(ChaletModel chalet) async {
    try {
      final created = await _chaletService.create(chalet);
      return Success(created);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to create chalet: $e'));
    }
  }

  @override
  Future<Result<ChaletModel>> updateChalet(int id, ChaletModel chalet) async {
    try {
      final updated = await _chaletService.update(id, chalet);
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to update chalet: $e'));
    }
  }

  @override
  Future<Result<void>> deleteChalet(int id) async {
    try {
      await _chaletService.delete(id);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to delete chalet: $e'));
    }
  }
}
