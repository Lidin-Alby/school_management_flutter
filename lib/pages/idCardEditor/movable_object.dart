import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:school_management/ip_address.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:widgets_easier/widgets_easier.dart';

import 'movable_and_extra_class.dart';

class MovableObject extends StatefulWidget {
  const MovableObject({
    super.key,
    required this.element,
    required this.onSelected,
    required this.showGuidlines,
    required this.selected,
  });
  final Movable element;
  final Movable? selected;
  final bool showGuidlines;
  final Function(Movable?) onSelected;

  @override
  State<MovableObject> createState() => _MovableObjectState();
}

class _MovableObjectState extends State<MovableObject> {
  late Movable element;

  Movable? selectedObj;
  late BorderRadius myRadius;
  @override
  void initState() {
    element = widget.element;

    super.initState();
  }

  Widget getElement(Movable element) {
    if (element is MyText) {
      return Padding(
        padding: selectedObj == element || widget.showGuidlines
            ? EdgeInsets.zero
            : EdgeInsets.only(top: 1, left: 1),
        child: TextField(
          onTap: () {
            setState(() {
              selectedObj = element;
            });
            widget.onSelected(selectedObj);
          },
          // onTapOutside: (event) {
          //   setState(() {
          //     selectedObj = null;
          //   });
          //   widget.onSelected(null);
          // },
          controller: element.textEditingController,
          maxLines: null,
          textAlign: element.textAlign,
          decoration: InputDecoration(
              hintStyle: TextStyle(color: element.textcolor),
              hintText: 'Type Here',
              isCollapsed: true,
              border: InputBorder.none),
          style: GoogleFonts.getFont(
            element.font,
            color: element.textcolor,
            fontSize: element.fontSize,
            fontStyle: element.fontStyle,
            fontWeight: element.fontWeight,
            decoration: element.textDecoration,
          ),
        ),
      );
    } else if (element is MyAutoText) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedObj = element;
          });
          widget.onSelected(selectedObj);
        },
        child: element.isQR
            ? QrImageView(
                data: element.value!,
                backgroundColor: Colors.white,
                padding: EdgeInsets.zero,
              )
            : Padding(
                padding: selectedObj == element || widget.showGuidlines
                    ? EdgeInsets.zero
                    : EdgeInsets.only(top: 1, left: 1),
                child: AutoSizeText(
                  element.value.toString(),
                  textAlign: element.textAlign,
                  minFontSize: 5,
                  style: GoogleFonts.getFont(
                    element.font,
                    color: element.textcolor,
                    fontSize: element.fontSize,
                    fontStyle: element.fontStyle,
                    fontWeight: element.fontWeight,
                    decoration: element.textDecoration,
                  ),
                ),
              ),
      );
    } else if (element is MyImage) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedObj = element;
          });
          widget.onSelected(selectedObj);
        },
        child: Container(
          decoration: selectedObj == element && widget.showGuidlines
              ? ShapeDecoration(
                  shape: DashedBorder(
                    borderRadius: myRadius,
                    dashSpacing: 2.5,
                    dashSize: 8,
                  ),
                )
              : null,
          child: Stack(
            children: [
              Transform.scale(
                scale: element.borderWidth,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    element.borderColor,
                    BlendMode.srcIn,
                  ),
                  child: element.pngMaskImage == ''
                      ? Image.asset(
                          'assets/square.png',
                        )
                      : Image.network(
                          '$ipv4/getPngMask/${element.pngMaskImage}',
                        ),
                ),
              ),
              WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: element.getImage(),
                child: element.pngMaskImage == ''
                    ? Image.asset(
                        'assets/square.png',
                      )
                    : Image.network('$ipv4/getPngMask/${element.pngMaskImage}'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Text('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    myRadius = BorderRadius.only(
      topLeft: Radius.circular(element.topLeft),
      topRight: Radius.circular(element.topRight),
      bottomLeft: Radius.circular(element.bottomLeft),
      bottomRight: Radius.circular(element.bottomRight),
    );
    selectedObj = widget.selected;
    return Positioned(
      top: element.top,
      left: element.left,
      child: Focus(
        autofocus: true,
        child: SizedBox(
          width: element.width + 3,
          height: element.height + 3,
          child: Stack(
            children: [
              Container(
                width: element.width,
                height: element.height,
                decoration: ShapeDecoration(
                  shape: selectedObj == element
                      ? SolidBorder()
                      : widget.showGuidlines
                          ? DashedBorder(
                              borderRadius: myRadius,
                              dashSpacing: 2.5,
                              dashSize: 8,
                            )
                          : Border(),
                ),
                child: getElement(element),
              ),
              if (selectedObj == element)
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
                          widget.onSelected(selectedObj);
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
              if (selectedObj == element)
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
                          widget.onSelected(selectedObj);
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
              if (selectedObj == element)
                Positioned(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.move,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          selectedObj!.top += details.delta.dy;
                          selectedObj!.left += details.delta.dx;
                        });
                        widget.onSelected(selectedObj);
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
