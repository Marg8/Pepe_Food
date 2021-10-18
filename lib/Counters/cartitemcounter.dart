import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Config/config.dart';


class CartItemCounter extends ChangeNotifier {
  int _counter =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList) !=
              null
          ? EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList).length - 1
          : 0;
  int get count => _counter;

  Future<void> displayResult() async {
     int _counter =
      EcommerceApp.sharedPreferences.getStringList(EcommerceApp.userCartList) !=
              null
          ? EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length -
              1
          : 0;

    await Future.delayed(const Duration(microseconds: 100), () {
      notifyListeners();
    });
  }
  
}
