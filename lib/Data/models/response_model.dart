

/// API response for status & message only
class APIResponse {
  int? status;
  String? message;

  APIResponse({this.status, this.message});

  APIResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

/// Response for model
class ApiResponse<T> {
  int? status = 0;
  int? statusCode = 0;
  String? message = '';
  String? user = '';
  String? token = '';
  final T? data; // Data can be optional

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.user,
    required this.token,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    // Add a type and null check for 'data' before parsing it
    return ApiResponse<T>(
      status: json['status'] as int?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      user: json['user'] as String?,
      token: json['token'] as String?,
      data: (json.containsKey('data') && json['data'] is Map<String, dynamic>)
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
      'user': user,
      'token': token,
      'data': data != null ? toJsonT(data!) : null,
    };
  }
}

class ApiResponseData<T> {
  int? status = 0;
  String? message = '';
  final T? data; // Data can be optional

  ApiResponseData({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponseData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    // Add a type and null check for 'data' before parsing it
    return ApiResponseData<T>(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: (json.containsKey('data') && json['data'] is Map<String, dynamic>)
          ? fromJsonT(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'status': status,
      'message': message,
      'data': data != null ? toJsonT(data!) : null,
    };
  }
}


// class ApiResponse<T> {
//   final int? status;
//   final int? statusCode;
//   final String? message;
//   final String? user;
//   final String? token;
//   final T? data; // Data can be optional
//
//   ApiResponse({
//     required this.status,
//     required this.statusCode,
//     required this.message,
//     required this.user,
//     required this.token,
//     this.data,
//   });
//
//   factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
//     return ApiResponse<T>(
//       status: json['status'],
//       statusCode: json['status_code'],
//       message: json['message'],
//       user: json['user'],
//       token: json['token'],
//       data: json.containsKey('data') ? fromJsonT(json['data']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
//     return {
//       'status': status,
//       'status_code': statusCode,
//       'message': message,
//       'user': user,
//       'token': token,
//       'data': data != null ? toJsonT(data!) : null,
//     };
//   }
// }

/// Response for List Model

class ApiResponseList<T> {
  final int status;
  final String message;
  final List<T> data;

  ApiResponseList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponseList.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    var dataJson = json['data'] as List;
    List<T> dataList = dataJson.map((item) => fromJsonT(item)).toList();

    return ApiResponseList<T>(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }

  Map<String, dynamic> toJson(T Function(T) toJsonT) {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => toJsonT(item)).toList(),
    };
  }
}

class ApiResponseCatalogList<T> {
  final int status;
  final String message;
  final List<T> data;
  String androidVersion = "";
  String iosVersion = "";

  ApiResponseCatalogList({
    required this.status,
    required this.message,
    required this.data,
    required this.androidVersion,
    required this.iosVersion,
  });

  factory ApiResponseCatalogList.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    var dataJson = json['data'] as List;
    List<T> dataList = dataJson.map((item) => fromJsonT(item)).toList();

    return ApiResponseCatalogList<T>(
      status: json['status'],
      message: json['message'],
      data: dataList,
      androidVersion: json['androidVersion'],
      iosVersion: json['iosVersion'],
    );
  }

  Map<String, dynamic> toJson(T Function(T) toJsonT) {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => toJsonT(item)).toList(),
      'androidVersion': androidVersion,
      'iosVersion': iosVersion,
    };
  }
}

