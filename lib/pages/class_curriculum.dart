import 'dart:convert';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';
import 'study_material_management.dart';

class ClassCurriculum extends StatelessWidget {
  const ClassCurriculum({super.key});

  // getClasses() async {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: AppBar(
            bottom: TabBar(
                indicatorColor: Colors.white,
                indicator: UnderlineTabIndicator(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(width: 4, color: Colors.white)),
                padding: EdgeInsets.only(left: 12),
                tabs: [
                  Tab(child: Text('Homework')),
                  Tab(child: Text('Study Material')),
                  Tab(child: Text('Syllabus'))
                ]),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            // elevation: 0,
            backgroundColor: Colors.indigo[900],
            title: Text('Class Curriculum'),
          ),
        ),
        body: TabBarView(children: [Homeworks(), StudyMaterials(), Syllabus()]),
      ),
    );
  }
}

class Syllabus extends StatefulWidget {
  const Syllabus({super.key});

  @override
  State<Syllabus> createState() => _SyllabusState();
}

class _SyllabusState extends State<Syllabus> {
  late String schoolCode;
  late Future _syllabus;
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

  getSyllabus() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getsyllabus/$selectedClass/$selectedSubject');

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

  deleteSyllabus(int index) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/deleteSyllabus');

    var res = await client.post(url, body: {
      'classTitle': selectedClass,
      'subject': selectedSubject,
      'index': index.toString(),
      'schoolCode': schoolCode
    });

