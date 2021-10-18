// import 'dart:convert';
// import 'dart:io';
// import 'package:pepe_food/Admin/uploadItems.dart';
// import 'package:pepe_food/Authentication/authenication.dart';
// import 'package:pepe_food/Config/config.dart';
// import 'package:pepe_food/Models/item.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// int theme = 0xff009688;

// class UploadColorProdPage extends StatefulWidget
// {
//   final ItemModel itemModel;
//   UploadColorProdPage({this.itemModel});

//   @override
//   _UploadColorProdPageState createState() => _UploadColorProdPageState();
// }

// class _UploadColorProdPageState extends State<UploadColorProdPage> with AutomaticKeepAliveClientMixin<UploadColorProdPage>
// {
//   bool get wantKeepAlive => true;
//   File file;
//   TextEditingController _descriptionTextEditingController = TextEditingController();
//   TextEditingController _priceTextEditingController = TextEditingController();
//   TextEditingController _titleTextEditingController = TextEditingController();
//   TextEditingController _shortInfoTextEditingController = TextEditingController();
//   TextEditingController _qtyitemsTextEditingController = TextEditingController();
//   TextEditingController _colorTextEditingController = TextEditingController();
//   String productId;
//   String color;
//   final ImagePicker pickerImg = ImagePicker();
  


      
    
//       @override
//       // ignore: must_call_super
//       Widget build(context) {
//         print("${widget.itemModel.thumbnailUrl} Aqui esta la imgen");
//         print("${widget.itemModel.productId} aqui debe estar el ID");
//         getImageSelection(); 
//         return file == null ? displayAdminUpdateColorFile(context) : displayAdminUpdateColor(context);
        
        
//       }
    
    
//        Widget displayAdminUpdateColor(BuildContext context,)
//       {

       
        
//        return Scaffold(
//          appBar: AppBar(
//            flexibleSpace: Container(
//              decoration: new BoxDecoration(
//                gradient: new LinearGradient(
//                  colors: [Color(theme),Color(theme)],
//                  begin: const FractionalOffset(0.0, 0.0),
//                  end: const FractionalOffset(1.0, 0.0),
//                  stops: [0.0, 1.0],
//                  tileMode: TileMode.clamp,
//                ),
//              ),
//            ),
//            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),
//            onPressed: clearFormInfo),
//            title: Text("Agregar Color", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold,),),
//            actions: [
//              TextButton(
//                onPressed: () => deleteProduct(context, productId),
//                child: Text("Borrar dato", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold,),),
//              )
//            ],
//          ),
//          body: ListView(
//            children: [
             
//              InkWell(
//                onTap: (){
//                   takeImageColor(context);
//                },
//                child: Container(
//                  height: 230.0,
//                  width: MediaQuery.of(context).size.width * 0.8,
//                  child: Center(
//                    child: AspectRatio(
//                      aspectRatio: 16/9,
//                      child: Container(                 
//                      decoration: BoxDecoration(
//                      image: DecorationImage(
//                      image: FileImage(file), 
//                      fit: BoxFit.cover)),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
            
//              Padding(padding: EdgeInsets.only(top: 12.0)),
             
//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    style: TextStyle(color: Colors.black),
//                    controller: _titleTextEditingController,
//                    decoration: InputDecoration(
//                      labelText: "Titulo",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),

//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    style: TextStyle(color: Colors.black),
//                    controller: _shortInfoTextEditingController,
//                    decoration: InputDecoration(
//                      labelText:  "Descripcion Corta",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),

//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    style: TextStyle(color: Colors.black),
//                    controller: _descriptionTextEditingController,
//                    decoration: InputDecoration(
//                      labelText: "Descripcion Completa",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),
    
//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    keyboardType: TextInputType.number,
//                    style: TextStyle(color: Colors.black),
//                    controller: _priceTextEditingController,
//                    decoration: InputDecoration(
//                      labelText: "Precio",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),
    
//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    keyboardType: TextInputType.number,
//                    style: TextStyle(color: Colors.black),
//                    controller: _qtyitemsTextEditingController,
//                    decoration: InputDecoration(
//                     labelText: "Cantidad",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),
    
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,               
//                children: [

//                  TextButton(
//                onPressed: (){
//                  saveItemColor();
//                },
//                child: Padding(
//                  padding: const EdgeInsets.only(),
//                  child: Center(
//                    child: Container(
                     
//                      height: 50,width: 120,
//                      decoration: BoxDecoration(
//                      color: Colors.black,
//                      borderRadius: BorderRadius.circular(50)),
//                    child: Center(child: Text("Guardar Producto", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
//                    ),
//                  ),
//                ),
//              ),

