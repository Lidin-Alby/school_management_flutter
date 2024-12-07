import 'dart:typed_data';

import 'my_text_class.dart';

class Design {
  String designName;
  Uint8List frontBackgroundImage;
  Uint8List? backBackgroundImage;
  List<MyText>? frontTexts;
  List<MyText>? backTexts;
  double backgroundImageWidth;
  String frontImageName;
  String? backImageName;
  Design({
    required this.designName,
    required this.frontImageName,
    this.backImageName,
    required this.frontBackgroundImage,
    this.backBackgroundImage,
    required this.frontTexts,
    required this.backTexts,
    required this.backgroundImageWidth,
  });
}
