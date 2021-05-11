import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class LandingScreen extends StatefulWidget {
  static const String id = "LandingScreen";

 

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String name="";
 
 @override
 void initState(){
   getData();
   super.initState();
 }

 void getData() async{
   SharedPreferences pref = await SharedPreferences.getInstance();
   String token = pref.getString("token");

   var url = "http://10.0.2.2:5000/Signup";
    final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'Bearer '+token
    },
  );
    var parse = jsonDecode(response.body);
    setState(() {
     this.name = "Hello";
    });
 }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        child: Align(
          alignment: Alignment.center,
            child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Text("Welcome back!",
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.black45,
                  fontWeight: FontWeight.bold
                ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(this.name,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
