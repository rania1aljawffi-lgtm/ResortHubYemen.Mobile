import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/booking_model.dart';

abstract class IBookingService {
  Future<List<BookingModel>> getAll();
  Future<BookingModel> getById(int id);
  Future<BookingModel> create(BookingModel booking);
  Future<BookingModel> update(int id, BookingModel booking);
  Future<void> delete(int id);
}

class BookingService implements IBookingService {
  final ApiClient _apiClient;

  BookingService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  @override
  Future<List<BookingModel>> getAll() async {
    final response = await _apiClient.get(ApiConstants.bookingsEndpoint);
    if (response is List) {
      return response
          .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<BookingModel> getById(int id) async {
    final response = await _apiClient.get('${ApiConstants.bookingsEndpoint}/$id');
    return BookingModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BookingModel> create(BookingModel booking) async {
    final response = await _apiClient.post(
      ApiConstants.bookingsEndpoint,
      body: booking.toJson(),
    );
    return BookingModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<BookingModel> update(int id, BookingModel booking) async {
    final response = await _apiClient.put(
      '${ApiConstants.bookingsEndpoint}/$id',
      body: booking.toJson(),
    );
    return BookingModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.delete('${ApiConstants.bookingsEndpoint}/$id');
  }
}
