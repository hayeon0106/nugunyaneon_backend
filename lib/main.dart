import 'package:flutter/material.dart';
import 'package:nugunyaneon/screen/screen_upload.dart';
import 'package:nugunyaneon/model/test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      //home: MyHomePage(),
      home: LogIn(),
    );
  }
}
