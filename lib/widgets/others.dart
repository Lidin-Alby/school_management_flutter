import 'dart:convert';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';

class AddResult extends StatefulWidget {
  const AddResult({super.key});

  @override
  State<AddResult> createState() => _AddResultState();
}

class _AddResultState extends State<AddResult> {
  late Future _classes;
  int _selectedIndex = 0;
  String? selectedClass;
  String? selectedSubject;
  late double height;
  List buttons = ['HomeWork', 'Study Material', 'Remarks', 'Add Marks'];
  List subjects = [];

  getClasses() async {
    var client = BrowserClient()..withCredentials = true;
    var url1 = Uri.parse('$ipv4/getTeacherClasses');
    var res1 = await client.get(url1);
    var url2 = Uri.parse('$ipv4/getSubjects');
    var res2 = await client.get(url2);
    subjects = jsonDecode(res2.body)['subjects'];
    print(res1.body);
    return jsonDecode(res1.body);
  }

  @override
  void initState() {
    _classes = getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _classes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List classes = snapshot.data;
                height = classes.length * 82;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          //  padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border:
                                  Border.all(color: Colors.indigo, width: 2.5),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton(
                            borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.all(8),
                            value: selectedClass,
                            isDense: true,
                            underline: Text(''),
                            hint: Text('Select Class'),
                            items: classes
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedClass = value.toString();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: Colors.grey[50],
                          child: DropdownButton(
                            hint: Text('Select Subject'),
                            value: selectedSubject,
                            items: subjects
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) => setState(() {
                              selectedSubject = value.toString();
                            }),
                          ),
                        )
                      ],
                    ),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 700),
                        // color: Colors.red,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              //    crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < buttons.length; i++)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: _selectedIndex == i
                                              ? Colors.indigo
                                              : null,
                                          foregroundColor: _selectedIndex == i
                                              ? Colors.white
                                              : null),
                                      onPressed: () {
                                        setState(() {
                                          _selectedIndex = i;
                                        });
                                      },
                                      child: Text(
                                        buttons[i],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (selectedClass != null &&
                                selectedSubject != null)
                              if (_selectedIndex == 0)
                                Homeworks(
                                  classTitle: selectedClass.toString(),
                                  subject: selectedSubject.toString(),
                                ),
                            if (_selectedIndex == 1)
                              StudyMaterials(
                                classTitle: selectedClass.toString(),
                                subject: selectedSubject.toString(),
                              ),
                            if (_selectedIndex == 2)
                              Remarks(
                                classTitle: selectedClass.toString(),
                                subject: selectedSubject.toString(),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class Remarks extends StatefulWidget {
  const Remarks({
    required this.classTitle,
    required this.subject,
    super.key,
  });
  final String classTitle;
  final String subject;

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
  late String schoolCode;
  late Future _remarks;

  getRemarks() async {
    var client = BrowserClient()..withCredentials = true;
    var url =
        Uri.parse('$ipv4/getRemarks/${widget.classTitle}/${widget.subject}');

    var res = await client.get(url);

    print(res.body);

    List data = jsonDecode(res.body);
    schoolCode = data.last;
    data.removeLast();
    return data;
  }

  @override
  void initState() {
    _remarks = getRemarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddRemark(
                schoolCode: schoolCode,
                subject: widget.subject,
                classTitle: widget.classTitle,
              ),
            ),
            label: Text('Give Remark'),
            icon: Icon(Icons.add_rounded),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FutureBuilder(
          future: _remarks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.isEmpty
                  ? Text('Empty')
                  : Column(
                      children: [
                        for (Map remark in snapshot.data)
                          Column(
                            children: [
                              ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(remark['fullName']),
                                ),
                                subtitle: Text(remark['content']),
                                trailing: Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(DateTime.parse(remark['date'])),
                                ),
                              ),
                              Divider()
                            ],
                          ),
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

class AddRemark extends StatefulWidget {
  const AddRemark({
    required this.classTitle,
    required this.subject,
    required this.schoolCode,
    super.key,
  });
  final String classTitle;
  final String subject;
  final String schoolCode;

  @override
  State<AddRemark> createState() => _AddRemarkState();
}

class _AddRemarkState extends State<AddRemark> {
  List students = [];
  String? selectedStudent;
  TextEditingController remarkController = TextEditingController();
  String? fullName;

  getClassStudents() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassStudents/${widget.classTitle}');

    var res = await client.get(url);

    print(res.body);

    setState(() {
      students = jsonDecode(res.body);
    });
  }

  addRemarks() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addRemark');

    var res = await client.post(url, body: {
      'schoolCode': widget.schoolCode,
      'subject': widget.subject,
      'classTitle': widget.classTitle,
      'date': DateTime.now().toString(),
      'content': remarkController.text,
      'admNo': selectedStudent,
      'fullName': fullName
    });

    print(res.body);
  }

  @override
  void initState() {
    getClassStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 500,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton(
                    isDense: true,
                    hint: Text('Select Student'),
                    value: selectedStudent,
                    items: students.map((e) {
                      return DropdownMenuItem(
                        child: Text(e['fullName']),
                        value: e['admNo'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      for (Map e in students) {
                        if (e['admNo'] == value) {
                          fullName = e['fullName'];
                        }
                      }
                      setState(() {
                        print(fullName);
                        selectedStudent = value.toString();
                      });
                    }),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Remark:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 10,
                  controller: remarkController,
                  decoration: InputDecoration(
                      hintText: 'Write your remark here...',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ElevatedButton(
                        onPressed: addRemarks, child: Text('Submit')))
              ]),
        ),
      ),
    );
  }
}

