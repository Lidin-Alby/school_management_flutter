import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../ip_address.dart';

class StudyMaterials extends StatefulWidget {
  const StudyMaterials({
    super.key,
  });

  @override
  State<StudyMaterials> createState() => _StudyMaterialsState();
}

class _StudyMaterialsState extends State<StudyMaterials> {
  late String schoolCode;
  late Future _documents;
  String? selectedClass;
  String? selectedSubject;
  List classes = [];
  List subjects = [];
  String searchText = '';

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List data = jsonDecode(res.body);
    schoolCode = data.last['schoolCode'];

    data.removeLast();

    classes = data;
    getInstitueSubjects();

    return data;
  }

  getInstitueSubjects() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getSubjects');
    var res = await client.get(url);

    print(res.body);
    var data = jsonDecode(res.body);
    subjects = data['subjects'];
    setState(() {});
  }

  getStudyMaterials() async {
    var client = BrowserClient()..withCredentials = true;
    var url =
        Uri.parse('$ipv4/getstudyMaterials/$selectedClass/$selectedSubject');

    var res = await client.get(url);

    print(res.body);
    List data = jsonDecode(res.body);

    return data;
  }

  downloadFile(String loc, String name) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/downloadDoc');
    var response = await client.post(url, body: {'loc': loc});

    final fileBytes = response.bodyBytes;

    FileSaver.instance.saveFile(
      name: name,
      bytes: fileBytes,
      // ext: 'pdf',
      // mimeType: MimeType.pdf,
    );
  }

  deleteMaterial(int index) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/deleteStudyMaterial');

    var res = await client.post(url, body: {
      'classTitle': selectedClass,
      'subject': selectedSubject,
      'index': index.toString(),
      'schoolCode': schoolCode
    });

    if (res.body == 'true') {
      print(true);
      setState(() {
        _documents = getStudyMaterials();
      });
    }
  }

  @override
  void initState() {
    getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Class',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(4)),
                      child: DropdownButton(
                        // borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.all(4),
                        value: selectedClass,
                        isDense: true, isExpanded: true,
                        underline: Text(''),
                        hint: Text('Select Class'),
                        items: classes
                            .map((e) => DropdownMenuItem(
                                value: e['title'], child: Text(e['title'])))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value.toString();
                            if (selectedSubject != null) {
                              _documents = getStudyMaterials();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subject',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(4)),
                      child: DropdownButton(
                        // borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.all(4),
                        value: selectedSubject,
                        isDense: true, isExpanded: true,
                        underline: Text(''),
                        hint: Text('Select Subject'),
                        items: subjects
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            // _attendanceData = getAttendace();
                            selectedSubject = value.toString();
                            if (selectedSubject != null) {
                              _documents = getStudyMaterials();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (selectedClass != null && selectedSubject != null)
            FutureBuilder(
              future: _documents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List files = snapshot.data;

                  if (searchText != '') {
                    files = files
                        .where((element) =>
                            element['title']
                                .toLowerCase()
                                .contains(searchText.toLowerCase()) ||
                            DateFormat('dd-MM-yyyy h:mma')
                                .format(DateTime.parse(element['uploadDate']))
                                .contains(searchText))
                        .toList();
                  }
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 400,
                            child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    hintText: 'Search',
                                    isDense: true,
                                    prefixIcon: Icon(Icons.search)),
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                }
                                // searchFunction(value),
                                ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(elevation: 0),
                            onPressed: () => showModalBottomSheet(
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              context: context,
                              builder: (context) => AddStudyMaterial(
                                selectedClass: selectedClass!,
                                selectedSubject: selectedSubject!,
                                schoolCode: schoolCode,
                                refresh: () {
                                  setState(() {
                                    _documents = getStudyMaterials();
                                  });
                                },
                              ),
                            ),
                            icon: Icon(Icons.add_rounded),
                            label: Text('Add New Material'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Table(
                            columnWidths: {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(1),
                              3: FlexColumnWidth(1)
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            border: TableBorder(
                                horizontalInside: BorderSide(),
                                verticalInside: BorderSide()),
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.orange.shade50),
                                  children: const [
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        'Material Name',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                    TableCell(
                                        child: Text(
                                      'Description',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    TableCell(
                                        child: Text(
                                      'Upload Date',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    TableCell(
                                        child: Text(
                                      'Action',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))
                                  ]),
                              for (int i = files.length - 1; i >= 0; i--)
                                TableRow(children: [
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      files[i]['title'],
                                    ),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(files[i]['description']),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      DateFormat('dd-MM-yyyy h:mma').format(
                                        DateTime.parse(files[i]['uploadDate']),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                                  TableCell(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Wrap(
                                      runSpacing: 10,
                                      alignment: WrapAlignment.end,
                                      children: [
                                        if (files[i]['link'] != "")
                                          TextButton(
                                              onPressed: () => html.window
                                                  .open(files[i]['link'], ''),
                                              // launchUrl(Uri.parse(e['link'])),
                                              child: Icon(Icons.open_in_new)),
                                        if (files[i]["loc"] != "")
                                          TextButton(
                                              onPressed: () => downloadFile(
                                                  files[i]["loc"],
                                                  files[i]['fname']),
                                              child: Icon(Icons
                                                  .download_for_offline_outlined)),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero),
                                          onPressed: () => deleteMaterial(i),
                                          child: Icon(
                                            Icons.delete_rounded,
                                            color: Colors.red,
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () =>
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  context: context,
                                                  builder: (context) =>
                                                      EditStudyMaterial(
                                                    selectedClass:
                                                        selectedClass!,
                                                    selectedSubject:
                                                        selectedSubject!,
                                                    schoolCode: schoolCode,
                                                    title: files[i]['title'],
                                                    description: files[i]
                                                        ['description'],
                                                    link: files[i]['link'],
                                                    fileName: files[i]['fname'],
                                                    index: i,
                                                    loc: files[i]['loc'],
                                                    refresh: () {
                                                      setState(() {
                                                        _documents =
                                                            getStudyMaterials();
                                                      });
                                                    },
                                                  ),
                                                ),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                  )),
                                ])
                            ]),
                      )
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
        ],
      ),
    );
  }
}

class AddStudyMaterial extends StatefulWidget {
  const AddStudyMaterial(
      {super.key,
      required this.selectedClass,
      required this.selectedSubject,
      required this.schoolCode,
      required this.refresh});
  final String selectedClass;
  final String selectedSubject;
  final String schoolCode;
  final VoidCallback refresh;

  @override
  State<AddStudyMaterial> createState() => _AddStudyMaterialState();
}

class _AddStudyMaterialState extends State<AddStudyMaterial> {
  PlatformFile? _studyMaterialFile;
  Uint8List? _studyMaterialFileBytes;
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();
  String fileName = '';
  TextEditingController link = TextEditingController();

  uploadFile() async {
    var url = Uri.parse('$ipv4/addStudyMaterial');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_studyMaterialFileBytes != null) {
      var httpFile = http.MultipartFile.fromBytes(
        'studyFile',
        _studyMaterialFileBytes!,
        filename: _studyMaterialFile!.name,
      );
      req.files.add(httpFile);
    }
    req.fields.addAll({
      'schoolCode': widget.schoolCode,
      'classTitle': widget.selectedClass,
      'subject': widget.selectedSubject,
      'title': title.text.trim(),
      'description': description.text.trim(),
      'uploadDate': DateTime.now().toString(),
      'link': link.text.trim(),
    });
    var res = await req.send();
    var responded = await http.Response.fromStream(res);
    print(responded.body);
    if (responded.body == 'true') {
      if (mounted) {
        Navigator.of(context).pop();
      }
      widget.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              'Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: title,
              decoration: InputDecoration(
                hintText: 'Enter',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Description / Content',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              maxLines: 10,
              controller: description,
              decoration: InputDecoration(
                hintText: 'Write here...',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: link,
              decoration: InputDecoration(
                hintText: 'Link/URL',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    _studyMaterialFile = result!.files.first;

                    setState(() {
                      _studyMaterialFileBytes = _studyMaterialFile!.bytes;
                      fileName = _studyMaterialFile!.name;
                    });
                  },
                  child: Text('Upload file'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    fileName,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ElevatedButton(
                onPressed: uploadFile,
                child: Text('Add'),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class EditStudyMaterial extends StatefulWidget {
  const EditStudyMaterial(
      {super.key,
      required this.selectedClass,
      required this.selectedSubject,
      required this.schoolCode,
      required this.description,
      required this.fileName,
      required this.title,
      required this.index,
      required this.link,
      required this.loc,
      required this.refresh});
  final String selectedClass;
  final String selectedSubject;
  final String schoolCode;
  final int index;
  final String description;
  final String title;
  final String fileName;
  final String link;
  final String loc;

  final VoidCallback refresh;
  @override
  State<EditStudyMaterial> createState() => _EditStudyMaterialState();
}

class _EditStudyMaterialState extends State<EditStudyMaterial> {
  PlatformFile? _studyMaterialFile;
  Uint8List? _studyMaterialFileBytes;
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();
  String fileName = '';
  TextEditingController link = TextEditingController();
  late int index;

  uploadFile() async {
    var url = Uri.parse('$ipv4/editStudyMaterial');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_studyMaterialFile != null) {
      var httpFile = http.MultipartFile.fromBytes(
        'studyFile',
        _studyMaterialFileBytes!,
        filename: _studyMaterialFile!.name,
      );
      req.files.add(httpFile);
    }
    req.fields.addAll({
      'schoolCode': widget.schoolCode,
      'classTitle': widget.selectedClass,
      'subject': widget.selectedSubject,
      'title': title.text.trim(),
      'description': description.text.trim(),
      'uploadDate': DateTime.now().toString(),
      'link': link.text.trim(),
      'index': index.toString(),
      'loc': widget.loc,
      'fname': fileName,
    });
    var res = await req.send();
    var responded = await http.Response.fromStream(res);
    print(responded.body);
    if (responded.body == 'true') {
      if (mounted) {
        Navigator.of(context).pop();
      }
      widget.refresh();
    }
  }

  @override
  void initState() {
    title.text = widget.title;
    description.text = widget.description;
    link.text = widget.link;
    fileName = widget.fileName;
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              'Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: title,
              decoration: InputDecoration(
                hintText: 'Enter',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Description / Content',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              maxLines: 10,
              controller: description,
              decoration: InputDecoration(
                hintText: 'Write here...',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: link,
              decoration: InputDecoration(
                hintText: 'Link/URL',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    _studyMaterialFile = result!.files.first;

                    setState(() {
                      _studyMaterialFileBytes = _studyMaterialFile!.bytes;
                      fileName = _studyMaterialFile!.name;
                    });
                  },
                  child: Text('Upload file'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    fileName,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: ElevatedButton(
                onPressed: uploadFile,
                child: Text('Save'),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
