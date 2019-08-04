import 'package:flutter/material.dart';
import 'package:rentalapp/HomePage.dart';
import 'package:rentalapp/singup.dart';
import 'package:rentalapp/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firbase Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        "/singup":(BuildContext context) =>SingUp(),
        "/LoginPage":(BuildContext context) =>LoginPage(),

      },
    );
  }
}

