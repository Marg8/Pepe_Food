import 'package:pepe_food/Admin/adminOrderCard.dart';
import 'package:pepe_food/Admin/uploadItems.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminShiftOrders1 extends StatefulWidget {
  @override
  _AdminShiftOrders1State createState() => _AdminShiftOrders1State();
}

class _AdminShiftOrders1State extends State<AdminShiftOrders1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: new AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.yellow, Colors.yellow],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                GestureDetector(
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => UploadPage());
                    Navigator.pop(context, route);
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          centerTitle: true,
          title: Text(
            "My Orders Admin",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white,),
            //   onPressed: ()
            //   {
            //     Route route = MaterialPageRoute(builder: (c) => UploadPage());
            // Navigator.pushReplacement(context, route);
            //   },
            // ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection("orders")
              .orderBy("orderTime", descending: false)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: EcommerceApp.firestore
                            .collection("users_carts_orders")
                            .where("productId",
                                whereIn: snapshot.data.docs[index]
                                    .get(EcommerceApp.productID))
                            .get(),
                        builder: (c, snaps) {
                          return snaps.hasData
                              ? AdminOrderCard(
                                  itemCount: snaps.data.docs.length,
                                  data: snaps.data.docs,
                                  orderID: snapshot.data.docs[index].id,
                                  orderBy:
                                      snapshot.data.docs[index].get("orderBy"),
                                  addressID: snapshot.data.docs[index]
                                      .get("addressID"),
                                )
                              : Center(
                                  child: circularProgress(),
                                );
                        },
                      );
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
