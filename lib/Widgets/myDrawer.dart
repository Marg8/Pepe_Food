import 'package:pepe_food/Address/addAddress.dart';
import 'package:pepe_food/Orders/myOrders.dart';
import 'package:pepe_food/Store/Search.dart';
import 'package:pepe_food/Store/cart.dart';
import 'package:pepe_food/main.dart';
import 'package:flutter/material.dart';
import '../Authentication/authenication.dart';
import '../Config/config.dart';


class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.white30,Colors.white],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
              ),
             child: Column(
               children: [
                 Material(
                   borderRadius: BorderRadius.all(Radius.circular(80.0)),
                   elevation: 8.0,
                   child: Container(
                     height: 160.0,
                       width: 160.0,
                    //  child: CircleAvatar(
                    //    backgroundImage: NetworkImage(
                    //      EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                    //    ),
                    //  ),
                   ),
                 ),
                 SizedBox(height: 10.0,),
                //  Text(
                //    EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                //    style: TextStyle(color: Colors.black, fontSize: 35.0, fontFamily: "Signatra"),
                //  ),
               ],
              ),
            ),
          SizedBox(height: 0.0,),
          Divider(height: 0.0, color: Colors.black, thickness: 4.0,),
          Container(
              padding: EdgeInsets.only(top: 1.0),
              decoration: new BoxDecoration(
              gradient: new LinearGradient(
              colors: [Colors.white30,Colors.white],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
              ),
              ),
              child: Column(
                 children: [
                   ListTile(
                     leading: Icon(Icons.home, color: Colors.black,),
                     title: Text("Inicio", style: TextStyle(color: Colors.black),),
                     onTap: (){
                       Route route = MaterialPageRoute(builder: (c) => Hamburger());
                       Navigator.push(context, route);
                     },
                   ),
                   Divider(height: 10.0, color: Colors.black, thickness: 4.0,),

                   ListTile(
                     leading: Icon(Icons.reorder, color: Colors.black,),
                     title: Text("Mis Ordenes", style: TextStyle(color: Colors.black),),
                     onTap: (){
                       Route route = MaterialPageRoute(builder: (c) => MyOrders());
                       Navigator.push(context, route);
                     },
                   ),
                   Divider(height: 10.0, color: Colors.black, thickness: 4.0,),

                   ListTile(
                     leading: Icon(Icons.shopping_cart, color: Colors.black,),
                     title: Text("Mi Carrito", style: TextStyle(color: Colors.black),),
                     onTap: (){
                       Route route = MaterialPageRoute(builder: (c) => CartPage());
                       Navigator.push(context, route);
                     },
                   ),
                   Divider(height: 10.0, color: Colors.black, thickness: 4.0,),

                   ListTile(
                     leading: Icon(Icons.search, color: Colors.black,),
                     title: Text("Busqueda Avanzada", style: TextStyle(color: Colors.black),),
                     onTap: (){
                       Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                       Navigator.push(context, route);
                     },
                   ),
                   Divider(height: 10.0, color: Colors.black, thickness: 4.0,),

                   ListTile(
                     leading: Icon(Icons.add_location, color: Colors.black,),
                     title: Text("Agregar Nueva Direccion", style: TextStyle(color: Colors.black),),
                     onTap: (){
                       Route route = MaterialPageRoute(builder: (c) => AddAddress());
                       Navigator.push(context, route);
                     },
                   ),
                   Divider(height: 10.0, color: Colors.black, thickness: 4.0,),

                   ListTile(
                     leading: Icon(Icons.exit_to_app, color: Colors.black,),
                     title: Text("Cerrar Sesion", style: TextStyle(color: Colors.black),),
                     onTap: (){
                       EcommerceApp.auth.signOut().then((c) {
                         Route route = MaterialPageRoute(
                             builder: (c) => AuthenticScreen());
                         Navigator.push(context, route);
                       });
                     },
                   ),
                   Divider(height: 10.0, color: Colors.black, thickness: 4.0,),

                 ],
          ),
        ),
        ],
      ),
    );
  }
}
