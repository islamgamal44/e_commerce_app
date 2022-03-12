// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/sign_up/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/handle.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  //SignUpModel object
  late LoginModel SignUpModelObject;

  //--------SignUp-----------------------------------------
  void userSignUp({
    required String email,
    required String password,
    required String name,
    required String phone
  }) {
    emit(SignUpLoadingState());
    DioHelper.postData(
        path: register,
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        })
        .then((value) {
      print('Sign up success  :  ${value.data}');
      //put data that i already received from server in a model to reuse it:
      SignUpModelObject = LoginModel.fromJson(value.data);

      //send data to state to listen on it from UI
      emit(SignUpSuccessState(SignUpModelObject));
    }, )
        . catchError ((error) {
      if (error is DioError)
      {print ('i am in Dio');
      emit(SignUpErrorState(exceptionsHandle(error: error)));}
      else
      {
        print ('i am in cubit else');
        emit(SignUpErrorState(error.toString()));
      }

    });

//          emit(SignUpErrorState(error.toString()));
//----------change passsword visibility suffix icon ------
  }


  bool obsecureTextToggle = true;
  void changeSignUpPasswordVisibility() {
    obsecureTextToggle = !obsecureTextToggle;
    emit(SignUpPasswordVisibilityState());
  }
}
