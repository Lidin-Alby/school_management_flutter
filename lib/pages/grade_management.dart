import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/widgets/textfield_widget.dart';

import '../ip_address.dart';

class GradeManagement extends StatefulWidget {
  const GradeManagement({super.key});

  @override
  State<GradeManagement> createState() => _GradeManagementState();
}

class _GradeManagementState extends State<GradeManagement> {
  late String schoolCode;
  late Future _getGrades;
  List gradeFields = [];

  getGrades() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getGrades');

    var res = await client.get(url);
    print(res.body);
    var data = jsonDecode(res.body);
    schoolCode = data['schoolCode'].toString();
    return data;
  }

  addGradeField(String f) async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/addGradeField');

    var res =
        await client.post(url, body: {'schoolCode': schoolCode, 'field': f});
    print(res.body);
  }

  removeGradeField(String f) async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/removeGradeField');

    var res =
        await client.post(url, body: {'schoolCode': schoolCode, 'field': f});
    print(res.body);
  }

  @override
  void initState() {
    _getGrades = getGrades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
          backgroundColor: Colors.indigo[900],
          title: Text('Exam Management'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: FutureBuilder(
              future: _getGrades,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Map data = snapshot.data;
                  Map grades = {};
                  if (data.containsKey('grades')) {
                    grades = snapshot.data['grades'];
                  }
                  gradeFields = data['gradeFields'];

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton.icon(
                          onPressed: () => showModalBottomSheet(
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (context) => AddOrEditGrade(
                              groups: [],
                              grades: [],
                              schoolCode: schoolCode,
                              refresh: () {
                                setState(() {
                                  _getGrades = getGrades();
                                });
                              },
                            ),
                          ),
                          icon: Icon(Icons.add),
                          label: Text('New Grade System'),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var k in grades.keys)
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text(
                                k,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () => showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) => AddOrEditGrade(
                                    examType: k,
                                    grades: grades[k]['grades'],
                                    groups: grades[k]['groups'],
                                    schoolCode: schoolCode,
                                    refresh: () {
                                      setState(() {
                                        _getGrades = getGrades();
                                      });
                                    },
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                              Switch(
                                activeColor: Colors.green,
                                value: gradeFields.contains(k),
                                onChanged: (value) {
                                  setState(() {
                                    if (value) {
                                      // gradeFields.add(k);
                                      addGradeField(k);
                                      _getGrades = getGrades();
                                    } else {
                                      // gradeFields.remove(k);
                                      removeGradeField(k);
                                      _getGrades = getGrades();
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                          initiallyExpanded: true,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Wrap(
                                  children: [
                                    for (int i = 0;
                                        i < grades[k]['groups'].length;
                                        i++)
                                      Text(grades[k]['groups'][i] + '   |   '),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 700,
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Table(
                                // border: TableBorder(
                                //   horizontalInside: BorderSide(),
                                //   verticalInside: BorderSide(),
                                // ),
                                children: [
                                  TableRow(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.orange.shade50),
                                      children: const [
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Grade',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Percentage From / Upto (%)',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                        TableCell(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Grade Point',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                      ]),
                                  for (int j = 0;
                                      j < grades[k]['grades'].length;
                                      j++)
                                    TableRow(
                                      children: [
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Center(
                                            child: Text(
                                              grades[k]['grades'][j]
                                                  ['gradeName'],
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Center(
                                              child: Text(
                                                grades[k]['grades'][j]
                                                        ['percentageFrom'] +
                                                    ' - ' +
                                                    grades[k]['grades'][j]
                                                        ['percentageUpto'],
                                              ),
                                            )),
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                grades[k]['grades'][j]
                                                    ['gradePoint'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ));
  }
}

class AddOrEditGrade extends StatefulWidget {
  const AddOrEditGrade(
      {super.key,
      required this.schoolCode,
      this.examType = '',
      required this.groups,
      required this.refresh,
      required this.grades});
  final String schoolCode;
  final String examType;
  final List grades;
  final List groups;
  final VoidCallback refresh;

  @override
  State<AddOrEditGrade> createState() => _AddOrEditGradeState();
}

class _AddOrEditGradeState extends State<AddOrEditGrade> {
  TextEditingController examType = TextEditingController();
  bool? isGroup = false;
  int count = 3;
  int fieldCount = 2;
  String oldName = '';
  List grades = [
    {
      'gradeName': TextEditingController(),
      'percentageUpto': TextEditingController(),
      'percentageFrom': TextEditingController(),
      'gradePoint': TextEditingController(),
    },
    {
      'gradeName': TextEditingController(),
      'percentageUpto': TextEditingController(),
      'percentageFrom': TextEditingController(),
      'gradePoint': TextEditingController(),
    },
    {
      'gradeName': TextEditingController(),
      'percentageUpto': TextEditingController(),
      'percentageFrom': TextEditingController(),
      'gradePoint': TextEditingController(),
    }
  ];
  List groups = [];

  addGrades() async {
    List data = List.generate(count, (index) => {});
    for (int i = 0; i < grades.length; i++) {
      data[i]['gradeName'] = grades[i]['gradeName'].text.trim();
      data[i]['percentageUpto'] = grades[i]['percentageUpto'].text.trim();
      data[i]['percentageFrom'] = grades[i]['percentageFrom'].text.trim();
      data[i]['gradePoint'] = grades[i]['gradePoint'].text.trim();
    }
    for (int i = 0; i < groups.length; i++) {
      String trim = groups[i].text.trim();
      if (trim == '') {
        groups.removeAt(i);
        i--;
      } else {
        groups[i] = groups[i].text.trim();
      }
    }
    print(groups);

    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/addGrades');

    var res = await client.post(url, body: {
      'oldName': oldName,
      'schoolCode': widget.schoolCode,
      'examType': examType.text.trim(),
      'groups': jsonEncode(groups),
      'data': jsonEncode(data)
    });

    if (res.body == 'true') {
      widget.refresh();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  initialize() {
    oldName = widget.examType;
    examType.text = widget.examType;
    if (widget.grades.isNotEmpty) {
      count = widget.grades.length;
      grades = List.generate(widget.grades.length, (index) => {});
      for (int i = 0; i < widget.grades.length; i++) {
        grades[i]['gradeName'] =
            TextEditingController(text: widget.grades[i]['gradeName']);
        grades[i]['percentageUpto'] =
            TextEditingController(text: widget.grades[i]['percentageUpto']);
        grades[i]['percentageFrom'] =
            TextEditingController(text: widget.grades[i]['percentageFrom']);
        grades[i]['gradePoint'] =
            TextEditingController(text: widget.grades[i]['gradePoint']);
      }
    }
    if (widget.groups.isNotEmpty) {
      isGroup = true;

      fieldCount = widget.groups.length;
      for (String i in widget.groups) {
        print(i);
        groups.add(TextEditingController(text: i));
      }
      print(groups);
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'New Grade Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                TextFieldWidget(
                  label: 'Grade Title',
                  controller: examType,
                  isEdit: true,
                ),
                Checkbox(
                  value: isGroup,
                  onChanged: (value) {
                    setState(() {
                      isGroup = value;
                      if (value!) {
                        groups.addAll(
                            [TextEditingController(), TextEditingController()]);
                      } else {
                        groups = [];
                      }
                    });
                  },
                ),
                Text('Divisions')
              ],
            ),
            SizedBox(
              height: 15,
            ),
            if (isGroup!)
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int j = 0; j < fieldCount; j++)
                    TextFieldWidget(
                        label: 'Field', controller: groups[j], isEdit: true),
                  ElevatedButton(
                      onPressed: () {
                        groups.add(TextEditingController());
                        setState(() {
                          fieldCount++;
                        });
                      },
                      child: Icon(Icons.add))
                ],
              ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: Table(
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
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Grade',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Percentage From',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Percentage To',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Grade Point',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ' ',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                      ]),
                  for (int i = 0; i < count; i++)
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFieldWidget(
                              label: 'Grade Name',
                              controller: grades[i]['gradeName'],
                              isEdit: true),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFieldWidget(
                              label: 'Percentage From',
                              controller: grades[i]['percentageFrom'],
                              isEdit: true),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFieldWidget(
                              label: 'Percentage Upto',
                              controller: grades[i]['percentageUpto'],
                              isEdit: true),
                        )),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFieldWidget(
                              label: 'Grade Point',
                              controller: grades[i]['gradePoint'],
                              isEdit: true,
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextButton(
                                onPressed: () {
                                  grades.removeAt(i);
                                  setState(() {
                                    count--;
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  grades.add({
                    'gradeName': TextEditingController(),
                    'percentageUpto': TextEditingController(),
                    'percentageFrom': TextEditingController(),
                    'gradePoint': TextEditingController(),
                  });
                  setState(() {
                    count++;
                  });
                },
                child: Icon(Icons.add),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: addGrades,
                child: Text(widget.grades.isEmpty ? 'Add' : 'Save'),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
