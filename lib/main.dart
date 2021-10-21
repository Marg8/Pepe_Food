import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:pepe_food/Counters/orderNumberProvider.dart';
import 'package:pepe_food/Authentication/authenication.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Counters/ItemQuantity.dart';
import 'package:pepe_food/Counters/cartitemcounter.dart';
import 'package:pepe_food/Counters/categoryProvider.dart';
import 'package:pepe_food/Counters/changeAddresss.dart';
import 'package:pepe_food/Counters/totalMoney.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/Models/producto_model.dart';
import 'package:pepe_food/Store/cart.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';
import 'package:pepe_food/Widgets/myDrawer.dart';
import 'package:pepe_food/src/categories.dart';
import 'package:pepe_food/src/hamburgers_list.dart';
import 'package:pepe_food/src/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;

  return runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ProductoModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsService()),
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
        ChangeNotifierProvider(create: (c) => OrderNumberNotifier()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            cardColor: Colors.white,
            appBarTheme: AppBarTheme(color: Colors.yellow, centerTitle: true),
            bottomAppBarColor: Colors.yellow,
            floatingActionButtonTheme:
                FloatingActionButtonThemeData(backgroundColor: Colors.black)),
        home: SplashScreen(),
        // routes: {BurgerPage.tag: (_)=>BurgerPage()},
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Hamburger extends StatefulWidget {
  @override
  _HamburgerState createState() => _HamburgerState();
}

class _HamburgerState extends State<Hamburger> {
  @override
  Widget build(BuildContext context) {
    final newsService = Provider.of<NewsService>(context, listen: false);
    print(newsService.selectedCategory);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: Icon(
                    Icons.list,
                    color: Colors.black,
                  ));
            }),
            pinned: true,
            title: Text(
              "Pepe Food",
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            // leading: IconButton(icon:Icon(Icons.menu), onPressed: (){

            // }),
            actions: [
              // AgregadosCompras(),
            ],
          ),
          Header(),
          Categories(),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .limit(100)
                  .where("category", isEqualTo: newsService.selectedCategory)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: Container(
                            height: 240,
                            margin: EdgeInsets.only(top: 10),
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                ItemModel model = ItemModel.fromJson(
                                    dataSnapshot.data.docs[index].data());
                                return sourceInfoBurger(model, context);
                              },
                              itemCount: dataSnapshot.data.docs.length,
                            )));
              }),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
                  color: Colors.black,
                  onPressed: () {
                    _mostrarAlerta(context);
                  }),
              Spacer(),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.turned_in),
                  color: Colors.black,
                  onPressed: () {
                    _mostrarAlerta(context);
                  }),
              Spacer(),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

void _mostrarAlerta(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text("Titulo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Contenido de prueba de contenedor...."),
              FlutterLogo(
                size: 100.0,
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ]);
    },
  );
}

class AgregadosCompras extends StatelessWidget {
  const AgregadosCompras({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(
            Icons.shopping_bag,
            color: Colors.white,
          ),
          onPressed: () {
            Route route = MaterialPageRoute(builder: (c) => CartPage());
            Navigator.push(context, route);
          },
        ),
        Positioned(
          child: Stack(
            children: [
              Icon(
                Icons.brightness_1,
                size: 20.0,
                color: Colors.white,
              ),

              //Video 11 o 19
              //falta determinar la funcion de este indicador
              Positioned(
                top: 3.0,
                bottom: 4.0,
                left: 4.0,
                child: Consumer<CartItemCounter>(
                  builder: (context, counter, _) {
                    return Text(0.toString());
                    // Text(
                    //   (EcommerceApp.sharedPreferences
                    //               .getStringList(EcommerceApp.userCartList)
                    //               .length -
                    //           1)
                    //       .toString(),
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 12.0,
                    //       fontWeight: FontWeight.w500),
                    // );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 3), () async {
      if (EcommerceApp.auth.currentUser != null) {
        Route route = MaterialPageRoute(builder: (_) => Hamburger());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/mini-van.png",
                height: 200.0,
                width: 240.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Don Pepe Food",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Servicio de Comida",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
