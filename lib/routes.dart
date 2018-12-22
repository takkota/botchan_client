import 'package:botchan_client/view/bot_detail.dart';
import 'package:botchan_client/view/main_page.dart';
import 'package:flutter/material.dart';

class Routes {
  final routes = <String, WidgetBuilder>{
    '/main': (BuildContext context) => MainPage(),
    '/botDetail': (BuildContext context) => BotDetail()
  };

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
                return MaterialPageRoute(builder: (context) => BotDetail(), fullscreenDialog: true);
            }
          },
        )
    );
  }
}