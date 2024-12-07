import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'my_text_class.dart';

class MovableObject extends StatefulWidget {
  const MovableObject(
      {super.key,
      required this.object,
      this.auto = false,
      required this.onSelected,
      this.selected});
  final MyText object;
  final bool auto;
  final MyText? selected;
  final Function(MyText?) onSelected;

  @override
  State<MovableObject> createState() => _MovableObjectState();
}

class _MovableObjectState extends State<MovableObject> {
  late MyText object;
  MyText? selectedObj;
  @override
  void initState() {
    object = widget.object;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedObj = widget.selected;
    return Positioned(
      top: object.top,
      left: object.left,
      child: Focus(
        autofocus: true,
        child: SizedBox(
          width: object.width + 3,
          height: object.height + 3,
          child: Stack(
            children: [
              Container(
                width: object.width,
                height: object.height,
                decoration: selectedObj == object
                    ? BoxDecoration(
                        border: Border.all(),
                      )
                    : null,
                child: Padding(
                  padding: selectedObj == object
                      ? EdgeInsets.zero
                      : EdgeInsets.only(top: 1, left: 1),
                  child: !widget.auto
                      ? TextField(
                          onTap: () {
                            setState(() {
                              selectedObj = object;
                            });
                            widget.onSelected(object);
                          },
                          onTapOutside: (event) {
                            setState(() {
                              selectedObj = null;
                            });
                            widget.onSelected(null);
                          },
                          controller: object.textEditingController,
                          maxLines: null,
                          textAlign: object.texAlign,
                          decoration: InputDecoration(
                              hintText: 'Type Here',
                              isCollapsed: true,
                              border: InputBorder.none),
                          style: TextStyle(
                            color: object.textcolor,
                            fontSize: object.fontSize,
                            fontStyle: object.fontStyle,
                            fontWeight: object.fontWeight,
                            decoration: object.textDecoration,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedObj = object;
                            });
                            widget.onSelected(object);
                          },
                          child: AutoSizeText(
                            object.textName,
                            textAlign: object.texAlign,
                            minFontSize: 5,
                            style: TextStyle(
                              color: object.textcolor,
                              fontSize: object.fontSize,
                              fontStyle: object.fontStyle,
                              fontWeight: object.fontWeight,
                              decoration: object.textDecoration,
                            ),
                          ),
                        ),
                ),
              ),
              if (selectedObj == object)
                Positioned(
                  right: 0,
                  top: (selectedObj!.height - 6) / 2,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        double width = selectedObj!.width + details.delta.dx;
                        if (width > 8) {
                          setState(() {
                            selectedObj!.width = width;
                          });
                        }
                      },
                      child: Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                        ),
                      ),
                    ),
                  ),
                ),
              if (selectedObj == object)
                Positioned(
                  right: (selectedObj!.width) / 2,
                  bottom: 0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeUpDown,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        double height = selectedObj!.height + details.delta.dy;
                        if (height > 8) {
                          setState(() {
                            selectedObj!.height = height;
                          });
                        }
                      },
                      child: Container(
                        height: 6,
                        width: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                        ),
                      ),
                    ),
                  ),
                ),
              if (selectedObj == object)
                Positioned(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.move,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          selectedObj!.top += details.delta.dy;
                          selectedObj!.left += details.delta.dx;
                        });
                      },
                      child: Container(
                        height: 5,
                        width: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
