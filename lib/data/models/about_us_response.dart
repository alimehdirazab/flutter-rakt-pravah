import 'dart:convert';

class AboutUsResponse {
  final AboutUsData data;

  AboutUsResponse({required this.data});

  factory AboutUsResponse.fromJson(Map<String, dynamic> json) {
    return AboutUsResponse(
      data: AboutUsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class AboutUsData {
  final int id;
  final String title;
  final String description;
  final String image;

  AboutUsData({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory AboutUsData.fromJson(Map<String, dynamic> json) {
    return AboutUsData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image': image,
      };
}
