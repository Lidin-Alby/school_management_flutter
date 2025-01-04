import 'package:flutter/material.dart';

import 'movable_and_extra_class.dart';

class ImageProperties extends StatelessWidget {
  const ImageProperties(
      {super.key,
      required this.selected,
      required this.onChange,
      required this.onDelete});
  final MyImage selected;
  final Function(MyImage) onChange;
  final Function(MyImage) onDelete;

  @override
  Widget build(BuildContext context) {
    MyImage selectedObj = selected;
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            // Spacer(),
            Text(selectedObj.name),
            // Spacer(),
            FilledButton(
              onPressed: () {
                onDelete(selectedObj);
              },
              child: Text('Delete'),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          // spacing: 5,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Width: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                ),
                controller: TextEditingController(
                  text: selectedObj.width.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.width = double.parse(value);
                  // });
                  onChange(selectedObj);
                },
              ),
            ),
            Spacer(),
            Text('Height: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(isDense: true),
                controller: TextEditingController(
                  text: selectedObj.height.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.height = double.parse(value);
                  // });
                  onChange(selectedObj);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
