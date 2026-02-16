class User {
  String? sId;
  String? name;
  String? email;
  String? password;
  int? mobileNumber;
  int? status;
  String? createdAt;
  String? updatedAt;
  num? iV;

  User(
      {this.sId,
        this.name,
        this.email,
        this.password,
        this.mobileNumber,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobileNumber = json['mobileNumber'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobileNumber'] = this.mobileNumber;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}


/*
class User {
  bool? result;
  String? message;
  String? csrfToken;

  User({this.result, this.message, this.csrfToken});

  User.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    csrfToken = json['csrf_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    data['csrf_token'] = this.csrfToken;
    return data;
  }
}
*/