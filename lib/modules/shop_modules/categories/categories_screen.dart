// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home/cubit/cubit.dart';
import 'package:shop_app/layout/home/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';


class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (BuildContext context, Object? state){},
        builder: (BuildContext context, state) {
          var cubit = HomeCubit.get(context);
          return  Container(
            color: Colors.grey[300],
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index)=>categoryListItem(cubit.categoriesModel!.allCategories!.data[index]),
                    separatorBuilder: (context,index)=>SizedBox(height: 10.0,),
                    itemCount: cubit.categoriesModel!.allCategories!.data.length)
            ),
          );
        }
    );
  }


  Widget categoryListItem(CategoryModel category){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,

      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: NetworkImage(category.image),
              width: 80.0,
              height: 80.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 5.0,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Janna'
                ),
              ),
              SizedBox(height: 2.0,),
              Text(
                '25 items',
                style: TextStyle(
                  fontSize: 15.0,

                ),

              ),
            ],
          ),

          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(

                icon:Icon(Icons.arrow_forward_ios), onPressed: () {  },),
          )

        ],
      ),
    );
  }
}