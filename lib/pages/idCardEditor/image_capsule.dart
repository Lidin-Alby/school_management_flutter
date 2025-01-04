import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'movable_and_extra_class.dart';
import 'movable_object.dart';

class ImageCapsule extends StatelessWidget {
  const ImageCapsule(
      {super.key,
      required this.backgroundImage,
      // required this.backgroundImageWidth,
      required this.backgroundImageHeight,
      required this.elements,
      required this.selected,
      required this.onSelected});
  final Uint8List? backgroundImage;
  // final double backgroundImageWidth;
  final double backgroundImageHeight;
  final List<Movable> elements;
  final Movable? selected;
  final Function(Movable?) onSelected;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Stack(
        children: [
          Image.memory(
            // width: backgroundImageWidth,
            height: backgroundImageHeight,
            backgroundImage!,
            // fit: BoxFit.fill,
          ),
          for (Movable element in elements)
            MovableObject(
              element: element,
              selected: selected,
              onSelected: (p0) {
                onSelected(p0);
              },
            )
        ],
      ),
    );
  }
}
