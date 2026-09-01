import 'package:flutter/foundation.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/models/chalet_model.dart';
import '../../../data/repositories/chalet_repository.dart';

class ChaletViewModel extends ChangeNotifier {
  final IChaletRepository _chaletRepository;

  ChaletViewModel({IChaletRepository? chaletRepository})
      : _chaletRepository = chaletRepository ?? ChaletRepository();

  List<ChaletModel> _chalets = [];
  ChaletModel? _selectedChalet;
  bool _isLoading = false;
  AppException? _error;

  List<ChaletModel> get chalets => _chalets;
  ChaletModel? get selectedChalet => _selectedChalet;
  bool get isLoading => _isLoading;
  AppException? get error => _error;
  bool get hasError => _error != null;

  Future<void> fetchChalets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _chaletRepository.getChalets();

    result.when(
      success: (data) {
        final seen = <int>{};

        final uniqueChalets =
            data.where((c) => seen.add(c.chaletId)).toList();

        // استخدام البيانات الحقيقية القادمة من الـ API
        // بدون تغيير أسماء الشاليهات أو الـ ChaletId.
        _chalets = uniqueChalets;
        _error = null;
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchChaletById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _chaletRepository.getChaletById(id);

    result.when(
      success: (data) {
        _selectedChalet = data;
        _error = null;
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createChalet(ChaletModel chalet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _chaletRepository.createChalet(chalet);

    var success = false;

    result.when(
      success: (created) {
        _chalets.add(created);
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

  Future<bool> deleteChalet(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _chaletRepository.deleteChalet(id);

    var success = false;

    result.when(
      success: (_) {
        _chalets.removeWhere((c) => c.chaletId == id);

        if (_selectedChalet?.chaletId == id) {
          _selectedChalet = null;
        }

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