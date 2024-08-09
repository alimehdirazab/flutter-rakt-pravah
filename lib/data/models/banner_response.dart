// lib/data/models/banner_response.dart

class BannerResponse {
  final int status;
  final List<BannerData> data; // Change to a list of BannerData

  BannerResponse({
    required this.status,
    required this.data,
  });

  // Factory constructor to create an instance from JSON
  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    return BannerResponse(
      status: json['status'],
      // Map each item in the data list to a BannerData instance
      data: (json['data'] as List<dynamic>)
          .map((item) => BannerData.fromJson(item))
          .toList(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((banner) => banner.toJson()).toList(),
    };
  }
}

// BannerData class to represent each banner object
class BannerData {
  final int id;
  final String title;
  final String image;

  BannerData({
    required this.id,
    required this.title,
    required this.image,
  });

  // Factory constructor to create a BannerData instance from JSON
  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      id: json['id'],
      title: json['title'],
      image: json['image'],
    );
  }

  // Method to convert a BannerData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
    };
  }
}
