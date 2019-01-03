import 'package:flutter/material.dart';

class FuelForm extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _FuelFormState();
  }

}

class _FuelFormState extends State<FuelForm> {
  String name = "";
  var currencies = <String>['Dollars', 'Euro', 'Pounds'];
  var currency = 'Dollars';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello"),
          backgroundColor: Colors.blueAccent),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "Please insert your name"
                ),
                onSubmitted: (String string){
                  setState(() {
                    name = string;
                  });
                },
              ),
              DropdownButton<String>(
                items: currencies.map((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                value: currency,
                onChanged: (String value) { _onDropDownChanged(value);},
              ),
              Text('Hello '+name+'!')
            ],
        ),
      ),
    );
  }

  void _onDropDownChanged(String value) {
    setState(() {
      this.currency = value;
    });
  }
}