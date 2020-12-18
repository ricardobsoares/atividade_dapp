import 'package:flutter/material.dart';

class Inicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Pagina inicial"),
      ),
      body: new Column(
        children: <Widget>[
          new Text("Seja Bem Vindo!"),
        ],
      ),
    );
  }
}
