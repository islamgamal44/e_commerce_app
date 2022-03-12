// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home/home_screen.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/componentes/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import 'package:shop_app/shared/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();

  //get data  from shared preference
  await CacheHelper.init() ;
  Widget startScreen ;
  bool? onBoard = CacheHelper.getDataFromSharedPreference(key: 'onboard');
  token = CacheHelper.getDataFromSharedPreference(key: 'token');

  if(onBoard != null)
  {
    if(token==null)
    {
      startScreen = LoginScreen();
    }
    else{
      startScreen = HomeScreen();
    }
  }
  else {startScreen = OnBoardingScreen();}

  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {

  late final Widget startWidgetScreen ;
  MyApp(this.startWidgetScreen);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: startWidgetScreen,
    );
  }
}