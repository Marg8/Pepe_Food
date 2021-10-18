import 'package:flutter/material.dart';

class ProductoModel with ChangeNotifier{

  String _assetImage = "images/azul.png";
  double _talla = 7.5;

  String get assetImage => this._assetImage;
  set assetImage(String valor){
    this._assetImage = valor;
    notifyListeners();
  }

  double get talla => this._talla;
  set talla(double valor){
    this._talla = valor;
    notifyListeners();
  }
}