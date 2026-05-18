import 'package:flutter/material.dart';

void main() {
  runApp(
    //Widgets qui permet de définir le design global de notre application
    //MaterialApp (tout) ou CupertinoApp (Apple)
    //widget Scaffold - ajout app barre - menu coulissant - bouton flottant
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Box Familia"),
        ),
        body: Text(
          'Hello World!', 
          style: TextStyle(
            fontSize: 30),
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){},child:Text('OK'),),
      )
    ),
  );
}
