import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Movable {
  Key key;
  double height = 25;
  double width = 100;
  double top = 0;
  double left = 0;
  double topLeft = 0;
  double topRight = 0;
  double bottomLeft = 0;
  double bottomRight = 0;
  String name;
  String? value;
  Movable(this.name, this.key) {
    value = name;
  }
  Map toMap() {
    return {
      'name': name,
      'value': name,
      'height': height,
      'width': width,
      'top': top,
      'left': left,
      'topLeft': topLeft,
      'topRight': topRight,
      'bottomLeft': bottomLeft,
      'bottomRight': bottomRight
    };
  }

  initialize(Map json) {
    height = json['height'];
    width = json['width'];
    top = json['top'];
    left = json['left'];
    topLeft = json['topLeft'] ?? 0;
    topRight = json['topRight'] ?? 0;
    bottomLeft = json['bottomLeft'] ?? 0;
    bottomRight = json['bottomRight'] ?? 0;
    value = json['value'];
  }
}

class MyImage extends Movable {
  @override
  double width = 100;
  @override
  double height = 100;
  Uint8List? imageBytes;
  String? pngMaskImage;
  Color borderColor = Color(0xff000000);
  double borderWidth = 1;

  // bool circle = false;

  // Image getMask() {
  //   if (pngBytes == null) {
  //     Image.asset(
  //       'assets/square.png',
  //     );
  //   } else {
  //     return Image.memory(
  //       pngBytes!,
  //     );
  //   }
  // }

  // Image getMask() {
  //   if (pngBytes == null) {
  //     return
  //   } else {
  //     return Image.memory(
  //       pngBytes!,
  //     );
  //   }
  // }

  Image getImage() {
    if (imageBytes == null) {
      return Image.asset(
        'assets/image_asset.jpg',
        fit: BoxFit.cover,
      );
    } else {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.cover,
      );
    }
  }

  MyImage(super.name, super.key, {Map? json}) {
    if (json != null) {
      initialize(json);
    }
  }
  @override
  initialize(Map json) {
    pngMaskImage = json['pngMaskImage'] ?? '';
    borderColor = json['borderColor'] ?? borderColor;
    borderWidth = json['borderWidth'] ?? borderWidth;
    super.initialize(json);
  }

  @override
  Map toMap() {
    return {
      'width': width,
      'height': height,
      'pngMaskImage': pngMaskImage ?? '',
      'borderColor': borderColor,
      'borderWidth': borderWidth,
      ...super.toMap(),
    };
  }

  // @override
  // initialize(Map json) {
  //   // TODO: implement initialize
  //   return super.initialize(json);
  // }
  factory MyImage.fromMap(Map json) {
    return MyImage(json['name'], UniqueKey(), json: json);
  }
}

class MyAutoText extends Movable {
  String font = 'Roboto';
  double fontSize = 14;
  String stringCase = '';
  FontStyle fontStyle = FontStyle.normal;
  TextAlign textAlign = TextAlign.left;
  FontWeight fontWeight = FontWeight.normal;
  TextDecoration textDecoration = TextDecoration.none;
  Color textcolor = Color(0xff000000);
  bool isQR = false;

  MyAutoText(super.name, super.key, {Map? json}) {
    if (json != null) {
      initialize(json);
    }
  }

  @override
  Map toMap() {
    return {
      'font': font,
      'fontSize': fontSize,
      'stringCase': stringCase,
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
    font = json['font'] ?? 'Roboto';
    fontSize = json['fontSize'];
    stringCase = json['stringCase'] ?? '';
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
    return MyAutoText(json['name'], UniqueKey(), json: json);
  }
}

class MyText extends MyAutoText {
  TextEditingController textEditingController = TextEditingController();
  MyText(super.name, super.key, {Map? json}) {
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
    return MyText(json['name'], UniqueKey(), json: json);
  }
}
