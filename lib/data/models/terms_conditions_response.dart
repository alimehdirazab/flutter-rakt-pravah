// lib/data/models/terms_conditions_response.dart

class TermsConditionsResponse {
  final int status;
  final List<TermsConditionsData> data;

  TermsConditionsResponse({required this.status, required this.data});

  factory TermsConditionsResponse.fromJson(Map<String, dynamic> json) {
    return TermsConditionsResponse(
      status: json['status'],
      data: (json['data'] as List)
          .map((item) => TermsConditionsData.fromJson(item))
          .toList(),
    );
  }
}

class TermsConditionsData {
  final int id;
  final String title;
  final String description;

  TermsConditionsData({
    required this.id,
    required this.title,
    required this.description,
  });

  factory TermsConditionsData.fromJson(Map<String, dynamic> json) {
    return TermsConditionsData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}
