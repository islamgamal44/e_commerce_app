// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home/home_screen.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/sign_up/cubit/cubit.dart';
import 'package:shop_app/modules/sign_up/cubit/states.dart';
import 'package:shop_app/shared/componentes/componentes.dart';
import 'package:shop_app/shared/componentes/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

import 'package:shop_app/shared/styles/colors.dart';
import 'package:shop_app/shared/styles/styles.dart';

class SignUpScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignUpCubit(),
      child: BlocConsumer<SignUpCubit,SignUpState>(
        listener: (BuildContext context, state){
          if(state is SignUpSuccessState){
            if (state.SignUpModelObject.status != null &&  state.SignUpModelObject.status == true)
            {
              CacheHelper.putDataInSharedPreference(value: state.SignUpModelObject.data!.token, key: 'token')
                  .then((value) {
                token =  state.SignUpModelObject.data!.token!;
                navigateAndFinish(context, HomeScreen());
              });

            }
            else
            {
              makeToast('${state.SignUpModelObject.message}');
              navigateTo(context,SignUpScreen());
            }
          }

          else if(state is SignUpErrorState){
            makeToast('${state.errorString}');
          }


        },
        builder: (BuildContext context, state){
          return  Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('SIGN UP',
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
                            controller: nameController,
                            labelText: 'name',
                            keyboardType: TextInputType.name,
                            prefixIcon: Icon(Icons.person)
                        ),

                        SizedBox(height: 15.0,),

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
                        SizedBox(height: 15.0,),

                        defaultTextFormField(
                            validator: (String? text) {
                              if(text!.isEmpty)
                                return 'please enter valid email';
                            },
                            controller: phoneController,
                            labelText: 'phone',
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(Icons.phone)
                        ),
                        SizedBox(height: 15.0,),

                        defaultTextFormField(
                            validator: (String? text) {
                              if(text!.isEmpty)
                                return 'please enter valid password';
                            },
                            controller: passwordController,
                            labelText: 'password',
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: SignUpCubit.get(context).obsecureTextToggle ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                            obscureText:SignUpCubit.get(context).obsecureTextToggle,
                            suffixFun: (){SignUpCubit.get(context).changeSignUpPasswordVisibility();}
                            ,
                            onSubmit: (value){
                              if(formKey.currentState!.validate())
                              {
                                SignUpCubit.get(context).userSignUp(email: emailController.text, password: passwordController.text,name: nameController.text,phone: phoneController.text);
                              }
                            }
                        ),



                        SizedBox(height: 15.0,),

                        state is! SignUpLoadingState ?
                        Container(
                          width: double.infinity,
                          child: defaultButton(
                            buttonFunction: () {
                              if(formKey.currentState!.validate())
                              {
                                SignUpCubit.get(context).userSignUp(email: emailController.text, password: passwordController.text,name: nameController.text,phone: phoneController.text);
                              }
                            },
                            buttonText: 'Sign Up',
                          ),
                        )
                            : Center(child: CircularProgressIndicator(),),


                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account ?'),
                            TextButton(onPressed: () {
                              navigateAndFinish(context, LoginScreen());
                            }, child: Text('Login',style: bigTitles.bodyText2!
                                .copyWith(color: primaryColor,fontWeight: FontWeight.bold),)),
                          ],
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ),
          ) ;
        },

      ),
    ) ;
  }
}