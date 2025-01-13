import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:screenshot/screenshot.dart';

import 'package:pdf/widgets.dart' as pw;

import '../../ip_address.dart';
import 'design_class.dart';
import 'functions.dart';
import 'image_capsule.dart';
import 'movable_and_extra_class.dart';

class PrintHomePage extends StatefulWidget {
  const PrintHomePage({super.key});

  @override
  State<PrintHomePage> createState() => _PrintHomePageState();
}

class _PrintHomePageState extends State<PrintHomePage> {
  late Future _getAllSchools;
  late Future _getClasses;
  late Future _getStudents;
  String? selectedSchool;
  late String selectedSchoolName;
  String? selectedClass;
  String? selectedDesign;
  List designs = [];
  late Design design;
  List<List<Map>> studentProgress = [];
  List students = [];
  List screenshotAdded = [];

  Future<List> getAllSchools() async {
    var url = Uri.parse('$ipv4/getAllMidSchools');

    var res = await http.get(url);

    List schools = jsonDecode(res.body);
    return schools;
  }

  getClasses() async {
    var url = Uri.parse('$ipv4/getMidClasses/$selectedSchool');

    var res = await http.get(url);

    Map classes = jsonDecode(res.body);
    return classes['classes'];
  }

  getStudents() async {
    var url = Uri.parse('$ipv4/eachClassMid/$selectedSchool/$selectedClass');

    var res = await http.get(url);

    List students = jsonDecode(res.body);
    return students;
  }

  Future getImage(String image) async {
    final url = Uri.parse('$ipv4/getPic/$selectedSchool/$image');
    final res = await http.get(url);
    if (res.statusCode == 404) {
      return res.body;
    }
    // setState(() {
    //   studentProgress[index][j]['progress'] = 1;
    // });
    return res.bodyBytes;
  }

  getDesigns() async {
    final url = Uri.parse('$ipv4/getDesigns');
    final res = await http.get(url);
    List data = jsonDecode(res.body);

    designs = data;
  }

  startDataCollection() async {
    List<pw.Image> ims = [];

    ScreenshotController screenshotController = ScreenshotController();
    for (int i = 0; i < students.length; i++) {
      int j = 0;
      for (var ele in design.frontElements) {
        if (ele is MyImage) {
          // print(students[i][ele.value]);
          var res = await getImage(students[i][ele.value]);

          if (res is Uint8List) {
            setState(() {
              studentProgress[i][j]['progress'] = 1.0;
            });
            // print(res);
            ele.imageBytes = res;
          } else {
            setState(() {
              studentProgress[i][j]['progress'] = res;
            });
            ele.imageBytes = null;
          }
          j++;
        } else {
          ele.value = students[i][ele.name];
        }
      }

      Uint8List? im = await screenshotController.captureFromWidget(ImageCapsule(
        backgroundImage: design.frontBackgroundImage,
        backgroundImageHeight: design.backgroundImageHeight,
        elements: design.frontElements,
        selected: null,
        onSelected: (p0) {},
      ));
      ims.add(
        pw.Image(
          pw.MemoryImage(
            im,
          ),
          height: 3.34 * 72,
          width: 2.12 * 72,
          fit: pw.BoxFit.fill,
        ),
      );
      setState(() {
        screenshotAdded[ims.length - 1] = true;
      });
    }
    print(studentProgress);
    generatePdf(ims);
  }

  Uint8List? img;

  @override
  void initState() {
    getDesigns();
    _getAllSchools = getAllSchools();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAllSchools,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List schools = snapshot.data;

          Map schoolNames = {};

          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownMenu(
                    enableFilter: true,
                    label: Text('Select School'),
                    dropdownMenuEntries: schools.map((e) {
                      schoolNames.addAll({e['schoolCode']: e['schoolName']});
                      return DropdownMenuEntry(
                        label: '${e['schoolCode']} - ${e['schoolName']}',
                        value: e['schoolCode'],
                      );
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        selectedSchool = value.toString();
                        selectedSchoolName = schoolNames[selectedSchool];
                        _getClasses = getClasses();
                      });
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton(
                    items: designs
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (value) async {
                      design = await getDesignData(value.toString());
                      setState(() {
                        selectedDesign = value.toString();
                      });
                    },
                    value: selectedDesign,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  if (selectedDesign != null)
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Image.memory(design.frontBackgroundImage!),
                        ),
                        SizedBox(
                            width: 40,
                            child: Image.memory(design.backBackgroundImage!)),
                      ],
                    ),
                  SizedBox(
                    width: 30,
                  ),
                  if (selectedClass != null && selectedDesign != null)
                    FilledButton(
                      onPressed: () {
                        for (var ele in design.frontElements) {
                          if (ele is MyImage) {
                            studentProgress = List.generate(
                              students.length,
                              (index) => [
                                {'fieldName': ele.name, 'progress': 0.0}
                              ],
                            );
                          }
                        }
                        screenshotAdded = List.generate(
                          students.length,
                          (index) => false,
                        );
                        setState(() {});
                        startDataCollection();
                      },
                      child: Text('Download PDF'),
                    )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              if (selectedSchool != null)
                Expanded(
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: _getClasses,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List classes = snapshot.data;
                            return SingleChildScrollView(
                              child: SizedBox(
                                width: 300,
                                child: Column(
                                  children: [
                                    for (Map myClass in classes)
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedClass = myClass['title'];
                                            _getStudents = getStudents();
                                          });
                                        },
                                        child: SizedBox(
                                          width: 200,
                                          height: 50,
                                          child: Card(
                                            color: selectedClass ==
                                                    myClass['title']
                                                ? Colors.grey[300]
                                                : null,
                                            child: Center(
                                              child: Text(
                                                myClass['title'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      if (selectedClass != null)
                        FutureBuilder(
                          future: _getStudents,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              students = snapshot.data;

                              return Expanded(
                                child: ListView.builder(
                                  itemCount: students.length,
                                  itemBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    child: ListTile(
                                      tileColor: Colors.grey[300],
                                      leading: SizedBox(
                                        width: 150,
                                        child:
                                            Text(students[index]['fullName']),
                                      ),
                                      title: studentProgress.isNotEmpty
                                          ? Column(
                                              children: [
                                                for (Map progressMap
                                                    in studentProgress[index])
                                                  progressMap['progress']
                                                          is double
                                                      ? Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            LinearProgressIndicator(
                                                              value: progressMap[
                                                                  'progress'],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  progressMap[
                                                                      'fieldName'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  '${(progressMap['progress'] * 100).toStringAsFixed(1)}%',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      : Text(progressMap[
                                                          'progress']),
                                              ],
                                            )
                                          : null,
                                      trailing: screenshotAdded.isNotEmpty
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: screenshotAdded[index]
                                                  ? Icon(Icons
                                                      .check_circle_outline)
                                                  : CircularProgressIndicator())
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        )
                    ],
                  ),
                ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Future generatePdf(List images) async {
  final pdf = pw.Document();

  pdf.addPage(pw.MultiPage(
    build: (context) => [
      pw.Wrap(children: [for (var i in images) i])
    ],
  ));

  final file = await pdf.save();

  // return file;
  FileSaver.instance.saveFile(
      name: 'my_file', bytes: file, mimeType: MimeType.pdf, ext: 'pdf');
}
