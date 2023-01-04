import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:iot_boiler/notification/notification.dart';
import 'package:iot_boiler/switch_iot.dart';
import 'package:iot_boiler/toggle_buttons_switch.dart';
import 'package:iot_boiler/time_weekdays_input.dart';
import 'package:iot_boiler/widget_keys.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:iot_boiler/mqtt/mqtt_client.dart';

import 'auth/authentication.dart';
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

 // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
            headline1: TextStyle(
                fontFamily: "PatrickHand",
                fontSize: 72.0,
                fontWeight: FontWeight.bold),
            headline2: TextStyle(
                fontFamily: "PatrickHand",
                height: 2,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.blue),
            headline3: TextStyle(
                fontFamily: "PatrickHand",
                height: 2,
                fontWeight: FontWeight.bold,
                fontSize: 8.0,
                color: Colors.blue),
            headline4: TextStyle(
                fontFamily: "PatrickHand",
                height: 2,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                ),
            headline5: TextStyle(
                fontFamily: "RubikBubbles",
                height: 2,
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.blue),
            headline6: TextStyle(
                fontFamily: "Roboto",
                fontSize: 36.0,
                fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontFamily: "Roboto", fontSize: 14.0),
            bodyText1: TextStyle(fontFamily: "PatrickHand", fontSize: 15.0),
            button: TextStyle(
                fontFamily: "PatrickHand", fontWeight: FontWeight.bold),
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

  NotificationManager _notif = NotificationManager();
  dynamic _formData = {};
  final String title;
  late String _sync = "0";

  @override
  State<BoilerPage> createState() => _BoilerPageState();
}

class _BoilerPageState extends State<BoilerPage> {
  final _formKey = GlobalKey<FormState>();
  late final Future<String> _fdata; // = getDataFromFirebase();
  late TimeWeekdaysInput _TimeWeekdaysInputV10;
  late TimeWeekdaysInput _TimeWeekdaysInputV11;
  late TimeWeekdaysInput _TimeWeekdaysInputV12;
  late ToggleButtonsSwitch _ToggleV8;
  late Widget _SwitchV20, _SwitchV21, _SwitchV22, _SwitchV8;
  late Widget _ledV0;
  late Widget _numberPickerV6, _numberPickerV7;
  late Widget _ThreeButtonsSwitchV1, _boostButtonsSwitchV9, _ButoonV30;
  late String _textV31, _textV5,_textV30;
  late MqttClient client;
  var topic = "esp8266/test-guys";


  Future<void> _publish(String message) async {
    final builder = MqttClientPayloadBuilder();
    print('before connect, status: ${client?.connectionHandler?.connectionStatus?.state}');
    if (client?.connectionHandler?.connectionStatus?.state != MqttConnectionState.connected ){
      print ("MQTT Reconnet...");
      await client.connect();
    }
    builder.addString(message);
    print("about to publish: $message");
    try{
      client?.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    }catch (e){
      print(e);
    }
  }

