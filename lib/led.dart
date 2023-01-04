import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_boiler/widget_keys.dart';

import 'iData.dart';

class Led extends StatelessWidget implements iData{
  bool _on = false;
  String _title = "";
  Led(bool on, String title, {Key? key}) {
    //super(key: key);
    _on = on;
    _title = title;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            _title,
          style: Theme.of(context).textTheme.bodyText1
        ),
        Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
        color: (_on)?Colors.green:Colors.red,
        shape: BoxShape.circle,
        ),
        ),
      ],
    );

  }

  @override
  getData() {
    String _key = WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey);
    String jsonString =     '''
    {
    "${_key}",
      {
        "id": ${_key},
        "value": ${_on}
      }
    }
    ''';
    const JsonDecoder decoder = JsonDecoder();
    Map<String, dynamic> result =  decoder.convert(jsonString);
    return result;
  }

  @override
  setData(_d) {
    _on = (_d == "true");
  }
}
