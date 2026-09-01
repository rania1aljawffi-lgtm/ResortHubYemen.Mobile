import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class IUserService {
  Future<List<UserModel>> getAll();
  Future<UserModel> getById(int id);
  Future<UserModel> create(UserModel user);
  Future<UserModel> update(int id, UserModel user);
  Future<void> delete(int id);
}

class UserService implements IUserService {
  final ApiClient _apiClient;

  UserService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<UserModel>> getAll() async {
    final response = await _apiClient.get(ApiConstants.usersEndpoint);
    if (response is List) {
      return response
          .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<UserModel> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.usersEndpoint}/$id');
    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UserModel> create(UserModel user) async {
    final response = await _apiClient.post(
      ApiConstants.usersEndpoint,
      body: user.toJson(),
    );
    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UserModel> update(int id, UserModel user) async {
    final response = await _apiClient.put(
      '${ApiConstants.usersEndpoint}/$id',
      body: user.toJson(),
    );
    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.delete('${ApiConstants.usersEndpoint}/$id');
  }
}
