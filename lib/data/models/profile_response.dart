// profile_response.dart

class ProfileResponse {
  final bool status;
  final String? message;
  final ProfileData? data;

  ProfileResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      message: json['message'],
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class ProfileData {
  final int? id;
  final String? uniqueId;
  final String? name;
  final String? email;
  final String? mobile;
  final String? expiresAt;
  final String? emailVerifiedAt;
  final String? dob;
  final String? bloodGroup;
  final String? location;
  final String? latitude;
  final String? longitude;
  final int? tattoo;
  final int? isHivPositive;
  final String? lastDate;
  final String? image; // Added image field

  ProfileData({
    this.id,
    this.uniqueId,
    this.name,
    this.email,
    this.mobile,
    this.expiresAt,
    this.emailVerifiedAt,
    this.dob,
    this.bloodGroup,
    this.location,
    this.latitude,
    this.longitude,
    this.tattoo,
    this.isHivPositive,
    this.lastDate,
    this.image, // Added image parameter
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      uniqueId: json['unique_id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      expiresAt: json['expires_at'],
      emailVerifiedAt: json['email_verified_at'],
      dob: json['dob'],
      bloodGroup: json['blood_group'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      tattoo: json['tattoo'],
      isHivPositive: json['is_hiv_positive'],
      lastDate: json['last_date'],
      image: json['image'], // Added image field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unique_id': uniqueId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'expires_at': expiresAt,
      'email_verified_at': emailVerifiedAt,
      'dob': dob,
      'blood_group': bloodGroup,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'tattoo': tattoo,
      'is_hiv_positive': isHivPositive,
      'last_date': lastDate,
      'image': image, // Added image field
    };
  }
}
