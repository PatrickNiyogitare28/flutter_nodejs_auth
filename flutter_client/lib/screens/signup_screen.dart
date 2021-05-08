import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './landing_screen.dart';
import '../models/Error.dart';
import '../widgets/error.dart';

Error error;

class Signup extends StatefulWidget {
  
  Signup(){
    error = new Error(false, '');

  }

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  var email;

  var password;

  var name;

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
            
            Stack(
              children: [
              (error.message == true) ? (
                Text("Error happened.....")
              ) : (Container()),
                
              ],
            ),
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
                },
              ),
            ),
           ElevatedButton(
             onPressed: () async{
              signup(name,email, password);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String token = prefs.getString("token");
              // if(token != null){
              //  Navigator.pushNamed(context, LandingScreen.id);
              // }
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
    print("code......."+(response.statusCode).toString());
    print(parse);
  
  if (response.statusCode == 201) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', parse["token"]);
    String token = prefs.getString("token");
    print("Token: "+token);
  } else if(response.statusCode == 406) {
     new Error(true, parse["message"]);
  }
}
}

