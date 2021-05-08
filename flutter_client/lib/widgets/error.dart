import 'package:flutter/material.dart';

class ShowError extends StatelessWidget {
  final error;
  ShowError(this.error);
   
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Error: "+error),
    );
  }
}