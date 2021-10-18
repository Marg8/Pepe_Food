import 'package:pepe_food/Counters/cartitemcounter.dart';
import 'package:pepe_food/Counters/orderNumberProvider.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pepe_food/Config/config.dart';
import '../Config/config.dart';

bool payment = true;
ItemModel model;

class PaymentPage extends StatefulWidget {
  final String addressId;
  final double totalAmount;
  final double cost;

  PaymentPage({
    Key key,
    this.addressId,
    this.totalAmount,
    orderNumber, this.cost,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List cart =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartListID);

  int orderNumber;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Consumer<OrderNumberNotifier>(
            builder: ((context, orderProvider, c) {
              FirebaseFirestore.instance
                  .collection("order_history")
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                querySnapshot.docs.forEach((doc) => querySnapshot.docs.length);

                setState(() {
                  final orderNumber = querySnapshot.docs.length;
                  WidgetsBinding.instance.addPostFrameCallback((c) {
                    Provider.of<OrderNumberNotifier>(context, listen: false)
                        .display(orderNumber);
                  });
                });
              });

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => null,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent),
                      child: Text(
                          "Entrega a Domicilio #${orderProvider.orderNumber.toInt() + 1}",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset("images/delvham.png"),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextButton(
                    onPressed: () => Null,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.transparent),
                      child: Text(
                        "Seleccionar Forma de Pago",
                        style: TextStyle(fontSize: 30.0, color: Colors.brown),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          addOrderDetails(
                              "Pago en Efectivo",
                              "${orderProvider.orderNumber.toInt() + 1}/" +
                                  EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userName),
                              model);
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange),
                          child: Text(
                            "Pargar en Efectivo",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          addOrderDetails(
                              "Pago Electronico",
                              "${orderProvider.orderNumber.toInt() + 1}/" +
                                  EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userName),
                              model);
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.orange),
                          child: Text(
                            "Pargar con Tarjeta",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          addOrderDetails(
                              "Pagar en Efectivo",
                              "${orderProvider.orderNumber.toInt() + 1}/" +
                                  EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userName),
                              model);
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.brown,
                            size: 100,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      TextButton(
                        onPressed: () {
                          addOrderDetails(
                              "Pago Electronico",
                              "${orderProvider.orderNumber.toInt() + 1}/" +
                                  EcommerceApp.sharedPreferences
                                      .getString(EcommerceApp.userName),
                              model);
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.transparent),
                          child: Icon(
                            Icons.credit_card_rounded,
                            color: Colors.brown,
                            size: 100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  addOrderDetails(String paymentMethod, orderNumberC, ItemModel model) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList2)
        .get();

    writeOrderDetailsForUser({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "cost": widget.cost,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListID),
      EcommerceApp.paymentDetails: paymentMethod,
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      "orderNumber": orderNumberC,
    });

    writeOrderDetailsForAdmin({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "cost": widget.cost,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListID),
      EcommerceApp.paymentDetails: paymentMethod,
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      "orderNumber": orderNumberC,
    }).whenComplete(() => {
          cartDataOrder(cart),
          cartDataUsersOrders(cart),
          emptyCartNowID(),
          emptyCartNow(),
        });

    writeOrderDetailsForAdminHistory({
      EcommerceApp.addressID: widget.addressId,
      EcommerceApp.totalAmount: widget.totalAmount,
      "cost": widget.cost,
      "orderBy": EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID),
      EcommerceApp.productID: EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartListID),
      EcommerceApp.paymentDetails: paymentMethod,
      EcommerceApp.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      EcommerceApp.isSuccess: true,
      "orderNumber": orderNumberC,
    });
  }

  emptyCartNow() {
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
    List tempList =
        EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList);

    FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartList: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Felizidades, Tu Ordern ha sido Recibida.");

    Route route = MaterialPageRoute(builder: (c) => Hamburger());
    Navigator.push(context, route);
  }

  emptyCartNowID() {
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartListID, ["garbageValue"]);
    List tempList = EcommerceApp.sharedPreferences
        .getStringList(EcommerceApp.userCartListID);

    FirebaseFirestore.instance
        .collection("users")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .update({
      EcommerceApp.userCartListID: tempList,
    }).then((value) {
      EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartListID, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
    Fluttertoast.showToast(msg: "Felizidades, Tu Ordern ha sido Recibida.");

    Route route = MaterialPageRoute(builder: (c) => Hamburger());
    Navigator.push(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection(EcommerceApp.collectionOrders)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForAdminHistory(Map<String, dynamic> data) async {
    await EcommerceApp.firestore
        .collection("order_history")
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID) +
            data['orderTime'])
        .set(data);
  }

  paymentDetails(String payment) {
    setState(() {
      return payment;
    });
    print(payment);
  }
}

