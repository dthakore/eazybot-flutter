import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/models/response_model.dart';
import '../../Data/models/authentication/user_model.dart';
import '../../Data/repositories/ipo_repositories/ipo_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super( AuthInitialState() );

  void userLogin(String emailId, String password) async {
    emit( AuthInitialState() );
    emit( AuthLoadingState() );
    if (emailId == "" && password == "") {
      if (emailId == "") {
        emit(AuthErrorState("Please enter valid email address"));
      } else {
        emit(AuthErrorState("Please enter valid password"));
      }
    } else {

      IPORepository postRepository = IPORepository();
      try {
        User? loginResp = await postRepository.userLogin(emailId, password);
        print("loginResp: ${loginResp}");
        emit(AuthLoadedState(loginResp!));
      }
      on DioException catch (ex) {
        print("ex: ${ex}");
        emit( AuthErrorState(ex.message.toString()) );
      }
    }

  }
}