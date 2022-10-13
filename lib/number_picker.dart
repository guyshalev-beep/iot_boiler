import 'package:flutter/cupertino.dart';
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
  getData() {
    return {
      //WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey):
  //    {
        "id": WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey),
        "value": _value
 //     }
    };
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
        Text(widget.title),
        NumberPicker(
        value: widget._value,
        minValue: 0,
        maxValue: 50,
        onChanged: (value) => setState(() => widget._value = value),
        ),
      ],
    );

  }
}
