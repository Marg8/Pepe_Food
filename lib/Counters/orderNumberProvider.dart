import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderNumberNotifier extends ChangeNotifier {
  int _orderNumber = 0;

  int get orderNumber => _orderNumber;

  display(int no) async {
    _orderNumber = no;

    await Future.delayed(const Duration(microseconds: 1), () {
      notifyListeners();
    });
  }
}
