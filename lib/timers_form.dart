import 'package:flutter/material.dart';
import 'package:iot_boiler/time_weekdays_input.dart';
import 'package:iot_boiler/widget_keys.dart';

import 'iData.dart';

class TimersForm extends StatefulWidget implements iData {
  WidgetKeysManager keys = WidgetKeysManager();
  final dynamic _formData = {};
  dynamic get formData => _formData;
  TimersForm({super.key});
  @override
  State<StatefulWidget> createState() {
    return _TimersFormState();
  }

  @override
  getData() {
    return _formData;
  }
}

class _TimersFormState extends State<TimersForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    WidgetKeysManager keys = widget.keys;
    print("build called ${WidgetKeysManager.KeyV20}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildForm(),
      ]
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        onChanged: () {print ("timersForm changed");},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSwitch(widget.keys.KeyV20),
                Text('Timer 1',
                  style: Theme.of(context).textTheme.bodyText1,),

                SizedBox(width:20),
                _buildTimeWeekdaysInput(widget.keys.KeyV10),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSwitch(widget.keys.KeyV21),
                Text('Timer 2',
                  style: Theme.of(context).textTheme.bodyText1,),

                SizedBox(width:20),
                _buildTimeWeekdaysInput(widget.keys.KeyV11),
              ],
            ),

          ],
        ));
  }
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
  }

  TimeWeekdaysInput _TimeWeekdaysInput = TimeWeekdaysInput(
  mode:TimeWeekdaysInput.MODE_DISPLAY);

  Widget _buildSwitch(GlobalKey id) {
    dynamic _formData = widget._formData;
    GlobalKey key = id;
    String _id = widget.keys.getIDFromGlobalKey(key);
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
        String id = widget.keys.getIDFromGlobalKey(key);
        setState(() {
          // light = value;
          _formData[id] = {"id":id,"value":value};
        });
      },
    );
  }
  /*
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submitForm();
      },
      child: Text('SEND1'),
    );
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //print(widget.keys.getIDFromGlobalKey(_formKey));
      print(widget._formData);
    }
  }

   */
}