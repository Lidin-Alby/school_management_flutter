import 'dart:convert';
import 'dart:typed_data';

import 'movable_and_extra_class.dart';

class Design {
  String designName;
  Uint8List? frontBackgroundImage;
  Uint8List? backBackgroundImage;
  List<Movable> frontElements;
  List<Movable> backElements;
  double backgroundImageHeight;
  String? frontImageName;
  String? backImageName;
  Design({
    required this.designName,
    required this.frontImageName,
    this.backImageName,
    required this.frontBackgroundImage,
    this.backBackgroundImage,
    required this.frontElements,
    required this.backElements,
    required this.backgroundImageHeight,
  });

  Map<String, String> toMap() {
    return {
      'designName': designName,
      'frontImageName': frontImageName!,
      'backImageName': backImageName.toString(),
      'backgroundImageHeight': backgroundImageHeight.toString(),
      'frontElements': jsonEncode(
        frontElements
            .map(
              (e) => e.toMap(),
            )
            .toList(),
      ),
      'backElements': jsonEncode(
        backElements
            .map(
              (e) => e.toMap(),
            )
            .toList(),
      )
    };
  }

  factory Design.fromMap(Map json, Uint8List frontBackgroundImage,
      Uint8List? backBackgroundImage) {
    List frontJson = jsonDecode(json['frontElements']);
    List backJson = jsonDecode(json['backElements']);

    List<Movable> frontElements = [];
    List<Movable> backElements = [];

    for (int i = 0; i < frontJson.length; i++) {
      Map json = frontJson[i];

      if (json.containsKey('text')) {
        frontElements.add(MyText.fromMap(json));
      } else if (json.containsKey('fontSize')) {
        frontElements.add(MyAutoText.fromMap(json));
      } else {
        frontElements.add(MyImage.fromMap(json));
      }
    }
    for (Map json in backJson) {
      if (json.containsKey('text')) {
        backElements.add(MyText.fromMap(json));
      } else if (json.containsKey('fontSize')) {
        backElements.add(MyAutoText.fromMap(json));
      } else {
        backElements.add(MyImage.fromMap(json));
      }
    }
    final de = Design(
      designName: json['designName'],
      frontImageName: json['frontImageName'],
      frontBackgroundImage: frontBackgroundImage,
      backImageName: json['backImageName'],
      backBackgroundImage: backBackgroundImage,
      frontElements: frontElements,
      backElements: backElements,
      backgroundImageHeight: double.parse(json['backgroundImageHeight']),
    );

    return de;
  }
}
