import 'package:canteen/loginpage.dart';
import 'package:canteen/registerpage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const login(),
        '/register': (context) => const Registerpage(),
      },
      theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: Color.fromRGBO(28, 235, 156, 1),
      )),
      title: "Canteen App",
      debugShowCheckedModeBanner: false,
      home: const login(),
    );
  }
}




class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
