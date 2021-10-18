// import 'package:pepe_food/Config/config.dart';
// import 'package:flutter/material.dart';

// class BurgerPage extends StatefulWidget {
//   static const tag = "Buger_Page";
//   @override
//   _BurgerPageState createState() => _BurgerPageState();
// }

// class _BurgerPageState extends State<BurgerPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: CustomScrollView(slivers: [
//       SliverAppBar(
//         pinned: true,
//         title: Avatar(),
//         leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
//         actions: [IconButton(icon: Icon(Icons.shopping_bag), onPressed: () {})],
//       ),
//       header(context),
//     ]));
//   }
// }

// Widget header(context) {
//   Size size = MediaQuery.of(context).size;

//   return SliverList(
//       delegate: SliverChildListDelegate([
//     Stack(children: [
//       Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             height: size.height / 5,
//             decoration: BoxDecoration(
//                 color: Colors.teal,
//                 borderRadius:
//                     BorderRadius.vertical(bottom: Radius.circular(10)),
//                 boxShadow: [
//                   BoxShadow(blurRadius: 2),
//                 ]),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(
//                       height: 20,
//                     ),

//                     SizedBox(width: 5),
//                     Column(
//                       children: [],
//                     ),
//                     Spacer(),
//                     // Text("\$150 pesos",
//                     // style: TextStyle(
//                     // color: Colors.white,fontWeight: FontWeight.bold,
//                     // fontSize: 18),)
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     ])
//   ]));
// }

