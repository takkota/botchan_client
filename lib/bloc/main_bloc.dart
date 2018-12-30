import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/bloc/line_group_list_bloc.dart';

class MainBloc extends Bloc {
  BotListBloc botListBloc;
  LineGroupListBloc lineGroupListBloc;

  MainBloc() {
    botListBloc = BotListBloc();
    lineGroupListBloc = LineGroupListBloc();
  }

  Future<bool> isGroupAlreadyAdded(String lineGroupId) async {
    final list = await lineGroupListBloc.groupList.first;
    final index = list.indexWhere((model) {
      return model.lineGroupId == lineGroupId;
    });

    return index >= 0 ? true : false;
  }

  @override
  void dispose() {
    botListBloc.dispose();
    lineGroupListBloc.dispose();
  }
}
