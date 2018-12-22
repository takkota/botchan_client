import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class BotDetail extends StatefulWidget {
  BotDetail({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _BotDetailState createState() => _BotDetailState();
}

class _BotDetailState extends State<BotDetail>{
  final _formKey = GlobalKey<FormState>();
  BotDetailBloc bloc;

  final _botTypes = Map<BotType, Text>.of({
    BotType.REPLY: Text("応答"),
    BotType.PUSH: Text("通知")
  });

  @override
  void initState() {
    super.initState();
    bloc = BotDetailBloc();
    if (widget.id != null) {
      bloc.fetchBotDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    StreamBuilder(
     stream: bloc.stream,
     builder: (BuildContext context, AsyncSnapshot<BotDetailScreenData> snapshot) {
       if (snapshot.hasData) {
         print("build" + snapshot.data.botType.toString());
         return Scaffold(
           appBar: AppBar(
             // Here we take the value from the MyHomePage object that was created by
             // the App.build method, and use it to set our appbar title.
             title: Text("ボット詳細"),
             actions: <Widget>[
               FlatButton(
                   onPressed: () {
                     if (!_formKey.currentState.validate()) {
                       if (_formKey.currentState.validate()) {
                         // If the form is valid, we want to show a Snackbar
                         Scaffold.of(context)
                             .showSnackBar(SnackBar(content: Text('Processing Data')));
                       }
                     };
                   },
                   child: Text("保存")
               )
             ],
           ),
           body: _body(snapshot.data.botType),
         );
       } else {
         return Container();
       }
     },
    );
  }

  Widget _body(BotType botType) {
    print("body");
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text("ボットのタイプ"), heightFactor: 3.0),
            Row(
              children: <Widget>[
                Expanded(child: _buildCupertinoSegmentedControl(botType))
              ],
            ),
            _buildConditionSection(botType)
          ],
        )
    );
  }

  Widget _buildCupertinoSegmentedControl(BotType currentType) {
    return CupertinoSegmentedControl<BotType>(
        children: _botTypes,
        groupValue: currentType,
        onValueChanged: (type) {
          bloc.changeType(type);
        }
    );
  }

  Widget _buildConditionSection(BotType botType) {
    print("condition");
    if (botType == BotType.REPLY) {
      return Text("reply");
    } else {
      return Text("push");
    }
  }
}
