import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Counters/cartitemcounter.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/Store/product_page.dart';

import 'package:pepe_food/main.dart';


import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';



Widget sourceInfoBurger(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  int items = 10;

  //  bool reverse = index.isEven;
final Size size = MediaQuery.of(context).size;

  return removeCartFunction == null
      ? Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 1, right: 1),
              height: size.height,
              width: size.width / 2,
              child: GestureDetector(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (c) => ProductPage(itemModel: model));
                  Navigator.push(context, route);
                },
                child: Container(
                
                  decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.80),
                     
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          Container(
                                 child: GestureDetector(
                                  onTap: () {
                                    Route route = MaterialPageRoute(
                                        builder: (c) => ProductPage(itemModel: model));
                                    Navigator.push(context, route);
                                  },

                                ),
                    height: size.height / 3.5,
                    width: size.width / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(model.thumbnailUrl),
                        fit: BoxFit.cover
                      )
                    ),
                  ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Center(
                              
                              child: Text(
                                model.title,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                         Spacer(),
                          Row(
                            children: [
                          Spacer(),
                              Text(r"$",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text("${model.price.toString()}.0",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                             SizedBox(width: 5,)
                            ],
                          )
                        ],
                      )),
                  margin: EdgeInsets.only(top: 25, left: 10, right: 10),
                ),
              ),
            ),
            // Positioned(
            //     top: 50,
            //     right: 10,
            //     child: GestureDetector(
            //       onTap: () {
            //         Route route = MaterialPageRoute(
            //             builder: (c) => ProductPage(itemModel: model));
            //         Navigator.push(context, route);
            //       },
                  
            //       // ),
            //     ))
          ],
        )
      : Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              height: 200,
              width: 500,
              child: GestureDetector(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (c) => ProductPage(itemModel: model));
                  Navigator.push(context, route);
                },
                child: Card(
                  child: Table(
                    children: [
                      TableRow(children: [
                        Container(
                          height: 180.0,
                          width: 50,
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
                                                  color: Colors.black,
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
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 1.0),
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
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    (model.cartPrice ?? '')
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 170,
                                          child: CantidadProducto(model),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: removeCartFunction == null
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.add_shopping_cart,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    checkItemInCart(
                                                        model.title, context);
                                                    checkProductIdinCart(
                                                        model.title,
                                                        model,
                                                        context);
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

                                                    Route route =
                                                        MaterialPageRoute(
                                                            builder: (c) =>
                                                                Hamburger());
                                                    Navigator.push(
                                                        context, route);
                                                  },
                                                ),
                                        ),
                                      ],
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
                  elevation: 3,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45))),
                ),
              ),
            ),
            Positioned(
              top: 50,
              child: GestureDetector(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (c) => ProductPage(itemModel: model));
                  Navigator.push(context, route);
                },
                child: Row(
                  children: [],
                ),
              ),
            )
          ],
        );
}

checkItemInCart(String titleAsID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(titleAsID.toString())
      ? Fluttertoast.showToast(msg: "Articulo ya existe en Carrito.")
      : addItemToCart(titleAsID, context);
}

checkProductIdinCart(String tittleAsId, ItemModel model, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(tittleAsId.toString())
      ? Fluttertoast.showToast(msg: "Articulo ya existe.")
      : saveItemInfoUserCart(tittleAsId, model, context);
}

// checkProductInCartOrders(
//     String tittleAsId, ItemModel model, BuildContext context) {
//   EcommerceApp.sharedPreferences
//           .getStringList(EcommerceApp.userCartList)
//           .contains(tittleAsId.toString())
//       ? Fluttertoast.showToast(msg: "Articulo ya existe.")
//       : saveUsersOrdersByItem(tittleAsId, model, context);
// }

// checkItemInCart2(String productId, BuildContext context) {
//   EcommerceApp.sharedPreferences
//           .getStringList(EcommerceApp.userCartList)
//           .contains(productId.toString())
//       ? Fluttertoast.showToast(msg: "Articulo ya existe en Carrito.")
//       : addItemToCart2(productId, context);
// }

