import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  TextStyle inputStyle = TextStyle(fontSize: 20, color: Colors.blue[900]);
  TextStyle lebelStyle = TextStyle(fontSize: 24, color: Colors.grey[700]);
  double? value;
  final List<String> _measures = [
    'meters',
    'kilometers',
    'grams',
    'kilograms',
    'feet',
    'miles',
    'pounds (lbs)',
    'ounces',
  ];

  String? _startMeasure;
  String? _convertedMeasure;
  String _resultText = '';

  final Map<String, int> _measuresMap = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };

  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  double convert(value, from, to) {
    String? from_idx = _measuresMap[from].toString();
    int to_idx = _measuresMap[to]!;
    var factor = _formulas[from_idx][to_idx];

    double _convertedValue = value * factor;
    return _convertedValue;
  }

  void initState() {
    value = 0.0;
    _startMeasure = 'meters';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Unit converter',
        home: Scaffold(
            appBar: AppBar(title: Text('Unit converter is awsome')),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Spacer(),
                Text(
                  'Value',
                  style: lebelStyle,
                ),
                Spacer(),
                TextField(
                  style: inputStyle,
                  decoration: InputDecoration(
                    hintText: 'Enter the value you want to convert',
                  ),
                  onChanged: (text) {
                    var val = double.tryParse(text);

                    setState(() {
                      (val == null) ? value = 0.0 : value = val;
                    });
                  },
                ),
                Spacer(),
                Text(
                  'From',
                  style: lebelStyle,
                ),
                Spacer(),
                DropdownButton<String>(
                    isExpanded: true,
                    value: _startMeasure,
                    items: _measures.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? curr_value) {
                      setState(() {
                        _startMeasure = curr_value;
                      });
                    }),
                Spacer(),
                Text(
                  'To',
                  style: lebelStyle,
                ),
                Spacer(),
                DropdownButton<String>(
                    isExpanded: true,
                    value: _convertedMeasure,
                    items: _measures.map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? curr_value) {
                      setState(() {
                        _convertedMeasure = curr_value;
                      });
                    }),
                Spacer(
                  flex: 2,
                ),
                ElevatedButton(
                    onPressed: () {
                      // before calling the convert method check if the values exist
                      if (_startMeasure == null ||
                          _convertedMeasure == null ||
                          value == 0.0) {
                      } else {
                        double convertedValue =
                            convert(value, _startMeasure, _convertedMeasure);
                        if (convertedValue == 0) {
                          _resultText = "Unable to perform conversion";
                        } else {
                          _resultText =
                              " $value $_startMeasure is $convertedValue $_convertedMeasure";
                       
                        }
                           setState(() {
                            _resultText = _resultText;
                          });
                      }
                    },
                    child: Text('Convert')),
                Spacer(flex: 2),
                Text(_resultText),
                Spacer(flex: 8),
              ]),
            )));
  }
}
