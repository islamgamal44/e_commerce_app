
// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/handle.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  //loginModel object
  late LoginModel loginModelObject;

  void userLogin({
    required String email,
    required String password
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
        path: login,
        data: {
          'email': email,
          'password': password
        })
        .then((value) {
      print(value.data);
      //put data that i already received from server in a model to reuse it:
      loginModelObject = LoginModel.fromJson(value.data);

      //send data to state to listen on it from UI
      emit(LoginSuccessState(loginModelObject));
    }, )
        . catchError ((error) {
      if (error is DioError)
      {print ('i am in Dio');
      emit(LoginErrorState(exceptionsHandle(error: error)));}
      else
      {
        print ('i am in cubit else');
        emit(LoginErrorState(error.toString()));
      }

    });

//          emit(LoginErrorState(error.toString()));
//----------change passsword visibility suffix icon ------
  }


  bool obsecureTextToggle = true;
  void changePasswordVisibility() {
    obsecureTextToggle = !obsecureTextToggle;
    emit(PasswordVisibilityState());
  }
}
