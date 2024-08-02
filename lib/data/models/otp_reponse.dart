import 'dart:convert';

class OtpResponse {
  final String? message;
  final Map<String, List<String>>? errorMessages;

  OtpResponse({
    this.message,
    this.errorMessages,
  });

  // Factory constructor to create an instance from JSON
  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    if (json['message'] is String) {
      // When message is a String
      return OtpResponse(
        message: json['message'] as String?,
      );
    } else if (json['message'] is Map<String, dynamic>) {
      // When message is a Map with errors
      final errorMap = json['message'] as Map<String, dynamic>;
      final errorMessages = <String, List<String>>{};

      errorMap.forEach((key, value) {
        if (value is List) {
          errorMessages[key] = value.map((e) => e.toString()).toList();
        }
      });

      return OtpResponse(
        errorMessages: errorMessages,
      );
    } else {
      return OtpResponse();
    }
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (message != null) {
      json['message'] = message;
    }

    if (errorMessages != null) {
      json['message'] = errorMessages;
    }

    return json;
  }
}