addItemToCart(String titleAsID, BuildContext context) {
  List temCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
  temCartList.add(titleAsID);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartList: temCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: "Agregado con exito.");

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, temCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}

saveItemInfoUserCart(String tittleAsId, ItemModel model, BuildContext context) {
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection(EcommerceApp.userCartList2)
      .doc(productId)
      .set({
    "shortInfo": model.shortInfo.toString(),
    "longDescription": model.longDescription.toString(),
    "price": model.price.toInt(),
    "cartPrice": model.price.toInt(),
    "publishedDate": DateTime.now(),
    "status": "available",
    "thumbnailUrl": model.thumbnailUrl,
    "title": model.title.toString(),
    "qtyitems": model.qtyitems.toInt(),
    "productId": productId
  }).whenComplete(() {
    addItemToCart2(productId, context);
    saveUsersOrdersByItem(model.title, productId, model, context);
  });
}

saveUsersOrdersByItem(
  String tittleAsId,
  productId,
  ItemModel model,
  BuildContext context,
) {
  EcommerceApp.firestore.collection("users_carts_orders").doc(productId).set({
    "shortInfo": model.shortInfo.toString(),
    "longDescription": model.longDescription.toString(),
    "price": model.price.toInt(),
    "cartPrice": model.price.toInt(),
    "publishedDate": DateTime.now(),
    "status": "available",
    "thumbnailUrl": model.thumbnailUrl,
    "title": model.title.toString(),
    "qtyitems": model.qtyitems.toInt(),
    "productId": productId
  });
}

addItemToCart2(String productId, BuildContext context) {
  List temCartList =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartListID);
  temCartList.add(productId);

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .update({
    EcommerceApp.userCartListID: temCartList,
  }).then((v) {
    Fluttertoast.showToast(msg: "Agregado con exito.");

    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListID, temCartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}

class CantidadProducto extends StatefulWidget {
  final ItemModel model;
  CantidadProducto(this.model);

  @override
  _CantidadProductoState createState() => _CantidadProductoState(this.model);
}

class _CantidadProductoState extends State<CantidadProducto> {
  _CantidadProductoState(this.model);
  final ItemModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: Container(
              child: IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                onPressed: () {
                  int min = widget.model.qtyitems;
                  if (min > 1) {
                    _removeProd();
                    _removeProdUsersOrders();
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              "${widget.model.qtyitems}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            child: Container(
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () {
                  int max = widget.model.qtyitems;
                  if (max < 20) {
                    _addProd();
                    _addProdUsersOrders();
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addProd() {
    widget.model.qtyitems++;

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList2)
        .doc(widget.model.productId.toString())
        .update({
      "price": widget.model.price.toInt(),
      "cartPrice": widget.model.price.toInt() * widget.model.qtyitems.toInt(),
      "qtyitems": widget.model.qtyitems.toInt(),
    });
  }

  _removeProd() {
    widget.model.qtyitems--;

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList2)
        .doc(widget.model.productId.toString())
        .update({
      "price": widget.model.price.toInt(),
      "cartPrice": widget.model.price.toInt() * widget.model.qtyitems.toInt(),
      "qtyitems": widget.model.qtyitems.toInt(),
    });
  }

  _addProdUsersOrders() {
    widget.model.qtyitems++;

    EcommerceApp.firestore
        .collection("users_carts_orders")
        .doc(widget.model.productId.toString())
        .update({
      "price": widget.model.price.toInt(),
      "cartPrice": widget.model.price.toInt() * widget.model.qtyitems.toInt() -
          widget.model.price.toInt(),
      "qtyitems": widget.model.qtyitems.toInt() - 1,
    });
  }

  _removeProdUsersOrders() {
    widget.model.qtyitems--;

    EcommerceApp.firestore
        .collection("users_carts_orders")
        .doc(widget.model.productId.toString())
        .update({
      "price": widget.model.price.toInt(),
      "cartPrice": widget.model.price.toInt() * widget.model.qtyitems.toInt() +
          widget.model.price.toInt(),
      "qtyitems": widget.model.qtyitems.toInt() + 1,
    });
  }
}
