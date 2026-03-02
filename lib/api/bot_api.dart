import 'package:dio/dio.dart';

class BotApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.eazybot.com/api/v1/",
      headers: {
        "Accept": "application/json",
        "Authorization":
            "Bearer 14|Ty0oeH0sKTDEG3BcywG4sDaA00K0gnYtrEkb1ztOae1db13b",
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
