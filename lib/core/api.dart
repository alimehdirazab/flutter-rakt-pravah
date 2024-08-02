import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String BASE_URL = "https://raktpravah.com/api/";
const Map<String, dynamic> DEFAULT_HEADERS = {
  'Content-Type': 'application/json',
};

class Api {
  final Dio _dio = Dio();

  Api() {
    _dio.options.baseUrl = BASE_URL;
    _dio.options.headers = DEFAULT_HEADERS;

    _dio.options.connectTimeout = const Duration(seconds: 30); // 5 seconds
    _dio.options.receiveTimeout = const Duration(seconds: 30); // 5 seconds

    _dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Request: ${options.method} ${options.uri}');
        print('Headers: ${options.headers}');
        print('Body: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response: ${response.statusCode} ${response.statusMessage}');
        print('Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print('Dio error: $e');
        return handler.next(e);
      },
    ));
  }

  Dio get sendRequest => _dio;
}

class ApiResponse {
  int status;
  String res;
  String? message;
  dynamic data;
  ApiResponse(
      {required this.status, required this.res, this.message, this.data});

  factory ApiResponse.fromResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    return ApiResponse(
      status: data["status"],
      res: data["res"],
      message: data["message"] ?? "Unexpected error",
      data: data["data"],
    );
  }
}
