// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home/home_screen.dart';
import 'package:shop_app/modules/sign_up/sign_up_screen.dart';
import 'package:shop_app/shared/componentes/componentes.dart';
import 'package:shop_app/shared/componentes/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shared/styles/styles.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext con) {

    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit,LoginState>(
        listener: (BuildContext context, state){
          if(state is LoginSuccessState){
            if (state.loginModelObject.status != null &&  state.loginModelObject.status == true)
            {
              CacheHelper.putDataInSharedPreference(value: state.loginModelObject.data!.token, key: 'token')
                  .then((value) {
                token =  state.loginModelObject.data!.token!;
                navigateAndFinish(context, HomeScreen());
              });

            }
            else
            {
              makeToast('${state.loginModelObject.message}');
              navigateTo(context,SignUpScreen());
            }
          }

          else if(state is LoginErrorState){
            makeToast('${state.errorString}');
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
                      child: Form(
                        key: formKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text('login',
                                style: Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black54
                                ),

                              ),

                              SizedBox(height: 20.0,),
                              defaultTextFormField(
                                  validator: (String? text) {
                                    if(text!.isEmpty)
                                      return 'please enter valid email';
                                  },
                                  controller: emailController,
                                  labelText: 'E-mail',
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icon(Icons.email)
                              ),
                              SizedBox(height: 20.0,),

                              defaultTextFormField(
                                  validator: (String? text) {
                                    if(text!.isEmpty)
                                      return 'please enter valid password';
                                  },
                                  controller: passwordController,
                                  labelText: 'password',
                                  keyboardType: TextInputType.visiblePassword,
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: LoginCubit.get(context).obsecureTextToggle ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                  obscureText:LoginCubit.get(context).obsecureTextToggle,
                                  suffixFun: (){LoginCubit.get(context).changePasswordVisibility();}
                                  ,
                                  onSubmit: (value){
                                    if(formKey.currentState!.validate())
                                    {
                                      LoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  }
                              ),



                              SizedBox(height: 15.0,),

                              state is! LoginLoadingState ?
                              Container(
                                width: double.infinity,

                                child: defaultButton(
                                  buttonFunction: () {
                                    if(formKey.currentState!.validate())
                                    {
                                      LoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  buttonText: 'login',
                                ),
                              )
                                  : Center(child: CircularProgressIndicator(),),


                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Don\'t have an account ?'),
                                  TextButton(onPressed: () {
                                    navigateTo(context, SignUpScreen());
                                  }, child: Text('Sign up',style: bigTitles.bodyText2!.copyWith(
                                      color: primaryColor,fontWeight: FontWeight.bold),)),
                                ],
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ) ;
        },

      ),
    );
  }
}