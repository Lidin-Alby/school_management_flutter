import 'package:flutter/material.dart';

import 'movable_and_extra_class.dart';

class ImageProperties extends StatefulWidget {
  const ImageProperties(
      {super.key,
      required this.selected,
      required this.onChange,
      required this.onDelete});
  final MyImage selected;
  final Function(MyImage) onChange;
  final Function(MyImage) onDelete;

  @override
  State<ImageProperties> createState() => _ImagePropertiesState();
}

class _ImagePropertiesState extends State<ImageProperties> {
  @override
  Widget build(BuildContext context) {
    MyImage selectedObj = widget.selected;
    if (selectedObj.circle) {
      selectedObj.height = selectedObj.width;
      selectedObj.topLeft = selectedObj.bottomLeft = selectedObj.topRight =
          selectedObj.bottomRight = selectedObj.width / 2;
      // widget.onChange(selectedObj);
    }
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
                widget.onDelete(selectedObj);
              },
              child: Text('Delete'),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text('Circle'),
            Checkbox(
              value: selectedObj.circle,
              onChanged: (value) {
                selectedObj.circle = value!;
                if (!value) {
                  selectedObj.topLeft = selectedObj.topRight =
                      selectedObj.bottomLeft = selectedObj.bottomRight = 0;
                }
                widget.onChange(selectedObj);
              },
            ),
          ],
        ),
        SizedBox(
          height: 15,
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
                  widget.onChange(selectedObj);
                },
              ),
            ),
            Spacer(),
            if (!selectedObj.circle)
              Row(
                children: [
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
                        widget.onChange(selectedObj);
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          // spacing: 5,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('top: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                ),
                controller: TextEditingController(
                  text: selectedObj.top.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.top = double.parse(value);
                  // });
                  widget.onChange(selectedObj);
                },
              ),
            ),
            Spacer(),
            Text('left: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(isDense: true),
                controller: TextEditingController(
                  text: selectedObj.left.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.left = double.parse(value);
                  // });
                  widget.onChange(selectedObj);
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        if (!selectedObj.circle)
          Row(
            // spacing: 5,
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('top-left: '),
              SizedBox(
                width: 30,
                child: TextField(
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                  ),
                  controller: TextEditingController(
                    text: selectedObj.topLeft.toStringAsFixed(1),
                  ),
                  onSubmitted: (value) {
                    // setState(() {
                    selectedObj.topLeft = double.parse(value);
                    // });
                    widget.onChange(selectedObj);
                  },
                ),
              ),
              Spacer(),
              Text('top-right: '),
              SizedBox(
                width: 30,
                child: TextField(
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(isDense: true),
                  controller: TextEditingController(
                    text: selectedObj.topRight.toStringAsFixed(1),
                  ),
                  onSubmitted: (value) {
                    // setState(() {
                    selectedObj.topRight = double.parse(value);
                    // });
                    widget.onChange(selectedObj);
                  },
                ),
              ),
            ],
          ),
        SizedBox(
          height: 15,
        ),
        if (!selectedObj.circle)
          Row(
            // spacing: 5,
            // crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('btm-left: '),
              SizedBox(
                width: 30,
                child: TextField(
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                  ),
                  controller: TextEditingController(
                    text: selectedObj.bottomLeft.toStringAsFixed(1),
                  ),
                  onSubmitted: (value) {
                    // setState(() {
                    selectedObj.bottomLeft = double.parse(value);
                    // });
                    widget.onChange(selectedObj);
                  },
                ),
              ),
              Spacer(),
              Text('btm-right: '),
              SizedBox(
                width: 30,
                child: TextField(
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(isDense: true),
                  controller: TextEditingController(
                    text: selectedObj.bottomRight.toStringAsFixed(1),
                  ),
                  onSubmitted: (value) {
                    // setState(() {
                    selectedObj.bottomRight = double.parse(value);
                    // });
                    widget.onChange(selectedObj);
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}
