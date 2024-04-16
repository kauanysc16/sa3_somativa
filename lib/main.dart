import 'package:flutter/material.dart';
import 'package:sa3_somativa/View/LoginPageView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SA3- Somativa",
      debugShowCheckedModeBanner: false,
      home: PaginaLogin(),
    
    );
  }
}
