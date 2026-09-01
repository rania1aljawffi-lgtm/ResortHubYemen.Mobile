import '../../core/errors/app_exception.dart';
import '../../core/utils/result.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

abstract class IBookingRepository {
  Future<Result<List<BookingModel>>> getBookings();
  Future<Result<BookingModel>> getBookingById(int id);
  Future<Result<BookingModel>> createBooking(BookingModel booking);
  Future<Result<BookingModel>> updateBooking(int id, BookingModel booking);
  Future<Result<void>> deleteBooking(int id);
}

class BookingRepository implements IBookingRepository {
  final IBookingService _bookingService;

  BookingRepository({IBookingService? bookingService})
      : _bookingService = bookingService ?? BookingService();

  @override
  Future<Result<List<BookingModel>>> getBookings() async {
    try {
      final bookings = await _bookingService.getAll();
      return Success(bookings);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch bookings: $e'));
    }
  }

  @override
  Future<Result<BookingModel>> getBookingById(int id) async {
    try {
      final booking = await _bookingService.getById(id);
      return Success(booking);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to fetch booking $id: $e'));
    }
  }

  @override
  Future<Result<BookingModel>> createBooking(BookingModel booking) async {
    try {
      final created = await _bookingService.create(booking);
      return Success(created);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to create booking: $e'));
    }
  }

  @override
  Future<Result<BookingModel>> updateBooking(int id, BookingModel booking) async {
    try {
      final updated = await _bookingService.update(id, booking);
      return Success(updated);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to update booking: $e'));
    }
  }

  @override
  Future<Result<void>> deleteBooking(int id) async {
    try {
      await _bookingService.delete(id);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(ServerException('Failed to delete booking: $e'));
    }
  }
}
