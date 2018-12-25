import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/network/request/push_schedule.dart';
import 'package:botchan_client/network/request/reply_condition.dart';
import 'package:botchan_client/view/widget/datetime_picker.dart';
import 'package:botchan_client/view/widget/match_method_dialog.dart';
import 'package:botchan_client/view/widget/weekday_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

class BotDetail extends StatefulWidget {
  BotDetail({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _BotDetailState createState() => _BotDetailState();
}

class _BotDetailState extends State<BotDetail>{
  TextEditingController keywordController;
  BotDetailBloc bloc;

  final _botTypes = Map<BotType, Text>.of({
    BotType.REPLY: Text("応答"),
    BotType.PUSH: Text("通知")
  });

  @override
  void initState() {
    super.initState();
    keywordController = TextEditingController();
    bloc = BlocProvider.of<BotDetailBloc>(context);
    if (widget.id != null) {
      try {
        bloc.fetchBotDetail(int.parse(widget.id));
      } on Error {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: bloc.stream,
     builder: (BuildContext context, AsyncSnapshot<BotDetailScreenData> snapshot) {
       if (snapshot.hasData) {
         return Scaffold(
           appBar: AppBar(
             title: Text("ボット詳細"),
             actions: <Widget>[
               FlatButton(
                   onPressed: () {
                     final error = bloc.validateForm();
                     if (error.isNotEmpty) {
                       showDialog(context: context, builder: (BuildContext context) {
                         return AlertDialog(
                          title: FittedBox(child: Text(error), fit: BoxFit.scaleDown)
                         );
                       });
                     } else {
                       try {
                         bloc.saveBotDetail().whenComplete(() {
                           Navigator.of(context).pop(true);
                         });
                       } on Error {
                         Scaffold.of(context).showSnackBar(
                             SnackBar(content: Text('保存に失敗しました。再度お試しください。')));
                       }
                     }
                   },
                   textColor: Colors.white,
                   child: Text(
                       "保存",
                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                   )
               )
             ],
           ),
           body: _body(snapshot.data),
         );
       } else {
         return Container();
       }
     },
    );
  }

  @override
  void dispose() {
    super.dispose();
    keywordController.dispose();
  }

  Widget _body(BotDetailScreenData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black12)
                )
            ),
            child: TextField(
              maxLength: 10,
              onChanged: (value) {
                bloc.changeTitle(value);
              },
            ),
          ),
        ),
        Center(child: Text("ボットのタイプ"), heightFactor: 3.0),
        Row(
          children: <Widget>[
            Expanded(child: _buildCupertinoSegmentedControl(data))
          ],
        ),
        _buildConditionList(data)
      ],
    );
  }

  Widget _buildCupertinoSegmentedControl(BotDetailScreenData data) {
    return CupertinoSegmentedControl<BotType>(
        children: _botTypes,
        groupValue: data.botType, // 初期値
        onValueChanged: (type) {
          bloc.changeType(type);
        }
    );
  }

  Widget _buildConditionList(BotDetailScreenData data) {
    if (data.botType == BotType.REPLY) {
      return _buildReplyConditionList(data);
    } else {
      return _buildPushConditionList(data);
    }
  }

  Widget _buildReplyConditionList(BotDetailScreenData data) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.message, color: Colors.green),
          ),
          title: TextField(
            decoration: InputDecoration(
                hintText: "ボットが反応するキーワード"
            ),
            onChanged: (value) {
              bloc.changeKeyword(value);
            },
            controller: keywordController,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.flag, color: Colors.green),
          ),
          title: Text(data.replyCondition.matchMethod == MatchMethod.PARTIAL ? "部分一致" : "完全一致"),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black26),
          onTap: () {
            showDialog(context: context, builder: (BuildContext context) {
              return MatchMethodDialog(
                  initialValue: data.replyCondition.matchMethod,
                  onConfirmed: (matchMethod) {
                    bloc.changeMatchMethod(matchMethod);
                  }
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildPushConditionList(BotDetailScreenData data) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.schedule, color: Colors.green),
          ),
          title: Text(
            DateFormat('yyyy年MM月dd日 HH:mm').format(data.pushSchedule.scheduleTime.toLocal())
          ),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black26),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DateTimePicker(
                    initialDateTime: DateTime.now(),
                    onConfirmed: (dateTime) {
                      bloc.changeScheduleDateTime(dateTime);
                    },
                  );
                });
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.repeat, color: Colors.green),
          ),
          title: Text(data.pushSchedule.days.length > 0 ? buildDaysString(data.pushSchedule.days) : "繰り返しなし"),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black26),
          onTap: () {
            showDialog(context: context, builder: (BuildContext context) {
              return WeekdayPicker(
                  initialValue: data.pushSchedule.days,
                  onConfirmed: (days) {
                    bloc.changeDays(days);
                  }
              );
            });
          },
        ),
      ],
    );
  }

  String buildDaysString(List<DAY> days) {
    return days.fold("", (String str, day) {
      if (str.isEmpty) {
        return "${convertDayToString(day)}";
      } else {
        return str + ",${convertDayToString(day)}";
      }
    });
  }
}
