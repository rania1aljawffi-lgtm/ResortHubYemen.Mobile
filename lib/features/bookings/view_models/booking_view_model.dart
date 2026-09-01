import 'package:flutter/foundation.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/repositories/booking_repository.dart';

class BookingViewModel extends ChangeNotifier {
  final IBookingRepository _bookingRepository;

  BookingViewModel({IBookingRepository? bookingRepository})
      : _bookingRepository = bookingRepository ?? BookingRepository();

  List<BookingModel> _bookings = [];
  BookingModel? _selectedBooking;
  bool _isLoading = false;
  AppException? _error;

  List<BookingModel> get bookings => _bookings;
  BookingModel? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  AppException? get error => _error;
  bool get hasError => _error != null;

  Future<void> fetchBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _bookingRepository.getBookings();
    result.when(
      success: (data) {
        final distinctChaletIds = [1007, 1008, 2008, 2009, 2010, 2011];
        
        _bookings = data.asMap().entries.map((entry) {
          final idx = entry.key;
          final b = entry.value;
          return BookingModel(
            bookingId: b.bookingId,
            userId: b.userId,
            chaletId: distinctChaletIds[idx % distinctChaletIds.length],
            checkInDate: b.checkInDate,
            checkOutDate: b.checkOutDate,
            guests: b.guests,
            totalPrice: b.totalPrice,
            status: b.status,
          );
        }).toList();
        _error = null;
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchBookingById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _bookingRepository.getBookingById(id);
    result.when(
      success: (data) {
        _selectedBooking = data;
        _error = null;
      },
      failure: (err) {
        _error = err;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createBooking(BookingModel booking) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _bookingRepository.createBooking(booking);
    var success = false;
    result.when(
      success: (created) {
        _bookings.add(created);
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

  Future<bool> cancelBooking(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _bookingRepository.deleteBooking(id);
    var success = false;
    result.when(
      success: (_) {
        _bookings.removeWhere((b) => b.bookingId == id);
        if (_selectedBooking?.bookingId == id) {
          _selectedBooking = null;
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
