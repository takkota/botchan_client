import 'package:botchan_client/model/partial/message/flex_message.dart' as flex;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


Column flexBlock(flex.FlexMessage message, VoidCallback selectImage) {
  List<Widget> blocks = List();
  //hero
  if (message?.hero != null) {
    final hero = message?.hero;
    blocks.add(buildHero(hero, selectImage));
  }

  if (message?.body?.box != null) {
    final box = message?.body?.box;
    blocks.add(buildBox(box, selectImage));
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: blocks,
  );
}

Widget buildHero(flex.Hero hero, selectImage) {
  // heroはImageのみ
  return Container(
    width: 200,
    height: 130,
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide())
    ),
    child: buildImage(hero.image, selectImage),
  );
}

Widget buildBox(flex.Box box, VoidCallback selectImage) {
  Widget layoutBox;
  if (box.layout == "vertical") {
    final column = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: box.contents.map((content) {
          return buildContent(content, selectImage);
        }).toList()
    );
    if (column.children.length < 3) {
      column.children.add(contentAvailableSpace());
    }
    layoutBox = column;

  } else {
    final row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: box.contents.map((content) {
          return buildContent(content, selectImage);
        }).toList()
    );
    if (row.children.length < 3) {
      row.children.add(contentAvailableSpace());
    }
    layoutBox = row;
  }
  return Expanded(
    child: layoutBox,
  );
}

Widget buildContent(flex.Content content, VoidCallback selectImage) {
  // contentの中にboxがある可能性もある
  if (content is flex.Box) {
    return buildBox(content, selectImage);
  } else {
    if (content is flex.Image) {
      return buildImage(content, selectImage);
    } else if (content is flex.Text){
      return buildText(content);
    } else {
      return contentAvailableSpace();
    }
  }
}

Widget buildText(flex.Text text) {
  return Text(text.text,style: TextStyle(fontSize: text.sizeValue(), fontWeight: text.weightValue()));
}

Widget buildImage(flex.Image image, VoidCallback selectImage) {
  Widget widget;
  if (image?.cachedImage != null) {
    // ローカルキャッシュを表示
    widget = InkWell(
      onTap: () {
        selectImage();
      },
      child: Image.memory( //変更
        image.cachedImage.readAsBytesSync(), //変更
        fit: BoxFit.contain,
      ),
    );

  } else if (image?.url != null){
    // ネットワーク画像
    widget = InkWell(
      onTap: () {
        selectImage();
      },
      child: Image.network( //変更
        image.url,
        fit: BoxFit.contain,
      ),
    );
  } else {
    // 画像なし
    widget = Padding(
      padding: EdgeInsets.all(5.0),
      child: Center(
          child: InkWell(
              onTap: () {
                selectImage();
              },
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.image),
                  Text("画像を選択する")
                ],
              )
          )
      ),
    );
  }
  return widget;
}

Widget contentAvailableSpace() {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      border: Border.all(
        color: Colors.black,
      )
    ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add),
          Text("要素を追加", style: TextStyle(fontSize: 8),)
        ],
      )
  );
}
