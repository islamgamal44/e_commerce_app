

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/componentes/componentes.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

void signOutFun(context){
  CacheHelper.clearDataFromSharedPreference(key: 'token')
      .then((value) {
    if(value)
      navigateAndFinish(context, LoginScreen());
  });
}

String? token = ' ';