import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Counters/changeAddresss.dart';
import 'package:pepe_food/Models/address.dart';
import 'package:pepe_food/Models/request.dart';
import 'package:pepe_food/Orders/placeOrderPayment.dart';
import 'package:pepe_food/Widgets/customAppBar.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';
import 'package:pepe_food/Widgets/wideButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pepe_food/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addAddress.dart';

class Address extends StatefulWidget {
  final double totalAmount;
  final double cost;
  const Address({Key key, this.totalAmount, this.cost}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {

  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Selecciona tu locacion",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Consumer<AddressChanger>(
              builder: (context, address, c) {
                return Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .doc(EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userUID))
                        .collection(EcommerceApp.subCollectionAddress)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          : snapshot.data.docs.length == 0
                              ? noAddressCard()
                              : ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return AddressCard(
                                      currentIndex: address.count,
                                      value: index,
                                      addressId: snapshot.data.docs[index].id,
                                      
                                      
                                      model: AddressModel.fromJson(
                                          snapshot.data.docs[index].data()),
                                    );
                                  },
                                );
                    },
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("Agregar Nueva Locacion"),
          backgroundColor: Colors.black,
          icon: Icon(Icons.add_location),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => AddAddress());
            Navigator.push(context, route);
          },
        ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.black.withOpacity(0.5),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_location,
              color: Colors.black,
            ),
            Text("No shipment address has been saved."),
            Text(
                "Please add your shipment Adresss so what we can deliever product.")
          ],
        ),
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final String addressId;
  final double totalAmount;
  final int currentIndex;
  final int value;
  final double cost;

  AddressCard(
      {Key key,
      this.model,
      this.currentIndex,
      this.addressId,
      this.totalAmount,
      this.value, this.cost})
      : super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent,
      ),
      onDismissed: (direccion) {
        deleteAddress(context, widget.addressId);
        print(widget.addressId);
      },
      child: InkWell(
        onTap: () {
          Provider.of<AddressChanger>(context, listen: false)
              .displayResult(widget.value);
        },
        child: Card(
          color: Colors.white70,
          child: Column(
            children: [
              Row(
                children: [
                  Radio(
                    groupValue: widget.currentIndex,
                    value: widget.value,
                    activeColor: Colors.black,
                    onChanged: (val) {
                      Provider.of<AddressChanger>(context, listen: false)
                          .displayResult(val);
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: screenWidth * 0.8,
                        child: Table(
                          children: [
                            TableRow(children: [
                              KeyText(
                                msg: "Locacion",
                              ),
                              Text(widget.model.locacion),
                            ]),
                            TableRow(children: [
                              KeyText(
                                msg: "Colonia",
                              ),
                              Text(widget.model.colonia),
                            ]),
                            TableRow(children: [
                              KeyText(
                                msg: "Ciudad",
                              ),
                              Text(widget.model.ciudad),
                            ]),
                         
                            TableRow(children: [
                              KeyText(
                                msg: "Estado",
                              ),
                              Text(widget.model.estado),
                            ]),
                       
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              widget.value == Provider.of<AddressChanger>(context).count
                  ? WideButton(
                      message: "Confirmar",
                      onPressed: () {
                        String name = EcommerceApp.sharedPreferences.getString(EcommerceApp.userName);
                        final model = Request(
                          locacion: widget.model.locacion,
                          user: name,
                          time: Timestamp.now()
                        ).toJson();

                        //add to firebase
                        EcommerceApp.firestore
                            .collection("request")
                            .doc()
                            .set(model)
                            .then((value) {
                          final snack1 = ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  content: Text("Solicitud enviada.")));
                          FocusScope.of(context).requestFocus(FocusNode());

                          Route route =
                              MaterialPageRoute(builder: (c) => Hamburger());
                          Navigator.push(context, route);
                        });
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class KeyText extends StatelessWidget {
  final String msg;

  KeyText({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
