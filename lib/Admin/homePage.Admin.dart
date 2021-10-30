import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pepe_food/Admin/adminShifOrders1.dart';
import 'package:pepe_food/Admin/updateItems.dart';
import 'package:pepe_food/Admin/uploadItems.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Models/address.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/Models/request.dart';
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
      backgroundColor: Colors.blue[200],
             
        
        appBar: AppBar(

          title: Text(
            "Inicio",
            style: TextStyle(color: Colors.black),
          ),
          flexibleSpace: Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.blueGrey, Colors.blue[100]],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          leading: IconButton(iconSize: 50,
            icon: Icon(
              Icons.food_bank,
              color: Colors.black,
            ),
            onPressed: () {
               Route route = MaterialPageRoute(builder: (c) => UploadPage());
              Navigator.push(context, route);
            },
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
                
                Navigator.pop(context);
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
  get myLocacion => _locacion != null ? _locacion : "";

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
        ReqTitle(),
        ReqList(size: size),
        // Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("images/star.jpg"), fit: BoxFit.cover),
        //   ),
        //   height: 50,
        //   width: size.width,
        //   child: TextButton(
        //     child: Text(
        //       "Pagina de productos",
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 20),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Container MyLocation(Size size) {
    return Container(
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey, Colors.blue[100]],
      ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight:Radius.circular(30)),
      //   image: DecorationImage(
      //       image: AssetImage("images/star.jpg"), fit: BoxFit.cover),
      // ),
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
                        child: ButtonTheme(
                          disabledColor: null,
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            dropdownColor: Colors.grey,
                            value: _locacion,
                            iconSize: 30,
                            icon: Icon(
                              Icons.location_city,
                              color: Colors.white,
                            ),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            hint: Text('Locacion',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            onChanged: (String newValue) {
                              setState(() {
                                _locacion = newValue;

                                print(_locacion);
                              });
                              final model = AddressModel(
                                locacion: _locacion.toString(),
                                ciudad: "H.Matamoros",
                                colonia: "Ejido Las Ventanas",
                                estado: "Tamaulimas",
                                addressID: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                              ).toJson();

                              //add to firebase
                              EcommerceApp.firestore
                                  .collection("location_Admin")
                                  .doc("myLocation")
                                  .set(model)
                                  .then((value) {
                                final snack1 = ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text("Locacion Actulizada.")));
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
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
            "Los Clientes Saben que estas en",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "$myLocacion",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8,)
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

  ReqTitle() {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //       image: AssetImage("images/star.jpg"), fit: BoxFit.cover),
      // ),
      child: Row(children: [
        SizedBox(width:30),
        Text("Solicitudes de Clientes",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        Spacer(),
      ]),
    );
  }
}

class ReqList extends StatelessWidget {
  const ReqList({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Flexible(
      child: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage("images/star.jpg"), fit: BoxFit.cover),
        // ),
        child: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore
              .collection("request")
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.docs.map((req) {
                  if (snapshot != null) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                        top: 5,
                        left: 20,
                        right: 20,
                      ),
                      child: Container(
                        height: 100,
                        
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueGrey, Colors.blue[100]],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 15),
                                Text("Nombre:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                SizedBox(width: 10),
                                Text(req["user"].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                SizedBox(width: 15),
                                Text("Locacion:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                SizedBox(width: 10),
                                Text(req["locacion"].toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                SizedBox(width: 15),
                                Text("Hora:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                SizedBox(width: 10),
                                Text(
                                  DateFormat.Md().format(req["time"].toDate()),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(" -- "),
                                Text(
                                    DateFormat.jm()
                                        .format(req["time"].toDate()),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    circularProgress();
                  }
                }).toList(),
              );
            }
            return circularProgress();
          },
        ),
      ),
    );
  }
}

Widget sourceInfoRequest(Request modelReq, BuildContext context) {
  final Size size = MediaQuery.of(context).size;
  return Container(
      color: Colors.blue,
      height: size.height,
      width: size.width,
      child: Row(
        children: [Text(modelReq.user.toString())],
      ));
}
