import 'package:flutter/material.dart';
import 'package:hausiui/forms/hausiui_text_form_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'My Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                HausiuiTextFormField(
                  label: 'Hausiui Textfeld',
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textInputAction: TextInputAction.go,
                  obscureText: false,
                  autofocus: false,
                  height: 50,
                  readOnly: false,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Normales Textfeld',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Slider(
                    value: _sliderValue,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _sliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ),
                Transform.rotate(
                  angle: _sliderValue * 2 / 5,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
