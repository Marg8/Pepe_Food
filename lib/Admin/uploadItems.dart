import 'dart:io';
import 'package:pepe_food/Admin/adminShifOrders1.dart';
import 'package:pepe_food/Admin/updateItems.dart';
import 'package:pepe_food/Models/item.dart';
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


class UploadPage extends StatefulWidget
{
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> with AutomaticKeepAliveClientMixin<UploadPage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  TextEditingController _qtyitemsTextEditingController = TextEditingController();
  TextEditingController _categoryTextEditingController = TextEditingController();
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
  Widget build(BuildContext context) {print("$file Aqui esta la imgen");
    return file == null ? displayAdminHomeScreen() : displayAdminUploadFormScreem();
    
  }

  Widget displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.yellow,Colors.yellow],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        

        actions: [
          // goColorList(),
          getAdminHomeScreenBody(),
          TextButton(
            child: Text("Salir", style: TextStyle(color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,),),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
      body: CustomScrollView(          
          slivers: [     
                   
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegateAdmin()),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("items")
                    .limit(50)
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: circularProgress(),
                          ),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 2,
                          staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            ItemModel model = ItemModel.fromJson(
                                dataSnapshot.data.docs[index].data());         
                              
                          return sourceInfoAdmin(model, context);
                          },
                          itemCount: dataSnapshot.data.docs.length,
                        );
                }),

                 
          
                
          ],
          
          
        ),    
        
      );
  }

  getAdminHomeScreenBody() {

  
    
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.yellow,Colors.yellow],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Icon(Icons.shop_two, color: Colors.black, size: 80.0,),
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: ElevatedButton(
                style: raisedButtonStyle,
                child: Text("Agregar Producto",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),),
                // color: Colors.black,
                onPressed: () => takeImage(context),
              ),
            )
          ],
        ),
      ),
    );

    
    
  }
 


   goColorList() {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.black,Colors.black],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Icon(Icons.shop_two, color: Colors.black, size: 80.0,),
            Padding(
              padding: EdgeInsets.only(top: 0.0),
              child: ElevatedButton(
                style: raisedButtonStyle,
                child: Text("Color Product",
                  style: TextStyle(fontSize: 15.0, color: Colors.white),),
                
                onPressed: (){
                  // Route route = MaterialPageRoute(builder: (c) => MultiColorPage());
                  // Navigator.push(context, route);                  

                }
              ),
            )
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text("Item Image", style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                child: Text("Capture with Camera", style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold,)),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Select from Galery", style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold,)),
                onPressed: pickPhotoFromGalery,
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold,)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  capturePhotoWithCamera() async
  {
    Navigator.pop(context);
    final imageFile = await pickerImg.getImage(source: ImageSource.camera, /*maxHeight: 680.0, maxWidth: 970.0*/);

    setState(() {
      file = File(imageFile.path);
    });
  }

  pickPhotoFromGalery() async
  {
    print("$file Aqui esta la imgen");
    Navigator.pop(context);
    final imageFile = await pickerImg.getImage(source: ImageSource.gallery,);

    setState(() {
       file = File(imageFile.path);
    });
  }

  displayAdminUploadFormScreem()
  {
    
   return Scaffold(
     appBar: AppBar(
       flexibleSpace: Container(
         decoration: new BoxDecoration(
           gradient: new LinearGradient(
             colors: [Color(theme),Color(theme)],
             begin: const FractionalOffset(0.0, 0.0),
             end: const FractionalOffset(1.0, 0.0),
             stops: [0.0, 1.0],
             tileMode: TileMode.clamp,
           ),
         ),
       ),
       leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),
       onPressed: clearFormInfo),
       title: Text("New Product", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold,),),
       actions: [
         TextButton(
           onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
           child: Text("Add", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold,),),
         )
       ],
     ),
     body: ListView(
       children: [
         uploading ? linearProgress() : Text(""),
         Container(
           height: 230.0,
           width: MediaQuery.of(context).size.width * 0.8,
           child: Center(
             child: AspectRatio(
               aspectRatio: 16/9,
               child: Container(                 
               decoration: BoxDecoration(
                 image: DecorationImage(
                   image: FileImage(file), 
                   fit: BoxFit.cover)),
               ),
             ),
           ),
         ),
         Padding(padding: EdgeInsets.only(top: 12.0)),

         ListTile(
           leading: Icon(Icons.perm_device_information, color: Colors.black,),
           title: Container(
             width: 250.0,
             child: TextField(
               style: TextStyle(color: Colors.black),
               controller: _categoryTextEditingController,
               decoration: InputDecoration(
                 hintText: "Escribir Comida o Bebida o Postre",
                 hintStyle: TextStyle(color: Colors.grey),
                 border: InputBorder.none,
               ),
             ),
           ),
         ),
         Divider(color: Colors.black,),

         ListTile(
           leading: Icon(Icons.perm_device_information, color: Colors.black,),
           title: Container(
             width: 250.0,
             child: TextField(
               style: TextStyle(color: Colors.black),
               controller: _titleTextEditingController,
               decoration: InputDecoration(
                 hintText: "Titulo",
                 hintStyle: TextStyle(color: Colors.grey),
                 border: InputBorder.none,
               ),
             ),
           ),
         ),
         Divider(color: Colors.black,),

         ListTile(
           leading: Icon(Icons.perm_device_information, color: Colors.black,),
           title: Container(
             width: 250.0,
             child: TextField(
               style: TextStyle(color: Colors.black),
               controller: _shortInfoTextEditingController,
               decoration: InputDecoration(
                 hintText: "Descripcion Corta",
                 hintStyle: TextStyle(color: Colors.grey),
                 border: InputBorder.none,
               ),
             ),
           ),
         ),
         Divider(color: Colors.black,),

         

         ListTile(
           leading: Icon(Icons.perm_device_information, color: Colors.black,),
           title: Container(
             width: 250.0,
             child: TextField(
               style: TextStyle(color: Colors.black),
               controller: _descriptionTextEditingController,
               decoration: InputDecoration(
                 hintText: "Descripcion Completa",
                 hintStyle: TextStyle(color: Colors.grey),
                 border: InputBorder.none,
               ),
             ),
           ),
         ),
         Divider(color: Colors.black,),

         ListTile(
           leading: Icon(Icons.perm_device_information, color: Colors.black,),
           title: Container(
             width: 250.0,
             child: TextField(
               keyboardType: TextInputType.number,
               style: TextStyle(color: Colors.black),
               controller: _priceTextEditingController,
               decoration: InputDecoration(
                 hintText: "Precio",
                 hintStyle: TextStyle(color: Colors.grey),
                 border: InputBorder.none,
               ),
             ),
           ),
         ),
         Divider(color: Colors.black,),

         ListTile(
           leading: Icon(Icons.perm_device_information, color: Colors.black,),
           title: Container(
             width: 250.0,
             child: TextField(
               keyboardType: TextInputType.number,
               style: TextStyle(color: Colors.black),
               controller: _qtyitemsTextEditingController,
               decoration: InputDecoration(
                 hintText: "Cantidad",
                 hintStyle: TextStyle(color: Colors.grey),
                 border: InputBorder.none,
               ),
             ),
           ),
         ),
         Divider(color: Colors.black,),

         TextButton(
           onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
           child: Padding(
             padding: const EdgeInsets.only(),
             child: Center(
               child: Container(
                 decoration: BoxDecoration(
                     color: Colors.black,
                     borderRadius: BorderRadius.circular(50)),
                     height: 50,width: 80,
               child: Center(
                 child: Text("Guardar Producto", 
                 style: TextStyle(
                 color: Colors.white, fontWeight: FontWeight.bold),)),
               ),
             ),
           ),
         )
       ],  
       
     ),
   );
  }

  clearFormInfo()
  {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _qtyitemsTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _categoryTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo()async
  {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl =  await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }
  Future<String> uploadItemImage(mFileImage) async
  {
    final Reference storageReference =  FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask = storageReference.child("Product_$productId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  saveItemInfo(String downloadUrl)
  {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(productId).set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
      "qtyitems": int.parse(_qtyitemsTextEditingController.text),
      "productId": productId,
      "category": _categoryTextEditingController.text.trim(),
    });
    setState(() {
      file = null;
      uploading = false;
      productId =DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _qtyitemsTextEditingController.clear();
      _categoryTextEditingController.clear();
    });
  }
}



