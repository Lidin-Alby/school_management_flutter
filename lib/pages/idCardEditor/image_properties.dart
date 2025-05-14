import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

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
  List<String> inbuildPngList = ['square.png', 'circle.png'];
  List pngList = [];
  XFile? newPng;
  Uint8List? newPngBytes;
  bool saving = false;

  getMaskPng() async {
    var url = Uri.parse('$ipv4/getPngMaskList');
    var res = await http.get(url);
    List fileNames = jsonDecode(res.body);
    setState(() {
      pngList = fileNames;
    });
  }

  saveMaskPng() async {
    setState(() {
      saving = true;
    });
    var request = http.MultipartRequest('POST', Uri.parse('$ipv4/saveMaskPng'));
    request.files.add(http.MultipartFile.fromBytes('pngMask', newPngBytes!,
        filename: newPng!.name));

    var response = await request.send();
    await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      setState(() {
        saving = false;
      });
    }
  }

  @override
  void initState() {
    getMaskPng();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyImage selectedObj = widget.selected;

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
        SizedBox(
          height: 250,
          width: 240,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                height: 250,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                color: Colors.white,
                child: Wrap(
                  runSpacing: 8,
                  spacing: 2.5,
                  children: [
                    for (String i in inbuildPngList)
                      InkWell(
                        onTap: () {
                          selectedObj.pngMaskImage = Image.asset(
                            'assets/$i',
                          );
                          widget.onChange(selectedObj);
                        },
                        child: Image.asset(
                          'assets/$i',
                          height: 40,
                        ),
                      ),
                    for (String i in pngList)
                      InkWell(
                          onTap: () {
                            selectedObj.pngMaskImage = Image.network(
                                height: 40, '$ipv4/getPngMask/$i');
                            widget.onChange(selectedObj);
                          },
                          child:
                              Image.network(height: 40, '$ipv4/getPngMask/$i')),
                    saving
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator()),
                          )
                        : IconButton(
                            onPressed: () async {
                              final picker = ImagePickerPlugin();
                              newPng = await picker.getImageFromSource(
                                  source: ImageSource.gallery);
                              newPngBytes = await newPng!.readAsBytes();
                              saveMaskPng();
                            },
                            icon: Icon(Icons.add),
                          ),
                  ],
                ),
              ),
            ),
          ),
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
