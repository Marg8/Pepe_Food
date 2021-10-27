import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Store/Search.dart';
import 'package:flutter/material.dart';

import '../Widgets/loadingWidget.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  DataBase db;
  List docs = [];
  initialise() {
    db = DataBase();
    db.initiliase();
    db.getData().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    // user.initData(100);
    super.initState();
    initialise();
    // _cargarReferencias();
    db.getData().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SliverList(
      delegate: SliverChildListDelegate([
        Stack(children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: size.height / 5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(45)),
                    boxShadow: [
                      BoxShadow(blurRadius: 2),
                    ]),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Donde esta Don Pepe?",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "En: ",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        _getTitleItemWidget2(context, "locacion"),
                      ],
                    ),
                    Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          image: DecorationImage(
                              image: AssetImage("images/mini-van.png"),
                              fit: BoxFit.cover)),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                        ),

                        SizedBox(width: 5),
                        Column(
                          children: [
                            // Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                            // style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          ],
                        ),
                        Spacer(),
                        // Text("\$150 pesos",
                        // style: TextStyle(
                        // color: Colors.white,fontWeight: FontWeight.bold,
                        // fontSize: 18),)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              height: 50,
              child: Card(
                color: Colors.white,
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.push(context, route);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Buesqueda avanzada",
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(left: 20)),
                ),
              ),
            ),
          )
        ]),
      ]),
    );
  }

  Widget _getTitleItemWidget2(
    BuildContext context,
    String label,
  ) {
    final course =
        EcommerceApp.firestore.collection("location_Admin").snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: course,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 100,
          );
        }
        // final datat = snapshot.requireData;
       
        return Container(
          
          height: 50,
          width: 200,
          child: ListView.builder(
            padding: EdgeInsets.only(top: 14),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Text(snapshot.data.docs[0][label].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.blueGrey[700]));
              
            },
            
          ),
        );
        
      },
    );
  }
}

class DataBase {
  FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<List> getData() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot = await firestore.collection("location_Admin").get();
      if (querySnapshot.docs.isNotEmpty) {
        final docs = querySnapshot.docs;

        return docs;
      }
    } catch (e) {
      print(e);
    }
  }
}
