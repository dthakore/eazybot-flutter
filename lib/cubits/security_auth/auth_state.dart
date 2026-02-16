
import '../../Data/models/response_model.dart';
import '../../Data/models/authentication/user_model.dart';

abstract class AuthState {}

/// Login-OTP
class AuthInitialState extends AuthState {}
class AuthValidState extends AuthState {}
class AuthLoadingState extends AuthState {}
class AuthLoadedState extends AuthState {
  final User loginResp;
  AuthLoadedState(this.loginResp);
}
class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}

class AddNotificationInitialState extends AuthState {}
class AddNotificationLoadingState extends AuthState {}
class AddNotificationLoadedState extends AuthState {
  final APIResponse response;
  AddNotificationLoadedState(this.response);
}
class AddNotificationErrorState extends AuthState {
  final String error;
  AddNotificationErrorState(this.error);
}

