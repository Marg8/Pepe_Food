import 'dart:convert';

import 'package:pepe_food/Address/address.dart';
import 'package:pepe_food/Address/addressModel.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Models/address.dart';
import 'package:pepe_food/Orders/myOrders.dart';
import 'package:pepe_food/Store/storehome.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pepe_food/Widgets/orderCard.dart';
import 'package:intl/intl.dart';

import '../Widgets/loadingWidget.dart';

String getOrderId = "";
CancelOrder cancel = CancelOrder();

class OrderDetails extends StatelessWidget {
  final String orderID;

  OrderDetails({
    Key key,
    this.orderID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences
                    .getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders)
                .doc(orderID)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(children: [
                        // StatusBanner(
                        //   status: dataMap[EcommerceApp.isSuccess],
                        // ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: headCost(dataMap),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text("Order Number: #" +
                              dataMap["orderNumber"].toString()),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "Order at" +
                                DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["orderTime"]))),
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        ),
                        Divider(
                          height: 2.0,
                        ),
                        FutureBuilder<QuerySnapshot>(
                          future: EcommerceApp.firestore
                              .collection(EcommerceApp.collectionUser)
                              .doc(EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.userUID))
                              .collection(EcommerceApp.userCartList2)
                              .where("productId",
                                  whereIn: dataMap[EcommerceApp.productID])
                              .get(),
                          builder: (c, dataSnapshot) {
                            return dataSnapshot.hasData
                                ? OrderCard2(
                                    itemCount: dataSnapshot.data.docs.length,
                                    data: dataSnapshot.data.docs,
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                        Divider(
                          height: 2.0,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .doc(EcommerceApp.sharedPreferences
                                    .getString(EcommerceApp.userUID))
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(dataMap[EcommerceApp.addressID])
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? ShippingDetails(
                                      model: AddressModel.fromJson(
                                          snap.data.data()),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            }),
                      ]),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }

  Column headCost(Map<dynamic, dynamic> dataMap) {
    double total = dataMap["cost"]+dataMap[EcommerceApp.totalAmount];
    return Column(children: [
      Row(
        children: [
          Text(
            "Costo de Compra:",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            r"$ " + dataMap[EcommerceApp.totalAmount]?.toString() + " MXN",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            "Costo de Envio:",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            r"$ " + dataMap["cost"].toString() + " MXN",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            "Total:",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            r"$ " + total.toString() + " MXN",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ]);
  }
}

class StatusBanner extends StatelessWidget {
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Exitosa" : msg = "Incompleta";

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.yellow, Colors.yellow],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.push(context, route);
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Orden Generada " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.white,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.black,
                size: 14.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ShippingDetails extends StatelessWidget {
  final AddressModel model;

  ShippingDetails({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Text(
            "Detalles de Envio:",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Nombre",
                ),
                Text(model.name),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Numero de Celular",
                ),
                Text(model.phoneNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Direccion",
                ),
                Text(model.flatNumber),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Costo",
                ),
                Text("\$ ${model.cost.toString()} MXN"),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Ciudad",
                ),
                Text(model.city),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Estado, Pais",
                ),
                Text(model.state),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Codigo Postal",
                ),
                Text(model.pincode),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmedUserOrderReceived(context, getOrderId);
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.yellow, Colors.yellow],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Confirmar || Articulos Recibidos",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                cancel.cancelOrderUser(context, getOrderId);
                cancel.cancelOrderAdmin(context, getOrderId);
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Colors.red, Colors.red],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50.0,
                child: Center(
                  child: Text(
                    "Cancelar || Cancelar Order",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmedUserOrderReceived(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => MyOrders());
    Navigator.push(context, route);

    Fluttertoast.showToast(msg: "Orden Entregada. Confirmada.");
  }
}

class CancelOrder {
  cancelOrderUser(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .delete();
  }

  cancelOrderAdmin(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => MyOrders());
    Navigator.push(context, route);

    Fluttertoast.showToast(msg: "Orden Cancelada.");
  }
}
