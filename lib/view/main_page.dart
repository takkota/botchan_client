import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/utility/shared_preferences_helper.dart';
import 'package:botchan_client/view/bot_list.dart';
import 'package:botchan_client/view/widget/group_name_dialog.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bloc_provider/bloc_provider.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AfterLayoutMixin<MainPage>, WidgetsBindingObserver {

  int _selectedTabIndex = 0;
  int cardCount = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          SharedPreferencesHelper.isAccountLinked().then((linked) {
            if (linked) Navigator.of(context).pop();
          });
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: getPage(),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), title: Text('ボット')),
              BottomNavigationBarItem(icon: Icon(Icons.group), title: Text('グループ')),
              BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('設定')),
            ],
            currentIndex: _selectedTabIndex,
            fixedColor: Colors.deepPurple,
            onTap: _onTabTapped,
          )
        )
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    void _showDialogs() async {
      _showTutorialIfAny();
    }
    _showDialogs();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state.index == 0) {
      _retrieveDynamicLink();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget getPage() {
    if (_selectedTabIndex == 0) {
      return BlocProvider<BotListBloc>(
        child: BotList(),
        creator: (context, _bag) => BotListBloc(),
      );
    } else {
      return BlocProvider<BotListBloc>(
        child: BotList(),
        creator: (context, _bag) => BotListBloc(),
      );
    }
  }

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.retrieveDynamicLink();
    if (data == null) return;
    final Uri deepLink = data?.link;
    print("handleDeepLink:" + deepLink.toString());
    if (deepLink == null) return;
    switch (deepLink.path) {
      case "/linkAccount":
        if (deepLink.queryParameters.containsKey("lineId")) {
          final lineId = deepLink.queryParameters["lineId"];
          final accountLinked = await SharedPreferencesHelper.isAccountLinked();
          if (!accountLinked) {
            // userIdとlineIdを紐付ける
            dio.post("/account/link", data: {"userId": await userId, "lineId": lineId}).then((res) {
              // 紐付け完了
              SharedPreferencesHelper.setAccountLinked(true);
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            }).catchError(() {});
          }
        }
        break;
      case "/addGroup":
        // アカウント連携未済ならスキップ
        if (!await SharedPreferencesHelper.isAccountLinked()) return;
        if (deepLink.queryParameters.containsKey("lineGroupId")) {
          final lineGroupId = deepLink.queryParameters["lineGroupId"];
          _showGroupNameDialog(int.parse(lineGroupId));
        }
        break;
    }
  }

  void _showTutorialIfAny() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    final accountLinked = await SharedPreferencesHelper.isAccountLinked();

    if (accountLinked) return;
    // 初回ダイアログを出す。
    _showInitialDialog();
      return;
  }

  void _showInitialDialog() {
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

  void _showGroupNameDialog(int lineGroupId) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GroupNameDialog(lineGroupId: lineGroupId);
        }
    ).then((value) {
      if (value == true) {
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }
}