//              TextButton(
//                onPressed: (){
//                  createFormInfo();
//                },
//                child: Padding(
//                  padding: const EdgeInsets.only(),
//                  child: Center(
//                    child: Container(
                     
//                      height: 50,width: 120,
//                      decoration: BoxDecoration(
//                      color: Colors.black,
//                      borderRadius: BorderRadius.circular(50)),
//                    child: Center(child: Text("Dato Actual", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
//                    ),
//                  ),
//                ),
//              ),
//                ],
//              ),
             
//            ],  
           
//          ),
         
//        );
    
       
//       }

//       Widget displayAdminUpdateColorFile(BuildContext context,)
//       {

       
        
//        return Scaffold(
//          appBar: AppBar(
//            flexibleSpace: Container(
//              decoration: new BoxDecoration(
//                gradient: new LinearGradient(
//                  colors: [Color(theme),Color(theme)],
//                  begin: const FractionalOffset(0.0, 0.0),
//                  end: const FractionalOffset(1.0, 0.0),
//                  stops: [0.0, 1.0],
//                  tileMode: TileMode.clamp,
//                ),
//              ),
//            ),
//            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.white,),
//            onPressed: clearFormInfo),
//            title: Text("Agregar Color", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold,),),
//            actions: [
//              TextButton(
//                onPressed: () => deleteProduct(context, productId),
//                child: Text("Borrar dato", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold,),),
//              )
//            ],
//          ),
//          body: ListView(
//            children: [
             
//              InkWell(
//                onTap: (){
//                   takeImageColor(context);
//                },
//                child: Container(
//                  height: 230.0,
//                  width: MediaQuery.of(context).size.width * 0.8,
//                  child: Center(
//                    child: AspectRatio(
//                      aspectRatio: 16/9,
//                      child: Container(                
//                      child: FadeInImage(
//                      image: NetworkImage(widget.itemModel.thumbnailUrl),
//                      placeholder: AssetImage("images/jar-loading1.gif"),
//                      fadeInDuration: Duration(milliseconds: 50),
//                   ),
//                    ),
//                    ),
//                  ),
//                ),
//              ),
            
//              Padding(padding: EdgeInsets.only(top: 12.0)),

//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    style: TextStyle(color: Colors.black),
//                    controller: _colorTextEditingController,
//                    decoration: InputDecoration(
//                      labelText: "Color",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),
             
//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    style: TextStyle(color: Colors.black),
//                    controller: _titleTextEditingController,
//                    decoration: InputDecoration(
//                      labelText: "Titulo",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),

//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    style: TextStyle(color: Colors.black),
//                    controller: _shortInfoTextEditingController,
//                    decoration: InputDecoration(
//                      labelText:  "Descripcion Corta",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),

//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    style: TextStyle(color: Colors.black),
//                    controller: _descriptionTextEditingController,
//                    decoration: InputDecoration(
//                      labelText: "Descripcion Completa",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),
    
//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    keyboardType: TextInputType.number,
//                    style: TextStyle(color: Colors.black),
//                    controller: _priceTextEditingController,
//                    decoration: InputDecoration(
//                      labelText: "Precio",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),
    
//              ListTile(
//                leading: Icon(Icons.perm_device_information, color: Colors.black,),
//                title: Container(
//                  width: 250.0,
//                  child: TextField(
//                    keyboardType: TextInputType.number,
//                    style: TextStyle(color: Colors.black),
//                    controller: _qtyitemsTextEditingController,
//                    decoration: InputDecoration(
//                     labelText: "Cantidad",
//                      hintStyle: TextStyle(color: Colors.grey),
//                      border: InputBorder.none,
//                    ),
//                  ),
//                ),
//              ),
//              Divider(color: Colors.black,),
    
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,               
//                children: [

//                  TextButton(
//                onPressed: (){
//                  saveItemColor();
//                },
//                child: Padding(
//                  padding: const EdgeInsets.only(),
//                  child: Center(
//                    child: Container(
                     
//                      height: 50,width: 120,
//                      decoration: BoxDecoration(
//                      color: Colors.black,
//                      borderRadius: BorderRadius.circular(50)),
//                    child: Center(child: Text("Guardar Producto", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
//                    ),
//                  ),
//                ),
//              ),

//              TextButton(
//                onPressed: (){
//                  createFormInfo();
//                },
//                child: Padding(
//                  padding: const EdgeInsets.only(),
//                  child: Center(
//                    child: Container(
                     
