import 'package:dio/dio.dart';
import '../core/token_storage.dart';

class BotApi {
  Future<Dio> _dioInstance() async {
    String? token = await TokenStorage.getToken();

    return Dio(
      BaseOptions(
        baseUrl: "https://api.eazybot.com/api/v1/",
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getBots() async {
    final dio = await _dioInstance();
    final response = await dio.get("bots?is_backtest=0");
    return response.data;
  }

  Future<Map<String, dynamic>> getBotDetails(int botId) async {
    final dio = await _dioInstance();
    final response = await dio.get("bots/$botId");
    return response.data;
  }

  Future<Map<String, dynamic>> getBotSession({
    required int botId,
    String status = "OPEN",
    int offset = 0,
    int limit = 5,
  }) async {
    final dio = await _dioInstance();

    final response = await dio.post(
      "sessions",
      data: {
        "bot_id": botId,
        "status": status,
        "offset": offset,
        "limit": limit,
      },
    );

    return response.data;
  }
}
