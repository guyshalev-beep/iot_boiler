import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_boiler/time_input.dart';
import 'package:iot_boiler/widget_keys.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'dart:ui';

import 'iData.dart';

class TimeWeekdaysInput extends StatefulWidget implements iData{
  static  const MODE_DISPLAY = 1;
  static const MODE_EDIT = 2;
  late int mode;
  WidgetKeysManager keys = WidgetKeysManager();
  late dynamic _widgetData = {};
  //late String id;

  TimeWeekdaysInput({super.key, required this.mode});
  @override
  State<TimeWeekdaysInput> createState() => _TimeWeekdaysInputState(this.mode);

  @override
  getData() {
    return _widgetData;
  }

}

class _TimeWeekdaysInputState extends State<TimeWeekdaysInput> {
  final dynamic _state = {"mode":-1};
  _TimeWeekdaysInputState(int _mode){
      _state["mode"] = _mode;
    print ("set mode for id to ${_state["mode"]}");
  }

  @override
  Widget build(BuildContext context) {

    _state["mode"] = widget.mode;
    //setState(() {});
    print ("${widget.key}--" + _state.toString());
    final values = List.filled(7, true);
    const shortWeekdays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];
    var buffer = StringBuffer();
    int c = 0;
    bool all_week = true;
    shortWeekdays.forEach((item){
      if(values[c])
        buffer.write(item + ", ");
      else
        all_week = false;
    });
    String days = (all_week)?"Everyday":buffer.toString().substring(0,buffer.toString().length - 2);
    TimeInput time_input = TimeInput();
    time_input.mode = _state["mode"];
    //widget.getData()["time_input"] = time_input.getData();
    Widget editWidget = Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('CHOOSE DAYS OF WEEK',
              style: Theme.of(context).textTheme.bodyText1,),
            const SizedBox(height: 10,),
            WeekdaySelector(
              firstDayOfWeek: DateTime.sunday,
              shortWeekdays: shortWeekdays,
              onChanged: (int day) {
                setState(() {
                  final index = day % 7;
                  values[index] = !values[index];
                  widget._widgetData = {"values":values};
                });
              },
              values: values,
            ),
          ]),
    );

    Widget displayWidget = Container(
      height:50,
    child: ListView(
      scrollDirection: Axis.vertical,
      children: [
        time_input,
        //const SizedBox(height: 10),
        Text(days),
      ],
    ),
    );
    print("mode = ${_state["mode"]}");
    print("data=${widget.key}");
    widget._widgetData[WidgetKeysManager.getIDFromGlobalKey(widget.key as GlobalKey)] = {
      "id":WidgetKeysManager.getIDFromGlobalKey(widget.key as GlobalKey),
      "time_input": (time_input as iData).getData(),
      "week_days": values
    };
    return (_state["mode"] == TimeWeekdaysInput.MODE_EDIT) ? editWidget : displayWidget;
  }
}
