import 'package:flutter/material.dart';
import 'package:pengyou/values/strings.dart';
import 'package:pengyou/views/homeView.dart';

void main() => runApp(PengyouApp());

class PengyouApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.applicationName,
      theme: ThemeData(
        primarySwatch: Colors.blue, // TODO: Set Theme here
      ),
      home: HomeView(),
    );
  }
}


