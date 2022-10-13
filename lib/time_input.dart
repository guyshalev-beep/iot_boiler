import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

import 'iData.dart';

class TimeInput extends StatefulWidget implements iData{
  late int mode = -1;
  late Map<String, dynamic> _widgetData = {};
  TimeInput({Key? key}) : super(key: key);
  @override
  State<TimeInput> createState() => _TimeInputState();

  @override
  getData() {
    print (_widgetData);
    return _widgetData;
  }

  @override
  setData(_d) {
    _widgetData = _d;
  }
}

class _TimeInputState extends State<TimeInput> {
  bool isEdit = false;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    setState(() {});
    Future selectedTime(BuildContext context, bool ifPickedTime,
        TimeOfDay initialTime, Function(TimeOfDay) onTimePicked) async {
      var _pickedTime =
          await showTimePicker(context: context, initialTime: initialTime);
      if (_pickedTime != null) {
        onTimePicked(_pickedTime);
      }
    }

    Widget _buildTimePick(String title, bool ifPickedTime,
        TimeOfDay currentTime, Function(TimeOfDay) onTimePicked) {
      return Row(
        children: [
          (title!="")?SizedBox(
            width: 80,
            child: Text(
              title,
            ),
          ):SizedBox(),
          Container(
            //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              //border: Border.all(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: GestureDetector(
              child: Text(
             "${currentTime.hour.toString()}:${currentTime.minute.toString()}",
              ),
              onTap: () {
                selectedTime(context, ifPickedTime, currentTime, onTimePicked);
              },
            ),
          ),
        ],
      );
    }
    Widget editWidget = Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("edit"),
          ]),
    );
    Widget displayWidget = Row(
      children: [
        _buildTimePick("", true, startTime, (x) {
          setState(() {
            startTime = x;
            widget._widgetData["start_time"] = "${startTime.hour.toString()}:${startTime.minute.toString()}";
            //widget._widgetData["start_time"]["hour"] = "${startTime.hour.toString()}";
            //widget._widgetData["start_time"]["minutes"] = "${startTime.minute.toString()}";

            print("The picked time is: ${widget._widgetData}");
          });
        }),
        const Text(" - "),
        _buildTimePick("", true, endTime, (x) {
          setState(() {
            endTime = x;
            widget._widgetData["end_time"] = endTime.toString();
            print("The picked time is: $x");
          });
        }),
      ],
    );
    print("isEdit1 = ${isEdit}");
    //widget._widgetData["start_time"] = startTime.hour;
    //widget._widgetData["end_time"] =endTime.hour;

    widget._widgetData["start_time"] = {"hour":startTime.hour, "minute":startTime.minute};
    widget._widgetData["end_time"] = {"hour":endTime.hour, "minute":endTime.minute};

    return (isEdit) ? editWidget : displayWidget;
  }
}
