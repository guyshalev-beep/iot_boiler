import 'package:flutter/material.dart';
import 'package:iot_boiler/time_input.dart';
import 'package:iot_boiler/time_weekdays_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo1',
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page1'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool light = true;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int _mode =  TimeWeekdaysInput.MODE_DISPLAY;
  TimeWeekdaysInput twdi = TimeWeekdaysInput(id:"v1",mode:TimeWeekdaysInput.MODE_DISPLAY);
  @override
  Widget build(BuildContext context) {
    print ("start build mode=${_mode}");
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final values = List.filled(7, true);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:

      Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),

            ElevatedButton(
              style: style,
              onPressed: () {
                print("move to mode display");
                setState(() {
                  _mode = TimeWeekdaysInput.MODE_EDIT;
                  twdi.mode = _mode;
                });
              },
              child: const Text('Enabled'),
            ),
            ElevatedButton(
              style: style,
              onPressed: null,
              child: const Text('Disabledn'),
            ),
            twdi,
            TimeWeekdaysInput(id:"v2",mode:_mode),
            TimeWeekdaysInput(id:"V3", mode:TimeWeekdaysInput.MODE_DISPLAY),

        Switch(
          // This bool value toggles the switch.
          value: light,
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Colors.red,
          onChanged: (bool value) {
            // This is called when the user toggles the switch.
            setState(() {
              light = value;
            });
          },
        ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
