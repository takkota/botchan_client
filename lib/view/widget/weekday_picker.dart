
import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/network/request/push_schedule.dart';
import 'package:botchan_client/network/request/reply_condition.dart';
import 'package:flutter/material.dart';

class WeekdayPicker extends StatefulWidget {
  WeekdayPicker({
    Key key,
    this.initialValue,
    this.onConfirmed
  }): super(key: key);

  final List<DAY> initialValue;
  final ValueChanged<List<DAY>> onConfirmed;

  @override
  _WeekdayPickerState createState() => new _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker> {
  List<DAY> _selectedDays = [];

  @override
  void initState() {
    super.initState();
    _selectedDays.addAll(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Column(
          children: <Widget>[
            Text("繰り返しする曜日を選択"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDaySelection(),
                  ),
                )

              ],
            )
          ],
        ),
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4.0)),
        children: <Widget>[
          Center(
            child: SimpleDialogOption(
                onPressed: () {
                  widget.onConfirmed(_selectedDays);
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text("確定",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      )
                  )),
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                )
            ),
          ),
        ]);
  }

  List<Widget> _buildDaySelection() {
    print("testd:build" + _selectedDays.toString());
    return DAY.values.map((day) {
      return _dayButton(day);
    }).toList();
  }

  Widget _dayButton(DAY day) {
    final isSelected = _selectedDays.contains(day);

    Widget _buttonContent() {
      return new Container(
        height: 25.0,
        width: 25.0,
        margin:EdgeInsets.symmetric(horizontal: 3.0) ,
        child: new Center(
          child: new Text(
              convertDayToString(day),
              style: new TextStyle(
                  color: isSelected ? Colors.white : Colors.black12,
                  //fontWeight: FontWeight.bold,
                  fontSize: 18.0)
          ),
        ),
        decoration: new BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : Colors.transparent,
          border: new Border.all(
              width: 1.0,
              color: isSelected
                  ? Colors.blueAccent
                  : Colors.grey),
          borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
        ),
      );
    }

    return new InkWell(
      splashColor: Colors.blueAccent,
      onTap: () {
        setState(() {
          isSelected ? _selectedDays.remove(day) : _selectedDays.add(day);
        });
      },
      child: _buttonContent(),
    );
  }
}