Widget sourceInfoAdmin(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell(
    onTap: () {
      Route route = MaterialPageRoute(builder: (c) => UpdatePage(itemModel: model));
      Navigator.push(context, route);
    },
    splashColor: Colors.black,
    child: Padding(
      padding: EdgeInsets.all(6.0),
      child: removeCartFunction == null ? Table(
        children: [
          TableRow(
            children: [
              Container(
            height: 300.0,
            width: 50,
            decoration: BoxDecoration(
              boxShadow:[
              new BoxShadow(
              color: Colors.black,
              offset: new Offset(0.0, 5.0),
              blurRadius: 5.0,
        ),
         ],
              borderRadius: BorderRadius.circular(15),
              gradient: new LinearGradient(
              colors: [Colors.white,Colors.white],
              ),
            ),
            child: Column(
              children: [
                FadeInImage(
                  image: NetworkImage(model.thumbnailUrl),
                  placeholder: AssetImage("images/jar-loading1.gif"),
                  fadeInDuration: Duration(milliseconds: 50),
                  width: 140.0,
                  height: 140.0,
                  ),
                SizedBox(
                  width: 1.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                model.title ?? '',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                model.shortInfo ?? '',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          
                          SizedBox(
                            width: 10.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 1.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"",
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.black),
                                    ),
                                    Text(
                                      r"$",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (model.price ?? '').toString(),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(left: 30.0),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         r"$",


                              //         style: TextStyle(
                              //           fontSize: 18.0,
                              //           color: Colors.red,
                              //           decoration: TextDecoration.lineThrough,
                              //         ),
                              //       ),
                                    // Text(
                                    //   (model.price + model.price*0.30 ?? '')
                                    //       .toString().replaceAll(".0", ""),
                                    //   style: TextStyle(
                                    //     fontSize: 18.0,
                                    //     color: Colors.red,
                                    //     decoration: TextDecoration.lineThrough,
                                    //   ),
                                    // ),
                              //     ],
                              //   ),
                              // ),
                              
                              
                            ],
                          )
                        ],
                      ),
                      
                      Padding(
                                padding: EdgeInsets.only(left: 10, top: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      r"Cantidad: ",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                    Text(
                                      r"",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                    Text(
                                      (qtyItems ?? '').toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      //to implement the cart item remove feature
                      
                      
                    ],
                  ),
                )
              ],
            ),
        ),
              
            ]
          )

        ],
         // Aqui se modifica la informacion del Carro unicamente
         //Cart Page

      ) : Table(
        children: [
          TableRow(
            children: [
              Container(
            height: 180.0,
            width: 50,
            decoration: BoxDecoration(
              boxShadow:[
              new BoxShadow(
              color: Colors.black,
              offset: new Offset(0.0, 5.0),
              blurRadius: 5.0,
        ),
         ],
              borderRadius: BorderRadius.circular(15),
              gradient: new LinearGradient(
              colors: [Colors.white,Colors.white],
              ),
            ),
            child: Row(
              children: [
                Image.network(
                  model.thumbnailUrl,
                  width: 140.0,
                  height: 140.0,
                ),
                SizedBox(
                  width: 1.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                model.title ?? '',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                model.shortInfo ?? '',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.red,
                            ),
                            alignment: Alignment.topLeft,
                            width: 40.0,
                            height: 43.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "30%",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "OFF%",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 1.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"",
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.black),
                                    ),
                                    Text(
                                      r"$",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      (model.price ?? '').toString(),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"$",


                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      (model.price + model.price*0.30 ?? '')
                                          .toString().replaceAll(".0", ""),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              /*Padding(
                                padding: EdgeInsets.only(top: 1.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"Cantidad: ",
                                      style: TextStyle(
                                          fontSize: 14.0, color: Colors.black),
                                    ),
                                    Text(
                                      r"",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                    Text(
                                      (qtyItems ?? '').toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                            ],
                          )
                        ],
                      ),
                      Flexible(
                        child: Container(),
                      ),
                      //to implement the cart item remove feature
                      Align(
                        alignment: Alignment.centerRight,
                        child: removeCartFunction == null
                            ? IconButton(
                                icon: Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  // checkItemInCart(model.title, context);
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.delete, color: Colors.black,),
                          onPressed: ()
                          {
                            removeCartFunction();

                            //opcional para salir automatico

                            Route route = MaterialPageRoute(builder: (c) => StoreHome());
                            Navigator.push(context, route);

                          },
                              ),
                      ),
                      
                    ],
                  ),
                )
              ],
            ),
        ),
              
            ]
          )

        ],
         
      ),
    ),
  );
}