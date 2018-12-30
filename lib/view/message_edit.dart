import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/bloc/message_edit_bloc.dart';
import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/model/bot_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/push_schedule.dart';
import 'package:botchan_client/model/partial/reply_condition.dart';
import 'package:botchan_client/view/widget/datetime_picker.dart';
import 'package:botchan_client/view/widget/match_method_dialog.dart';
import 'package:botchan_client/view/widget/message_preview.dart';
import 'package:botchan_client/view/widget/weekday_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageEdit extends StatefulWidget {
  MessageEdit({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _MessageEditState createState() => _MessageEditState();
}

class _MessageEditState extends State<MessageEdit>{
  TextEditingController keywordController;
  MessageEditBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MessageEditBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
     children: <Widget>[
     ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    keywordController.dispose();
  }


}
