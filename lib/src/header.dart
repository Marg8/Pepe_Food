import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Store/Search.dart';
import 'package:flutter/material.dart';

import '../Widgets/loadingWidget.dart';

class Header extends StatefulWidget {
  

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children:[
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: size.height / 5,
                  decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(45)
                  ),
                  boxShadow: [
                    BoxShadow( blurRadius: 2),
                  ]  
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 20,),
                        
                        CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 35,
                        child: CircleAvatar(onBackgroundImageError: null ,
                      //     backgroundImage: NetworkImage(
                      //    EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                      //  ),
                          radius: 32,
                        ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          children: [
                            // Text(EcommerceApp.sharedPreferences.getString(EcommerceApp.userName), 
                            // style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.orange
                              ),
                              child: Text("Premium User",
                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 11),),
                            ),
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
                SizedBox(height: 20,)
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        onTap: (){
                          Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                           Navigator.push(context, route);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Buesqueda avanzada",
                          suffixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.only(left: 20)
                        ),                      
                      ),
                    ),
                  ),
                )

            ]
          ),
        ]
       ),
    );
      
  }
}