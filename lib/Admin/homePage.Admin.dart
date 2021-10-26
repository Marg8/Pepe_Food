import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pepe_food/Admin/adminShifOrders1.dart';
import 'package:pepe_food/Admin/updateItems.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/Store/storehome.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';
import 'package:pepe_food/Widgets/searchBox.dart';
import 'package:pepe_food/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

int theme = 0xff009688;

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin>
    with AutomaticKeepAliveClientMixin<HomeAdmin> {
  bool get wantKeepAlive => true;
  File file;

  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;
  final ImagePicker pickerImg = ImagePicker();

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Colors.black,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(9)),
    ),
  );

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Inicio",
            style: TextStyle(color: Colors.black),
          ),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          actions: [
            // goColorList(),

            TextButton(
              child: Text(
                "Salir",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
            ),
          ],
        ),
        body: BodyHome());
  }
}

class BodyHome extends StatefulWidget {
  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  get myLocacion => _locacion != null ? _locacion : "" ;

  @override
  void initState() {
    _getLocacion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        MyLocation(size),
        Container(
          color: Colors.grey,
          height: 200,
          width: size.width,
          child: Text(
            "Lista de Requerimiento",
            style: TextStyle(color: Colors.black),
          ),
        ),
        Container(
          color: Colors.brown,
          height: 200,
          width: size.width,
          child: Text(
            "Pagina de productos",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Container MyLocation(Size size) {
    return Container(margin: EdgeInsets.all(0),padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("images/test1.jpg"),fit: BoxFit.cover),
          ),
                height: 200,
      width: size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Elegir mi Locacion",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Row(
            children: [
              Container(
                width: 240,
                padding: EdgeInsets.only(left: 0, right: 15, top: 5),
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(disabledColor: null,
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                                                       value: _locacion,
                            iconSize: 30,
                            icon: (null),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            hint: Text('Locacion'),
                            onChanged: (String newValue) {
                              setState(() {
                                _locacion = newValue;

                                print(_locacion);
                              });
                            },
                            items: getOption?.map((item) {
                                  return new DropdownMenuItem(
                                    child:
                                        new Text(item["Location"].toString()),
                                    value: item["Location"].toString(),
                                  );
                                })?.toList() ??
                                [],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "images/mini-van.png",
                  height: 100.0,
                  width: 140.0,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            "Los Clientes Saben que estas en $myLocacion",
            style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _locacion;
  List getOption;

  Future<String> _getLocacion() async {
    await rootBundle.loadString("json/location.json").then((response) {
      Map datos = json.decode(response);

      setState(() {
        getOption = datos["0"];
      });
    });
  }
}
