import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.eazybot.com/api/",
      headers: {"Accept": "application/json"},
    ),
  );

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "login",
        data: {"email": email, "password": password},
      );

      print("API RESPONSE: ${response.data}");

      if (response.data["success"] == true) {
        return response.data["api_token"]; // correct path
      }

      return null;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }
}
