import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/bloc/main_bloc.dart';
import 'package:botchan_client/view/bot_detail.dart';
import 'package:botchan_client/view/main_page.dart';
import 'package:botchan_client/view/message_editor.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes () {
    runApp(
        MaterialApp(
          title: 'BotChan',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: BlocProvider<MainBloc>(
            child: MainPage(),
            creator: (context, _bag) => MainBloc(),
          ),
          onGenerateRoute: (RouteSettings settings) {
            List<String> pathElements = settings.name.split("/");
            if (pathElements[0] != "") return null;
            switch (pathElements[1]) {
              case "main":
                return MaterialPageRoute(builder: (context) => MainPage());
              case "botDetail":
                return MaterialPageRoute(builder: (context) =>
                    BlocProvider(
                      child: pathElements.length > 2 ? BotDetail(botId: int.parse(pathElements[2])) : BotDetail(),
                      creator: (context, bag) => BotDetailBloc(),
                    ),
                    fullscreenDialog: true);
            }
          },
        )
    );
  }
}