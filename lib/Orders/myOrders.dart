import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Store/storehome.dart';
import 'package:pepe_food/Widgets/myDrawer.dart';
import 'package:pepe_food/Widgets/orderCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Widgets/loadingWidget.dart';
import '../main.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.teal, Colors.teal],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "Lista de Ordenes",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => StoreHome());
                Navigator.push(context, route);
              },
            ),
          ],
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection(EcommerceApp.collectionUser)
              .doc(EcommerceApp.sharedPreferences
                  .getString(EcommerceApp.userUID))
              .collection(EcommerceApp.collectionOrders)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                        future: EcommerceApp.firestore
                            .collection(EcommerceApp.collectionUser)
                            .doc(EcommerceApp.sharedPreferences
                                .getString(EcommerceApp.userUID))
                            .collection(EcommerceApp.userCartList2)
                            .where("productId",
                                whereIn: snapshot.data.docs[index]
                                    .get(EcommerceApp.productID))
                            .get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? OrderCard(
                                  itemCount: snap.data.docs.length,
                                  data: snap.data.docs,
                                  orderID:
                                      snapshot.data.docs[index].id,
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
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => Hamburger());
            Navigator.push(context, route);
          },
          child: Icon(Icons.home),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Row(
              children: [
                Spacer(),
                IconButton(
                    icon: Icon(Icons.add_alert),
                    color: Colors.white,
                    onPressed: () {}),
                Spacer(),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.turned_in),
                    color: Colors.white,
                    onPressed: () {}),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
