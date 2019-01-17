import 'dart:io';

import 'package:botchan_client/model/partial/message.dart';
import 'package:flutter/material.dart';

class FlexMessage extends Message {

  Hero hero = Hero(image: Image());
  Body body = Body(box: Box(layout: "vertical", contents: List()));
  Footer footer = Footer(box: Box(layout: "vertical", contents: List()));

  FlexMessage(): super(MessageType.FLEX);

  static FlexMessage fromJson(Map<String, dynamic> json) {
    FlexMessage flexMessage = FlexMessage();
    if (json.containsKey("hero")) {
      final hero = json["hero"];
      flexMessage.hero = Hero()
        ..image = Image(url: hero["url"]);
    }
    if (json.containsKey("body")) {
      final body = json["body"];
      flexMessage.body = Body()
        ..box = Box(layout: body["layout"], contents: body["contents"]);
    }
    if (json.containsKey("footer")) {
      final body = json["footer"];
      flexMessage.footer = Footer()
        ..box = Box(layout: body["layout"], contents: body["contents"]);
    }
    return flexMessage;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "image",
    };
  }

  @override
  bool hasContent() {
    return false;
  }
}

class Hero {
  Image image;
  Hero({this.image});
}

class Body {
  Box box;
  Body({this.box});
}

class Footer {
  Box box;
  Footer({this.box});
}

abstract class Content {
  String type;
  Content(this.type);
}

class Box extends Content {
  String layout;
  List<Content> contents = [];

  Box({this.layout, this.contents = const []}): super("box");
}


class Image extends Content {
  String size = "full";
  String aspectRatio = "20:13";
  String aspectMode = "cover";
  String url;
  File cachedImage;

  Image({this.url}): super("image");
}

class Text extends Content {
  String type = "text";
  String text;
  bool wrap = true;
  String weight; // "bold"
  String size; // "xl"
  int flex; // 0 or 1

  FontWeight weightValue() {
    if (weight == "bold") {
      return FontWeight.bold;
    } else {
      return FontWeight.normal;
    }
  }

  double sizeValue() {
    switch (weight) {
      case "xl":
        return 14.0;
      case "md":
        return 10.0;
      case "sm":
        return 6.0;
    }
    return 10.0;
  }
  Text({this.weight, this.size}): super("text");
}

class Button extends Content {
  String type = "button";
  Action action;

  Button({this.action}): super("button");
}


class Action {
  String type = "uri";
  String label;
  String uri;

  Action({this.label, this.uri});
}
