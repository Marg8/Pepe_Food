import 'package:pepe_food/Address/provideraddress.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Models/address.dart';
import 'package:pepe_food/Widgets/customAppBar.dart';
import 'package:pepe_food/Widgets/myDrawer.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final cName = TextEditingController();

  final cPhoneNumber = TextEditingController();

  final cFlatHomeNumber = TextEditingController();

  final cCity = TextEditingController();

  final cState = TextEditingController();

  final cPinCode = TextEditingController();

  final cCost = TextEditingController();
  String _nombre = "";
  String _codigoPostalText = "";

  @override
  void initState() {
    _getCodigoPostal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();

    return SafeArea(
      child: Scaffold(
        key: scaffoldMessengerKey,
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_codigoPostal.isNotEmpty) {
              final model = AddressModel(
                locacion: _codigoPostal.toString(),
                colonia: _colonia.toString(),
                ciudad: _ciudad.toString(),
                estado: _estado.toString(),
                addressID: DateTime.now().millisecondsSinceEpoch.toString(),
              ).toJson();

              //add to firebase
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(model)
                  .then((value) {
                final snack1 = ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Nueva Direccion Agregada Exitosamente.")));
                print(snack1);
                //No se necesita esta linea Cuando se implementa ScaffoldMessenger
                //scaffoldMessengerKey.currentState.showSnackBar(snack1);
                FocusScope.of(context).requestFocus(FocusNode());
                
              });
            }
          },
          label: Text("Listo"),
          backgroundColor: Colors.black,
          icon: Icon(Icons.check),
        ),
        body: ListView(
          children: [
            Column(
              children: <Widget>[
               
                Row(
                  children: [
                   
                    buildCodigoPostal(),
                  ],
                ),
               
                SizedBox(
                  height: 5,
                ),
                buildColonia(),
                
                SizedBox(
                  height: 5,
                ),
                buildCiudad(),
                SizedBox(
                  height: 5,
                ),
                buildEstado()
              ],
            ),
          ],
        ),
      ),
    );
  }


  // Widget buildInputoCode() {
  //   return Padding(
  //     padding: EdgeInsets.all(8.0),
  //     child: Container(
  //       width: 150,
  //       child: TextFormField(
  //         textCapitalization: TextCapitalization.sentences,
  //         validator: (val) =>
  //             val.isEmpty ? "No Puede Dejar Campos Vacios" : null,
  //         onFieldSubmitted: (valor) {
  //           setState(() {
  //             _codigoPostal = valor;
  //             print(_codigoPostal);
  //             _getColoniaList();
  //             _getCostoList();
  //             _colonia = null;
  //             _costo = null;
  //           });
  //         },
  //         decoration: InputDecoration(
  //           border:
  //               OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
  //           hintText: "87413",
  //           labelText: "CP",
  //           suffixIcon: Icon(Icons.filter_center_focus_rounded),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Container buildCodigoPostal() {
    return Container(
      width: 230,
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _codigoPostal,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Locacion'),
                  onChanged: (String newValue) {
                    setState(() {
                     
                     
                      _codigoPostal = newValue;
                 
                      print(_codigoPostal);
                    });
                  },
                  items: getOption?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item["Código Postal"].toString()),
                          value: item["Código Postal"].toString(),
                        );
                      })?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildColonia() {
   return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _colonia,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Colonia'),
                  onChanged: (String newValue) {
                    setState(() {
                      _colonia = newValue;
                      print(_colonia);
                      // _getEstadoList();
                    });
                  },
                  items: coloniaList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text("Parque Las Ventanas".toString()),
                          value: "Parque Las Ventanas".toString(),
                        );
                      })?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Container buildCiudad() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _ciudad,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Ciudad'),
                  onChanged: (String newValue) {
                    setState(() {
                      _ciudad = newValue;
                      print(_ciudad);
                      // _getEstadoList();
                    });
                  },
                  items: ciudadList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text("Matamoros".toString()),
                          value: "Matamoros".toString(),
                        );
                      })?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildEstado() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _estado,
                  iconSize: 30,
                  icon: (null),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: Text('Estado'),
                  onChanged: (String newValue) {
                    setState(() {
                      _estado = newValue;
                      print(_estado);
                    });
                  },
                  items: estadoList?.map((item) {
                        return new DropdownMenuItem(
                          child: new Text("Tamaulipas, Mex.".toString()),
                          value: "Tamaulipas, Mex.".toString(),
                        );
                      })?.toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _codigoPostal;
  List getOption;
  Future<String> _getCodigoPostal() async {
    await rootBundle.loadString("json/address.json").then((response) {
      Map datos = json.decode(response);

      setState(() {
        getOption = datos["0"];
      });
    });
  }

  // String _colonia;
  // List coloniaList;
  // Future<String> _getColoniaList() async {
  //   await rootBundle.loadString("json/address.json").then((response) {
  //     Map datos = json.decode(response);

  //     setState(() {
  //       coloniaList = datos[_codigoPostal];
  //     });
  //   });
  // }

  String _costo;
  List costoList;
  Future<String> _getCostoList() async {
    await rootBundle.loadString("json/address.json").then((response) {
      Map datos = json.decode(response);

      setState(() {
        costoList = datos[_codigoPostal];
      });
    });
  }

  String _ciudad = "Matamoros";
  List ciudadList = ["Matamoros"];
  // Future<String> _getCiudadList() async {
  //   await rootBundle.loadString("json/addressdata.json").then((response) {
  //     Map datos = json.decode(response);

  //     setState(() {
  //       ciudadList = datos[_codigoPostal];
  //     });
  //   });
  // }
  String _colonia = "Parque Las Ventanas";
  List coloniaList = ["Parque Las ventanas"];

  String _estado = "Tamaulipas, Mex.";
  List estadoList = ["Tamaulipas, Mex."];
  // Future<String> _getEstadoList() async {
  //   await rootBundle.loadString("json/addressdata.json").then((response) {
  //     Map datos = json.decode(response);

  //     setState(() {
  //       estadoList = datos[_codigoPostal];
  //     });
  //   });
  // }

}

