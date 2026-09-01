/// Image model matching backend ImageDto contract exactly.
class ImageModel {
  final int imageId;
  final int chaletId;
  final String imageUrl;
  final String caption;

  const ImageModel({
    required this.imageId,
    required this.chaletId,
    required this.imageUrl,
    required this.caption,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageId: json['imageId'] is int
          ? json['imageId'] as int
          : int.tryParse(json['imageId']?.toString() ?? '0') ?? 0,
      chaletId: json['chaletId'] is int
          ? json['chaletId'] as int
          : int.tryParse(json['chaletId']?.toString() ?? '0') ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageId': imageId,
      'chaletId': chaletId,
      'imageUrl': imageUrl,
      'caption': caption,
    };
  }

  ImageModel copyWith({
    int? imageId,
    int? chaletId,
    String? imageUrl,
    String? caption,
  }) {
    return ImageModel(
      imageId: imageId ?? this.imageId,
      chaletId: chaletId ?? this.chaletId,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageModel &&
          runtimeType == other.runtimeType &&
          imageId == other.imageId &&
          chaletId == other.chaletId &&
          imageUrl == other.imageUrl &&
          caption == other.caption;

  @override
  int get hashCode => Object.hash(imageId, chaletId, imageUrl, caption);
}