  @override
  initState() {
    super.initState();
    NotificationManager.notificationInitState();
    print("------------------- initState");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataFromFirebase();
    });
    connect().then((value) {
      client = value;
      print(
          "------------------------------ MQTT conected ------------------------------");
    });
    print("about fdata");
    //print(_fdata);
    _ledV0 = Led(false, "On/Off");
    _ThreeButtonsSwitchV1 = ToggleButtonsSwitch(
        3, ["Open", "Close", "Timer"], [false, true, false],
        key: WidgetKeysManager.KeyV1);
    _numberPickerV6 =
        NumberPickerIOT(title: "Max \u2103", key: WidgetKeysManager.KeyV6);
    _numberPickerV7 =
        NumberPickerIOT(title: "Min \u2103", key: WidgetKeysManager.KeyV7);
    _boostButtonsSwitchV9 = ToggleButtonsSwitch(
        2, ["Boost 40c", "Boost Max"], [false, false],
        key: WidgetKeysManager.KeyV9);
    _TimeWeekdaysInputV10 = TimeWeekdaysInput(
        mode: TimeWeekdaysInput.MODE_DISPLAY, key: WidgetKeysManager.KeyV10);
    _TimeWeekdaysInputV11 = TimeWeekdaysInput(
        mode: TimeWeekdaysInput.MODE_DISPLAY, key: WidgetKeysManager.KeyV11);
    _TimeWeekdaysInputV12 = TimeWeekdaysInput(
        mode: TimeWeekdaysInput.MODE_DISPLAY, key: WidgetKeysManager.KeyV12);

    _SwitchV20 = SwitchIOT(key: WidgetKeysManager.KeyV20);
    _SwitchV21 = SwitchIOT(key: WidgetKeysManager.KeyV21);
    _SwitchV22 = SwitchIOT(key: WidgetKeysManager.KeyV22);
    _SwitchV8 = SwitchIOT(key: WidgetKeysManager.KeyV8);
    _ButoonV30 = ElevatedButton(
      child: Text('Adjust Device Time'),
      onPressed: () async {
        _textV30 = '{"30":{"id":30,"value":true}}';
        _textV31 =
      //      '{"31":{"id":31,"value":"${TimeOfDay.now().hour.toString()}:${TimeOfDay.now().minute.toString()}"}}';
        '{"31":{"id":31,"time":{"year":${DateTime.now().year},"month":${DateTime.now().month},"day":${DateTime.now().day},"hour":${DateTime.now().hour},"minute":${DateTime.now().minute},"second":${DateTime.now().second}}}}';

        widget._formData = {
          ...(widget._formData as Map),
          ...(jsonDecode(
              (_textV30 != null) ? _textV30 : "{}")),
          ...(jsonDecode(
              (_textV30 != null) ? _textV31 : "{}"))
        };
        DatabaseReference _ref =
        FirebaseDatabase.instance.ref().child("test");
        await _ref.set(widget._formData);
        _publish("dosync");
        },
    );
    _textV31 = "{}";
    _textV30 = '{"30":{"id":30,"value":false}}';
    _textV5 = "N/A";
  }

  @override
  void dispose() {
    widget._notif.notificationDispose();
    super.dispose();
  }

  // Future<String> getDataFromFirebase1() async {
  //   print("getDataFromFirebase");
  //   DatabaseReference _ref = FirebaseDatabase.instance.ref().child("test");
  //   DataSnapshot res = await _ref.get();
  //   widget._formData = (res.value != null) ? jsonEncode(res.value) : {};
  //   print("++++++++++++++++ init state1 ${jsonEncode(res.value)}");
  //   setState(() {});
  //   return jsonEncode(res.value);
  // }

  getDataFromFirebase() async {
    print("getDataFromFirebase");
    DatabaseReference _ref = FirebaseDatabase.instance.ref().child("test");
    _ref.onValue.listen((DatabaseEvent event) {
      print("----=====-----===== firebase updated");
      final data = event.snapshot.value;
      updateWidgetData(data);
    });
    // return jsonEncode(res.value);
  }

  updateWidgetData(data) {
    widget._formData = (data != null) ? jsonEncode(data) : {};
    setState(() {});
  }

  @override
  void setState(VoidCallback fn) {
    widget._formData = jsonDecode(widget._formData.toString());
    setWidgetsData();
    super.setState(fn);
  }

  void setWidgetsData() {
    print('setWidgetsData ${widget._formData["sync"]}');
    if (widget._formData != null) {
      if (widget._formData["1"] != null)
        (_ThreeButtonsSwitchV1 as iData)
            .setData(widget._formData["1"]["selected"]);
      if (widget._formData["sync"] != null)
        widget._sync = widget._formData["sync"]["value"];
      if (widget._formData["0"] != null)
        (_ledV0 as iData).setData(widget._formData["0"]["value"]);
      if (widget._formData["5"] != null)
        _textV5 = widget._formData["5"]["value"].toString();
      if (widget._formData["6"] != null)
        (_numberPickerV6 as iData).setData(widget._formData["6"]["value"]);
      if (widget._formData["7"] != null)
        (_numberPickerV7 as iData).setData(widget._formData["7"]["value"]);
      if (widget._formData["9"] != null)
        (_boostButtonsSwitchV9 as iData)
            .setData(widget._formData["9"]["selected"]);
      if (widget._formData["10"] != null)
        (_TimeWeekdaysInputV10 as iData).setData(widget._formData["10"]);
      if (widget._formData["11"] != null)
        (_TimeWeekdaysInputV11 as iData).setData(widget._formData["11"]);
      if (widget._formData["12"] != null)
        (_TimeWeekdaysInputV12 as iData).setData(widget._formData["12"]);
      if (widget._formData["20"] != null)
        (_SwitchV20 as iData).setData(widget._formData["20"]["value"]);
      if (widget._formData["21"] != null)
        (_SwitchV21 as iData).setData(widget._formData["21"]["value"]);
      if (widget._formData["22"] != null)
        (_SwitchV22 as iData).setData(widget._formData["22"]["value"]);
      if (widget._formData["8"] != null)
        (_SwitchV8 as iData).setData(widget._formData["8"]["value"]);
    }
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plain title', 'plain body', notificationDetails,
        payload: 'item x');
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    print("boiler build ${widget._formData}");
    rebuildAllChildren(context);
    WidgetKeysManager keys = WidgetKeysManager();
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.centerRight,
            child: Text(widget.title + "  " + " \u2103 " + _textV5,
                style: Theme.of(context).textTheme.headline5)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildForm()
            // FutureBuilder(
            //   future: _fdata,
            //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //     if (snapshot.hasError) {
            //       return Text('Something wend wrong');
            //     } else if (snapshot.hasData) {
            //       print("Starting main page");
            //       return _buildForm();//BoilerPage(title: 'דוד החימום של משפחת שלו');
            //     } else {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //   },
            // ),
            // _buildForm(),
          ],
        ),
      ),
    );
  }
  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  Widget _buildForm() {
    print("build form");
    setWidgetsData();
    late MaterialStatePropertyAll<Color> __back_color;
    if (widget._sync == "1")
      __back_color = MaterialStatePropertyAll<Color>(Colors.green);
    else
      __back_color = MaterialStatePropertyAll<Color>(Colors.blue);
    return (widget._formData == null)
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            onChanged: () {
              print("form changed");
            },
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ledV0,
                      const SizedBox(width: 60),
                      _ThreeButtonsSwitchV1,
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          //MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height:10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SwitchV20,
                                Text(
                                  'Timer 1',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: _TimeWeekdaysInputV10,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SwitchV21,
                                Text(
                                  'Timer 2',
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: _TimeWeekdaysInputV11,
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SwitchV22,
                                Text(
                                  'Timer 3',
                                  style: Theme.of(context).textTheme.headline2,
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2),
                                  child: _TimeWeekdaysInputV12,
                                ),
                              ],
                            ),

                            //SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _SwitchV8,
                                Text(
                                  'Limit Temp',
                                  style: Theme.of(context).textTheme.headline2,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ])),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _numberPickerV6,
                        _numberPickerV7,
                      ]),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_boostButtonsSwitchV9]),
                  SizedBox(height: 50),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ButoonV30,
                        SizedBox(width: 50),
                        ElevatedButton(
                            style: TextButton.styleFrom(backgroundColor: (widget._sync == "1")?Colors.red:Colors.blue),
                          onPressed: () async {
                            //_showNotification();
                            //NotificationManager.notify();

                            widget._formData = {
                              ...(widget._formData as Map),
                              ...(_ThreeButtonsSwitchV1 as iData).getData(),
                              ...(_numberPickerV6 as iData).getData(),
                              ...(_numberPickerV7 as iData).getData(),
                              ...(_boostButtonsSwitchV9 as iData).getData(),
                              ...(_TimeWeekdaysInputV10 as iData).getData(),
                              ...(_TimeWeekdaysInputV11 as iData).getData(),
                              ...(_TimeWeekdaysInputV12 as iData).getData(),
                              ...(_SwitchV20 as iData).getData(),
                              ...(_SwitchV21 as iData).getData(),
                              ...(_SwitchV22 as iData).getData(),
                              ...(_SwitchV8 as iData).getData(),
                               ...(jsonDecode(
                                   (_textV31 != null) ? "{}" : "{}")),
                               ...(jsonDecode(
                                   (_textV30 != null) ? "{}" : "{}")),
                            };
                            widget._formData["sync"] =  {"id":"sync","value":"1"};
                            _textV30 = '{"30":{"id":30,"value":false}}';
                            print(widget._formData);
                            const JsonEncoder encoder = JsonEncoder();
                            String json = encoder.convert(widget._formData);
                            print(json);
                            DatabaseReference _ref =
                                FirebaseDatabase.instance.ref().child("test");
                            await _ref.set(widget._formData);
                            _publish("dosync");
                          },
                          child: Text('SEND'),
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await Authentication.signOut(context: context);
                              Navigator.of(context)
                                  .pushReplacement(_routeToSignInScreen());
                          },
                            child: Text("Log Out"))
                      ])
                ]));
  }

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
