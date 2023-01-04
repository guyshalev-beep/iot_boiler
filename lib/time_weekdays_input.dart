import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_boiler/time_input.dart';
import 'package:iot_boiler/widget_keys.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'dart:ui';

import 'edit_time_input.dart';
import 'iData.dart';

class TimeWeekdaysInput extends StatefulWidget implements iData{
  static  const MODE_DISPLAY = 1;
  static const MODE_EDIT = 2;
  late int mode;
  TimeInput time_input = TimeInput();
  WidgetKeysManager keys = WidgetKeysManager();
  late Map<String, dynamic> _widgetData = {};
  //late String id;

  TimeWeekdaysInput({super.key, required this.mode});
  @override
  State<TimeWeekdaysInput> createState() => _TimeWeekdaysInputState(this.mode);

  @override
  getData() {
    _widgetData[WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey)] = {
      "id":WidgetKeysManager.getIDFromGlobalKey(key as GlobalKey),
      "time_input": (time_input as iData).getData(),
      //"week_days": {"sun":"${values[0]}","mon":"${values[1]}","tue":"${values[2]}","wed":"${values[3]}","thu":"${values[4]}","fri":"${values[5]}","sat":"${values[6]}"}
      "week_days": values
    };


    print ("before ${_widgetData.toString()}");
    const JsonEncoder encoder = JsonEncoder();
    String r = encoder.convert(_widgetData);
    print ("r ${r.toString()}");
    const JsonDecoder decoder = JsonDecoder();
    Map<String, dynamic> result =  decoder.convert(r);
    print ("after ${result.toString()}");
    return result;
  }
  var values = List.filled(7, true);


  @override
  setData(_d) {
    if (_d == null) return;
    _d = jsonEncode(_d);
    print ("time_weekday_input received: " + _d.toString());
    _widgetData = jsonDecode(_d);
    print (_widgetData);
    values = List<bool>.from(jsonDecode(_widgetData["week_days"].toString()));
    print ("received time_input: " +_widgetData["time_input"].toString());
    (time_input as iData).setData(_widgetData["time_input"]);
    //_widgetData = _d;
  }

}

class _TimeWeekdaysInputState extends State<TimeWeekdaysInput> {
  final dynamic _state = {"mode":-1};
  //var values = List.filled(7, true);

  _TimeWeekdaysInputState(int _mode){
      _state["mode"] = _mode;
    print ("set mode for id to ${_state["mode"]}");
  }


  Future selectedWeekdays(BuildContext context, values, shortWeekdays) async {
    widget.values = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) =>
        EditTimeInput(values:values)
      ),
    );
    setState(() {
      print ('received result ${values}');
    });

  }

  @override
  Widget build(BuildContext context) {

    var values = widget.values;
    if (values == null)
      values = List.filled(7, true);

    print (values.toString());
    print (List.filled(7, true).toString());
    _state["mode"] = widget.mode;
    //setState(() {});
    print ("${widget.key}--" + values.toString());

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
      c = c + 1;
    });
    String days = (all_week)?"Everyday":buffer.toString().substring(0,buffer.toString().length - 2);
    TimeInput time_input = widget.time_input;
    time_input.setData(widget._widgetData["time_input"]);
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
              values: List<bool>.from(values) ,
            ),
          ]),
    );

    Widget displayWidget = Container(
      height:80,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          time_input,
          //const SizedBox(height: 10),
        GestureDetector(
          child: Text(
              days,
              style: Theme.of(context).textTheme.bodyText1),
          onTap: () {
            print ("click on days");
            selectedWeekdays(context, values, shortWeekdays);
          }),
        ],
      ),
    );
    print("mode = ${_state["mode"]}");
    print("data=${widget.key}");
    print("values[0]=${values[0]}");

    return (_state["mode"] == TimeWeekdaysInput.MODE_EDIT) ? editWidget : displayWidget;
  }
}
