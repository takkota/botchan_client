import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/model/bot.dart';
import 'package:flutter/material.dart';

class BotList extends StatefulWidget {
  BotList({Key key}) : super(key: key);

  @override
  _BotListState createState() => _BotListState();
}

class _BotListState extends State<BotList>{
  BotListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BotListBloc();
    bloc.fetchBotList();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: _body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/botDetail");
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }

  Widget _body() {
    return StreamBuilder<List<Bot>>(
      stream: bloc.botList,
      builder: (BuildContext context, AsyncSnapshot<List<Bot>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              padding:EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0) ,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _cardItem(index, snapshot.data[index]);
              }
          );
        } else {
          return Center(
            child: Text("作ったボットがまだありません。右上のアイコンをタップして最初のボットを作りましょう!",
              style: TextStyle(fontWeight: FontWeight.bold) ,
            ),
          );
        }
      },
    );
  }

  Widget _cardItem(int index, Bot data) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
              onTap: () {
                Navigator.pushNamed(context, "/botDetail/${data.id}");
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

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }
}