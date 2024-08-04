class BloodRequestListResponse {
  final bool status;
  final List<BloodRequestList> data;

  BloodRequestListResponse({
    required this.status,
    required this.data,
  });

  // Factory constructor for creating an instance from JSON
  factory BloodRequestListResponse.fromJson(Map<String, dynamic> json) {
    return BloodRequestListResponse(
      status: json['status'] as bool,
      data: (json['data'] as List<dynamic>)
          .map(
              (item) => BloodRequestList.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class BloodRequestList {
  final int? id;
  final int? userId;
  final String? patientFirstName;
  final String? patientLastName;
  final String? attendeeFirstName;
  final String? attendeeLastName;
  final String? attendeeMobile;
  final String? bloodGroup;
  final String? requestType;
  final int? numberOfUnits;
  final String? requiredDate;
  final String? requisitionDoctor;
  final String? locationForDonation;
  final String? hospitalName;
  final String? isCritical;
  final String? isAgree;
  final String? requestStatus;
  final int? acceptedBy;
  final String? createdAt;
  final String? updatedAt;
  final String? token;
  final int? status;

  BloodRequestList({
    required this.id,
    required this.userId,
    required this.patientFirstName,
    required this.patientLastName,
    required this.attendeeFirstName,
    required this.attendeeLastName,
    required this.attendeeMobile,
    required this.bloodGroup,
    required this.requestType,
    required this.numberOfUnits,
    required this.requiredDate,
    required this.requisitionDoctor,
    required this.locationForDonation,
    required this.hospitalName,
    required this.isCritical,
    required this.isAgree,
    required this.requestStatus,
    this.acceptedBy,
    required this.createdAt,
    required this.updatedAt,
    this.token,
    required this.status,
  });

  // Factory constructor for creating an instance from JSON
  factory BloodRequestList.fromJson(Map<String, dynamic> json) {
    return BloodRequestList(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      patientFirstName: json['patient_f_name'] as String?,
      patientLastName: json['patient_l_name'] as String?,
      attendeeFirstName: json['attendee_f_name'] as String?,
      attendeeLastName: json['attendee_l_name'] as String?,
      attendeeMobile: json['attendee_mobile'] as String?,
      bloodGroup: json['blood_group'] as String?,
      requestType: json['request_type'] as String?,
      numberOfUnits: json['no_of_units'] as int?,
      requiredDate: json['required_date'] as String?,
      requisitionDoctor: json['requisition_doctor'] as String?,
      locationForDonation: json['location_for_donation'] as String?,
      hospitalName: json['hospital_name'] as String?,
      isCritical: json['is_critical'] as String?,
      isAgree: json['is_agree'] as String?,
      requestStatus: json['request_status'] as String?,
      acceptedBy: json['accepted_by'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      token: json['_token'] as String?,
      status: json['status'] as int?,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'patient_f_name': patientFirstName,
      'patient_l_name': patientLastName,
      'attendee_f_name': attendeeFirstName,
      'attendee_l_name': attendeeLastName,
      'attendee_mobile': attendeeMobile,
      'blood_group': bloodGroup,
      'request_type': requestType,
      'no_of_units': numberOfUnits,
      'required_date': requiredDate,
      'requisition_doctor': requisitionDoctor,
      'location_for_donation': locationForDonation,
      'hospital_name': hospitalName,
      'is_critical': isCritical,
      'is_agree': isAgree,
      'request_status': requestStatus,
      'accepted_by': acceptedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      '_token': token,
      'status': status,
    };
  }
}
