import 'dart:convert';

// VerifyOtpResponse class
class VerifyOtpResponse {
  final String? message;
  final String? token;
  final UserData? data;

  VerifyOtpResponse({this.message, this.token, this.data});

  // Factory constructor to create an instance from JSON
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      message: json['message'] as String?,
      token: json['token'] as String?,
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (message != null) {
      json['message'] = message;
    }
    if (token != null) {
      json['token'] = token;
    }
    if (data != null) {
      json['data'] = data!.toJson();
    }

    return json;
  }
}

// UserData class to represent the user data part of the response
class UserData {
  final int? id;
  final String? uniqueId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? otp;
  final DateTime? expiresAt;
  final DateTime? emailVerifiedAt;
  final String? dob;
  final String? image;
  final String? bloodGroup;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? tattoo;
  final bool? isHivPositive;
  final int? registrationStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastDate;

  UserData({
    this.id,
    this.uniqueId,
    this.name,
    this.email,
    this.mobile,
    this.otp,
    this.expiresAt,
    this.emailVerifiedAt,
    this.dob,
    this.image,
    this.bloodGroup,
    this.location,
    this.latitude,
    this.longitude,
    this.tattoo,
    this.isHivPositive,
    this.registrationStatus,
    this.createdAt,
    this.updatedAt,
    this.lastDate,
  });

  // Factory constructor to create a UserData instance from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int?,
      uniqueId: json['unique_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      otp: json['otp'] as String?,
      expiresAt: _parseDateTime(json['expires_at']),
      emailVerifiedAt: _parseDateTime(json['email_verified_at']),
      dob: json['dob'] as String?,
      image: json['image'] as String?,
      bloodGroup: json['blood_group'] as String?,
      location: json['location'] as String?,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      tattoo: json['tattoo'] as String?,
      isHivPositive: _parseBool(json['is_hiv_positive']),
      registrationStatus: json['registration_status'] as int?,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      lastDate: _parseDateTime(json['last_date']),
    );
  }

  // Method to convert a UserData instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'otp': otp,
      'expires_at': expiresAt?.toIso8601String(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'dob': dob,
      'image': image,
      'blood_group': bloodGroup,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'tattoo': tattoo,
      'is_hiv_positive': isHivPositive,
      'registration_status': registrationStatus,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'last_date': lastDate?.toIso8601String(),
    };
  }

  // Helper method to parse DateTime from JSON string
  static DateTime? _parseDateTime(String? dateTimeString) {
    return dateTimeString != null ? DateTime.tryParse(dateTimeString) : null;
  }

  // Helper method to parse double from JSON
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // Helper method to parse boolean from JSON
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return null;
  }
}
