import 'package:flutter/material.dart';
import 'package:laws_app/widgets/app_drawer.dart';

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Center(
        child: Text('This is the Third Page'),
      ),
    );
  }
}
