import 'dart:convert';

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
  final String? dob;
  final String? bloodGroup;
  final String? location;
  final String? tattoo;
  final String? isHivPositive;
  final int? registrationStatus;

  UserData({
    this.id,
    this.uniqueId,
    this.name,
    this.email,
    this.mobile,
    this.dob,
    this.bloodGroup,
    this.location,
    this.tattoo,
    this.isHivPositive,
    this.registrationStatus,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int?,
      uniqueId: json['unique_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      dob: json['dob'] as String?,
      bloodGroup: json['blood_group'] as String?,
      location: json['location'] as String?,
      tattoo: json['tattoo'] as String?,
      isHivPositive: json['is_hiv_positive'] as String?,
      registrationStatus: json['registration_status'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'blood_group': bloodGroup,
      'location': location,
      'tattoo': tattoo,
      'is_hiv_positive': isHivPositive,
      'registration_status': registrationStatus,
    };
  }
}
