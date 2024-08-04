class BloodRequest {
  final String patientName;
  final String attendeeMobile;
  final String bloodType;
  final String bloodGroup;
  final String units;
  final DateTime date;
  final String location;
  final bool isCritical;
  final String additionalNote;

  BloodRequest({
    required this.patientName,
    required this.attendeeMobile,
    required this.bloodType,
    required this.bloodGroup,
    required this.units,
    required this.date,
    required this.location,
    required this.isCritical,
    required this.additionalNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'attendeeMobile': attendeeMobile,
      'bloodType': bloodType,
      'bloodGroup': bloodGroup,
      'units': units,
      'date': date.toIso8601String(),
      'location': location,
      'isCritical': isCritical,
      'additionalNote': additionalNote,
    };
  }
}