class AddInput extends StatelessWidget {
  const AddInput({
    Key key,
    @required this.formKey,
    @required this.cName,
    @required this.cPhoneNumber,
    @required this.cFlatHomeNumber,
    @required this.cCity,
    @required this.cState,
    @required this.cPinCode,
    @required this.cCost,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController cName;
  final TextEditingController cPhoneNumber;
  final TextEditingController cFlatHomeNumber;
  final TextEditingController cCity;
  final TextEditingController cState;
  final TextEditingController cPinCode;
  final TextEditingController cCost;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Agregar Direccion Para Entrega",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                MyTextField(
                  hint: "Nombre Completo",
                  controller: cName,
                  icon: Icons.accessibility,
                ),
                MyTextField(
                  hint: "Numero de Celular",
                  controller: cPhoneNumber,
                  icon: Icons.phone,
                ),
                MyTextField(
                  hint: "Calle, Numero de Casa",
                  controller: cFlatHomeNumber,
                  icon: Icons.home,
                ),
                // MyTextField(
                //   hint: "Ciudad",
                //   controller: cCity,
                // ),
                // MyTextField(
                //   hint: "Estado, Pais",
                //   controller: cState,
                // ),
                // MyTextField(
                //   hint: "Codigo Postal",
                //   controller: cPinCode,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final IconData icon;

  MyTextField({
    Key key,
    this.hint,
    this.controller,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        validator: (val) => val.isEmpty ? "No Puede Dejar Campos Vacios" : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: hint,
          labelText: hint,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }
}

deleteAddress(BuildContext context, String addressID) {
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection(EcommerceApp.subCollectionAddress)
      .doc(addressID)
      .delete();

  Fluttertoast.showToast(msg: "Direccion Borrada");
}