//  Future getdata(List<int> cart) async {
//     QuerySnapshot snap = await EcommerceApp.firestore
//         .collection(EcommerceApp.collectionUser)
//         .document(
//             EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//         .collection(EcommerceApp.userCartList)
//         .getDocuments();

//     snap.documents.forEach((document) {
//       final cart = document.documentID;
//       print(cart);
//       return cart;
//     });
//   }

Future cartDataOrder(List cart) async {
  WriteBatch batch = EcommerceApp.firestore.batch();

  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection(EcommerceApp.userCartList2)
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((productId) {
      try {
        if (cart.contains(productId.id.toString())) {
          batch.update(productId.reference, {"status": "Order"});
        }
      } on FormatException catch (error) {
        print("The document ${error.source} could not be parsed.");
        return null;
      }
    });
    return batch.commit();
  });
}

Future cartDataUsersOrders(List cart) async {
  WriteBatch batch = EcommerceApp.firestore.batch();

  EcommerceApp.firestore
      .collection("users_carts_orders")
      .get()
      .then((querySnapshot) {
    querySnapshot.docs.forEach((productId) {
      try {
        if (cart.contains(productId.id.toString())) {
          batch.update(productId.reference, {"status": "Order"});
        }
      } on FormatException catch (error) {
        print("The document ${error.source} could not be parsed.");
        return null;
      }
    });
    return batch.commit();
  });
}

//   CollectionReference _collectionRef =
//      EcommerceApp.firestore
//         .collection(EcommerceApp.collectionUser)
//         .document(
//             EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//         .collection(EcommerceApp.userCartList);

// Future<void> getData() async {
//     // Get docs from collection reference
//     QuerySnapshot querySnapshot = await _collectionRef.get();

//     // Get data from docs and convert map to List
//     final allData = querySnapshot.documents.
//     map((doc) => doc.data).toList();

//     print(allData);
// }

//intentos
// List<int> get cart {
//   EcommerceApp.firestore
//       .collection(EcommerceApp.collectionUser)
//       .document(
//           EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//       .collection(EcommerceApp.userCartList)
//       .getDocuments();

// }

// Future get cart async {
//   QuerySnapshot snap = await EcommerceApp.firestore
//       .collection(EcommerceApp.collectionUser)
//       .document(
//           EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//       .collection(EcommerceApp.userCartList)
//       .getDocuments();

//       for (int i = 0; i < snap.documents.length; i++) {
//         var a = snap.documents[i];
//         print(a.documentID);
//         return a.documentID;
//       }

//   // final List cart = snap.documents;

//   // snap.documents.forEach((document) {
//   //   final cart = document.documentID.toString();

//   //   return cart;
//   // });

// }

// Future getDocs(List<int> cart) async {
//   QuerySnapshot querySnapshot = await EcommerceApp.firestore
//       .collection(EcommerceApp.collectionUser)
//       .document(
//           EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
//       .collection(EcommerceApp.userCartList)
//       .getDocuments();
//   for (int i = 0; i < querySnapshot.documents.length; i++) {
//     var a = querySnapshot.documents[i];
//     print(a.documentID);
//     final cart = a.documentID;
//     return cart;
//   }
// }

//   List<int> cart = [
// 1615791984072,1615791987965

// ];
