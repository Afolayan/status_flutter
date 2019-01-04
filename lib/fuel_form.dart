import 'package:flutter/material.dart';

class FuelForm extends StatefulWidget {
  FuelForm({Key key, this.title}) : super(key: key);
  final String title;
  @override
  State<StatefulWidget> createState() {
    return _FuelFormState();
  }
}

class _FuelFormState extends State<FuelForm> {
  String result = "";
  var currencies = <String>['Dollars', 'Euro', 'Pounds'];
  var currency = 'Dollars';
  TextEditingController distanceController = TextEditingController();
  TextEditingController avgController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final double _formDistance = 5.0;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.blueAccent),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: _formDistance, bottom: _formDistance),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: distanceController,
                  decoration: InputDecoration(
                      labelText: "Distance",
                      hintText: "e.g 124",
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                )),
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: avgController,
                decoration: InputDecoration(
                    labelText: "Distance per Unit",
                    hintText: "e.g 17",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: _formDistance, bottom: _formDistance),
              child: Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration: InputDecoration(
                        labelText: "Price",
                        hintText: "e.g 1.7",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                Container(width: _formDistance * 2),
                Expanded(
                    child: DropdownButton<String>(
                  items: currencies.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  value: currency,
                  onChanged: (String value) {
                    _onDropDownChanged(value);
                  },
                ))
              ]),
            ),

            Container(height: _formDistance * 4),
            Row(children: <Widget>[
              Expanded(child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text('Submit', textScaleFactor: 1.5),
                onPressed: () {
                  setState(() {
                    result = _calculate();
                  });
                },
              ),
              ),
              Container(width: _formDistance * 2),
              Expanded(child: RaisedButton(
                color: Theme.of(context).buttonColor,
                textColor: Theme.of(context).primaryColorDark,
                child: Text('Reset', textScaleFactor: 1.5),
                onPressed: () {
                  setState(() {
                    _reset();
                  });
                },
              ),
              )
            ]),

            Text(result)
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

  String _calculate() {
    double distance = double.parse(distanceController.text);
    double consumption = double.parse(avgController.text);
    double fuelCost = double.parse(priceController.text);

    double _totalCost = distance / consumption * fuelCost;
    String _result = "The total cost of your trip is " +
        _totalCost.toStringAsFixed(2) +
        " " +
        currency;
    return _result;
  }

  void _reset() {
    distanceController.text = "";
    avgController.text = "";
    priceController.text = "";
    setState(() {
      result = "";
    });
  }
}
