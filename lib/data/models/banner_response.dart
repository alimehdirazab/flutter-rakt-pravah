// lib/data/models/banner_response.dart

class BannerResponse {
  final int status;
  final BannerData data;

  BannerResponse({
    required this.status,
    required this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      status: json['status'],
      data: BannerData.fromJson(json['data']),
    );
  }
}

class BannerData {
  final int id;
  final String title;
  final String image;

  BannerData({
    required this.id,
    required this.title,
    required this.image,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }
}