//                      height: 50,width: 120,
//                      decoration: BoxDecoration(
//                      color: Colors.black,
//                      borderRadius: BorderRadius.circular(50)),
//                    child: Center(child: Text("Dato Actual", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
//                    ),
//                  ),
//                ),
//              ),
//                ],
//              ),
             
//            ],  
           
//          ),
         
//        );
    
       
//       }
  
     
    
//       deleteProduct(BuildContext context, String productId)
//   {
    
//     EcommerceApp.firestore
//         .collection("items")
//         .document(productId)
//         .delete();

//     productId = "";

//     Route route = MaterialPageRoute(builder: (c)=> UploadPage());
//     Navigator.push(context, route);

//     Fluttertoast.showToast(msg: "Producto Borrado");
//   }
    
//       clearFormInfo()
//       {
//         setState(() {
//           Route route =
//           MaterialPageRoute(builder: (c) => UploadPage());
//           Navigator.pop(context, route);

//           _shortInfoTextEditingController.clear();
//           _descriptionTextEditingController.clear();
//           _titleTextEditingController.clear();
//           _priceTextEditingController.clear();
//           _qtyitemsTextEditingController.clear();
//           _colorTextEditingController.clear();
//         });
//       }

//       createFormInfo()
//       {

//           _shortInfoTextEditingController.text = widget.itemModel.shortInfo;
//           _descriptionTextEditingController.text = widget.itemModel.longDescription;
//           _titleTextEditingController.text = widget.itemModel.title;
//           _priceTextEditingController.text = widget.itemModel.price.toString();
//           _qtyitemsTextEditingController.text = widget.itemModel.qtyitems.toString();
        
//       }
    
//       getImageSelection() 
//       {
        
//         // final imageFile =  widget.itemModel.thumbnailUrl;
//         final productIdCode =  widget.itemModel.productId;
//         final colorName = _colorTextEditingController.text.trim();
        
       
    
//         setState(() {
//           // file = File(imageFile.toString());
//           productId = productIdCode;
//           color = colorName;
          
          
//         });
//       }

      
      
    
    
//       saveItemColor()
//       {
       

//        final colorId = ("$productId$color");  

//        Route route =
//           MaterialPageRoute(builder: (c) => UploadPage());
//           Navigator.pop(context, route);


//         final itemsRef = Firestore.instance.collection("items");
    
//         itemsRef.document(productId)
//         .collection("productcolor")
//         .document(colorId)
//         .setData({
//           "shortInfo": _shortInfoTextEditingController.text.trim(),
//           "longDescription": _descriptionTextEditingController.text.trim(),
//           "price": int.parse(_priceTextEditingController.text),
//           "publishedDate": DateTime.now(),
//           "status": "available",
//           "thumbnailUrl": widget.itemModel.thumbnailUrl,      
//           "title": _titleTextEditingController.text.trim(),
//           "qtyitems": int.parse(_qtyitemsTextEditingController.text),
//           "productId": productId,
//           "color": _colorTextEditingController.text.trim(),
          

          
//         });
//         setState(() {
          
//           _shortInfoTextEditingController.clear();
//           _descriptionTextEditingController.clear();
//           _titleTextEditingController.clear();
//           _priceTextEditingController.clear();
//           _descriptionTextEditingController.clear();
//           _qtyitemsTextEditingController.clear();
//           _colorTextEditingController.clear();
//         });
//       }

//       takeImageColor(mContext) {
//     return showDialog(
//         context: mContext,
//         builder: (con) {
//           return SimpleDialog(
//             title: Text("Item Image", style: TextStyle(
//                 color: Colors.black, fontWeight: FontWeight.bold),),
//             children: [
//               SimpleDialogOption(
//                 child: Text("Capture with Camera", style: TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold,)),
//                 onPressed: capturePhotoWithCamera,
//               ),
//               SimpleDialogOption(
//                 child: Text("Select from Galery", style: TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold,)),
//                 onPressed: pickPhotoFromGalery,
//               ),
//               SimpleDialogOption(
//                 child: Text("Cancel", style: TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold,)),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         }
//     );
//   }

//   capturePhotoWithCamera() async
//   {
//     Navigator.pop(context);
//     final imageFile = await pickerImg.getImage(source: ImageSource.camera, /*maxHeight: 680.0, maxWidth: 970.0*/);

//     setState(() {
//       file = File(imageFile.path);
//     });
//   }

//   pickPhotoFromGalery() async
//   {
//     print("$file Aqui esta la imgen");
//     Navigator.pop(context);
//     final imageFile = await pickerImg.getImage(source: ImageSource.gallery,);

//     setState(() {
//        file = File(imageFile.path);
//     });
//   }

    
    
      
// }

  