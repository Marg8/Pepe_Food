
import 'package:pepe_food/Admin/adminLogin.dart';
import 'package:pepe_food/DialogBox/errorDialog.dart';
import 'package:pepe_food/Config/config.dart';
import 'package:pepe_food/DialogBox/loadingDialog.dart';
import 'package:pepe_food/Widgets/customTextField.dart';
import 'package:pepe_food/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';




class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}





class _LoginState extends State<Login>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
   bool isChecked = false;
  @override
  Widget build(BuildContext context) {

    double _screenWidth = MediaQuery.of(context).size.width;
    //double _screenHeigh = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 40,),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset("images/mini-van.png",
                height: 200.0,
                width: 200.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Ingresa con tu cuenta",
                  style: TextStyle(color: Colors.black)
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [

                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.lock,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            GestureDetector(
                    child: Text(
                      "Click here to Read and Accept Security Policy",
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    onTap: () {
                      _launchUrl(
                          "https://docs.google.com/document/d/1hUhnBEjC6K6Tn9ju0TvokfmVWPxpxn9X/edit?usp=sharing&ouid=117237507655107805599&rtpof=true&sd=true");
                    },
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      _checkBox(),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      Text(
                        "I have Read and accept Security Policy",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )
                    ],
                  ),

            RaisedButton(
              onPressed: () {
               
                _emailTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty &&
                        isChecked == true
                    ? loginUser(context, isChecked)
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog1(
                            message:
                                "Please write email and password and accept Security Policy.",
                          );
                        });
              },
              color: Colors.black,
              child: Text("Iniciar", style: TextStyle(color: Colors.white),),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.black,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton.icon(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AdminSignInPage())),
              icon: (Icon(Icons.nature_people, color: Colors.black,)),
              label: Text("Entrada de Administrador", style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),),
            )
          ],
        ),
      ),
    );
  }

   Widget _checkBox() {
    return Checkbox(
        
        value: isChecked,
        onChanged: (valor) {
          setState(() {
            isChecked = valor;
          });
        });
  }
    FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser(ontext, bool checkBox) async
  {
    showDialog(
        context: context,
    builder: (c)
    {
      return LoadingAlertDialog(message: "Authenticating, Please wait...",);
    });
    User firebaseUser;
    await _auth.signInWithEmailAndPassword(email: _emailTextEditingController.text.trim(), password: _passwordTextEditingController.text.trim(),
    ).then((authUser){
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog1 (message: error.message.toString(),);
          }
      );
    });

      if(firebaseUser != null) {
        readData(firebaseUser).then((s) {
          Navigator.pop(context);
          Route route = MaterialPageRoute(builder: (c) => Hamburger());
          Navigator.push(context, route);
        });
      }
  }


  Future readData(User fUser) async
  {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).get().then((dataSnapshot) async
    {

      await EcommerceApp.sharedPreferences.setString("uid", dataSnapshot.data()[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userEmail, dataSnapshot.data()[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userName, dataSnapshot.data()[EcommerceApp.userName]);
      

      
      
    });
  }
  Future<void> _launchUrl(String urlString) async {
    if (await canLaunch(urlString)) {
      await launch(urlString, forceWebView: true);
    } else {
      ErrorAlertDialog1(
        message: "Please Review your internet conection",
      );
    }
  }
}
  


class ErrorAlertDialog {
}
