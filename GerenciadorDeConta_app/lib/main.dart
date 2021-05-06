import 'package:flutter/material.dart';
//import 'dart:math';
import 'package:path_provider/path_provider.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart' as path;

import 'package:listatarefas_app/PaginaLogin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Contas',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PaginaLogin(),
    );
  }
}

