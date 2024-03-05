import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';

class MarksManagement extends StatefulWidget {
  const MarksManagement({super.key});

  @override
  State<MarksManagement> createState() => _MarksManagementState();
}

class _MarksManagementState extends State<MarksManagement> {
  List sessions =
      List.generate(20, (index) => '${2020 + index}-${20 + index + 1}');
  String? selectedClass;
  String? selectedSubject;
  String? selectedSession;
  List classes = [];
  List subjects = [];
  late Future _papers;
  String? _selectedKey;
  String? selectedPaper;
  List paperNames = [];

  List students = [];
  late String schoolCode;
  late Future _getMarks;

  getSession() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getCurrentSession');
    var res = await client.get(url);

    print(res.body);
    var data = jsonDecode(res.body);
    selectedSession =
        data['selectedSession'] == '' ? null : data['selectedSession'];
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    List cl = jsonDecode(res.body);
    schoolCode = cl.last['schoolCode'];

    getSession();
    getInstitueSubjects();
    cl.removeLast();
    classes = cl;
  }

  getInstitueSubjects() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getSubjects');
    var res = await client.get(url);

    var data = jsonDecode(res.body);
    subjects = data['subjects'];

    setState(() {});
  }

  getPaper() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getPaper/$selectedClass');
    var res = await client.get(url);

    print(res.body);
    var data = jsonDecode(res.body);
    return data;
  }

  getMarksAll() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse(
        '$ipv4/getMarksAll/$selectedClass/$selectedSession/$_selectedKey/$selectedPaper/$selectedSubject');
    var res = await client.get(url);

    print(res.body);
    var data = jsonDecode(res.body);
    return data;
  }

  addMarks() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/addMarks');
    var res = await client.post(url, body: {
      'schoolCode': schoolCode,
      'session': selectedSession,
      'term': _selectedKey,
      'paper': selectedPaper,
      'subject': selectedSubject,
      'students': jsonEncode(students)
    });

    print(res.body);
    if (res.body == 'true') {
      if (context.mounted) {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                              selectedPaper = null;
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
                              selectedPaper = null;
                              _papers = getPaper();
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
                          isDense: true,
                          isExpanded: true,
                          underline: Text(''),
                          hint: Text('Select Subject'),
                          items: subjects
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedSubject = value.toString();
                              selectedPaper = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (selectedClass != null &&
                selectedSubject != null &&
                selectedSession != null)
              FutureBuilder(
                future: _papers,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map papers = snapshot.data;
                    if (papers.isNotEmpty) {
                      papers = papers['paper'];
                    }
                    final newMap = {};
                    int index = 0;
                    papers.forEach((key, value) {
                      newMap[index] = key;
                      index++;
                    });

                    return Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ExpansionPanelList(
                                animationDuration: Duration(milliseconds: 400),
                                expandedHeaderPadding: EdgeInsets.zero,
                                expansionCallback: (panelIndex, isExpanded) {
                                  selectedPaper = null;
                                  if (_selectedKey == newMap[panelIndex]) {
                                    setState(() {
                                      _selectedKey = null;
                                    });
                                  } else {
                                    setState(() {
                                      _selectedKey = newMap[panelIndex];

                                      paperNames = papers[_selectedKey]
                                          .map((e) => e['paperName'])
                                          .toList();
                                      paperNames = paperNames.toSet().toList();
                                    });
                                  }
                                },
                                children: [
                                  for (var i in papers.keys)
                                    ExpansionPanel(
                                      canTapOnHeader: true,
                                      isExpanded: i == _selectedKey,
                                      headerBuilder: (context, isExpanded) =>
                                          ListTile(
                                        tileColor: Colors.blue[50],
                                        title: Text(i),
                                      ),
                                      body: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (_selectedKey != null)
                                              SizedBox(
                                                width: 500,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Paper',
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4)),
                                                      child: DropdownButton(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        value: selectedPaper,
                                                        isDense: true,
                                                        isExpanded: true,
                                                        underline: Text(''),
                                                        hint: Text(
                                                            'Select Paper'),
                                                        items: paperNames
                                                            .map(
                                                              (e) =>
                                                                  DropdownMenuItem(
                                                                value: e,
                                                                child: Text(e),
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedPaper =
                                                                value
                                                                    .toString();
                                                            _getMarks =
                                                                getMarksAll();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (selectedPaper != null)
                                              FutureBuilder(
                                                future: _getMarks,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    students = snapshot.data;
                                                    String maxMarks = '';

                                                    List listOfTerm =
                                                        papers[_selectedKey];
                                                    for (var item
                                                        in listOfTerm) {
                                                      if (item['paperName'] ==
                                                              selectedPaper &&
                                                          item['subject'] ==
                                                              selectedSubject) {
                                                        maxMarks =
                                                            item['maxMarks'];
                                                        break;
                                                      }
                                                    }

                                                    return Column(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              border:
                                                                  Border.all(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Table(
                                                            border: TableBorder(
                                                              horizontalInside:
                                                                  BorderSide(),
                                                              verticalInside:
                                                                  BorderSide(),
                                                            ),
                                                            children: [
                                                              TableRow(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .orange
                                                                          .shade50),
                                                                  children: const [
                                                                    TableCell(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        'Adm No.',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    )),
                                                                    TableCell(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        'Student Name',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    )),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          'Father Name',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          'Max Marks',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          'Marks',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Text(
                                                                          'Attendance',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ]),
                                                              for (int s = 0;
                                                                  s <
                                                                      students
                                                                          .length;
                                                                  s++)
                                                                TableRow(
                                                                  children: [
                                                                    TableCell(
                                                                      verticalAlignment:
                                                                          TableCellVerticalAlignment
                                                                              .middle,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        child:
                                                                            Text(
                                                                          students[s]
                                                                              [
                                                                              'admNo'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      verticalAlignment:
                                                                          TableCellVerticalAlignment
                                                                              .middle,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        child:
                                                                            Text(
                                                                          students[s]
                                                                              [
                                                                              'fullName'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      verticalAlignment:
                                                                          TableCellVerticalAlignment
                                                                              .middle,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(10),
                                                                        child:
                                                                            Text(
                                                                          students[s]
                                                                              [
                                                                              'fatherName'],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      verticalAlignment:
                                                                          TableCellVerticalAlignment
                                                                              .middle,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              40,
                                                                          child:
                                                                              Text(maxMarks),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      verticalAlignment:
                                                                          TableCellVerticalAlignment
                                                                              .middle,
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              50,
                                                                          height:
                                                                              40,
                                                                          child:
                                                                              TextField(
                                                                            onChanged:
                                                                                (value) {
                                                                              students[s]['marks'] = value;
                                                                            },
                                                                            controller:
                                                                                TextEditingController(text: students[s]['marks']),
                                                                            decoration: InputDecoration(
                                                                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                                                                isDense: true,
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Marks'),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                        verticalAlignment:
                                                                            TableCellVerticalAlignment
                                                                                .middle,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text('A'),
                                                                            Switch(
                                                                              activeColor: Colors.green,
                                                                              inactiveTrackColor: Colors.red,
                                                                              value: students[s]['attendance'] ?? true,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  students[s]['attendance'] = value;
                                                                                });
                                                                              },
                                                                            ),
                                                                            Text('P'),
                                                                          ],
                                                                        )),
                                                                  ],
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: addMarks,
                                                            child: Text('Save'))
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
                                    )
                                ],
                              )),
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
    );
  }
}

// class EditingMarkTable extends StatefulWidget {
//   const EditingMarkTable(
//       {super.key,
//       required this.selectedSubject,
//       required this.selectedSession,
//       required this.selectedPaper,
//       required this.selectedKey,
//       required this.schoolCode,
//       required this.papers,
//       required this.getMarks});
//   final String selectedPaper;
//   final String selectedSubject;
//   final String selectedKey;
//   final String selectedSession;
//   final String schoolCode;
//   final Map papers;
//   final Future getMarks;

//   @override
//   State<EditingMarkTable> createState() => _EditingMarkTableState();
// }

// class _EditingMarkTableState extends State<EditingMarkTable> {
//   late String selectedPaper;
//   late String selectedSubject;
//   late String _selectedKey;
// // late String selectedClass;
//   late String selectedSession;
//   late String schoolCode;
//   late Map papers;
//   late Future _getMarks;
//   List students = [];

  

//   @override
//   void initState() {
//     selectedPaper = widget.selectedPaper;
//     selectedSubject = widget.selectedSubject;
//     _selectedKey = widget.selectedKey;
//     selectedSession = widget.selectedSession;
//     schoolCode = widget.schoolCode;
//     papers = widget.papers;
//     _getMarks = widget.getMarks;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return 
    
//   }
// }
