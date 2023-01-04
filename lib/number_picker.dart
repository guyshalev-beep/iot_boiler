import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_boiler/widget_keys.dart';
import 'package:numberpicker/numberpicker.dart';

import 'iData.dart';

class NumberPickerIOT extends StatefulWidget implements iData{
  String title = "";
  int _value = 36;
  NumberPickerIOT({super.key, required this.title});


  @override
  State<NumberPickerIOT> createState() => _NumberPickerIOTState();

  @override
  getData1() {
    return {
      //WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey):
  //    {
        "id": WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey),
        "value": _value
 //     }
    };
  }


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
    return result;
  }

  @override
  setData(_d) {
    _value = _d;
  }
}

class _NumberPickerIOTState extends State<NumberPickerIOT> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            widget.title,
            style: Theme.of(context).textTheme.headline2,
        ),
        NumberPicker(
          itemHeight: 50,
          itemWidth: 50,
          axis: Axis.horizontal,
          textStyle: Theme.of(context).textTheme.headline3,
          selectedTextStyle: Theme.of(context).textTheme.headline4,
        value: widget._value,
        minValue: 0,
        maxValue: 60,
        onChanged: (value) => setState(() => widget._value = value),
        ),
      ],
    );

  }
}
