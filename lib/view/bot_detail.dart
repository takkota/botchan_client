import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/bloc/line_group_select_bloc.dart';
import 'package:botchan_client/bloc/message_edit_bloc.dart';
import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/model/partial/push_schedule.dart';
import 'package:botchan_client/model/partial/reply_condition.dart';
import 'package:botchan_client/view/line_group_select.dart';
import 'package:botchan_client/view/message_editor.dart';
import 'package:botchan_client/view/widget/datetime_picker.dart';
import 'package:botchan_client/view/widget/match_method_dialog.dart';
import 'package:botchan_client/view/widget/message_preview.dart';
import 'package:botchan_client/view/widget/weekday_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BotDetail extends StatefulWidget {
  BotDetail({Key key, this.botId}) : super(key: key);

  final int botId;

  @override
  _BotDetailState createState() => _BotDetailState();
}

class _BotDetailState extends State<BotDetail>{
  TextEditingController titleController;
  TextEditingController keywordController;
  BotDetailBloc botBloc;
  bool _saving = false;

  final _botTypes = Map<BotType, Text>.of(
      {
        BotType.REPLY: Text("応答"),
        BotType.PUSH: Text("通知")
      }
  );

  @override
  void initState() {
    super.initState();
    keywordController = TextEditingController();
    titleController = TextEditingController();

    botBloc = BlocProvider.of<BotDetailBloc>(context);
    botBloc.stream.listen((model) {
      keywordController.text = model.replyCondition.keyword;
      titleController.text = model.title;
    });

    if (widget.botId != null) {
      try {
        botBloc.fetchBotDetail(widget.botId);
      } on Error {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, false);
        }
      }
    } else {
      // 初期値空欄
      botBloc.addBot(BotDetailModel());
    }
  }

  void _submit() async {
    setState(() {
      _saving = true;
    });

    try {
      print('submitting to backend...');
      botBloc.save().whenComplete(() {
        Navigator.pop(context, true);
      });
    } on Error {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました。再度お試しください。')));
      setState(() {
        _saving = false;
      });
    }
    //Simulate a service call
    print('submitting Done...');
  }

  @override
  Widget build(BuildContext context) {
    return
      ModalProgressHUD(
        inAsyncCall: _saving,
        child: StreamBuilder(
          stream: botBloc.stream,
          builder: (BuildContext context, AsyncSnapshot<BotDetailModel> snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: Text("ボット詳細"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        final error = botBloc.validateForm();
                        if (error != true) {
                          showDialog(context: context, builder: (BuildContext context) {
                            return AlertDialog(
                                title: FittedBox(child: Text(error), fit: BoxFit.scaleDown)
                            );
                          });
                        } else {
                          _submit();
                        }
                        return;
                      },
                      textColor: Colors.white,
                      child: Text(
                          "保存",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                      )
                  )
                ],
              ),
              body: _body(snapshot.hasData),
            );
          },
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    keywordController.dispose();
    titleController.dispose();
  }

  Widget _body(bool hasData) {
    if (hasData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  botBloc.changeTitle(value);
                },
                controller: titleController,
              ),
            ),
          ),
          Center(child: Text("ボットのタイプ"), heightFactor: 3.0),
          Row(
            children: <Widget>[
              Expanded(child: _buildCupertinoSegmentedControl())
            ],
          ),
          _buildConditionList(),
          Expanded(
              child: Container(
                  padding: EdgeInsets.all(80.0),
                  child: _buildMessagePreview()
              )
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildCupertinoSegmentedControl() {
    final model = botBloc.getCurrentModel();
    return CupertinoSegmentedControl<BotType>(
        children: _botTypes,
        groupValue: model.botType, // 初期値
        onValueChanged: (type) {
          botBloc.changeType(type);
        }
    );
  }

  Widget _buildConditionList() {
    Column list;
    final model = botBloc.getCurrentModel();
    if (model.botType == BotType.REPLY) {
      list = _buildReplyConditionList(model);
    } else {
      list = _buildPushConditionList(model);
    }

    String groupNames = model.lineGroups
        .take(3)
        .map((g) { return g.displayName; })
        .join(", ");
    if (model.lineGroups.length > 3) {
      groupNames += "...";
    }
    list.children.add(
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.group, color: Colors.green),
          ),
          title: Text(groupNames),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black26),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    BlocProvider(
                        child: LineGroupSelect(
                            onComplete: (selectedGroups) {
                              botBloc.changeAttachedGroups(selectedGroups);
                            }),
                        creator: (context, bag) => LineGroupSelectBloc(
                            initialSelectedIds: botBloc.getCurrentModel().lineGroups
                                .map ((group) { return group.lineGroupId; })
                                .toList()
                        )
                    ),
                    fullscreenDialog: false)
            );
          },
        ),
    );
    return list;
  }

  Widget _buildMessagePreview() {
    final model = botBloc.getCurrentModel();
    return InkWell(
        child: MessagePreview(message: model.message),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  BlocProvider(
                      child: MessageEditor(onCompleteEdit: (message) {
                        // 編集完了。新しいMessageでpreviewを再構築する。
                        botBloc.reflectMessageEdit(message);
                      }),
                      creator: (context, bag) => MessageEditBloc(message: model.message)
                  ),
                  fullscreenDialog: false)
          );
        }
    );
  }

  Widget _buildReplyConditionList(BotDetailModel data) {
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
              botBloc.changeKeyword(value);
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
                    botBloc.changeMatchMethod(matchMethod);
                  }
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildPushConditionList(BotDetailModel data) {
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
                      botBloc.changeScheduleDateTime(dateTime);
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
                    botBloc.changeDays(days);
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
        return "${PushSchedule.convertDayToString(day)}";
      } else {
        return str + ",${PushSchedule.convertDayToString(day)}";
      }
    });
  }
}
