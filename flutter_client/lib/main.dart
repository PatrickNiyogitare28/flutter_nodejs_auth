
import 'package:flutter/material.dart';

import './screens/signup_screen.dart';
import './screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      home: Signup(),
      routes: {
        LandingScreen.id: (context) => LandingScreen()
      },
    );
  }
}

// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.








