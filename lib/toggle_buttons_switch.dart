import 'package:flutter/material.dart';
import 'package:iot_boiler/time_weekdays_input.dart';
import 'package:iot_boiler/widget_keys.dart';

import 'iData.dart';

class ToggleButtonsSwitch extends StatefulWidget implements iData{
  WidgetKeysManager keys = WidgetKeysManager();
  late int buttonsNum;
  late List<String> titles;
  late List<bool> isSelected;
  late int value = 0;
  Map<String, dynamic> _widgetData = {};

  ToggleButtonsSwitch(this.buttonsNum,this.titles,this.isSelected,{ super.key});
  @override
  State<StatefulWidget> createState() {
    return _ToggleButtonsSwitchState();
  }

  @override
  getData() {
    _widgetData[WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey)] = {
      "id":WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey),
      "selected": (value!=0)?value:0
    };
    return _widgetData;
  }

  @override
  setData(_d) {
    if(_d == null) return;
    int val;
    try{
      val = int.parse(_d);
    }catch(err){
      val = _d;
    }
    print('setData ToggleButton = ${key} ${val}');

    for (int index = 0; index < isSelected.length; index++) {
      int _index = val - 1;
      print('_index=${_index}, index=${index}');
      if (val == 0)
        isSelected[index] = false;
      else
        isSelected[index]=(index == _index);
    }
    value = val - 1;
  }
}

class _ToggleButtonsSwitchState extends State<ToggleButtonsSwitch> {
  @override
  Widget build(BuildContext context) {
    WidgetKeysManager keys = widget.keys;
    setState(() {

      for (int index = 0; index < widget.isSelected.length; index++) {
        // checking for the index value
        if (widget.isSelected[index]) {
          // one button is always set to true
          widget.value = index + 1;
        }
      }

    });
    return Container(
      child:
      _buildToggleButton(WidgetKeysManager.KeyV30),
    );
  }

  Widget _buildToggleButton(GlobalKey key) {
    String _id = WidgetKeysManager.getIDFromGlobalKey(key);

    return ToggleButtons(
      // list of booleans
        isSelected:   widget.isSelected,
        // text color of selected toggle
        selectedColor: Colors.white,
        // text color of not selected toggle
        color: Colors.blue,
        // fill color of selected toggle
        fillColor: Colors.lightBlue.shade900,
        // when pressed, splash color is seen
        splashColor: Colors.red,
        // long press to identify highlight color
        highlightColor: Colors.orange,
        // if consistency is needed for all text style
        textStyle: Theme.of(context).textTheme.button,
        // border properties for each toggle
        renderBorder: true,
        borderColor: Colors.black,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(10),
        selectedBorderColor: Colors.pink,
// add widgets for which the users need to toggle
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(widget.titles[0], style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(widget.titles[1], style: TextStyle(fontSize: 18)),
          ),
          if (widget.buttonsNum == 3) Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(widget.titles[2], style: TextStyle(fontSize: 18)),
          ),
        ],
      onPressed: (int newIndex) {
        setState(() {
          // looping through the list of booleans values
          for (int index = 0; index < widget.isSelected.length; index++) {
            // checking for the index value
            if (index == newIndex) {
              // one button is always set to true
              widget.isSelected[index] = true;
              //_widgetData = {"id":_id, "value":index};
            } else {
              // other two will be set to false and not selected
              widget.isSelected[index] = false;
            }
          }
        });
      },
    );
  }
}