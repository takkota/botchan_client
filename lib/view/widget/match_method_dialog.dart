
import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/network/request/reply_condition.dart';
import 'package:flutter/material.dart';

class MatchMethodDialog extends StatefulWidget {
  MatchMethodDialog({
    Key key,
    this.initialValue,
    this.onConfirmed
  }): super(key: key);

  final MatchMethod initialValue;
  final ValueChanged<MatchMethod> onConfirmed;

  @override
  _MatchMethodDialogState createState() => new _MatchMethodDialogState();
}

class _MatchMethodDialogState extends State<MatchMethodDialog> {
  MatchMethod _selected = MatchMethod.PARTIAL;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Column(
          children: <Widget>[
            Text("キーワード合致条件を選択"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _button(MatchMethod.PARTIAL),
                    _button(MatchMethod.EXACT),
                  ],
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
                  widget.onConfirmed(_selected);
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

  Widget _button(MatchMethod matchMethod) {
    Widget _buttonContent(MatchMethod matchMethod) {
      final selected = _selected == matchMethod;
      return new Container(
        height: 20.0,
        width: 50.0,
        child: new Center(
          child: new Text(
              matchMethod == MatchMethod.PARTIAL ? "部分一致" : "完全一致",
              style: new TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 18.0)
          ),
        ),
        decoration: new BoxDecoration(
          color: selected
              ? Colors.blueAccent
              : Colors.transparent,
          border: new Border.all(
              width: 1.0,
              color: selected
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
          _selected = matchMethod;
        });
      },
      child: _buttonContent(matchMethod),
    );
  }
}
