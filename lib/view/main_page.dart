import 'package:botchan_client/network/api_client.dart';
import 'package:botchan_client/network/response/account_link_response.dart';
import 'package:botchan_client/utility/shared_preferences_helper.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AfterLayoutMixin<MainPage> {

  int _selectedIndex = 1;

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    final Uri deepLink = data?.link;
    if (deepLink == null) return;
    switch (deepLink.path) {
      case "/link/start":
        final accountLinked = await SharedPreferencesHelper.isAccountLinked();
        var requestParams = deepLink.queryParameters;
        if (requestParams.containsKey("token") && !accountLinked) {
          // 連携tokenを使ってエンドポイントを叩く。(期限あり)
          final client = ApiClient(AccountLinkResponse.fromJson);
          client.post("/account/link", {"linkToken": requestParams["token"]}).then((res) {
            // 連携URLを取得できたら、誘導ダイアログを出す。
            Navigator.of(context).pop();
            _showLinkAccountDialog(res.linkUrl);
          })
          .catchError(() {});
        }
        break;
      case "/link/complete":
        Navigator.of(context).pop();
        SharedPreferencesHelper.setAccountLinked(true);
        break;
    }
  }

  void _showInitialDialog() async {
    final accountLinked = await SharedPreferencesHelper.isAccountLinked();
    if (!accountLinked) {
      showDialog(context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
                title: Text("ダウンロードありがとうございます！まずはLINEと連携するために、下のボタンをタップしてね！"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      // Lineアカウント友達招待
                      _launchUrl("https://line.me/R/ti/p/XFGCw-NM4t");
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text("BotChanを友達招待する",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                          )
                      )),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                    ),
                  )
                ]);
          });
    }
  }

  void _showLinkAccountDialog(String linkUrl) {
    showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
      return SimpleDialog(
          title: Text("連携完了まであと一歩です！下のリンクをタップして、LINEの連携を許可してください。"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _launchUrl(linkUrl);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text("LINEと連携する",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    )
                )),
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            )
          ]);
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _showInitialDialog();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print("testd:build");
    return WillPopScope(
        onWillPop: () {
          SharedPreferencesHelper.isAccountLinked().then((linked) {
            if (linked) Navigator.of(context).pop();
          });
        },
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  'test',
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), title: Text('Home')),
              BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('Business')),
              BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('School')),
            ],
            currentIndex: _selectedIndex,
            fixedColor: Colors.deepPurple,
            onTap: _onTabTapped,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}
