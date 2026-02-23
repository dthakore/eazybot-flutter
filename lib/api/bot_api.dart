import 'package:dio/dio.dart';

class BotApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.eazybot.com/api/v1/",
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer 2|dys7J6wdDCbCD40zxRejJViv2x1f5aI3Oom18vmJe24dd9d5",
      },
    ),
  );

  Future<Map<String, dynamic>> getBots() async {
    final response = await _dio.get("bots?is_backtest=0");
    return response.data;
  }

  Future<Map<String, dynamic>> getBotDetails(int botId) async {
    final response = await _dio.get("bots/$botId");
    return response.data;
  }
}
