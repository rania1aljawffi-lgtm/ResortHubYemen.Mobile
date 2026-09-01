import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/chalet_model.dart';

abstract class IChaletService {
  Future<List<ChaletModel>> getAll();
  Future<ChaletModel> getById(int id);
  Future<ChaletModel> create(ChaletModel chalet);
  Future<ChaletModel> update(int id, ChaletModel chalet);
  Future<void> delete(int id);
}

class ChaletService implements IChaletService {
  final ApiClient _apiClient;

  ChaletService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<ChaletModel>> getAll() async {
    final response = await _apiClient.get(ApiConstants.chaletsEndpoint);
    if (response is List) {
      return response
          .map((item) => ChaletModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ChaletModel> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.chaletsEndpoint}/$id');
    return ChaletModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ChaletModel> create(ChaletModel chalet) async {
    final response = await _apiClient.post(
      ApiConstants.chaletsEndpoint,
      body: chalet.toJson(),
    );
    return ChaletModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<ChaletModel> update(int id, ChaletModel chalet) async {
    final response = await _apiClient.put(
      '${ApiConstants.chaletsEndpoint}/$id',
      body: chalet.toJson(),
    );
    return ChaletModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.delete('${ApiConstants.chaletsEndpoint}/$id');
  }
}
