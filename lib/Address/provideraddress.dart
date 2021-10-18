import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class ProviderAddress {
  List<dynamic> getOption = [];
  ProviderAddress() {
    loadData();
  }

  Future<List<dynamic>> loadData() async {
    final value = await rootBundle.loadString("json/address.json");
    Map datos = json.decode(value);
    getOption = datos["0"];

    return getOption;
  }
}

final addressProvider = new ProviderAddress();



  