class StudyMaterials extends StatefulWidget {
  const StudyMaterials({
    required this.classTitle,
    required this.subject,
    super.key,
  });
  final String classTitle;
  final String subject;

  @override
  State<StudyMaterials> createState() => _StudyMaterialsState();
}

class _StudyMaterialsState extends State<StudyMaterials> {
  PlatformFile? _studyMaterialFile;
  Uint8List? _studyMaterialFileBytes;
  late String schoolCode;
  late Future _documents;

  getStudyMaterials() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.https(
        ipv4, '/getstudyMaterials/${widget.classTitle}/${widget.subject}');

    var res = await client.get(url);

    print(res.body);
    List data = jsonDecode(res.body);
    schoolCode = data.last;
    data.removeLast();
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
      ext: 'pdf',
      mimeType: MimeType.pdf,
    );
  }

  uploadFile() async {
    var url = Uri.parse('$ipv4/addStudyMaterial');

    var req = http.MultipartRequest(
      'POST',
      url,
    );

    {
      var httpFile = http.MultipartFile.fromBytes(
        'studyFile',
        _studyMaterialFileBytes!,
        filename: _studyMaterialFile!.name,
      );
      req.files.add(httpFile);
    }
    req.fields.addAll({
      'schoolCode': schoolCode,
      'classTitle': widget.classTitle,
      'subject': widget.subject
    });
    var res = await req.send();
    var responded = await http.Response.fromStream(res);
    print(responded.body);
  }

  @override
  void initState() {
    _documents = getStudyMaterials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: OutlinedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              _studyMaterialFile = result!.files.first;

              setState(() {
                _studyMaterialFileBytes = _studyMaterialFile!.bytes;
              });
              uploadFile();
            },
            child: Text('Upload file'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.black),
            ),
          ),
        ),
        FutureBuilder(
          future: _documents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Wrap(
                children: [
                  for (Map doc in snapshot.data)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: SizedBox(
                        width: 160,
                        height: 190,
                        child: Material(
                          //   padding: EdgeInsets.fromLTRB(8, 8, 8, 0),

                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                width: 150,
                                height: 125,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(
                                  Icons.description_outlined,
                                  color: Colors.red[600],
                                  size: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 8, 0, 3),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 110,
                                          child: Tooltip(
                                            message: doc['fname'],
                                            child: Text(
                                              doc['fname'],
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ),
                                        Text('5.2 MB',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12))
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                        color: Colors.grey[700],
                                        padding: EdgeInsets.zero,
                                        iconSize: 28,
                                        splashRadius: 18,
                                        onPressed: () => downloadFile(
                                            doc['loc'], doc['fname']),
                                        icon: Icon(Icons
                                            .download_for_offline_outlined))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}

class Homeworks extends StatefulWidget {
  const Homeworks({
    required this.classTitle,
    required this.subject,
    super.key,
  });
  final String classTitle;
  final String subject;
  @override
  State<Homeworks> createState() => _HomeworksState();
}

class _HomeworksState extends State<Homeworks> {
  late Future _hws;
  // late Future _studentsHomework;
  //late List<bool> _isOpen;
  late List studentsHomework;
  bool _loaded = false;
  getHomeworks() async {
    var client = BrowserClient()..withCredentials = true;
    var url =
        Uri.parse('$ipv4/getHomeworks/${widget.classTitle}/${widget.subject}');

    var res = await client.get(url);
    print(res.body);
    List homeworks = jsonDecode(res.body);

    studentsHomework = List.generate(homeworks.length, (index) => []);

    return homeworks;
  }

  getstudentsHomework(String hid) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getstudentsHomework/${widget.classTitle}/$hid');

    var res = await client.get(url);
    print(res.body);
    return jsonDecode(res.body);
  }

  @override
  void initState() {
    _hws = getHomeworks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddHomework(),
                  ),
              child: Icon(Icons.add_rounded)),
        ),
        SizedBox(
          height: 30,
        ),
        FutureBuilder(
            future: _hws,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List homeworks = snapshot.data;

                return Column(children: [
                  for (int i = 0; i < homeworks.length; i++)
                    ExpansionTile(
                      childrenPadding: EdgeInsets.all(20),
                      expandedAlignment: Alignment.centerLeft,
                      onExpansionChanged: (value) async {
                        if (value == true) {
                          studentsHomework[i] =
                              await getstudentsHomework(homeworks[i]['hid']);
                          setState(() {
                            _loaded = true;
                          });
                        }
                      },
                      title: Row(
                        children: [
                          Text(homeworks[i]['title']),
                          Spacer(),
                          Text('Due Date')
                        ],
                      ),

                      // trailing: Text('dueDate'),
                      children: [
                        _loaded
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (Map j in studentsHomework[i])
                                      Container(
                                        // height: 40,
                                        decoration: BoxDecoration(
                                            border: Border(
                                          bottom:
                                              BorderSide(color: Colors.grey),
                                        )),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.grey))),
                                              child: Text(j['fullName']),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 85),
                                              width: 200,
                                              child: InkWell(
                                                onTap: () {},
                                                child: j.containsKey(
                                                        homeworks[i]['hid'])
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        3),
                                                            color:
                                                                Colors.indigo),
                                                        child: Icon(
                                                            color: Colors.white,
                                                            size: 12,
                                                            Icons
                                                                .file_download_rounded),
                                                      )
                                                    : SizedBox(
                                                        width: 20,
                                                      ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : CircularProgressIndicator()
                      ],
                    ),
                ]);
              } else {
                return SizedBox();
              }
            }),
      ],
    );
  }
}

class AddHomework extends StatefulWidget {
  const AddHomework({
    super.key,
  });

  @override
  State<AddHomework> createState() => _AddHomeworkState();
}

class _AddHomeworkState extends State<AddHomework> {
  DateTime? _selectedDate;
  PlatformFile? _homeworkFile;
  Uint8List? _homeworkFileBytes;
  TextEditingController title = TextEditingController();
  String fileName = '';

  addHomework() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addHomework');

    var res = await client.post(url, body: {
      'subject': 'English',
      'classTitle': 'Class 3-A',
      'title': 'Homework 4'
    });
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
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
                                    style:
                                        TextStyle(color: Colors.grey.shade600))
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
                      onPressed: addHomework, child: Text('Post')))
            ],
          ),
        ),
      ),
    );
  }
}
