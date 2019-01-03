import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        color: Colors.deepOrangeAccent,
        child: Text("Pizza", textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 30.0,
                decoration: TextDecoration.none, fontFamily: 'Chivo'),
        ),
      ),
    );
  }
}
