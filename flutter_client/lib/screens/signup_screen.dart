import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './landing_screen.dart';
import '../models/Error.dart';

Error error;

class Signup extends StatefulWidget {


  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  var email;

  var password;

  var name;

  var errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: ListView(
          restorationId: 'text_field_demo_list_view',
          padding: const EdgeInsets.all(16),
          children: [
            Text(errorMessage, style: TextStyle(fontSize: 10, backgroundColor: Colors.white),),
            // ShowError(error.message),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                textInputAction: TextInputAction.next,
                restorationId: 'email_address_text_field',
                placeholder: "Name",
                keyboardType: TextInputType.emailAddress,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                onChanged: (value) {
                  name = value;
                  setState(() {
                    this.errorMessage="";
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                textInputAction: TextInputAction.next,
                restorationId: 'email_address_text_field',
                placeholder: "Email",
                keyboardType: TextInputType.emailAddress,
                clearButtonMode: OverlayVisibilityMode.editing,
                autocorrect: false,
                onChanged: (value) {
                  email = value;
                  setState(() {
                    this.errorMessage="";
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CupertinoTextField(
                textInputAction: TextInputAction.next,
                restorationId: 'login_password_text_field',
                placeholder: "Password",
                clearButtonMode: OverlayVisibilityMode.editing,
                obscureText: true,
                autocorrect: false,
                 onChanged: (value) {
                  password = value;
                  setState(() {
                    this.errorMessage="";
                  });
                },
              ),
            ),
           ElevatedButton(
             onPressed: () async{
              signup(name,email, password);
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // String token = prefs.getString("token");
              
             }, 
             child: Text("Signup"),
            )
          ],
        ),
      ),
    );
  }

  void signup(name, email, password) async{
    var url = "http://10.0.2.2:5000/Signup";
    final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email, 'password': password
    }),
  );
    var parse = jsonDecode(response.body);
  
  if (response.statusCode == 201) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', parse["token"]);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (contex) => LandingScreen()),
    );
  } else if(response.statusCode == 406) {
     setState(() {
        this.errorMessage= parse["message"];
      });
  }
}
}

