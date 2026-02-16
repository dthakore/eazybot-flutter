import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../../../constant/app_constant.dart';
import '../../../preferences/user_preferences.dart';
import '../../models/response_model.dart';
import '../../models/authentication/user_model.dart';
import '../api.dart';

class Urls {
  static String userLogin                = "/api/login";
}

class IPORepository {

  API api = API();

  /// Exception Handling
  myException(String message)  => DioException(
    type: DioExceptionType.unknown,
    requestOptions: RequestOptions(),
    response: null,
    error: Error,
    message: message,
  );

  /// Login User
  Future<User?> userLogin(String userId, String password) async {
    try {
      Response response = await api.sendRequest.post(
          Urls.userLogin,
          data: {
            'email': userId,
            'password': password,
          },
      );
      if (response.statusCode == 200) {
        var apiResponse = ApiResponse<User>.fromJson(response.data, (data) => User.fromJson(data));
        if (apiResponse.status == 200) {
          UserPreferences.shared.setUser(apiResponse.data!);
          // set global data
          print("apiResponse.token: ${apiResponse.token??''}");
          AppConstant.userInfo = apiResponse.data??User();

          return apiResponse.data;
        } else {
          throw(myException(apiResponse.message.toString()));
        }
      } else {
        throw(myException("Please try again!"));
      }
    } catch(ex) {
      if ((ex as DioException).response != null) {
        var resp = (ex as DioException).response;
        APIResponse errorRespo = APIResponse.fromJson(resp?.data);
        throw(myException(
            "Error ${errorRespo.status} : ${errorRespo.message})"));
      } else {
        throw ex;
      }
    }
  }

}


