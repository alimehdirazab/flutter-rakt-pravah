// profile_response.dart

class ProfileResponse {
  final bool status;
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'],
      message: json['message'],
      data: ProfileData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ProfileData {
  final int id;
  final String uniqueId;
  final String name;
  final String email;
  final String mobile;
  final String? emailVerifiedAt;
  final DateTime dob;
  final String bloodGroup;
  final String location;
  final String tattoo;
  final String isHivPositive;
  final String lastDate;

  ProfileData({
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.email,
    required this.mobile,
    this.emailVerifiedAt,
    required this.dob,
    required this.bloodGroup,
    required this.location,
    required this.tattoo,
    required this.isHivPositive,
    required this.lastDate,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      uniqueId: json['unique_id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      emailVerifiedAt: json['email_verified_at'],
      dob: DateTime.parse(json['dob']),
      bloodGroup: json['blood_group'],
      location: json['location'],
      tattoo: json['tattoo'],
      isHivPositive: json['is_hiv_positive'],
      lastDate: json['last_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'email_verified_at': emailVerifiedAt,
      'dob': dob.toIso8601String(),
      'blood_group': bloodGroup,
      'location': location,
      'tattoo': tattoo,
      'is_hiv_positive': isHivPositive,
      'last_date': lastDate,
    };
  }
}
