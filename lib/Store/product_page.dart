import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Counters/cartitemcounter.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:pepe_food/Store/storehome.dart';
import 'package:pepe_food/Widgets/loadingWidget.dart';

import 'package:pepe_food/main.dart';
import 'package:pepe_food/src/burger_page.dart';
import 'package:pepe_food/src/categories.dart';
import 'package:pepe_food/src/hamburgers_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

TextEditingController _extraTextEditingController = TextEditingController();
TextEditingController _notaTextEditingController = TextEditingController();

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [
              AgregadosCompras(),
            ],
          ),
          body: buildListView(context)),
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: [
        Container(
          padding: const EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
          width: MediaQuery.of(context).size.width,
          color: Colors.yellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(children: [
                SizedBox(width: 20),
                Text(
                  widget.itemModel.title,
                  style: boldTextStyle1,
                ),
              ]),

              Row(children: [
                SizedBox(width: 20),
                Text(
                  widget.itemModel.shortInfo,
                  style: boldTextStyle,
                ),
              ]),

              Row(children: [
                Container(
                  child: Image.network(
                    widget.itemModel.thumbnailUrl,
                  ),
                  width: 200,
                  height: 200,
                ),
                InofrmacionProducto(widget.itemModel),
              ]),

              SizedBox(height: 20.0),

              MultipleOptions(
                widget: widget,
              ),

              // OnClickforAddToCart(widget: widget),
            ],
          ),
        ),
      ],
    );
  }
}

class InofrmacionProducto extends StatefulWidget {
  final ItemModel itemModel;
  InofrmacionProducto(this.itemModel);

  @override
  _InofrmacionProductoState createState() =>
      _InofrmacionProductoState(this.itemModel);
}

class _InofrmacionProductoState extends State<InofrmacionProducto> {
  _InofrmacionProductoState(this.itemModel);
  final ItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1, bottom: 0, left: 30, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          buildText(),
          SizedBox(
            height: 3.0,
          ),
          Text(
            r"$ " + widget.itemModel.price.toString() + ".0 MXN",
            style: boldTextStyle,
          ),
          SizedBox(
            height: 3.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.white),
              Icon(Icons.star, color: Colors.white),
              Icon(Icons.star, color: Colors.white),
              Icon(Icons.star, color: Colors.white),
              Icon(Icons.star, color: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  Text buildText() {
    setState(() {
      widget.itemModel.qtyitems.toString();
    });
    return Text(
      "Cantidad: " + widget.itemModel.qtyitems.toString(),
      style: boldTextStyle,
    );
  }
}

class MultipleOptions extends StatefulWidget {
  const MultipleOptions({Key key, this.widget});
  final ProductPage widget;

