import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:google_fonts/google_fonts.dart';
// import 'package:id_card_editor/fetch_design.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:http/http.dart' as http;

import '../../ip_address.dart';
import 'design_class.dart';
import 'image_capsule.dart';

import 'image_properties.dart';
import 'movable_and_extra_class.dart';
import 'save_dialog.dart';
import 'text_properties.dart';

class DeleteIntent extends Intent {}

class DesignEditor extends StatefulWidget {
  const DesignEditor(
      {super.key, required this.design, required this.savedDesigns});
  final Design design;
  final List savedDesigns;

  @override
  State<DesignEditor> createState() => _DesignEditorState();
}

class _DesignEditorState extends State<DesignEditor> {
  Movable? selectedObj;
  late Design design;
  // List fonts = GoogleFonts.asMap().keys.toList().sublist(0, 200);

  late Future _getFieldNames;
  bool isBack = false;
  bool showGuidlines = true;

  @override
  void initState() {
    design = widget.design;
    isBack = design.backImageName == '' ? false : true;
    _getFieldNames = getFieldNames();

    super.initState();
  }

  getFieldNames() async {
    var url = Uri.parse("$ipv4/getFieldNames");
    var res = await http.get(url);
    var fieldNames = jsonDecode(res.body);

    return fieldNames;
  }

  deleteElement(Movable element) {
    if (design.frontElements.contains(element)) {
      design.frontElements.remove(element);
    } else {
      design.backElements.remove(element);
    }
    setState(() {
      selectedObj = null;
    });
  }

