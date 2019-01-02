import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/bloc/line_group_list_bloc.dart';
import 'package:botchan_client/bloc/main_bloc.dart';
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
    bloc = BlocProvider.of<MainBloc>(context).lineGroupListBloc;
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
        if (snapshot.hasData && snapshot.data.length > 0) {
          return ListView.builder(
              padding:EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0) ,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return _cardItem(index, snapshot.data[index]);
              }
          );
        } else {
          return Center();
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
                _showGroupNameDialog(data.id, data.lineGroupId, data.displayName);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupNameDialog(int id, String lineGroupId, initialDisplayName) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GroupNameDialog(
              id: id,
              initialValue: initialDisplayName,
              lineGroupId: lineGroupId,
              onSaveSuccess: (LineGroupModel model) async {
                bloc.changeGroupDisplayName(id, model.displayName);
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
          );
        }
    );
  }
}