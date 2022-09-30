import 'package:flutter/material.dart';
import 'package:iot_boiler/time_weekdays_input.dart';
import 'package:iot_boiler/widget_keys.dart';

import 'iData.dart';

class ThreeButtonsSwitch extends StatefulWidget implements iData{
  WidgetKeysManager keys = WidgetKeysManager();
  dynamic _widgetData = {};

  ThreeButtonsSwitch({ super.key});
  @override
  State<StatefulWidget> createState() {
    return _ThreeButtonsSwitchState();
  }

  @override
  getData() {
    return _widgetData;
  }
}

class _ThreeButtonsSwitchState extends State<ThreeButtonsSwitch> {
  @override
  Widget build(BuildContext context) {
    WidgetKeysManager keys = widget.keys;
    setState(() {
      int value = -1;
      for (int index = 0; index < isSelected.length; index++) {
        // checking for the index value
        if (isSelected[index]) {
          // one button is always set to true
          value = index;
        }
      }
      widget._widgetData[WidgetKeysManager.getIDFromGlobalKey(widget.key as GlobalKey)] = {
        "id":WidgetKeysManager.getIDFromGlobalKey(widget.key as GlobalKey),
        "selected": value
      };
    });
    return Container(
      child:
      _buildToggleButton(WidgetKeysManager.KeyV30),
    );
  }
  List<bool> isSelected = [true, false, false];
  Widget _buildToggleButton(GlobalKey key) {
    String _id = WidgetKeysManager.getIDFromGlobalKey(key);
    return ToggleButtons(
      // list of booleans
        isSelected: isSelected,
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
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        // border properties for each toggle
        renderBorder: true,
        borderColor: Colors.black,
        borderWidth: 1.5,
        borderRadius: BorderRadius.circular(10),
        selectedBorderColor: Colors.pink,
// add widgets for which the users need to toggle
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('Open', style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('Close', style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('Timer', style: TextStyle(fontSize: 18)),
          ),
        ],
      onPressed: (int newIndex) {
        setState(() {
          // looping through the list of booleans values
          for (int index = 0; index < isSelected.length; index++) {
            // checking for the index value
            if (index == newIndex) {
              // one button is always set to true
              isSelected[index] = true;
              //_widgetData = {"id":_id, "value":index};
            } else {
              // other two will be set to false and not selected
              isSelected[index] = false;
            }
          }
        });
      },
    );
  }
}