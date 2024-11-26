import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

import 'myText_class.dart';

class DeleteIntent extends Intent {}

class DesignMain extends StatefulWidget {
  const DesignMain({super.key});

  @override
  State<DesignMain> createState() => _DesignMainState();
}

class _DesignMainState extends State<DesignMain> {
  Uint8List? backgroundImage;
  double backgroundImageHeight = 0;
  double backgroundImageWidth = 0;

  Offset backgroundImageOffset = Offset(0, 0);
  Offset offset = Offset(0, 0);
  Offset topLeftOffset = Offset(0, 0);
  late Offset topRightOffset;

  bool backgroundImageSelected = false;
  bool topleft = false;
  TextEditingController backgroundImageHeightController =
      TextEditingController();

  List texts = [];
  MyText? selectedText;
  // List fonts = GoogleFonts.asMap().keys.toList().sublist(0, 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(),
        body: Shortcuts(
          shortcuts: {LogicalKeySet(LogicalKeyboardKey.delete): DeleteIntent()},
          child: Actions(
            actions: {
              DeleteIntent: CallbackAction(onInvoke: (intent) {
                setState(() {
                  texts.remove(selectedText);
                });
                return;
              })
            },
            child: Row(
              children: [
                Container(
                    width: 150,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        for (MyText text in texts)
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedText = text;
                              });
                            },
                            child: Container(
                                width: double.infinity,
                                color: selectedText == text
                                    ? Colors.black26
                                    : null,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                child: Text(text.textName)),
                          )
                      ],
                    )),
                Expanded(
                  child: SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              FilledButton(
                                onPressed: () async {
                                  final picker = ImagePickerPlugin();
                                  final XFile? image =
                                      await picker.getImageFromSource(
                                          source: ImageSource.gallery);
                                  final imgBytes = await image!.readAsBytes();
                                  // final decodedImage =
                                  //     await decodeImageFromList(imgBytes);
                                  // backgroundImageHeight = decodedImage.height.toDouble();
                                  // backgroundImageWidth = decodedImage.width.toDouble();
                                  // ratio = backgroundImageWidth / backgroundImageHeight;
                                  // if (backgroundImageHeight > 600) {
                                  //   backgroundImageHeight = 600;
                                  //   backgroundImageWidth = backgroundImageHeight * ratio;
                                  // }

                                  setState(() {
                                    backgroundImage = imgBytes;
                                    // topRightOffset = Offset(backgroundImageWidth, 10);
                                    backgroundImageWidth =
                                        backgroundImageHeight = 200;
                                  });
                                },
                                child: Text('Pick Background Image'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if (backgroundImage != null)
                                FilledButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      texts.add(
                                          MyText('Text${texts.length + 1}'));
                                    });
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text('Add Text'),
                                ),
                            ],
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 15,
                        ),
                        if (backgroundImage != null)
                          InteractiveViewer(
                            child: Stack(
                              children: [
                                Image.memory(
                                  backgroundImage!,
                                  fit: BoxFit.cover,
                                ),
                                for (MyText text in texts)
                                  Positioned(
                                    top: text.top,
                                    left: text.left,
                                    child: Focus(
                                      autofocus: true,
                                      child: SizedBox(
                                        width: text.width + 3,
                                        height: text.height + 3,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: text.width,
                                              height: text.height,
                                              decoration: selectedText == text
                                                  ? BoxDecoration(
                                                      border: Border.all(),
                                                    )
                                                  : null,
                                              child: Padding(
                                                padding: selectedText == text
                                                    ? EdgeInsets.zero
                                                    : EdgeInsets.only(
                                                        top: 1, left: 1),
                                                child: TextField(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedText = text;
                                                    });
                                                  },
                                                  onTapOutside: (event) {
                                                    setState(() {
                                                      selectedText = null;
                                                    });
                                                  },
                                                  controller: text
                                                      .textEditingController,
                                                  maxLines: null,
                                                  textAlign: text.texAlign,
                                                  decoration: InputDecoration(
                                                      hintText: 'Type Here',
                                                      isCollapsed: true,
                                                      border: InputBorder.none),
                                                  style: TextStyle(
                                                    color: text.textcolor,
                                                    fontSize: text.fontSize,
                                                    fontStyle: text.fontStyle,
                                                    fontWeight: text.fontWeight,
                                                    decoration:
                                                        text.textDecoration,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (selectedText == text)
                                              Positioned(
                                                right: 0,
                                                top:
                                                    (selectedText!.height - 6) /
                                                        2,
                                                child: MouseRegion(
                                                  cursor: SystemMouseCursors
                                                      .resizeLeftRight,
                                                  child: GestureDetector(
                                                    onHorizontalDragUpdate:
                                                        (details) {
                                                      double width =
                                                          selectedText!.width +
                                                              details.delta.dx;
                                                      if (width > 8) {
                                                        setState(() {
                                                          selectedText!.width =
                                                              width;
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
                                            if (selectedText == text)
                                              Positioned(
                                                right:
                                                    (selectedText!.width) / 2,
                                                bottom: 0,
                                                child: MouseRegion(
                                                  cursor: SystemMouseCursors
                                                      .resizeUpDown,
                                                  child: GestureDetector(
                                                    onVerticalDragUpdate:
                                                        (details) {
                                                      double height =
                                                          selectedText!.height +
                                                              details.delta.dy;
                                                      if (height > 8) {
                                                        setState(() {
                                                          selectedText!.height =
                                                              height;
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
                                            if (selectedText == text)
                                              Positioned(
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.move,
                                                  child: GestureDetector(
                                                    onPanUpdate: (details) {
                                                      setState(() {
                                                        selectedText!.top +=
                                                            details.delta.dy;
                                                        selectedText!.left +=
                                                            details.delta.dx;
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
                                  )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 250,
                  color: Colors.grey,
                  child: selectedText != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(child: Text(selectedText!.textName)),
                              SizedBox(
                                height: 20,
                              ),
                              Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text('Width:'),
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      decoration:
                                          InputDecoration(isDense: true),
                                      controller: TextEditingController(
                                        text: selectedText!.width
                                            .toStringAsFixed(2),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          selectedText!.width =
                                              double.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text('Text Align:'),
                                  ChoiceChip(
                                    labelPadding: EdgeInsets.zero,
                                    showCheckmark: false,
                                    label: Icon(
                                      Icons.align_horizontal_left_rounded,
                                      size: 20,
                                    ),
                                    selected: selectedText!.texAlign ==
                                        TextAlign.left,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedText!.texAlign = TextAlign.left;
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    labelPadding: EdgeInsets.zero,
                                    showCheckmark: false,
                                    label: Icon(
                                      Icons.align_horizontal_center,
                                      size: 20,
                                    ),
                                    selected: selectedText!.texAlign ==
                                        TextAlign.center,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedText!.texAlign =
                                            TextAlign.center;
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    labelPadding: EdgeInsets.zero,
                                    showCheckmark: false,
                                    label: Icon(
                                      Icons.align_horizontal_right,
                                      size: 20,
                                    ),
                                    selected: selectedText!.texAlign ==
                                        TextAlign.right,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedText!.texAlign =
                                            TextAlign.right;
                                      });
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text('Font Size:'),
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                      decoration:
                                          InputDecoration(isDense: true),
                                      controller: TextEditingController(
                                        text: selectedText!.fontSize
                                            .toStringAsFixed(1),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          selectedText!.fontSize =
                                              double.parse(value);
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text('Font Style:'),
                                  ChoiceChip(
                                    labelPadding: EdgeInsets.zero,
                                    showCheckmark: false,
                                    label: Icon(
                                      Icons.format_bold_rounded,
                                      size: 20,
                                    ),
                                    selected: selectedText!.fontWeight ==
                                        FontWeight.bold,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          selectedText!.fontWeight =
                                              FontWeight.bold;
                                        } else {
                                          selectedText!.fontWeight =
                                              FontWeight.normal;
                                        }
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    labelPadding: EdgeInsets.zero,
                                    showCheckmark: false,
                                    label: Icon(
                                      Icons.format_italic_rounded,
                                      size: 20,
                                    ),
                                    selected: selectedText!.fontStyle ==
                                        FontStyle.italic,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          selectedText!.fontStyle =
                                              FontStyle.italic;
                                        } else {
                                          selectedText!.fontStyle =
                                              FontStyle.normal;
                                        }
                                      });
                                    },
                                  ),
                                  ChoiceChip(
                                    labelPadding: EdgeInsets.zero,
                                    showCheckmark: false,
                                    label: Icon(
                                      Icons.format_underline_rounded,
                                      size: 20,
                                    ),
                                    selected: selectedText!.textDecoration ==
                                        TextDecoration.underline,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          selectedText!.textDecoration =
                                              TextDecoration.underline;
                                        } else {
                                          selectedText!.textDecoration =
                                              TextDecoration.none;
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              // DropdownMenu(
                              //   dropdownMenuEntries: fonts
                              //       .map(
                              //         (font) => DropdownMenuEntry(
                              //           label: font,
                              //           value: font,
                              //         ),
                              //       )
                              //       .toList(),
                              //   enableFilter: true,
                              //   onSelected: (value) {},
                              // )
                              SizedBox(
                                height: 15,
                              ),
                              ColorPicker(
                                colorPickerWidth: 200,
                                portraitOnly: true,
                                pickerColor: selectedText!.textcolor,
                                onColorChanged: (value) {
                                  setState(() {
                                    selectedText!.textcolor = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : null,
                )
              ],
            ),
          ),
        ));
  }
}
