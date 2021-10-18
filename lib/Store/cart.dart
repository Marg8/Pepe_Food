import 'package:pepe_food/Address/address.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Counters/cartitemcounter.dart';
import 'package:pepe_food/Counters/totalMoney.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/Widgets/customAppBar.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';
import 'package:pepe_food/Widgets/myDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pepe_food/src/hamburgers_list.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double totalAmount;

  @override
  void initState() {
    super.initState();

    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Your Cart is empty");
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          }
        },
        label: Text("Comprar Ahora"),
        backgroundColor: Colors.black,
        icon: Icon(Icons.navigate_next),
      ),
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
                builder: (context, amountProvider, cartProvider, c) {
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: cartProvider.count == 0
                      ? Container()
                      : Text(
                          r"Precio Total: $" +
                              "${amountProvider.totalAmount.toInt()} MXN",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                ),
              );
            }),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.userCartList2)
                  .where("status", isEqualTo: "available")
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : snapshot.data.docs.length == 0
                        ? beginBuildingCart()
                        : SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 1,
                            staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                            itemBuilder: (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.docs[index].data());

                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = model.cartPrice + totalAmount;
                              } else {
                                totalAmount = model.cartPrice + totalAmount;
                              }

                              if (snapshot.data.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((c) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .display(totalAmount);
                                });
                              }
                              return sourceInfoBurger(model, context,
                                  removeCartFunction: () {
                                removeItemFromUserCart(model.title);
                                deleteProduct(context, model.productId);
                                removeItemFromUserCartID(model.productId);
                                deleteUserOrderProduct(context, model.productId);
                              });
                            },
                            itemCount: snapshot.hasData
                                ? snapshot.data.docs.length
                                : 0,
                          );
              }),
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              width: 100,
              child: Text(""),
            ),
          )
        ],
      ),
    );
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Container(
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_emoticon,
              color: Colors.black,
            ),
            Text("Cart is empty"),
            Text("Star adding items to your Cart"),
          ],
        ),
      ),
    );
  }

  removeItemFromUserCart(String titleAsId) {
    List temCartList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);
    temCartList.remove(titleAsId);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: temCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item RemovedSuccessfully.");

      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, temCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;

      Route route = MaterialPageRoute(builder: (c) => CartPage());
      Navigator.pushReplacement(context, route);
    });
  }

  removeItemFromUserCartID(String productId) {
    List temCartList = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartListID);
    temCartList.remove(productId);

    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartListID: temCartList,
    }).then((v) {
      Fluttertoast.showToast(msg: "Item RemovedSuccessfully.");

      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartListID, temCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();

      totalAmount = 0;

      Route route = MaterialPageRoute(builder: (c) => CartPage());
      Navigator.pushReplacement(context, route);
    });
  }

  deleteProduct(BuildContext context, String productId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList2)
        .doc(productId)
        .delete();

    Fluttertoast.showToast(msg: "Producto Borrado de Carro");
  }

  deleteUserOrderProduct(BuildContext context, String productId) {
    EcommerceApp.firestore
        .collection("users_carts_orders")
        .doc(productId)
        .delete();

    Fluttertoast.showToast(msg: "Producto Borrado de Carro");
  }
}
