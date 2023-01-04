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
    if (_d == null) return;
    _widgetData = _d;
  }
}

class _TimeInputState extends State<TimeInput> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    TimeOfDay startTime = (widget._widgetData["start_time"]!=null)
        ?TimeOfDay(hour:int.parse(widget._widgetData["start_time"]["hour"].toString()),minute:int.parse(widget._widgetData["start_time"]["minute"].toString()))
        :TimeOfDay.now();
    TimeOfDay endTime = (widget._widgetData["end_time"]!=null)
        ?TimeOfDay(hour:int.parse(widget._widgetData["end_time"]["hour"].toString()),minute:int.parse(widget._widgetData["end_time"]["minute"].toString()))
        :TimeOfDay.now();
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
            width: 140,
            child: Text(
              style: Theme.of(context).textTheme.bodyText2,
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
                style: Theme.of(context).textTheme.bodyText1,
             "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}",
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
            //widget._widgetData["start_time"] = "${startTime.hour.toString()}:${startTime.minute.toString()}";
            widget._widgetData["start_time"]["hour"] = startTime.hour;
            widget._widgetData["start_time"]["minute"] = startTime.minute;
            print("The picked time is: ${widget._widgetData}");
          });
        }),
        const Text(" - "),
        _buildTimePick("", true, endTime, (x) {
          setState(() {
            endTime = x;
            //widget._widgetData["end_time"] = endTime.format(context);
            widget._widgetData["end_time"]["hour"] = endTime.hour;
            widget._widgetData["end_time"]["minute"] = endTime.minute;
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
