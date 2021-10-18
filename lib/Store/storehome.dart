import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Store/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../Counters/cartitemcounter.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';
import '../Models/item.dart';
import 'cart.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

//Color Theme
int theme = 0xff000000;
int qtyItems = 1;

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Color(theme), Color(theme)],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Image.asset(
              "images/dmwhite.png",
              height: 240.0,
              width: 240.0,
            ),
          ),
          title: Text(
            "",
            style: TextStyle(
                fontSize: 55.0, color: Colors.black, fontFamily: "Signatra"),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                Positioned(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.brightness_1,
                        size: 20.0,
                        color: Colors.white,
                      ),

                      //Video 11 o 19
                      //falta determinar la funcion de este indicador
                      Positioned(
                        top: 3.0,
                        bottom: 4.0,
                        left: 4.0,
                        child: Consumer<CartItemCounter>(
                          builder: (context, counter, _) {
                            return Text(
                              (EcommerceApp.sharedPreferences
                                          .getStringList(
                                              EcommerceApp.userCartList)
                                          .length -
                                      1)
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("items")
                    .limit(100)
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, dataSnapshot) {

                  
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 2,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                      
                            ItemModel model  =
                            ItemModel.fromJson(dataSnapshot.data.docs[index].data());

                            return sourceInfo(model, context);
                          },
                          itemCount: dataSnapshot.data.docs.length,
                        );
                }),
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
      Navigator.push(context, route);
    },
    splashColor: Colors.black,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: removeCartFunction == null
          ? Table(
              children: [
                TableRow(children: [
                  Container(
                    height: 150.0,
                    width: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          offset: new Offset(0.0, 5.0),
                          blurRadius: 5.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      gradient: new LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ),
                    ),
                    child: Row(
                      children: [
                        FadeInImage(
                          image: NetworkImage(model.thumbnailUrl),
                          placeholder: AssetImage("images/jar-loading1.gif"),
                          fadeInDuration: Duration(milliseconds: 50),
                          width: 140.0,
                          height: 140.0,
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        model.title ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        model.shortInfo ?? '',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  /*Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.red,
                            ),
                            alignment: Alignment.topLeft,
                            width: 40.0,
                            height: 43.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "30%",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "OFF%",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),*/
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 1.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              r"",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              r"$",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (model.price ?? '').toString(),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30.0),
                                        child: Row(
                                          children: [],
                                        ),
                                      ),

                                      /*Padding(
                                padding: EdgeInsets.only(top: 1.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"Cantidad: ",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                    Text(
                                      r"",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                    Text(
                                      (qtyItems ?? '').toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                                    ],
                                  )
                                ],
                              ),
                              Flexible(
                                child: Container(),
                              ),
                              //to implement the cart item remove feature
                              Align(
                                alignment: Alignment.centerRight,
                                child: removeCartFunction == null
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          // checkItemInCart(model.title, context);
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          removeCartFunction();

                                          //opcional para salir automatico

                                          Route route = MaterialPageRoute(
                                              builder: (c) => StoreHome());
                                          Navigator.push(context, route);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ])
              ],
              // Aqui se modifica la informacion del Carro unicamente
              //Cart Page
            )
          : Table(
              children: [
                TableRow(children: [
                  Container(
                    height: 180.0,
                    width: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.black,
                          offset: new Offset(0.0, 5.0),
                          blurRadius: 5.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      gradient: new LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          model.thumbnailUrl,
                          width: 140.0,
                          height: 140.0,
                        ),
                        SizedBox(
                          width: 1.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        model.title ?? '',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        model.shortInfo ?? '',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.red,
                                    ),
                                    alignment: Alignment.topLeft,
                                    width: 40.0,
                                    height: 43.0,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "30%",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Text(
                                            "OFF%",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 1.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              r"",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.black),
                                            ),
                                            Text(
                                              r"$",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (model.price ?? '').toString(),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 30.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              r"$",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.red,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                            Text(
                                              (model.price +
                                                          model.price * 0.30 ??
                                                      '')
                                                  .toString()
                                                  .replaceAll(".0", ""),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.red,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      /*Padding(
                                padding: EdgeInsets.only(top: 1.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"Cantidad: ",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                    Text(
                                      r"",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                    Text(
                                      (qtyItems ?? '').toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                                    ],
                                  )
                                ],
                              ),
                              Flexible(
                                child: Container(),
                              ),
                              //to implement the cart item remove feature
                              Align(
                                alignment: Alignment.centerRight,
                                child: removeCartFunction == null
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          // checkItemInCart(model.title, context);
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          removeCartFunction();

                                          //opcional para salir automatico

                                          Route route = MaterialPageRoute(
                                              builder: (c) => StoreHome());
                                          Navigator.push(context, route);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ])
              ],
            ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
    height: 150.0,
    width: width * .34,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 5), blurRadius: 10.0, color: Colors.grey[200]),
        ]),
    child: Image.network(
      imgPath,
      height: 150.0,
      width: width * .34,
      fit: BoxFit.fill,
    ),
  );
}
