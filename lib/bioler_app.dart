import 'package:flutter/material.dart';
import 'package:iot_boiler/three_buttons_switch.dart';
import 'package:iot_boiler/time_weekdays_input.dart';
import 'package:iot_boiler/widget_keys.dart';

import 'iData.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      title: 'Form Demo',
      home: BoilerPage(title: 'Flutter Demo Home Page1'),

    );
  }
}

class BoilerPage extends StatefulWidget {
  BoilerPage({super.key, required this.title});
  dynamic _formData = {};
  final String title;
  @override
  State<BoilerPage> createState() => _BoilerPageState();
}

class _BoilerPageState extends State<BoilerPage> {
  final _formKey = GlobalKey<FormState>();
  final TimeWeekdaysInput _TimeWeekdaysInputV10 = TimeWeekdaysInput(
      mode:TimeWeekdaysInput.MODE_DISPLAY, key:WidgetKeysManager.KeyV10);
  final TimeWeekdaysInput _TimeWeekdaysInputV11 = TimeWeekdaysInput(
      mode:TimeWeekdaysInput.MODE_DISPLAY, key:WidgetKeysManager.KeyV11);
  late Widget _SwitchV20, _SwitchV21;
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _SwitchV20 = _buildSwitch(WidgetKeysManager.KeyV20);
    _SwitchV21 = _buildSwitch(WidgetKeysManager.KeyV21);
  }
  @override
  Widget build(BuildContext context) {
    setState(() { });
    WidgetKeysManager keys = WidgetKeysManager();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            _buildForm(),
          ],
      ),
      ),
    );
  }
  Widget _buildForm() {
    return Form(
        key: _formKey,
        onChanged: () {print("form changed");},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                //print((_ThreeButtonsSwitch as iData).getData());
                //print((_TimeWeekdaysInputV10 as iData).getData());
                widget._formData = {
                  ...(widget._formData as Map),
                  ...(_TimeWeekdaysInputV10 as iData).getData(),
                  ...(_TimeWeekdaysInputV11 as iData).getData(),
                  ...(_ThreeButtonsSwitch as iData).getData()};
                print ( widget._formData);
                },
              child: Text('SEND'),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SwitchV20,
                Text('Timer 1',
                  style: Theme.of(context).textTheme.bodyText1,),
                SizedBox(width:20),
                Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: _TimeWeekdaysInputV10,
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SwitchV21,
                Text('Timer 2',
                  style: Theme.of(context).textTheme.bodyText1,),
                SizedBox(width:20),
                Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: _TimeWeekdaysInputV11,
                ),
              ],
            ),
            _ThreeButtonsSwitch,
          ],
        ));
  }
  final Widget _ThreeButtonsSwitch = ThreeButtonsSwitch(key:WidgetKeysManager.KeyV1);
  //final Widget _TimersForm = TimersForm();

  Widget _buildSwitch(GlobalKey id) {
    dynamic _formData = widget._formData;
    GlobalKey key = id;
    String _id = WidgetKeysManager.getIDFromGlobalKey(key);
    dynamic _widgetData = _formData[_id];
    if (_widgetData == null) _formData[_id] = {"id":_id, "value":false};
    return Switch(
      key: id,
      value: _formData[_id]["value"],
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
      inactiveTrackColor: Colors.red,
      onChanged: (bool value) {
        print("switch changed ${key}");
        String id = WidgetKeysManager.getIDFromGlobalKey(key);
        setState(() {
          // light = value;
          _formData[id] = {"id":id,"value":value};
        });
      },
    );
  }
  /*
  Widget _buildTimeWeekdaysInput(GlobalKey key) {
    String _id = widget.keys.getIDFromGlobalKey(key);
    dynamic _widgetData = widget._formData[_id];
    if (_widgetData == null) widget._formData[_id] = {"id":_id, "value":false};
    return Container(
      //height: 120,
      width: 120,
      //color: Colors.yellow,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: _TimeWeekdaysInput,
    );
  }*/

}

