import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';

class EditTimeInput extends StatefulWidget {
  var values;
  EditTimeInput({Key? key, required this.values}) : super(key: key);

  @override
  State<EditTimeInput> createState() => _EditTimeInputState();
}

class _EditTimeInputState extends State<EditTimeInput> {
  var shortWeekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  @override
  Widget build(BuildContext context) {
    var values = widget.values;
    return
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.blue),
        //   borderRadius: BorderRadius.circular(20),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select Weekdays for timer:',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            WeekdaySelector(
              textStyle: Theme.of(context).textTheme.bodyText1,
              selectedTextStyle: Theme.of(context).textTheme.bodyText1,
            firstDayOfWeek: DateTime.sunday,
            shortWeekdays: shortWeekdays,
            onChanged: (int day) {
              setState(() {
                final index = day % 7;
                values[index] = !values[index];
                //widget._widgetData = {"values":values};
                print('values.toString() ${values.toString()}');
              });
            },
            values: List<bool>.from(values),
          ),
            ElevatedButton(onPressed: () => (Navigator.pop(context,values)), child: Text("back")),
          ],
        ),
      );

  }
}
