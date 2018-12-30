import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/bloc/main_bloc.dart';
import 'package:botchan_client/model/bot_model.dart';
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
    bloc = BlocProvider.of<MainBloc>(context).botListBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, "/botDetail").then((value) {
            if (value == true) {
              Future.delayed(Duration(milliseconds: 500), () {
                bloc.fetchBotList();
              });
            }
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _body() {
    return StreamBuilder<List<BotModel>>(
      stream: bloc.botList,
      builder: (BuildContext context, AsyncSnapshot<List<BotModel>> snapshot) {
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

  Widget _cardItem(int index, BotModel data) {
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
                Navigator.pushNamed(context, "/botDetail/${data.botId}");
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