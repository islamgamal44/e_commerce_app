// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/home/cubit/cubit.dart';
import 'package:shop_app/layout/home/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';

import 'package:shop_app/shared/componentes/componentes.dart';

import 'package:shop_app/shared/styles/colors.dart';



class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (BuildContext context, Object? state) {
          if(state is FavoritesSuccessState){
            if(! state.changeFavModel!.status)
            {
              makeToast(state.changeFavModel!.message);
            }
            else if (state.changeFavModel!.status){

            }
          }
        },
        builder: (BuildContext context, state) {
          var cubit = HomeCubit.get(context);
          return cubit.homeModel != null && cubit.categoriesModel != null
              ? productScreenWidget(cubit.homeModel , cubit.categoriesModel,context)
              : Center(
               child: CircularProgressIndicator(),
          );
        });
  }

  Widget productScreenWidget(HomeModel? model , CategoriesModel? categoriesModel,context) {
    return Container(
      color: Colors.grey[100],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model!.data!.banners
                    .map((oneBanner) => Image(
                  image: NetworkImage('${oneBanner.image}',),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ))
                    .toList(),
                options: CarouselOptions(
                  height: 230.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  reverse: false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1.0,

                )),
            SizedBox(
              height: 5.0,
              child: Container(
                color: Colors.grey.shade100,
              ),
            ),

            //CATEGORIES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Text(
                'Categories',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                    fontFamily: 'Janna',
                    fontWeight: FontWeight.bold
                ),

              ),
            ),
            Container(
              height: 90.0,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.separated(
                  physics:BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index)=>categoryItemWidget(categoriesModel!.allCategories!.data[index]),
                  separatorBuilder: (context,index)=>SizedBox(width: 10.0,),
                  itemCount: categoriesModel!.allCategories!.data.length),
            ),

            SizedBox(
              height: 10.0,
              child: Container(
                color: Colors.grey.shade100,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Text(
                'Latest Products',
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black54,
                    fontFamily: 'Janna',
                    fontWeight: FontWeight.bold
                ),

              ),
            ),
            Container(
              color: Colors.grey.shade100,
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 0.8 / 0.85,
                crossAxisCount: 2,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                children: List.generate(model.data!.products.length,
                        (index) => productItemWidget(model.data!.products[index],context)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productItemWidget(ProductModel product,context) {
    return
      product.discount != 0 ?
      ClipRect  (
        child: Banner(
          message: 'DISCOUNT',
          location: BannerLocation.topStart,
          color: Colors.deepOrange,
          child: productItemWithoutDiscountBanner(product,context),
        ),
      )
          : productItemWithoutDiscountBanner(product,context);
  }

  Widget productItemWithoutDiscountBanner (ProductModel product,context){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: NetworkImage(product.image.toString()),
              width: double.infinity,
              height: 100,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Text(
                  '${product.name}',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                      wordSpacing: 1.0),
                ),
              ),
              SizedBox(
                width: 15.0,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 15.0,
              ),
              product.discount != 0
                  ? Text('${product.price} \$',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough))
                  : Text('${product.price} \$',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.black54,
                  )),
              SizedBox(
                width: 30.0,
              ),
              Expanded(
                  child: IconButton(
                    iconSize: 23.0,
                    onPressed: () {
                      HomeCubit.get(context).changeCart(product.id);
                    },
                    icon: HomeCubit.get(context).productsIndicatorIDCart[product.id] == true?
                    Icon(Icons.remove_shopping_cart,color: Colors.grey,) :
                    Icon(Icons.add_shopping_cart,color: primaryColor,),
                    padding: EdgeInsets.all(0),
                  )),

              Expanded(
                  child: IconButton(
                    color: Colors.deepOrange,
                    iconSize: 23.0,
                    onPressed: () {
                      HomeCubit.get(context).changeFavorites(product.id);
                    },
                    icon:HomeCubit.get(context).productsIndicatorID_Fav[product.id] == true? Icon(Icons.favorite) :
                    Icon(Icons.favorite_border_outlined),
                    padding: EdgeInsets.all(0),
                  )),
            ],
          )
        ],
      ),
    ) ;
  }

  Widget categoryItemWidget(CategoryModel category){
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        color: Colors.white,),
      child: Stack(
        alignment: Alignment.bottomCenter,

        children: [

          Image(
            image: NetworkImage(category.image),
            fit: BoxFit.contain,

          ),

          Container(
            width: 90.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
                color: Colors.teal.withOpacity(0.7)
            ),
            child: Text(category.name,style:TextStyle(
                color: Colors.white,fontSize: 16.0),
              textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
          ),


        ],
      ),
    );
  }
}