    if (res.body == 'true') {
      print(true);
      setState(() {
        _syllabus = getSyllabus();
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
    return Column(
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
                            _syllabus = getSyllabus();
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
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          // _attendanceData = getAttendace();
                          selectedSubject = value.toString();
                          if (selectedSubject != null) {
                            _syllabus = getSyllabus();
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
            future: _syllabus,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List syllabus = snapshot.data;

                if (searchText != '') {
                  syllabus = syllabus
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
                                      borderRadius: BorderRadius.circular(20)),
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
                            builder: (context) => AddSyllabus(
                              selectedClass: selectedClass!,
                              selectedSubject: selectedSubject!,
                              schoolCode: schoolCode,
                              refresh: () {
                                setState(() {
                                  _syllabus = getSyllabus();
                                });
                              },
                            ),
                          ),
                          icon: Icon(Icons.add_rounded),
                          label: Text('Add New syllabus'),
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
                            verticalInside: BorderSide(),
                          ),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  TableCell(
                                      child: Text(
                                    'Upload Date',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  TableCell(
                                      child: Text(
                                    'Action',
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                                ]),
                            for (int i = syllabus.length - 1; i >= 0; i--)
                              TableRow(children: [
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(syllabus[i]['title']),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(syllabus[i]['description']),
                                )),
                                TableCell(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    DateFormat('dd-MM-yyyy h:mma').format(
                                        DateTime.parse(
                                            syllabus[i]['uploadDate'])),
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
                                      if (syllabus[i]["loc"] != "")
                                        TextButton(
                                          onPressed: () => downloadFile(
                                              syllabus[i]["loc"],
                                              syllabus[i]['fname']),
                                          child: Icon(Icons
                                              .download_for_offline_outlined),
                                        ),
                                      TextButton(
                                        onPressed: () => deleteSyllabus(i),
                                        child: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () => showModalBottomSheet(
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(20),
                                                            topRight:
                                                                Radius.circular(
                                                                    20))),
                                                context: context,
                                                builder: (context) =>
                                                    EditSyllabus(
                                                  selectedClass: selectedClass!,
                                                  selectedSubject:
                                                      selectedSubject!,
                                                  schoolCode: schoolCode,
                                                  title: syllabus[i]['title'],
                                                  description: syllabus[i]
                                                      ['description'],
                                                  fileName: syllabus[i]
                                                      ['fname'],
                                                  index: i,
                                                  loc: syllabus[i]['loc'],
                                                  refresh: () {
                                                    setState(() {
                                                      _syllabus = getSyllabus();
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
    );
  }
}

class EditSyllabus extends StatefulWidget {
  const EditSyllabus(
      {super.key,
      required this.selectedClass,
      required this.selectedSubject,
      required this.schoolCode,
      required this.description,
      required this.fileName,
      required this.title,
      required this.index,
      required this.loc,
      required this.refresh});
  final String selectedClass;
  final String selectedSubject;
  final String schoolCode;
  final int index;
  final String description;
  final String title;
  final String fileName;

  final String loc;
  final VoidCallback refresh;

  @override
  State<EditSyllabus> createState() => _EditSyllabusState();
}

class _EditSyllabusState extends State<EditSyllabus> {
  PlatformFile? _syllabusFile;
  Uint8List? _syllabusBytes;
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();
  late int index;
  String fileName = '';

  uploadFile() async {
    var url = Uri.parse('$ipv4/editSyllabus');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_syllabusFile != null) {
      var httpFile = http.MultipartFile.fromBytes(
        'syllabus',
        _syllabusBytes!,
        filename: _syllabusFile!.name,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    _syllabusFile = result!.files.first;

                    setState(() {
                      _syllabusBytes = _syllabusFile!.bytes;
                      fileName = _syllabusFile!.name;
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

class AddSyllabus extends StatefulWidget {
  const AddSyllabus(
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
  State<AddSyllabus> createState() => _AddSyllabusState();
}

class _AddSyllabusState extends State<AddSyllabus> {
  PlatformFile? _syllabusFile;
  Uint8List? _syllabusBytes;
  TextEditingController description = TextEditingController();
  TextEditingController title = TextEditingController();
  String fileName = '';

  uploadFile() async {
    var url = Uri.parse('$ipv4/addSyllabus');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_syllabusBytes != null) {
      var httpFile = http.MultipartFile.fromBytes(
        'syllabus',
        _syllabusBytes!,
        filename: _syllabusFile!.name,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    _syllabusFile = result!.files.first;

                    setState(() {
                      _syllabusBytes = _syllabusFile!.bytes;
                      fileName = _syllabusFile!.name;
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

class Homeworks extends StatefulWidget {
  const Homeworks({
    super.key,
  });

  @override
  State<Homeworks> createState() => _HomeworksState();
}

class _HomeworksState extends State<Homeworks> {
  late Future _hws;
  List classes = [];
  List subjects = [];
  String? selectedClass;
  String? selectedSubject;
  late List studentsHomework;
  late List students;
  List filter = [];
  bool _loaded = false;
  late String schoolCode;
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

  getHomeworks() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getHomeworks/$selectedClass/$selectedSubject');

    var res = await client.get(url);
    print("objectlllllll");
    print(res.body);
    List homeworks = jsonDecode(res.body);

    studentsHomework = List.generate(homeworks.length, (index) => []);

    return homeworks;
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

  deleteHomework(int index) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/deleteHomework');

    var res = await client.post(url, body: {
      'classTitle': selectedClass,
      'subject': selectedSubject,
      'index': index.toString(),
      'schoolCode': schoolCode
    });

    if (res.body == 'true') {
      print(true);
      setState(() {
        _hws = getHomeworks();
      });
    }
  }

  getstudentsHomework(String hid) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getstudentsHomework/$selectedClass/$hid');

    var res = await client.get(url);
    print('helllllo');
    print(res.body);
    return jsonDecode(res.body);
  }

  @override
  void initState() {
    getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                                _hws = getHomeworks();
                              }
                              // _attendanceData = getAttendace();
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
                              if (selectedClass != null) {
                                _hws = getHomeworks();
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
            SizedBox(
              height: 10,
            ),
            if (selectedClass != null && selectedSubject != null)
              FutureBuilder(
                future: _hws,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List homeworks = snapshot.data;
                    if (searchText != '') {
                      homeworks = homeworks
                          .where((element) =>
                              element['title']
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()) ||
                              DateFormat('dd-MM-yyyy')
                                  .format(DateTime.parse(element['dueDate']))
                                  .contains(searchText))
                          .toList();
                    }
                    return Column(children: [
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
                              builder: (context) => AddHomework(
                                selectedClass: selectedClass!,
                                selectedSubject: selectedSubject!,
                                schoolCode: schoolCode,
                                refresh: () {
                                  setState(() {
                                    _hws = getHomeworks();
                                  });
                                },
                              ),
                            ),
                            icon: Icon(Icons.add_rounded),
                            label: Text('Add New Homework'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (int i = (homeworks.length - 1); i >= 0; i--)
                        Card(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ExpansionTile(
                                  childrenPadding: EdgeInsets.all(20),
                                  expandedAlignment: Alignment.centerLeft,
                                  onExpansionChanged: (value) async {
                                    if (value == true) {
                                      studentsHomework[i] =
                                          await getstudentsHomework(
                                              homeworks[i]['hid']) as List;
                                      students = studentsHomework[i];
                                      filter = studentsHomework[i];
                                      setState(() {
                                        _loaded = true;
                                      });
                                      print(studentsHomework);
                                    }
                                  },
                                  title: Row(
                                    children: [
                                      Text(
                                        homeworks[i]['title'],
                                        // style: TextStyle(
                                        //     fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      if (homeworks[i]['dueDate'] != "null")
                                        Text(
                                          'Due Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeworks[i]['dueDate']))}',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    'Uploaded on: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(homeworks[i]['uploadDate']))}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  children: [
                                    _loaded
                                        ? Wrap(
                                            runSpacing: 10,
                                            children: [
                                              SizedBox(
                                                  width: 300,
                                                  child: Text(
                                                      'Description:\n${homeworks[i]['description']}')),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(
                                                    width: 250,
                                                    child: TextField(
                                                        decoration: InputDecoration(
                                                            border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            hintText:
                                                                'Search Student',
                                                            isDense: true,
                                                            prefixIcon: Icon(
                                                                Icons.search)),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            students = filter
                                                                .where((element) => element[
                                                                        'fullName']
                                                                    .toLowerCase()
                                                                    .contains(value
                                                                        .toLowerCase()))
                                                                .toList();
                                                            print(students);
                                                          });
                                                        }
                                                        // searchFunction(value),
                                                        ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Table(
                                                          defaultVerticalAlignment:
                                                              TableCellVerticalAlignment
                                                                  .middle,
                                                          border: const TableBorder(
                                                              verticalInside:
                                                                  BorderSide(),
                                                              horizontalInside:
                                                                  BorderSide()),
                                                          children: [
                                                            TableRow(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color: Colors
                                                                        .orange
                                                                        .shade50),
                                                                children: [
                                                                  TableCell(
                                                                      child:
                                                                          Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      'Name',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  )),
                                                                  TableCell(
                                                                      child:
                                                                          Text(
                                                                    'Download Date',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                  TableCell(
                                                                      child:
                                                                          Text(
                                                                    'Upload Date',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                  TableCell(
                                                                      child:
                                                                          Text(
                                                                    'Action',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ))
                                                                ]),
                                                            for (int j = 0;
                                                                j <
                                                                    students
                                                                        .length;
                                                                j++)
                                                              TableRow(
                                                                children: [
                                                                  TableCell(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        students[j]
                                                                            [
                                                                            'fullName'],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  TableCell(
                                                                      child: Text(
                                                                          '')),
                                                                  TableCell(
                                                                      child: students[j].containsKey(homeworks[i]['hid'])
                                                                          ? Text(students[j]['hid']
                                                                              [
                                                                              'uploadDate'])
                                                                          : Text(
                                                                              '')),
                                                                  TableCell(
                                                                    child: students[j].containsKey(homeworks[i]
                                                                            [
                                                                            'hid'])
                                                                        ? Container(
                                                                            margin:
                                                                                EdgeInsets.all(8),
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 2),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(3), color: Colors.indigo),
                                                                            child: Icon(
                                                                                color: Colors.white,
                                                                                size: 12,
                                                                                Icons.file_download_rounded),
                                                                          )
                                                                        : SizedBox(
                                                                            width:
                                                                                20,
                                                                          ),
                                                                  )
                                                                ],
                                                              ),
                                                          ]),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : CircularProgressIndicator()
                                  ],
                                ),
                              ),
                              PopupMenuButton(
                                padding: EdgeInsets.only(top: 20),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 1, child: Text('Download')),
                                  PopupMenuItem(value: 2, child: Text('Edit')),
                                  PopupMenuItem(
                                      value: 3, child: Text('Delete')),
                                ],
                                onSelected: (value) {
                                  if (value == 1) {
                                    if (homeworks[i]['loc'] == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red[600],
                                          behavior: SnackBarBehavior.floating,
                                          content: const Row(
                                            children: [
                                              Text(
                                                'No file to Download ',
                                              ),
                                              Icon(
                                                Icons.error,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      downloadFile(homeworks[i]['loc'],
                                          homeworks[i]['fname']);
                                    }
                                  }
                                  if (value == 2) {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      context: context,
                                      builder: (context) => EditHomework(
                                        selectedClass: selectedClass!,
                                        selectedSubject: selectedSubject!,
                                        schoolCode: schoolCode,
                                        title: homeworks[i]['title'],
                                        description: homeworks[i]
                                            ['description'],
                                        fileName: homeworks[i]['fname'],
                                        index: i,
                                        dueDate: homeworks[i]['dueDate'],
                                        loc: homeworks[i]['loc'],
                                        refresh: () {
                                          setState(() {
                                            _hws = getHomeworks();
                                          });
                                        },
                                      ),
                                    );
                                  }
                                  if (value == 3) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Confirm Deletion'),
                                        content: Text(
                                            'Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              deleteHomework(i);
                                              Navigator.pop(context);
                                            },
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                    ]);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}

class EditHomework extends StatefulWidget {
  const EditHomework(
      {super.key,
      required this.selectedClass,
      required this.selectedSubject,
      required this.schoolCode,
      required this.description,
      required this.fileName,
      required this.title,
      required this.index,
      required this.dueDate,
      required this.loc,
      required this.refresh});
  final String selectedClass;
  final String selectedSubject;
  final String schoolCode;
  final int index;
  final String description;
  final String title;
  final String fileName;
  final String dueDate;

  final String loc;

  final VoidCallback refresh;
  @override
  State<EditHomework> createState() => _EditHomeworkState();
}

class _EditHomeworkState extends State<EditHomework> {
  DateTime? _selectedDate;
  PlatformFile? _homeworkFile;
  Uint8List? _homeworkFileBytes;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  String fileName = '';
  late int index;

  addHomework() async {
    var url = Uri.parse('$ipv4/editHomework');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_homeworkFile != null) {
      var httpFile = http.MultipartFile.fromBytes(
        'homework',
        _homeworkFileBytes!,
        filename: _homeworkFile!.name,
      );
      req.files.add(httpFile);
    }

    req.fields.addAll({
      'subject': widget.selectedSubject,
      'classTitle': widget.selectedClass,
      'schoolCode': widget.schoolCode,
      'title': title.text.trim(),
      'dueDate': _selectedDate.toString(),
      'description': description.text.trim(),
      'uploadDate': DateTime.now().toString(),
      'index': index.toString(),
      'loc': widget.loc,
      'fname': fileName,
    });
    var res = await req.send();
    var responded = await http.Response.fromStream(res);

    if (responded.body == 'true') {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
    widget.refresh();
  }

  @override
  void initState() {
    title.text = widget.title;
    description.text = widget.description;
    _selectedDate = DateTime.parse(widget.dueDate);
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Due Date  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.text,
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                          // helpText: 'dada',
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          currentDate: _selectedDate,
                          lastDate: DateTime(DateTime.now().year + 2));
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: SizedBox(
                        width: 100,
                        child: InputDecorator(
                          decoration: InputDecoration(isDense: true),
                          child: _selectedDate == null
                              ? Text('Date',
                                  style: TextStyle(color: Colors.grey.shade600))
                              : Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(_selectedDate!),
                                ),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    _homeworkFile = result!.files.first;

                    setState(() {
                      fileName = _homeworkFile!.name;
                      _homeworkFileBytes = _homeworkFile!.bytes;
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
                onPressed: addHomework,
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

class AddHomework extends StatefulWidget {
  const AddHomework(
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
  State<AddHomework> createState() => _AddHomeworkState();
}

class _AddHomeworkState extends State<AddHomework> {
  DateTime? _selectedDate;
  PlatformFile? _homeworkFile;
  Uint8List? _homeworkFileBytes;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  String fileName = '';

  addHomework() async {
    var url = Uri.parse('$ipv4/addHomework');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_homeworkFileBytes != null) {
      var httpFile = http.MultipartFile.fromBytes(
        'homework',
        _homeworkFileBytes!,
        filename: _homeworkFile!.name,
      );
      req.files.add(httpFile);
    }

    req.fields.addAll({
      'subject': widget.selectedSubject,
      'classTitle': widget.selectedClass,
      'schoolCode': widget.schoolCode,
      'title': title.text.trim(),
      'dueDate': _selectedDate.toString(),
      'description': description.text.trim(),
      'uploadDate': DateTime.now().toString()
    });
    var res = await req.send();
    var responded = await http.Response.fromStream(res);

    if (responded.body == 'true') {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
    widget.refresh();
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Due Date  ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.text,
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                          // helpText: 'dada',
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          currentDate: _selectedDate,
                          lastDate: DateTime(DateTime.now().year + 2));
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: SizedBox(
                        width: 100,
                        child: InputDecorator(
                          decoration: InputDecoration(isDense: true),
                          child: _selectedDate == null
                              ? Text('Date',
                                  style: TextStyle(color: Colors.grey.shade600))
                              : Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(_selectedDate!),
                                ),
                        )),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    _homeworkFile = result!.files.first;

                    setState(() {
                      fileName = _homeworkFile!.name;
                      _homeworkFileBytes = _homeworkFile!.bytes;
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
                onPressed: addHomework,
                child: Text('Post'),
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
