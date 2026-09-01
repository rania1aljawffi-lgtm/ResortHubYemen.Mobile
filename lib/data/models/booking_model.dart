import '../../core/utils/date_formatter.dart';

/// Booking model matching backend BookingDto contract exactly.
class BookingModel {
  final int bookingId;
  final int userId;
  final int chaletId;
  final String description;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final double totalPrice;
  final String status;
  final String chaletName;

  const BookingModel({
    required this.bookingId,
    required this.userId,
    required this.chaletId,
    this.description = '',
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.totalPrice,
    required this.status,
    this.chaletName = '',
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'] is int
          ? json['bookingId'] as int
          : int.tryParse(json['bookingId']?.toString() ?? '0') ?? 0,
      userId: json['userId'] is int
          ? json['userId'] as int
          : int.tryParse(json['userId']?.toString() ?? '0') ?? 0,
      chaletId: json['chaletId'] is int
          ? json['chaletId'] as int
          : int.tryParse(json['chaletId']?.toString() ?? '0') ?? 0,
      description: json['description'] as String? ?? '',
      checkInDate: DateFormatter.parseDateTimeSafe(json['checkInDate']),
      checkOutDate: DateFormatter.parseDateTimeSafe(json['checkOutDate']),
      guests: json['guests'] is int
          ? json['guests'] as int
          : int.tryParse(json['guests']?.toString() ?? '1') ?? 1,
      totalPrice: (json['totalPrice'] is num)
          ? (json['totalPrice'] as num).toDouble()
          : double.tryParse(json['totalPrice']?.toString() ?? '0') ?? 0.0,
      status: json['status'] as String? ?? 'Pending',
      chaletName: json['chaletName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'chaletId': chaletId,
      'description': description,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status,
      'chaletName': chaletName,
    };
  }

  BookingModel copyWith({
    int? bookingId,
    int? userId,
    int? chaletId,
    String? description,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? guests,
    double? totalPrice,
    String? status,
    String? chaletName,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      chaletId: chaletId ?? this.chaletId,
      description: description ?? this.description,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      guests: guests ?? this.guests,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      chaletName: chaletName ?? this.chaletName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModel &&
          runtimeType == other.runtimeType &&
          bookingId == other.bookingId &&
          userId == other.userId &&
          chaletId == other.chaletId &&
          description == other.description &&
          checkInDate == other.checkInDate &&
          checkOutDate == other.checkOutDate &&
          guests == other.guests &&
          totalPrice == other.totalPrice &&
          status == other.status &&
          chaletName == other.chaletName;

  @override
  int get hashCode => Object.hash(
        bookingId,
        userId,
        chaletId,
        description,
        checkInDate,
        checkOutDate,
        guests,
        totalPrice,
        status,
        chaletName,
      );
}