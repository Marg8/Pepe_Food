import 'dart:convert';
import 'dart:io';
import 'package:pepe_food/Admin/uploadItems.dart';
import 'package:pepe_food/Authentication/authenication.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/Models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

int theme = 0xff009688;

class UpdatePage extends StatefulWidget
{
  final ItemModel itemModel;
  UpdatePage({this.itemModel});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> with AutomaticKeepAliveClientMixin<UpdatePage>
{
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  TextEditingController _qtyitemsTextEditingController = TextEditingController();
  TextEditingController _categoryTextEditingController = TextEditingController();
  String productId ;
  final ImagePicker pickerImg = ImagePicker();
  


      
    
      @override
      // ignore: must_call_super
      Widget build(context) {
        print("${widget.itemModel.thumbnailUrl} Aqui esta la imgen");
        print("${widget.itemModel.productId} aqui debe estar el ID");
        getImageSelection();
           
        return displayAdminUpdateFormScreem1(context);
        
        
      }
    
    
       Widget displayAdminUpdateFormScreem1(BuildContext context,)
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
           title: Text("Editar Producto", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold,),),
           actions: [
             TextButton(
               onPressed: () => deleteProduct(context, productId),
               child: Text("Borrar Dato", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold,),),
             )
           ],
         ),
         body: ListView(
           children: [
             
             Container(
               height: 230.0,
               width: MediaQuery.of(context).size.width * 0.8,
               child: Center(
                 child: AspectRatio(
                   aspectRatio: 16/9,
                   child: Container(                
                   child: FadeInImage(
                  image: NetworkImage(widget.itemModel.thumbnailUrl),
                  placeholder: AssetImage("images/jar-loading1.gif"),
                  fadeInDuration: Duration(milliseconds: 50),
                  ),
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
                     labelText: "Escribir Comida o Bebida o Postre",
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
                     labelText: "Titulo",
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
                     labelText:  "Descripcion Corta",
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
                     labelText: "Descripcion Completa",
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
                     labelText: "Precio",
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
                    labelText: "Cantidad",
                     hintStyle: TextStyle(color: Colors.grey),
                     border: InputBorder.none,
                   ),
                 ),
               ),
             ),
             Divider(color: Colors.black,),
    
             Row(
               mainAxisAlignment: MainAxisAlignment.center,               
               children: [

                 TextButton(
               onPressed: (){
                 saveItemInfo1();
               },
               child: Padding(
                 padding: const EdgeInsets.only(),
                 child: Center(
                   child: Container(
                     
                     height: 50,width: 120,
                     decoration: BoxDecoration(
                     color: Colors.black,
                     borderRadius: BorderRadius.circular(50)),
                   child: Center(child: Text("Guardar Producto", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                   ),
                 ),
               ),
             ),

             TextButton(
               onPressed: (){
                 createFormInfo();
               },
               child: Padding(
                 padding: const EdgeInsets.only(),
                 child: Center(
                   child: Container(
                     
                     height: 50,width: 120,
                     decoration: BoxDecoration(
                     color: Colors.black,
                     borderRadius: BorderRadius.circular(50)),
                   child: Center(child: Text("Dato Actual", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                   ),
                 ),
               ),
             ),
               ],
             ),
             
           ],  
           
         ),
         
       );
    
       
      }
     
    
      deleteProduct(BuildContext context, String productId)
  {
    
    EcommerceApp.firestore
        .collection("items")
        .doc(productId)
        .delete();

    productId = "";

    Route route = MaterialPageRoute(builder: (c)=> UploadPage());
    Navigator.push(context, route);

    Fluttertoast.showToast(msg: "Producto Borrado");
  }
    
      clearFormInfo()
      {
        setState(() {
          Route route =
          MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pop(context, route);

          _shortInfoTextEditingController.clear();
          _descriptionTextEditingController.clear();
          _titleTextEditingController.clear();
          _priceTextEditingController.clear();
          _qtyitemsTextEditingController.clear();
          _categoryTextEditingController.clear();
        });
      }

      createFormInfo()
      {
       
          
          _shortInfoTextEditingController.text = widget.itemModel.shortInfo;
          _descriptionTextEditingController.text = widget.itemModel.longDescription;
          _titleTextEditingController.text = widget.itemModel.title;
          _priceTextEditingController.text = widget.itemModel.price.toString();
          _qtyitemsTextEditingController.text = widget.itemModel.qtyitems.toString();
          _categoryTextEditingController.text = widget.itemModel.category.toString();
        
      }
    
      getImageSelection() 
      {
        
        final imageFile =  widget.itemModel.thumbnailUrl;
        final productIdCode =  widget.itemModel.productId;
        
       
    
        setState(() {
          file = File(imageFile);
          productId = productIdCode;
          
          
        });
      }
      
      
    
    
      saveItemInfo1()
      {
       
       print(productId);

       Route route =
          MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pop(context, route);

        final itemsRef = FirebaseFirestore.instance.collection("items");
    
        itemsRef.doc(productId.toString()).update({
          "shortInfo": _shortInfoTextEditingController.text.trim(),
          "longDescription": _descriptionTextEditingController.text.trim(),
          "price": int.parse(_priceTextEditingController.text),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": widget.itemModel.thumbnailUrl,      
          "title": _titleTextEditingController.text.trim(),
          "qtyitems": int.parse(_qtyitemsTextEditingController.text),
          "category": widget.itemModel.category,

          
        });
        setState(() {
          
          _shortInfoTextEditingController.clear();
          _descriptionTextEditingController.clear();
          _titleTextEditingController.clear();
          _priceTextEditingController.clear();
          _descriptionTextEditingController.clear();
          _qtyitemsTextEditingController.clear();
          _categoryTextEditingController.clear();
        });
      }
    
      
}