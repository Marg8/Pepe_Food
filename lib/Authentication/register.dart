import 'dart:io';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/DialogBox/errorDialog.dart';
import 'package:pepe_food/DialogBox/loadingDialog.dart';
import 'package:pepe_food/Widgets/customTextField.dart';
import 'package:pepe_food/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';




class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  File _imageFile;
  final ImagePicker pickerImg = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width,
        // ignore: unused_local_variable
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 10.0,),
       
            SizedBox(height: 8.0,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Nombre",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Correo",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    controller: _cPasswordTextEditingController,
                    data: Icons.lock,
                    hintText: "Confirmar Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              color: Colors.black,
              child: Text("Iniciar", style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.black,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }



  Future<void> uploadAndSaveImage() async
  {
   
      _passwordTextEditingController.text ==
          _cPasswordTextEditingController.text

          ? _emailTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
          _cPasswordTextEditingController.text.isNotEmpty &&
          _nameTextEditingController.text.isNotEmpty

          ? _registerUser()

          : displayDilog("Please fill up the registration complete form..")
          : displayDilog("Passsword do not macth.");
      }

  displayDilog(String msg) {
    showDialog(context: context,
        builder: (c) {
          return ErrorAlertDialog(message: msg,);
        });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async
  {
    User firebaseUser;

    await _auth.createUserWithEmailAndPassword
      (email: _emailTextEditingController.text.trim(),
        password: _passwordTextEditingController.text.trim(),
      ).then((auth){
        firebaseUser = auth.user;
    }).catchError((error){
      //  Navigator.pop(context);
       showDialog(
           context: context,
           builder: (c)
       {
         return ErrorAlertDialog(message: error.message.toString(),);
       }
       );
    });
    if(firebaseUser != null)
      {
        saveUserInfoToFireStore(firebaseUser).then((value){
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c)=> Hamburger());
          Navigator.push(context, route);
        });
      }
  }
  Future saveUserInfoToFireStore(User fUser) async
  {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbaValue"]
    });

    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userCartList, ["garbaValue"]);
  }
}

