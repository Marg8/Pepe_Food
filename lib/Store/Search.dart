import 'package:pepe_food/Admin/uploadItems.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/Store/storehome.dart';
import 'package:pepe_food/Widgets/myDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Widgets/customAppBar.dart';
import '../main.dart';

class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
              child: searchWidget(), preferredSize: Size(56.0, 56.0)),
        ),
        drawer: MyDrawer(),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.docs.length,
                    itemBuilder: (context, index) {
                      ItemModel model =
                          ItemModel.fromJson(snap.data.docs[index].data());

                      return sourceInfo(model, context);
                    },
                  )
                : Text("Escriba en Area de buscador para ontener informacion");
          },
        ),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => Hamburger());
            Navigator.push(context, route);
          },
          child: Icon(Icons.home),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Row(
              children: [
                Spacer(),
                IconButton(
                    icon: Icon(Icons.add_alert),
                    color: Colors.white,
                    onPressed: () {}),
                Spacer(),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.turned_in),
                    color: Colors.white,
                    onPressed: () {}),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.yellow, Colors.yellow],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value) {
                    startSearching(value);
                    
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Busqueda Avanzada"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) {
    docList = FirebaseFirestore.instance
        .collection("items")
        .where("title", isGreaterThanOrEqualTo: query)
        .get();
    return docList;
    
  }
  
}

class SearchProductAdmin extends StatefulWidget {
  @override
  _SearchProductAdminState createState() => new _SearchProductAdminState();
}

class _SearchProductAdminState extends State<SearchProductAdmin> {
  Future<QuerySnapshot> docListA;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
              child: searchWidget1(), preferredSize: Size(56.0, 56.0)),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: docListA,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.docs.length,
                    itemBuilder: (context, index) {
                      ItemModel model =
                          ItemModel.fromJson(snap.data.docs[index].data());

                      return sourceInfoAdmin(model, context);
                    },
                  )
                : Text("Escriba en Area de buscador para ontener informacion");
          },
        ),
      ),
    );
  }

  Widget searchWidget1() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.yellow, Colors.yellow],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (query) {
                    // startSearching1(query);
                    print("Print 2 ----------$docListA");
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Busqueda Avanzada"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<QuerySnapshot> startSearching1(
    String query,
  ) {
    docListA = FirebaseFirestore.instance
        .collection("items")

        .get();

    return docListA;
  }
}
