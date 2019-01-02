import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/line_group_select_bloc.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:flutter/material.dart';

class LineGroupSelect extends StatefulWidget {
  LineGroupSelect({Key key, this.onComplete}) : super(key: key);

  final ValueChanged<List<LineGroupModel>> onComplete;

  @override
  _LineGroupSelectState createState() => _LineGroupSelectState();
}

class _LineGroupSelectState extends State<LineGroupSelect>{
  LineGroupSelectBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<LineGroupSelectBloc>(context);
    bloc.fetchGroupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("グループを選択"),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                widget.onComplete(bloc.getSelectedGroups());
                Navigator.pop(context);
              },
              textColor: Colors.white,
              child: Text(
                  "完了",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
              )
          )
        ],
      ),
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
                return _buildListTile(index, snapshot.data[index]);
              }
          );
        } else {
          return Center();
        }
      },
    );
  }

  Widget _buildListTile(int index, LineGroupModel data) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
        title: Text(data.displayName),
        trailing: bloc.isSelected(data.lineGroupId)
            ? Icon(Icons.check_box, color: Colors.deepOrangeAccent)
            : Icon(Icons.check_box_outline_blank, color: Colors.grey),
        onTap: () {
          setState(() {
            bloc.selectOrUnselect(data.lineGroupId);
          });
        });
  }
}