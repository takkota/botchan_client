import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/view/bot_detail.dart';
import 'package:botchan_client/view/main_page.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes () {
    runApp(
        MaterialApp(
          title: 'BotChan',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MainPage(title: 'Flutter Demo Home Page'),
          onGenerateRoute: (RouteSettings settings) {
            List<String> pathElements = settings.name.split("/");
            if (pathElements[0] != "") return null;
            switch (pathElements[1]) {
              case "main":
                return MaterialPageRoute(builder: (context) => MainPage());
              case "botDetail":
                return MaterialPageRoute(builder: (context) =>
                    BlocProvider(
                      child: pathElements.length > 2 ? BotDetail(id: pathElements[2]) : BotDetail(),
                      creator: (context, bag) => BotDetailBloc(),
                    ),
                    fullscreenDialog: true);
            }
          },
        )
    );
  }
}