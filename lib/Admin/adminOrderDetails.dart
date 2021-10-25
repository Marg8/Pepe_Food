import 'package:pepe_food/Address/address.dart';
import 'package:pepe_food/Admin/adminOrderCard.dart';
import 'package:pepe_food/Admin/uploadItems.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Models/address.dart';
import 'package:pepe_food/Store/storehome.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';
import 'package:pepe_food/Widgets/orderCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

int theme = 0xff000000;

String getOrderId = "";

class AdminOrderDetails extends StatelessWidget {
  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({Key key, this.orderID, this.orderBy, this.addressID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders)
                .doc(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(children: [
                        AdminStatusBanner(
                          status: dataMap[EcommerceApp.isSuccess],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: headCostAdmin(dataMap)
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
                              .collection("users_carts_orders")
                              .where("productId",
                                  whereIn: dataMap[EcommerceApp.productID])
                              .get(),
                          builder: (c, dataSnapshot) {
                            return dataSnapshot.hasData
                                ? OrderCard(
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
                                .doc(orderBy)
                                .collection(EcommerceApp.subCollectionAddress)
                                .doc(addressID)
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? AdminShippingDetails(
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

  Column headCostAdmin(Map<dynamic, dynamic> dataMap) {
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

class AdminStatusBanner extends StatelessWidget {
  final bool status;

  AdminStatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successful" : msg = "UnSuccessful";

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Color(theme), Color(theme)],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      height: 40.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Route route = MaterialPageRoute(builder: (c) => UploadPage());
                Navigator.pop(context, route);
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            // SizedBox(width: 100.0,),
            Text(
              "Order Shipped" + msg,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              radius: 8.0,
              backgroundColor: Colors.grey,
              child: Center(
                child: Icon(
                  iconData,
                  color: Colors.black,
                  size: 14.0,
                ),
              ),
            ),
            SizedBox(
              width: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;

  AdminShippingDetails({Key key, this.model}) : super(key: key);

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
            "Shipment Details:",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                KeyText(
                  msg: "Locacion",
                ),
                Text(model.locacion),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Colonia",
                ),
                Text(model.colonia),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Ciudad",
                ),
                Text(model.colonia),
              ]),
              TableRow(children: [
                KeyText(
                  msg: "Estado",
                ),
                Text(model.estado),
              ]),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                confirmParcelShifted(context, getOrderId);
              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [Color(theme), Color(theme)],
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
                    "Confirmedo || Producto Entregado",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
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
                confirmParcelShifted(context, getOrderId);
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
                    "Cancelar || Cancelar Orden",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  confirmParcelShifted(BuildContext context, String mOrderId) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(mOrderId)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.push(context, route);

    Fluttertoast.showToast(msg: "Order has been Received. Confirmed.");
  }
}
