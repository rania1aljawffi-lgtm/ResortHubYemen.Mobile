import 'package:flutter/foundation.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final IUserRepository _userRepository;

  AuthViewModel({IUserRepository? userRepository})
      : _userRepository = userRepository ?? UserRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  AppException? _error;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && _currentUser!.fullName.isNotEmpty;
  bool get isLoading => _isLoading;
  AppException? get error => _error;
  bool get hasError => _error != null;

  void setUserData({required String fullName, required String email, String? phone}) {
    _currentUser = UserModel(
      userId: (_currentUser != null && _currentUser!.userId > 0) ? _currentUser!.userId : 1,
      fullName: fullName.trim().isNotEmpty ? fullName.trim() : 'مستخدم جديد',
      email: email.trim().isNotEmpty ? email.trim() : '',
      phoneNumber: phone?.trim().isNotEmpty == true ? phone!.trim() : '',
      role: 'User',
    );
    _error = null;
    notifyListeners();
  }

  Future<bool> login(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _userRepository.getUsers();
    var success = false;
    result.when(
      success: (users) {
        try {
          final user = users.firstWhere((u) => u.email.toLowerCase() == email.toLowerCase());
          _currentUser = user;
          _error = null;
          success = true;
        } catch (e) {
          _error = ServerException('البريد الإلكتروني غير موجود');
        }
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> register(UserModel user) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _userRepository.createUser(user);
    var success = false;
    result.when(
      success: (created) {
        _currentUser = created;
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

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }
}
