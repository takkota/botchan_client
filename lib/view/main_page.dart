import 'package:botchan_client/main.dart';
import 'package:botchan_client/network/api_client.dart';
import 'package:botchan_client/network/response/account_link_response.dart';
import 'package:botchan_client/network/response/account_linked_response.dart';
import 'package:botchan_client/utility/shared_preferences_helper.dart';
import 'package:botchan_client/view/bot_list.dart';
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

  int _selectedTabIndex = 0;
  int cardCount = 1;

  @override
  void initState() {
    super.initState();
    _retrieveDynamicLink();
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
          body: botList(),
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
    _showTutorialIfAny();
  }

  Widget botList() {
    if (_selectedTabIndex == 0) {
      return BotList();
    } else {
      return Center(
        child: Text("まだボットを作成してません。")
      );
    }
  }

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
      case "/link_start":
        final accountLinked = await SharedPreferencesHelper.isAccountLinked();
        var requestParams = deepLink.queryParameters;
        if (requestParams.containsKey("token") && !accountLinked) {
          // 連携tokenを使って連携URLを取得。(期限あり)
          final client = ApiClient(AccountLinkResponse.fromJson);
          client.post("/account/link_url", {"linkToken": requestParams["token"]}).then((res) {
            // 連携URLを取得できたら、一旦SharedPreferenceに保存しておく。
            SharedPreferencesHelper.setLinkUrl(res.linkUrl);
          })
          .catchError(() {});
        }
        break;
    }
  }

  void _showTutorialIfAny() async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    final accountLinked = await SharedPreferencesHelper.isAccountLinked();
    final linkUrl = await SharedPreferencesHelper.getLinkUrl();

    if (accountLinked) return;
    if (linkUrl != null) {
      // 実は連携済みかもなので、サーバーに問い合わせる。
      final client = ApiClient(AccountLinkedResponse.fromJson);
      client.post("/account/is_linked", {"userId": await userId}).then((res) {
        if (res.isLinked) {
          // 連携済みだったので、何もださない。
          SharedPreferencesHelper.setAccountLinked(true);
        } else {
          // まだ連携してないので、誘導ダイアログ
          _showLinkAccountDialog(linkUrl);
        }
      });
      return;
    }
    // 初回ダイアログ
    _showInitialDialog();
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
      _selectedTabIndex = index;
    });
  }
}
