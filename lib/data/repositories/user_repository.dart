import '../../core/errors/app_exception.dart';
import '../../core/utils/result.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

abstract class IUserRepository {
  Future<Result<List<UserModel>>> getUsers();
  Future<Result<UserModel>> getUserById(int id);
  Future<Result<UserModel>> createUser(UserModel user);
  Future<Result<UserModel>> updateUser(int id, UserModel user);
  Future<Result<void>> deleteUser(int id);
}

class UserRepository implements IUserRepository {
  final IUserService _userService;

  UserRepository({IUserService? userService})
      : _userService = userService ?? UserService();

  @override
  Future<Result<List<UserModel>>> getUsers() async {
    try {
      final users = await _userService.getAll();
      return Success(users);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch users: $e'));
    }
  }

  @override
  Future<Result<UserModel>> getUserById(int id) async {
    try {
      final user = await _userService.getById(id);
      return Success(user);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch user $id: $e'));
    }
  }

  @override
  Future<Result<UserModel>> createUser(UserModel user) async {
    try {
      final created = await _userService.create(user);
      return Success(created);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to create user: $e'));
    }
  }

  @override
  Future<Result<UserModel>> updateUser(int id, UserModel user) async {
    try {
      final updated = await _userService.update(id, user);
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to update user: $e'));
    }
  }

  @override
  Future<Result<void>> deleteUser(int id) async {
    try {
      await _userService.delete(id);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to delete user: $e'));
    }
  }
}
