import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iot_boiler/switch_iot.dart';
import 'package:iot_boiler/three_buttons_switch.dart';
import 'package:iot_boiler/time_weekdays_input.dart';
import 'package:iot_boiler/widget_keys.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:iot_boiler/mqtt/mqtt_client.dart';

import 'auth/signin.dart';
import 'iData.dart';
import 'led.dart';
import 'number_picker.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbapp = Firebase.initializeApp();

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
        home: FutureBuilder(
          future: _fbapp,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Text('Something wend wrong');
            } else if (snapshot.hasData) {
              print("Starting main page");
              return SignInScreen(); //BoilerPage(title: 'דוד החימום של משפחת שלו');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
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
  late final Future<String> _fdata = getDataFromFirebase();

  final TimeWeekdaysInput _TimeWeekdaysInputV10 = TimeWeekdaysInput(
      mode: TimeWeekdaysInput.MODE_DISPLAY, key: WidgetKeysManager.KeyV10);
  final TimeWeekdaysInput _TimeWeekdaysInputV11 = TimeWeekdaysInput(
      mode: TimeWeekdaysInput.MODE_DISPLAY, key: WidgetKeysManager.KeyV11);
  late Widget _SwitchV20, _SwitchV21;
  late Widget _ledV0;
  late Widget _numberPickerV6, _numberPickerV7;

  late MqttClient client;
  var topic = "esp8266/test-guys";
  void _publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  initState() {
    super.initState();
    print("------------------- initState");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataFromFirebase();
    });
    connect().then((value) {
      client = value;
      print("------------------------------ MQTT conected ------------------------------");
    });
    _SwitchV20 = SwitchIOT(key: WidgetKeysManager.KeyV20);
    _SwitchV21 = SwitchIOT(key: WidgetKeysManager.KeyV21);
    _ledV0 = Led(false, "On/Off");
    _numberPickerV6 =
        NumberPickerIOT(title: "max", key: WidgetKeysManager.KeyV6);
    _numberPickerV7 =
        NumberPickerIOT(title: "min", key: WidgetKeysManager.KeyV7);
  }



  Future<String> getDataFromFirebase() async {
    print("getDataFromFirebase");
    DatabaseReference _ref = FirebaseDatabase.instance.ref().child("test");
    DataSnapshot res = await _ref.get();
    widget._formData = res.value;
    print("++++++++++++++++ init state1 ${jsonEncode(res.value)}");
    setState(() { });
    return jsonEncode(res.value);
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    (_numberPickerV6 as iData).setData(widget._formData["6"]["value"]);
    (_numberPickerV7 as iData).setData(widget._formData["7"]["value"]);
  }

  @override
  Widget build(BuildContext context) {
    WidgetKeysManager keys = WidgetKeysManager();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
              future: _fdata,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something wend wrong');
                } else if (snapshot.hasData) {
                  print("Starting main page");
                  return _buildForm();//BoilerPage(title: 'דוד החימום של משפחת שלו');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            // _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        onChanged: () {
          print("form changed");
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
//this._publish("guy shalev is the king3");
                //this._publish("{20: {id: 20, value: false}, 21: {id: 21, value: false}, 10: {id: 10, time_input: {start_time: 21, end_time: 21}, week_days: [true, true, true, true, true, true, true]}, 11: {id: 11, time_input: {start_time: 21, end_time: 21}, week_days: [true, true, true, true, true, true, true]}, 6: {id: 6, value: 34}, 7: {id: 7, value: 39}, 1: {id: 1, selected: 0}}");
                widget._formData = {
                  ...(widget._formData as Map),
                  ...(_SwitchV20 as iData).getData(),
                  ...(_SwitchV21 as iData).getData(),
                  ...(_TimeWeekdaysInputV10 as iData).getData(),
                  ...(_TimeWeekdaysInputV11 as iData).getData(),
                  ...(_numberPickerV6 as iData).getData(),
                  ...(_numberPickerV7 as iData).getData(),
                  ...(_ThreeButtonsSwitch as iData).getData()
                };
                print(widget._formData);
                const JsonEncoder encoder = JsonEncoder();
                String json = encoder.convert(widget._formData);
                //JsonDecoder _decoder = JsonDecoder();
                //final Map<String, dynamic> json = _decoder.convert(widget._formData.toString());
                //json = json.replaceAll("'", "\'").replaceAll('"', "\\\"");
                print(json);
                //_publish(json);
                _publish("{\"11\":{\"id\":\"11\",\"time_input\":{\"start_time\":18,\"end_time\":18},\"week_days\":[true,true,true,true,true,true,true],\"1\":{\"id\":\"1\",\"selected\":0},\"6\":{\"id\":\"6\",\"value\":34},\"7\":{\"id\":\"7\",\"value\":39},\"id\":\"7\",\"value\":39,\"21\":{\"id\":21,\"value\":false}}\"");
                _publish("{\"11\":{\"id\":\"11\",\"time_input\":{\"start_time\":18,\"end_time\":18},\"week_days\":[true,true,true,true,true,true,true]}\"");
                _publish("--------------------------------------------------------------------------------------------------------------------------------");
                _publish("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                DatabaseReference _ref =
                    FirebaseDatabase.instance.ref().child("test");
                _ref.set(widget._formData);
              },
              child: Text('SEND'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ledV0,
              ],
            ),
            const SizedBox(height: 20),
            _ThreeButtonsSwitch,
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SwitchV20,
                Text(
                  'Timer 1',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(width: 20),
                Container(
                  width: 120,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: _TimeWeekdaysInputV10,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SwitchV21,
                Text(
                  'Timer 2',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(width: 20),
                Container(
                  width: 120,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: _TimeWeekdaysInputV11,
                ),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _numberPickerV6,
                  _numberPickerV7,
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Boost Max'),
                  ),
                  SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Boost 40'),
                  ),
                ]),
          ],
        ));
  }

  final Widget _ThreeButtonsSwitch =
      ThreeButtonsSwitch(key: WidgetKeysManager.KeyV1);
//final Widget _TimersForm = TimersForm();
/*
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
*/
}
