
import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/partial/reply_condition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  DateTimePicker({
    Key key,
    this.initialDateTime,
    this.onConfirmed
  }): super(key: key);

  final DateTime initialDateTime;
  final ValueChanged<DateTime> onConfirmed;

  @override
  _DateTimePickerState createState() => new _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  int _selectedYear, _selectedMonth, _selectedDay, _selectedHour, _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDateTime.year;
    _selectedMonth = widget.initialDateTime.month;
    _selectedDay = widget.initialDateTime.day;
    _selectedHour = widget.initialDateTime.hour;
    _selectedMinute = widget.initialDateTime.minute;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                  child: Text("キャンセル"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                  child: Text("完了"),
                  onPressed: () {
                    final selectedDateTime = DateTime(_selectedYear, _selectedMonth, _selectedDay, _selectedHour, _selectedMinute);
                    widget.onConfirmed(selectedDateTime);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ),
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CupertinoPicker(
                      scrollController:
                      new FixedExtentScrollController(
                        initialItem: _selectedYear - DateTime.now().year,
                      ),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedYear = index + DateTime.now().year;
                        });
                      },
                      children: new List<Widget>.generate(100,
                              (int index) {
                            return new Center(
                              child: new Text('${DateTime.now().year + index}'),
                            );
                          })),
                ),
                Expanded(
                  child: CupertinoPicker(
                      scrollController:
                      new FixedExtentScrollController(
                        initialItem: _selectedMonth,
                      ),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedMonth = index;
                        });
                      },
                      children: new List<Widget>.generate(12,
                              (int index) {
                            return new Center(
                              child: new Text('${index+1}'),
                            );
                          })),
                ),
                Expanded(
                  child: CupertinoPicker(
                      scrollController:
                      new FixedExtentScrollController(
                        initialItem: _selectedDay,
                      ),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedDay = index;
                        });
                      },
                      children: new List<Widget>.generate(31,
                              (int index) {
                            return new Center(
                              child: new Text('${index+1}'),
                            );
                          })),
                ),
                Expanded(
                  child: CupertinoPicker(
                      scrollController:
                      new FixedExtentScrollController(
                        initialItem: _selectedHour,
                      ),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedHour = index;
                        });
                      },
                      children: new List<Widget>.generate(24,
                              (int index) {
                            return new Center(
                              child: new Text('${index+1}'),
                            );
                          })),
                ),
                Expanded(
                  child: CupertinoPicker(
                      scrollController:
                      new FixedExtentScrollController(
                        initialItem: _selectedMinute,
                      ),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedMinute = index;
                        });
                      },
                      children: new List<Widget>.generate(60,
                              (int index) {
                            return new Center(
                              child: new Text('${index+1}'),
                            );
                          })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
