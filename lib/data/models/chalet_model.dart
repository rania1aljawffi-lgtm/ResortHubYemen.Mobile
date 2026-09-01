/// Chalet model matching backend ChaletDto contract exactly.
class ChaletModel {
  final int chaletId;
  final String chaletName;
  final String location;
  final double pricePerNight;
  final int capacity;
  final String description;

  const ChaletModel({
    required this.chaletId,
    required this.chaletName,
    required this.location,
    required this.pricePerNight,
    required this.capacity,
    required this.description,
  });

  factory ChaletModel.fromJson(Map<String, dynamic> json) {
    return ChaletModel(
      chaletId: json['chaletId'] is int
          ? json['chaletId'] as int
          : int.tryParse(json['chaletId']?.toString() ?? '0') ?? 0,
      chaletName: json['chaletName'] as String? ?? '',
      location: json['location'] as String? ?? '',
      pricePerNight: (json['pricePerNight'] is num)
          ? (json['pricePerNight'] as num).toDouble()
          : double.tryParse(json['pricePerNight']?.toString() ?? '0') ?? 0.0,
      capacity: json['capacity'] is int
          ? json['capacity'] as int
          : int.tryParse(json['capacity']?.toString() ?? '0') ?? 0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chaletId': chaletId,
      'chaletName': chaletName,
      'location': location,
      'pricePerNight': pricePerNight,
      'capacity': capacity,
      'description': description,
    };
  }

  ChaletModel copyWith({
    int? chaletId,
    String? chaletName,
    String? location,
    double? pricePerNight,
    int? capacity,
    String? description,
  }) {
    return ChaletModel(
      chaletId: chaletId ?? this.chaletId,
      chaletName: chaletName ?? this.chaletName,
      location: location ?? this.location,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      capacity: capacity ?? this.capacity,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChaletModel &&
          runtimeType == other.runtimeType &&
          chaletId == other.chaletId &&
          chaletName == other.chaletName &&
          location == other.location &&
          pricePerNight == other.pricePerNight &&
          capacity == other.capacity &&
          description == other.description;

  @override
  int get hashCode => Object.hash(
        chaletId,
        chaletName,
        location,
        pricePerNight,
        capacity,
        description,
      );
}
