import 'package:flutter/foundation.dart';
import '../../../data/models/chalet_model.dart';
import '../../../data/repositories/chalet_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final IChaletRepository _chaletRepository;

  HomeViewModel({IChaletRepository? chaletRepository})
      : _chaletRepository = chaletRepository ?? ChaletRepository();

  List<ChaletModel> _featuredChalets = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChaletModel> get featuredChalets => _featuredChalets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _chaletRepository.getChalets();
    result.when(
      success: (chalets) {
        // إزالة التكرارات بناءً على chaletId
        final seen = <int>{};
        _featuredChalets = chalets.where((c) => seen.add(c.chaletId)).toList();
        _errorMessage = null;
      },
      failure: (err) {
        _errorMessage = err.message;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
