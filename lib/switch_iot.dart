import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_boiler/widget_keys.dart';
import 'package:numberpicker/numberpicker.dart';

import 'iData.dart';

class SwitchIOT extends StatefulWidget implements iData{

  bool _value = false;
  SwitchIOT({super.key});



  @override
  State<SwitchIOT> createState() => _SwitchIOTState();

  @override
  getData() {
    String _key = WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey);
    String jsonString =     '''
    {
    "${_key}":
      {
        "id": ${_key},
        "value": ${_value}
      }
    }
    ''';
    const JsonDecoder decoder = JsonDecoder();
    Map<String, dynamic> result =  decoder.convert(jsonString);
    print("js " + jsonString);
    print(result.toString());
    return result;
  }

  @override
  setData(_d) {
    _value = _d;
  }
}

class _SwitchIOTState extends State<SwitchIOT> {

  @override
  Widget build(BuildContext context) {
    return Switch(
        //key: widget.key,

        value: widget._value,
        activeColor: Colors.green,
        inactiveThumbColor: Colors.red,
        inactiveTrackColor: Colors.red,
        onChanged: (bool value) {
          print("switch changed ${widget.key}");
          String id = WidgetKeysManager.getIDFromGlobalKey(widget.key as GlobalKey);
          setState(() {
            // light = value;
            widget._value = value;
          });
        });
  }
}
