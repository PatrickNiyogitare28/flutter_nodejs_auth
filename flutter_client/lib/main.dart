import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      home: CupertinoTextFieldDemo(),
      routes: {
        LandingScreen.id: (context) => LandingScreen()
      },
    );
  }
}

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.




class CupertinoTextFieldDemo extends StatelessWidget {
  var email;
  var password;

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
           FlatButton.icon(
             onPressed: () async{
               signup(email, password);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String token = prefs.getString("token");
              if(token != null){
               Navigator.pushNamed(context, LandingScreen.id);
              }
             }, 
             icon: Icon(Icons.save, color: Colors.white,), 
             label: Text("Signup", style: TextStyle(color: Colors.white),
             ), 
             color: Colors.blueAccent,)
          ],
        ),
      ),
    );
  }
}


signup(email, password) async{
    var url = "http://10.0.2.2:5000/signup";
    final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email, 'password': password
    }),
  );

  if (response.statusCode == 201) {
    print(response.body);
    // SharedPreferences.setMockInitialValues({});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var parse = jsonDecode(response.body);
    await prefs.setString('token', parse["token"]);
    String token = prefs.getString("token");
    print("Token: "+token);
  } else {
    throw Exception('Failed to create album....');
  }
}

class LandingScreen extends StatelessWidget {
  static const String id = "LandingScreen";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Text("Welcome to landing screen"),
    );
  }
}
