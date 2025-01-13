import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Movable {
  double height = 25;
  double width = 100;
  double top = 0;
  double left = 0;
  String name;
  String? value;
  Movable(this.name) {
    value = name;
  }
  Map toMap() {
    return {
      'name': name,
      'value': name,
      'height': height,
      'width': width,
      'top': top,
      'left': left
    };
  }

  initialize(Map json) {
    height = json['height'];
    width = json['width'];
    top = json['top'];
    left = json['left'];
    value = json['value'];
  }
}

class MyImage extends Movable {
  @override
  double width = 100;
  @override
  double height = 100;
  Uint8List? imageBytes;
  late Movable movable;

  Image getImage() {
    if (imageBytes == null) {
      return Image.asset('assets/image_asset.jpg');
    } else {
      return Image.memory(imageBytes!);
    }
  }

  MyImage(super.name, {Map? json}) {
    if (json != null) {
      super.initialize(json);
    }
  }

  @override
  Map toMap() {
    return {
      'width': width,
      'height': height,
      ...super.toMap(),
    };
  }

  // @override
  // initialize(Map json) {
  //   // TODO: implement initialize
  //   return super.initialize(json);
  // }
  factory MyImage.fromMap(Map json) {
    return MyImage(json['name'], json: json);
  }
}

class MyAutoText extends Movable {
  double fontSize = 14;
  FontStyle fontStyle = FontStyle.normal;
  TextAlign textAlign = TextAlign.left;
  FontWeight fontWeight = FontWeight.normal;
  TextDecoration textDecoration = TextDecoration.none;
  Color textcolor = Color(0xff000000);
  bool isQR = false;

  MyAutoText(super.name, {Map? json}) {
    if (json != null) {
      initialize(json);
    }
  }

  @override
  Map toMap() {
    return {
      'fontSize': fontSize,
      'fontStyle': fontStyle.name,
      'textAlign': textAlign.name,
      'fontWeight': fontWeight.value,
      'textDecoration': textDecoration.toString(),
      'textcolor': colorToHex(textcolor),
      'isQR': isQR.toString(),
      ...super.toMap()
    };
  }

  @override
  initialize(Map json) {
    fontSize = json['fontSize'];
    fontStyle = FontStyle.values.byName(json['fontStyle']);
    textAlign = TextAlign.values.byName(json['textAlign']);
    fontWeight =
        json['fontWeight'] == 400 ? FontWeight.normal : FontWeight.bold;
    textDecoration = json['textDecoration'] == 'TextDecoration.none'
        ? TextDecoration.none
        : TextDecoration.underline;
    textcolor = colorFromHex(json['textcolor'])!;
    isQR = bool.parse(json['isQR']);
    super.initialize(json);
  }

  factory MyAutoText.fromMap(Map json) {
    return MyAutoText(json['name'], json: json);
  }
}

class MyText extends MyAutoText {
  TextEditingController textEditingController = TextEditingController();
  MyText(super.name, {Map? json}) {
    if (json != null) {
      initialize(json);
    }
  }
  @override
  Map toMap() {
    return {
      'text': textEditingController.text.trim(),
      ...super.toMap(),
    };
  }

  @override
  initialize(Map json) {
    textEditingController.text = json['text'].toString();
    super.initialize(json);
  }

  factory MyText.fromMap(Map json) {
    return MyText(json['name'], json: json);
  }
}
