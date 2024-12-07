import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:http/http.dart' as http;

import '../../ip_address.dart';
import 'Save_dialog.dart';
import 'design_class.dart';
import 'movable_object.dart';
import 'my_text_class.dart';

class DeleteIntent extends Intent {}

class DesignMain extends StatefulWidget {
  const DesignMain({super.key});

  @override
  State<DesignMain> createState() => _DesignMainState();
}

class _DesignMainState extends State<DesignMain> {
  Uint8List? frontBackgroundImageBytes;
  Uint8List? backBackgroundImageBytes;
  XFile? frontBackgroundImage;
  XFile? backBackgroundImage;

  double backgroundImageWidth = 0;

  List<MyText> frontTexts = [];
  List<MyText> backTexts = [];

  MyText? selectedObj;
  Design? design;
  // List fonts = GoogleFonts.asMap().keys.toList().sublist(0, 200);

  late Future _getFieldNames;
  bool isBack = false;

  @override
  void initState() {
    _getFieldNames = getFieldNames();
    super.initState();
  }

  getFieldNames() async {
    var url = Uri.parse("$ipv4/getFieldNames");
    var res = await http.get(url);
    var fieldNames = jsonDecode(res.body);

    return fieldNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => SaveDialog(
                  design: Design(
                      designName: '',
                      frontImageName: frontBackgroundImage!.name,
                      backImageName: backBackgroundImage?.name,
                      frontBackgroundImage: frontBackgroundImageBytes!,
                      backBackgroundImage: backBackgroundImageBytes,
                      frontTexts: frontTexts,
                      backTexts: backTexts,
                      backgroundImageWidth: backgroundImageWidth),
                ),
              ),
              icon: Icon(Icons.save_rounded),
            )
          ],
        ),
        body: Shortcuts(
          shortcuts: {LogicalKeySet(LogicalKeyboardKey.delete): DeleteIntent()},
          child: Actions(
            actions: {
              DeleteIntent: CallbackAction(onInvoke: (intent) {
                setState(() {
                  // texts.remove(selectedObj);
                });
                return;
              })
            },
            child: Row(
              children: [
                Container(
                    width: 160,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        FutureBuilder(
                          future: _getFieldNames,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List fields = snapshot.data;
                              return Expanded(
                                child: ListView.builder(
                                    itemCount: fields.length,
                                    itemBuilder: (context, index) => Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: PopupMenuButton(
                                            child: Text(fields[index]),
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: Text('At Front'),
                                                onTap: () {
                                                  setState(() {
                                                    frontTexts.add(MyText(
                                                        fields[index], true));
                                                  });
                                                },
                                              ),
                                              PopupMenuItem(
                                                child: Text('At Back'),
                                                onTap: () {
                                                  backTexts.add(MyText(
                                                      fields[index], true));
                                                },
                                              )
                                            ],
                                          ),
                                        )),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ],
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: frontBackgroundImageBytes == null
                          ? MediaQuery.of(context).size.height
                          : null,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text('Back Side'),
                                  Switch(
                                    value: isBack,
                                    onChanged: (value) {
                                      setState(() {
                                        isBack = !isBack;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  FilledButton(
                                    onPressed: () async {
                                      final picker = ImagePickerPlugin();
                                      frontBackgroundImage =
                                          await picker.getImageFromSource(
                                        source: ImageSource.gallery,
                                      );

                                      final imgBytes =
                                          await frontBackgroundImage!
                                              .readAsBytes();
                                      final decodedImage =
                                          await decodeImageFromList(imgBytes);

                                      backgroundImageWidth =
                                          decodedImage.width.toDouble();

                                      setState(() {
                                        frontBackgroundImageBytes = imgBytes;
                                      });
                                    },
                                    child: Text('Front Background Image'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (isBack)
                                    FilledButton(
                                      onPressed: () async {
                                        final picker = ImagePickerPlugin();
                                        backBackgroundImage =
                                            await picker.getImageFromSource(
                                                source: ImageSource.gallery);
                                        final imgBytes =
                                            await backBackgroundImage!
                                                .readAsBytes();
                                        final decodedImage =
                                            await decodeImageFromList(imgBytes);

                                        backgroundImageWidth =
                                            decodedImage.width.toDouble();

                                        setState(() {
                                          backBackgroundImageBytes = imgBytes;
                                        });
                                      },
                                      child: Text('Back Background Image'),
                                    ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Width:'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: TextField(
                                      decoration:
                                          InputDecoration(isDense: true),
                                      controller: TextEditingController(
                                        text: backgroundImageWidth
                                            .toStringAsFixed(2),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          backgroundImageWidth =
                                              double.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            Column(
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) => Row(
                                    children: [
                                      SizedBox(
                                        width: isBack
                                            ? constraints.maxWidth / 2
                                            : constraints.maxWidth - 20,
                                        child: frontBackgroundImage != null
                                            ? Column(
                                                children: [
                                                  if (frontBackgroundImage !=
                                                      null)
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: TextButton.icon(
                                                        onPressed: () {
                                                          setState(() {
                                                            frontTexts.add(MyText(
                                                                "Text${frontTexts.length + 1}",
                                                                false));
                                                          });
                                                        },
                                                        icon: Icon(Icons.add),
                                                        label: Text('Add Text'),
                                                      ),
                                                    ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  InteractiveViewer(
                                                    child: Stack(
                                                      children: [
                                                        Image.memory(
                                                          width:
                                                              backgroundImageWidth,
                                                          frontBackgroundImageBytes!,
                                                        ),
                                                        for (MyText text
                                                            in frontTexts)
                                                          MovableObject(
                                                            object: text,
                                                            auto: text.auto,
                                                            selected:
                                                                selectedObj,
                                                            onSelected: (p0) {
                                                              setState(() {
                                                                selectedObj =
                                                                    p0;
                                                              });
                                                            },
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : null,
                                      ),
                                      if (isBack)
                                        SizedBox(
                                          height: 500,
                                          child: VerticalDivider(),
                                        ),
                                      if (isBack)
                                        SizedBox(
                                          width: constraints.maxWidth / 2 - 20,
                                          child: backBackgroundImage != null
                                              ? Column(
                                                  children: [
                                                    if (backBackgroundImage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: TextButton.icon(
                                                          onPressed: () {
                                                            setState(() {
                                                              backTexts.add(MyText(
                                                                  "Text${backTexts.length + 1}",
                                                                  false));
                                                            });
                                                          },
                                                          icon: Icon(Icons.add),
                                                          label:
                                                              Text('Add Text'),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    InteractiveViewer(
                                                      child: Stack(
                                                        children: [
                                                          Image.memory(
                                                            width:
                                                                backgroundImageWidth,
                                                            backBackgroundImageBytes!,
                                                          ),
                                                          for (MyText text
                                                              in backTexts)
                                                            MovableObject(
                                                              object: text,
                                                              auto: text.auto,
                                                              selected:
                                                                  selectedObj,
                                                              onSelected: (p0) {
                                                                setState(() {
                                                                  selectedObj =
                                                                      p0;
                                                                });
                                                              },
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : null,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    width: 150,
                    color: Colors.grey,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: frontTexts.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedObj = frontTexts[index];
                                });
                              },
                              child: Container(
                                  width: double.infinity,
                                  color: selectedObj == frontTexts[index]
                                      ? Colors.black26
                                      : null,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: Text(frontTexts[index].textName)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: backTexts.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedObj = backTexts[index];
                                });
                              },
                              child: Container(
                                  width: double.infinity,
                                  color: selectedObj == backTexts[index]
                                      ? Colors.black26
                                      : null,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: Text(backTexts[index].textName)),
                            ),
                          ),
                        ),
                      ],
                    )),
                Container(
                  width: 250,
                  color: Colors.grey,
                  child: selectedObj != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Center(child: Text(selectedObj!.textName)),
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
                                        text: selectedObj!.width
                                            .toStringAsFixed(2),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          selectedObj!.width =
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
                                    selected:
                                        selectedObj!.texAlign == TextAlign.left,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedObj!.texAlign = TextAlign.left;
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
                                    selected: selectedObj!.texAlign ==
                                        TextAlign.center,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedObj!.texAlign =
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
                                    selected: selectedObj!.texAlign ==
                                        TextAlign.right,
                                    onSelected: (value) {
                                      setState(() {
                                        selectedObj!.texAlign = TextAlign.right;
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
                                        text: selectedObj!.fontSize
                                            .toStringAsFixed(1),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          selectedObj!.fontSize =
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
                                    selected: selectedObj!.fontWeight ==
                                        FontWeight.bold,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          selectedObj!.fontWeight =
                                              FontWeight.bold;
                                        } else {
                                          selectedObj!.fontWeight =
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
                                    selected: selectedObj!.fontStyle ==
                                        FontStyle.italic,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          selectedObj!.fontStyle =
                                              FontStyle.italic;
                                        } else {
                                          selectedObj!.fontStyle =
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
                                    selected: selectedObj!.textDecoration ==
                                        TextDecoration.underline,
                                    onSelected: (value) {
                                      setState(() {
                                        if (value) {
                                          selectedObj!.textDecoration =
                                              TextDecoration.underline;
                                        } else {
                                          selectedObj!.textDecoration =
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
                                pickerColor: selectedObj!.textcolor,
                                onColorChanged: (value) {
                                  setState(() {
                                    selectedObj!.textcolor = value;
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
