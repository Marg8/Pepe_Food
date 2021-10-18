import 'package:pepe_food/Config/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartListOrder extends ChangeNotifier {
  Future getdata(List<int> cart) async {
    QuerySnapshot snap = await EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList)
        .get();

    snap.docs.forEach((document) {
      final cart = document.id;
      print(cart);
      return cart;
    });
     await Future.delayed(const Duration(microseconds: 100), () {
      notifyListeners();
    });
  }
}
