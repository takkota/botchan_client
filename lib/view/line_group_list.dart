import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/bloc/line_group_list_bloc.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/view/widget/group_name_dialog.dart';
import 'package:flutter/material.dart';

class LineGroupList extends StatefulWidget {
  LineGroupList({Key key}) : super(key: key);

  @override
  _LineGroupListState createState() => _LineGroupListState();
}

class _LineGroupListState extends State<LineGroupList>{
  LineGroupListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<LineGroupListBloc>(context);
    bloc.fetchGroupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _body(),
      );
  }

  Widget _body() {
    return StreamBuilder<List<LineGroupModel>>(
      stream: bloc.groupList,
      builder: (BuildContext context, AsyncSnapshot<List<LineGroupModel>> snapshot) {
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
            child: Text("グループがありません。",
              style: TextStyle(fontWeight: FontWeight.bold) ,
            ),
          );
        }
      },
    );
  }

  Widget _cardItem(int index, LineGroupModel data) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.group),
              title: Center(
                  child: Text(data.displayName)
              ),
              onTap: () {
                _showGroupNameDialog(int.parse(data.id), data.displayName);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupNameDialog(int id, String initialDisplayName) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GroupNameDialog(id: id, initialValue: initialDisplayName);
        }
    ).then((value) {
      if (value == true) {
        bloc.fetchGroupList();
      }
    });
  }
}