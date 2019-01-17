import 'package:botchan_client/model/partial/message.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MessageTypeSelectOverlay extends ModalRoute<void> {
  final ValueSetter<MessageType> onSelectType;

  MessageTypeSelectOverlay({this.onSelectType});

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
        child: new CarouselSlider(
            items: [MessageType.TEXT, MessageType.IMAGE, MessageType.VIDEO].map((type) {
              return new Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    child: new Container(
                        width: MediaQuery.of(context).size.width,
                        margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: new BoxDecoration(
                            color: Colors.amber
                        ),
                        child: messageTypeImage(type)
                    ),
                    onTap: () {
                      onSelectType(type);
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }).toList(),
            height: 400.0,
            autoPlay: false
        )
    );
  }

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  Widget messageTypeImage(MessageType messageType) {
    String imagePath;
    String title;
    String description;
    switch (messageType) {
      case MessageType.TEXT:
        title = 'テキストメッセージ';
        imagePath = 'assets/images/test.jpeg';
        description = '通常のテキストのメッセージです';
        break;
      case MessageType.IMAGE:
        title = '画像メッセージ';
        imagePath = 'assets/images/test.jpeg';
        description = '画像メッセージです';
        break;
      case MessageType.VIDEO:
        title = '動画メッセージ';
        imagePath = 'assets/images/test.jpeg';
        description = '動画メッセージです';
        break;
      case MessageType.FLEX:
        title = 'テンプレート1';
        imagePath = 'assets/images/test.jpeg';
        description = 'テンプレートです';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(title),
        Text(description),
        //Image.asset(imagePath)
      ],
    );


  }
}
