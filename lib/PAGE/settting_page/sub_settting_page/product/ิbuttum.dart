import 'package:flutter/material.dart';

class buttom extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<buttom> {
  String selectedOption1 = 'Option 1';
  String selectedOption2 = 'Option A';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selectedOption1,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption1 = newValue!;
              });
            },
            items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // SizedBox(width: 16),
        ],
      ),
    );
  }
}
