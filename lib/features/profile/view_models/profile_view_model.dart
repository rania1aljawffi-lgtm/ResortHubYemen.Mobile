import 'package:flutter/foundation.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final IUserRepository _userRepository;

  ProfileViewModel({IUserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  UserModel? _user;
  bool _isLoading = false;
  AppException? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  AppException? get error => _error;
  bool get hasError => _error != null;

  Future<void> loadProfile(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _userRepository.getUserById(userId);
    result.when(
      success: (data) {
        _user = data;
        _error = null;
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _userRepository.updateUser(updatedUser.userId, updatedUser);
    var success = false;
    result.when(
      success: (data) {
        _user = data;
        _error = null;
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
