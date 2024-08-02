class RegisterResponse {
  final String message;
  final String accessToken;

  RegisterResponse({required this.message, required this.accessToken});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'],
      accessToken: json['accessToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'accessToken': accessToken,
    };
  }
}