  @override
  _MultipleOptionsState createState() => _MultipleOptionsState();
}

class _MultipleOptionsState extends State<MultipleOptions> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 100, left: 25, right: 25),
        child: Column(
          children: <Widget>[
            TouchPill(),

            SizedBox(height: 16),
            Container(
              child: Text("Descripcion"),
            ),
            SizedBox(height: 20.0),

            Row(
              children: [
                Text(
                  "Ingredientes:",
                  style: boldTextStyle2,
                ),
              ],
            ),

            SizedBox(height: 20.0),
            Text(
              widget.widget.itemModel.longDescription,
              style: largeTextStyle,
            ),
            SizedBox(height: 70),

            buildExtras(),
            SizedBox(height: 20.0),

            buildNota(),
            SizedBox(height: 20.0),

            //controls
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                      onTap: () {
                        checkItemInCart(widget.widget.itemModel.title, context);

                        checkProductIdinCart2(widget.widget.itemModel.title,
                            widget.widget.itemModel, context);
                      },
                      child: AddToCartBottom()),
                ),
                SizedBox(width: 10),
                // Expanded(
                //   child: CantidadProducto(widget.itemModel),
                // ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildNota() {
    return TextField(
      controller: _notaTextEditingController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),

        hintText: "Ejemplo: Sin Verduras",
        labelText: "Nota",

        suffixIcon: Icon(Icons.notes),
        // icon: Text("Nota")
      ),
      onChanged: (valor) {},
    );
  }

  Widget buildExtras() {
    return TextField(
      controller: _extraTextEditingController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),

        hintText: "Ejemplo: Extra Tocino",
        labelText: "Extras",
        helperText: "ingrediente Extra 10 Pesos",
        suffixIcon: Icon(Icons.notes),
        // icon: Text("Nota")
      ),
      onChanged: (valor) {},
    );
  }

  checkProductIdinCart2(
      String tittleAsId, ItemModel model, BuildContext context) {
    EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .contains(tittleAsId.toString())
        ? Fluttertoast.showToast(msg: "Articulo ya existe.")
        : saveItemInfoUserCart2(tittleAsId, model, context);
  }

  saveItemInfoUserCart2(
      String tittleAsId, ItemModel model, BuildContext context) {
    String productId = DateTime.now().millisecondsSinceEpoch.toString();
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
        .collection(EcommerceApp.userCartList2)
        .doc(productId)
        .set({
      "shortInfo": model.shortInfo.toString(),
      "longDescription": model.longDescription.toString(),
      "price": model.price.toInt(),
      "cartPrice": model.price.toInt(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": model.thumbnailUrl,
      "title": model.title.toString(),
      "qtyitems": model.qtyitems.toInt(),
      "productId": productId,
      "extra": _extraTextEditingController.text.toString(),
      "nota": _notaTextEditingController.text.toString(),
    }).whenComplete(() {
      addItemToCart2(productId, context);
      saveUsersOrdersByItem2(model.title, productId, model, context);
    });
  }

  saveUsersOrdersByItem2(
    String tittleAsId,
    productId,
    ItemModel model,
    BuildContext context,
  ) {
    EcommerceApp.firestore.collection("users_carts_orders").doc(productId).set({
      "shortInfo": model.shortInfo.toString(),
      "longDescription": model.longDescription.toString(),
      "price": model.price.toInt(),
      "cartPrice": model.price.toInt(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": model.thumbnailUrl,
      "title": model.title.toString(),
      "qtyitems": model.qtyitems.toInt(),
      "productId": productId,
      "extra": _extraTextEditingController.text.toString(),
      "nota": _notaTextEditingController.text.toString(),
    });
    setState(() {
      _extraTextEditingController.clear();
      _notaTextEditingController.clear();
    });
  }
}

class AddToCartBottom extends StatelessWidget {
  const AddToCartBottom({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange, width: 2),
          borderRadius: BorderRadius.circular(48),
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.orange],
          ),
        ),
        child: Text(
          "Agregar Compra",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// class CantidadProducto extends StatefulWidget {
//   final ItemModel itemModel;
//   CantidadProducto(this.itemModel);

//   @override
//   _CantidadProductoState createState() =>
//       _CantidadProductoState(this.itemModel);
// }

// class _CantidadProductoState extends State<CantidadProducto> {
//   _CantidadProductoState(this.itemModel);
//   final ItemModel itemModel;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 56,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(
//           color: Colors.yellow,
//           width: 2,
//         ),
//       ),
//       child: Row(
//         children: <Widget>[
//           Container(
//             width: 50.0,
//             height: 50.0,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.orange,
//             ),
//             child: Container(
//               child: IconButton(
//                 icon: Icon(
//                   Icons.remove,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     widget.itemModel.qtyitems--;
//                   });
//                 },
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               "${widget.itemModel.qtyitems}",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Container(
//             width: 50.0,
//             height: 50.0,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.orange,
//             ),
//             child: Container(
//               child: IconButton(
//                 icon: Icon(
//                   Icons.add,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     widget.itemModel.qtyitems++;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class TouchPill extends StatelessWidget {
  const TouchPill({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.orange,
      radius: 15,
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
        ),
        radius: 17,
      ),
    );
  }
}

const boldTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white);
const boldTextStyle1 =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white);
const boldTextStyle2 =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black);
const largeTextStyle =
    TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: Colors.black);