  Widget getProperties(Movable selectedObj) {
    if (selectedObj is MyText || selectedObj is MyAutoText) {
      return TextProperties(
        selectedObj: selectedObj as MyAutoText,
        isAuto: selectedObj is! MyText,
        onChange: (p0) {
          setState(() {
            selectedObj = p0;
          });
        },
        onDelete: (p0) => deleteElement(p0),
      );
    } else {
      return ImageProperties(
        selected: selectedObj as MyImage,
        onChange: (p0) {
          setState(() {
            selectedObj = p0;
          });
        },
        onDelete: (p0) => deleteElement(p0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.devicePixelRatioOf(context));
    // print(View.of(context).devicePixelRatio);
    // print(200 * 1.25); //physcial= flutterPixel*1.25
    //inch*96=flutterPixel*1.25
    //(inch*96)/1.25=flutterPixel
    //physical=inch*96
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => SaveDialog(
                  design: design,
                  savedDesigns: widget.savedDesigns,
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
                                              if (fields[index] ==
                                                  'profilePic') {
                                                design.frontElements.add(
                                                    MyImage(fields[index]));
                                              } else {
                                                design.frontElements.add(
                                                  MyAutoText(fields[index]),
                                                );
                                              }
                                            });
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: Text('At Back'),
                                          onTap: () {
                                            setState(() {
                                              if (fields[index] ==
                                                  'profilePic') {
                                                design.backElements.add(
                                                    MyImage(fields[index]));
                                              } else {
                                                design.backElements.add(
                                                  MyAutoText(fields[index]),
                                                );
                                              }
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
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
                      height: design.frontBackgroundImage == null
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
                                      final frontBackgroundImage =
                                          await picker.getImageFromSource(
                                        source: ImageSource.gallery,
                                      );
                                      design.frontImageName =
                                          frontBackgroundImage!.name;

                                      final imgBytes =
                                          await frontBackgroundImage
                                              .readAsBytes();
                                      final decodedImage =
                                          await decodeImageFromList(imgBytes);

                                      // backgroundImageWidth =
                                      //     decodedImage.width.toDouble();
                                      design.backgroundImageHeight =
                                          decodedImage.height.toDouble();

                                      setState(() {
                                        design.frontBackgroundImage = imgBytes;
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
                                        final backBackgroundImage =
                                            await picker.getImageFromSource(
                                                source: ImageSource.gallery);
                                        design.backImageName =
                                            backBackgroundImage!.name;
                                        final imgBytes =
                                            await backBackgroundImage
                                                .readAsBytes();

                                        // backgroundImageWidth =
                                        //     decodedImage.width.toDouble();

                                        setState(() {
                                          design.backBackgroundImage = imgBytes;
                                        });
                                      },
                                      child: Text('Back Background Image'),
                                    ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // Text('Width:'),
                                  // SizedBox(
                                  //   width: 5,
                                  // ),
                                  // SizedBox(
                                  //   width: 70,
                                  //   child: TextField(
                                  //     decoration:
                                  //         InputDecoration(isDense: true),
                                  //     controller: TextEditingController(
                                  //       text: backgroundImageWidth
                                  //           .toStringAsFixed(2),
                                  //     ),
                                  //     onSubmitted: (value) {
                                  //       setState(() {
                                  //         backgroundImageWidth =
                                  //             double.parse(value);
                                  //       });
                                  //     },
                                  //   ),
                                  // ),
                                  Text('Height:'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SizedBox(
                                    width: 70,
                                    child: TextField(
                                      decoration:
                                          InputDecoration(isDense: true),
                                      controller: TextEditingController(
                                        text: design.backgroundImageHeight
                                            .toStringAsFixed(2),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          design.backgroundImageHeight =
                                              double.parse(value);
                                        });
                                      },
                                    ),
                                  ),
                                  Spacer(),
                                  Text('Guidelines'),
                                  Switch(
                                    value: showGuidlines,
                                    onChanged: (value) {
                                      setState(() {
                                        showGuidlines = value;
                                      });
                                    },
                                  )
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
                                        child: design.frontImageName != null
                                            ? Column(
                                                children: [
                                                  if (design.frontImageName !=
                                                      null)
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: TextButton.icon(
                                                        onPressed: () {
                                                          setState(() {
                                                            design.frontElements
                                                                .add(MyText(
                                                              "Text${design.frontElements.length + 1}",
                                                            ));
                                                          });
                                                        },
                                                        icon: Icon(Icons.add),
                                                        label: Text('Add Text'),
                                                      ),
                                                    ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ImageCapsule(
                                                    backgroundImage: design
                                                        .frontBackgroundImage,
                                                    backgroundImageHeight: design
                                                        .backgroundImageHeight,
                                                    elements:
                                                        design.frontElements,
                                                    showGuidlines:
                                                        showGuidlines,
                                                    selected: selectedObj,
                                                    onSelected: (p0) {
                                                      setState(() {
                                                        selectedObj = p0;
                                                      });
                                                    },
                                                  )
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
                                          child: design.backBackgroundImage !=
                                                  null
                                              ? Column(
                                                  children: [
                                                    if (design
                                                            .backBackgroundImage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: TextButton.icon(
                                                          onPressed: () {
                                                            setState(() {
                                                              design
                                                                  .backElements
                                                                  .add(MyText(
                                                                "Text${design.backElements.length + 1}",
                                                              ));
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
                                                    ImageCapsule(
                                                      backgroundImage: design
                                                          .backBackgroundImage,
                                                      // backgroundImageWidth:
                                                      //     backgroundImageWidth,
                                                      backgroundImageHeight: design
                                                          .backgroundImageHeight,
                                                      elements:
                                                          design.backElements,
                                                      showGuidlines:
                                                          showGuidlines,
                                                      selected: selectedObj,
                                                      onSelected: (p0) {
                                                        setState(() {
                                                          selectedObj = p0;
                                                        });
                                                      },
                                                    )
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
                            itemCount: design.frontElements.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedObj = design.frontElements[index];
                                });
                              },
                              child: Container(
                                  width: double.infinity,
                                  color:
                                      selectedObj == design.frontElements[index]
                                          ? Colors.black26
                                          : null,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child:
                                      Text(design.frontElements[index].name)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: design.backElements.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                setState(() {
                                  selectedObj = design.backElements[index];
                                });
                              },
                              child: Container(
                                  width: double.infinity,
                                  color:
                                      selectedObj == design.backElements[index]
                                          ? Colors.black26
                                          : null,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: Text(design.backElements[index].name)),
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
                          child: getProperties(selectedObj!))
                      : null,
                )
              ],
            ),
          ),
        ));
  }
}
