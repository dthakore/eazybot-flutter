import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../constant/app_constant.dart';


class API {

  Dio _dio = Dio();

  API() {
    //_dio.options.baseUrl = "https://jsonplaceholder.typicode.com";
    //_dio.options.baseUrl = "https://stock-production-aac1.up.railway.app";
    //_dio.options.baseUrl = "https://backends.stockwiz.co.in";
    _dio.options.baseUrl = AppConstant.BASE_URL;
    _dio.interceptors.add(PrettyDioLogger(
      requestBody: true,
    ));
  }

  Dio get sendRequest => _dio;

}