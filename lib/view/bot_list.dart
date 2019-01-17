import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/bloc/main_bloc.dart';
import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BotList extends StatefulWidget {
  BotList({Key key}) : super(key: key);

  @override
  _BotListState createState() => _BotListState();
}

class _BotListState extends State<BotList>{
  BotListBloc bloc;
  bool _progressing = false;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MainBloc>(context).botListBloc;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _progressing,
        child: Scaffold(
          body: _body(),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, "/botDetail");
              if (result == true) {
                bloc.fetchBotList();
              }
            },
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }

  Widget _body() {
    return StreamBuilder<List<BotDetailModel>>(
      stream: bloc.botList,
      builder: (BuildContext context, AsyncSnapshot<List<BotDetailModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            return ListView.builder(
                padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _slidableItem(snapshot.data[index]);
                }
            );
          } else {
            return Center(
              child: Text("作ったボットがまだありません。右上のアイコンをタップして最初のボットを作りましょう!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget _slidableItem(BotDetailModel data) {
    return Slidable(
      delegate: SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: _cardItem(data),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.deepOrange,
          icon: Icons.delete,
          closeOnTap: false,
          onTap: () {
            _delete(data);
          },
        )
      ],
    );

  }

  Widget _cardItem(BotDetailModel data) {
    Widget buildSubTitle() {
      if (data.botType == BotType.REPLY) {
        return Text("キーワード: ${data.replyCondition.keyword}");
      } else {
        return Text("スケジュール:");
      }
    }
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: data.botType == BotType.REPLY ? Icon(Icons.reply) : Icon(Icons.notifications),
              title: Text(data.title),
              subtitle: buildSubTitle(),
              onTap: () async {
                final result = await Navigator.pushNamed(context, "/botDetail/${data.botId}");
                if (result == true) {
                  bloc.fetchBotList();
                }
              },
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                  FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _delete(BotDetailModel data) async {
    setState(() {
      _progressing = true;
    });

    try {
      print('submitting to backend...');
      bloc.deleteBot(data).whenComplete(() {
        setState(() {
          _progressing = false;
        });
      });
    } on Error {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('削除に失敗しました。再度お試しください。')));
      setState(() {
        _progressing = false;
      });
    }
    //Simulate a service call
    print('submitting Done...');
  }
}