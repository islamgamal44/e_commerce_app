// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/shop_modules/search/cubit/states.dart';
import 'package:shop_app/shared/componentes/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/handle.dart';


class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel ;
  void searchOn(String text)
  {
    emit(SearchLoadingState());
    DioHelper.postData(
        token: token,
        path: search,
        data: {
          'text':text
        })
        .then((value){
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    })
        . catchError ((error) {
      if (error is DioError)
      {print ('i am in Dio');
      emit(SearchErrorState(exceptionsHandle(error: error)));}
      else
      {
        print ('i am in cubit else');
        emit(SearchErrorState(error.toString()));
      }

    });
  }

}