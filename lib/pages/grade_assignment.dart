import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';

class GradeAssignment extends StatefulWidget {
  const GradeAssignment({super.key});

  @override
  State<GradeAssignment> createState() => _GradeAssignmentState();
}

class _GradeAssignmentState extends State<GradeAssignment> {
  List sessions =
      List.generate(20, (index) => '${2020 + index}-${20 + index + 1}');
  String? selectedSession;
  String? selectedClass;
  late String schoolCode;
  List classes = [];
  late Future _getReport;
  List gradeFields = [];
  Map grades = {};
  Map dropOptions = {};

  List students = [];
  bool? autoFillRemark = false;
  List defaultRemarks = [
    'Excellent! Keep it up',
    'is able to find creative and constructive to solutions and problems and issues',
    'has rich imaginationand is able to think out of the box',
    'is independent in thinking',
    'has fluency in expression',
    'can make independent judgement in critical matters',
    'examins the problem closely',
    'listens carefully and gives feedback',
    'tries to find out alternatives and solutions',
    'questions relevantly'
  ];

  getSession() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getCurrentSession');
    var res = await client.get(url);

    var data = jsonDecode(res.body);
    setState(() {
      selectedSession =
          data['selectedSession'] == '' ? null : data['selectedSession'];
    });
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    List cl = jsonDecode(res.body);
    schoolCode = cl.last['schoolCode'];

    cl.removeLast();

    getSession();
    classes = cl;

    getGrades();
  }

  getGrades() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getGrades');

    var res = await client.get(url);

    var data = jsonDecode(res.body);
    grades = data['grades'];
    gradeFields = data['gradeFields'];
    for (String a in gradeFields) {
      if (grades[a]['groups'].isNotEmpty) {
        dropOptions[a] =
            grades[a]['grades'].map((e) => e['gradeName']).toList();
      }
    }
  }

  getReportDetails() async {
    var client = BrowserClient()..withCredentials = true;

    var url =
        Uri.parse('$ipv4/getReportCardDetails/$selectedSession/$selectedClass');
    var res = await client.get(url);

    var data = jsonDecode(res.body);

    return data;
  }

  addReportDetails() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/addReportCardDetails');
    var res = await client.post(url, body: {
      'students': jsonEncode(students),
      'session': selectedSession,
      'schoolCode': schoolCode,
    });
    print(res.body);
    if (res.body == 'true') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            content: const Row(
              children: [
                Text(
                  'Updated Successfully ',
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        title: Text('Marks Management'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session',
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
                            value: selectedSession,
                            isDense: true,
                            isExpanded: true,
                            underline: Text(''),
                            hint: Text('Select Session'),
                            items: sessions
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSession = value.toString();
                                if (selectedClass != null) {
                                  _getReport = getReportDetails();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
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
                            isDense: true,
                            isExpanded: true,
                            underline: Text(''),
                            hint: Text('Select Class'),
                            items: classes
                                .map((e) => DropdownMenuItem(
                                    value: e['title'], child: Text(e['title'])))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedClass = value.toString();
                                if (selectedSession != null) {
                                  _getReport = getReportDetails();
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
                height: 20,
              ),
              if (selectedClass != null && selectedSession != null)
                FutureBuilder(
                  future: _getReport,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      students = snapshot.data;

                      return Column(
                        children: [
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
                                    children: [
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Adm No.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Student Name',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Father Name',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Field / Grade',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Remark',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Checkbox(
                                                value: autoFillRemark,
                                                onChanged: (value) {
                                                  if (value!) {
                                                    Random random = Random();
                                                    for (int i = 0;
                                                        i < students.length;
                                                        i++) {
                                                      int randomIndex =
                                                          random.nextInt(
                                                              defaultRemarks
                                                                  .length);
                                                      students[i]['remark'] =
                                                          defaultRemarks[
                                                              randomIndex];
                                                    }
                                                  } else {
                                                    for (int i = 0;
                                                        i < students.length;
                                                        i++) {
                                                      students[i]['remark'] =
                                                          '';
                                                    }
                                                  }
                                                  setState(() {
                                                    autoFillRemark = value;
                                                  });
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                                for (int s = 0; s < students.length; s++)
                                  TableRow(
                                    children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            students[s]['admNo'],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            students[s]['fullName'],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            students[s]['fatherName'],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                for (String a in gradeFields)
                                                  if (grades[a]['groups']
                                                      .isNotEmpty)
                                                    for (String i in grades[a]
                                                        ['groups'])
                                                      Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                              width: 150,
                                                              child: Text(i
                                                                  .toString())),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 3),
                                                            width: 75,
                                                            decoration: BoxDecoration(
                                                                border: Border
                                                                    .all(),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                            child:
                                                                DropdownButton(
                                                              // borderRadius: BorderRadius.circular(10),
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 3),
                                                              value: students[s]
                                                                      .containsKey(
                                                                          'reportDetails')
                                                                  ? students[s][
                                                                      'reportDetails'][i]
                                                                  : null,
                                                              isDense: true,
                                                              isExpanded: true,
                                                              underline:
                                                                  Text(''),
                                                              hint:
                                                                  Text('Grade'),
                                                              items: dropOptions[a].map<
                                                                  DropdownMenuItem<
                                                                      String>>((e) {
                                                                return DropdownMenuItem(
                                                                    value: e
                                                                        .toString(),
                                                                    child: Text(
                                                                        e.toString()));
                                                              }).toList(),
                                                              onChanged:
                                                                  (value) {
                                                                if (!students[s]
                                                                    .containsKey(
                                                                        'reportDetails')) {
                                                                  students[s]
                                                                      .addAll({
                                                                    'reportDetails':
                                                                        {}
                                                                  });
                                                                }
                                                                setState(() {
                                                                  students[s][
                                                                          'reportDetails']
                                                                      [
                                                                      i] = value;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            )),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 100,
                                            height: 40,
                                            child: TextField(
                                              onChanged: (value) {
                                                students[s]['remark'] = value;
                                              },
                                              controller: TextEditingController(
                                                  text: students[s]['remark']),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 6),
                                                  isDense: true,
                                                  border: OutlineInputBorder(),
                                                  hintText: 'Remark'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                              onPressed: addReportDetails, child: Text('Save'))
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
