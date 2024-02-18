import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/widgets/dropdown_widget.dart';
import 'package:school_management/widgets/textfield_widget.dart';

import '../ip_address.dart';

class ExamManagement extends StatefulWidget {
  const ExamManagement({super.key});

  @override
  State<ExamManagement> createState() => _ExamManagementState();
}

class _ExamManagementState extends State<ExamManagement> {
  String? selectedClass;
  List<String?> selectedSubjects = [];
  List classes = [];
  List subjects = [];
  late String schoolCode;
  late Future _getExamTerms;
  late Future _getPapers;
  bool isEdit = false;
  int nos = 3;
  int? _selectedIndex;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

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

    var data = jsonDecode(res.body);
    subjects = data['subjects'];
    setState(() {});
  }

  getExamTerms() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getExamTerms');
    var res = await client.get(url);

    var data = jsonDecode(res.body);
    return data;
  }

  getPaper() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getPaper/$selectedClass');
    var res = await client.get(url);

    print(res.body);
    var data = jsonDecode(res.body);
    return data;
  }

  deleteTerm(int index) async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/deleteTerm');

    var res = await client
        .post(url, body: {'schoolCode': schoolCode, 'index': index.toString()});
    if (res.body == 'true') {
      setState(() {
        _getExamTerms = getExamTerms();
      });
    }
  }

  @override
  void initState() {
    getClass();
    _getExamTerms = getExamTerms();
    selectedSubjects = List.generate(3, (index) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        title: Text('Exam Management'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton.icon(
              onPressed: () => showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  context: context,
                  builder: (context) => AddTerm(
                        schoolCode: schoolCode,
                        refresh: () {
                          setState(() {
                            _getExamTerms = getExamTerms();
                          });
                        },
                      )),
              icon: Icon(Icons.add_rounded),
              label: Text('New Term'),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getExamTerms,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List examTerms = snapshot.data['examTerm'];

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ExpansionPanelList(
                    animationDuration: Duration(milliseconds: 400),
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (panelIndex, isExpanded) {
                      selectedClass = null;
                      if (_selectedIndex == panelIndex) {
                        setState(() {
                          _selectedIndex = null;
                        });
                      } else {
                        setState(() {
                          _selectedIndex = panelIndex;
                        });
                      }
                    },
                    children: [
                      for (int i = 0; i < examTerms.length; i++)
                        ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: i == _selectedIndex,
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              tileColor: Colors.blue[50],
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Term Name',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(examTerms[i]['termName']),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Admit Card Name',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(examTerms[i]['admitCardName']),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: VerticalDivider(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Result Card Name',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(examTerms[i]['resultName']),
                                    ],
                                  ),
                                  Row(
                                    children: [
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
                                          builder: (context) => EditTerm(
                                            schoolCode: schoolCode,
                                            termName: examTerms[i]['termName'],
                                            admitCardName: examTerms[i]
                                                ['admitCardName'],
                                            resultName: examTerms[i]
                                                ['resultName'],
                                            index: i,
                                            refresh: () {
                                              setState(() {
                                                _getExamTerms = getExamTerms();
                                              });
                                            },
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => showDialog(
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
                                                  deleteTerm(i);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: SizedBox(
                                  width: 500,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            borderRadius:
                                                BorderRadius.circular(4)),
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
                                                  value: e['title'],
                                                  child: Text(e['title'])))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedClass = value.toString();
                                              _getPapers = getPaper();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              selectedClass == null
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child:
                                              Text('Select Class to see Exams'),
                                        ),
                                      ],
                                    )
                                  : FutureBuilder(
                                      future: _getPapers,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          Map paper = snapshot.data;
                                          if (paper.isNotEmpty) {
                                            paper = paper['paper'];
                                          }
                                          List termPapers = [];
                                          if (paper.containsKey(
                                              examTerms[i]['termName'])) {
                                            termPapers =
                                                paper[examTerms[i]['termName']];
                                          }
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Align(
                                              //   alignment: Alignment.topRight,
                                              //   child: TextButton(
                                              //     onPressed: () {
                                              //       setState(() {
                                              //         isEdit = !isEdit;
                                              //       });
                                              //     },
                                              //     child: Icon(
                                              //       Icons.edit_outlined,
                                              //     ),
                                              //   ),
                                              // ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    15, 5, 15, 15),
                                                decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
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
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: Colors.orange
                                                                .shade50),
                                                        children: const [
                                                          TableCell(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'Paper Name',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )),
                                                          TableCell(
                                                              child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'Maximum Marks',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )),
                                                          TableCell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'Subject Name',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                'Action',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                    for (int j = 0;
                                                        j < termPapers.length;
                                                        j++)
                                                      TableRow(
                                                        children: [
                                                          TableCell(
                                                            verticalAlignment:
                                                                TableCellVerticalAlignment
                                                                    .middle,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                termPapers[j][
                                                                    'paperName'],
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            verticalAlignment:
                                                                TableCellVerticalAlignment
                                                                    .middle,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                  termPapers[j][
                                                                      'maxMarks']),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            verticalAlignment:
                                                                TableCellVerticalAlignment
                                                                    .middle,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Center(
                                                                child: Text(
                                                                  termPapers[j][
                                                                      'subject'],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Center(
                                                                  child: Wrap(
                                                                children: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              showModalBottomSheet(
                                                                                isScrollControlled: true,
                                                                                shape: const RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.only(
                                                                                    topLeft: Radius.circular(20),
                                                                                    topRight: Radius.circular(20),
                                                                                  ),
                                                                                ),
                                                                                context: context,
                                                                                builder: (context) => EditPaper(
                                                                                  subjects: subjects,
                                                                                  schoolCode: schoolCode,
                                                                                  selectedClass: selectedClass!,
                                                                                  termName: examTerms[i]['termName'],
                                                                                  paperName: termPapers[j]['paperName'],
                                                                                  maxMarks: termPapers[j]['maxMarks'],
                                                                                  selectedSubject: termPapers[j]['subject'],
                                                                                  index: j,
                                                                                  refresh: () {
                                                                                    setState(() {
                                                                                      _getPapers = getPaper();
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                      child: Icon(
                                                                          Icons
                                                                              .edit)),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        var client = BrowserClient()
                                                                          ..withCredentials =
                                                                              true;

                                                                        var url =
                                                                            Uri.parse('$ipv4/deletePaper');

                                                                        var res = await client.post(
                                                                            url,
                                                                            body: {
                                                                              'termName': examTerms[i]['termName'],
                                                                              'classTitle': selectedClass,
                                                                              'schoolCode': schoolCode,
                                                                              'index': j.toString()
                                                                            });
                                                                        if (res.body ==
                                                                            'true') {
                                                                          setState(
                                                                              () {
                                                                            _getPapers =
                                                                                getPaper();
                                                                          });
                                                                        }
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .red,
                                                                      ))
                                                                ],
                                                              )),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),

                                              Align(
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(15),
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                        ),
                                                      ),
                                                      context: context,
                                                      builder: (context) =>
                                                          AddPaper(
                                                        subjects: subjects,
                                                        schoolCode: schoolCode,
                                                        selectedClass:
                                                            selectedClass!,
                                                        termName: examTerms[i]
                                                            ['termName'],
                                                        refresh: () {
                                                          setState(() {
                                                            _getPapers =
                                                                getPaper();
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    child: Icon(Icons.add),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class EditPaper extends StatefulWidget {
  const EditPaper(
      {super.key,
      required this.subjects,
      required this.schoolCode,
      required this.selectedClass,
      required this.termName,
      required this.paperName,
      required this.maxMarks,
      required this.selectedSubject,
      required this.index,
      required this.refresh});
  final List subjects;
  final String schoolCode;
  final String selectedClass;
  final String termName;
  final String paperName;
  final String maxMarks;
  final String selectedSubject;
  final int index;
  final VoidCallback refresh;

  @override
  State<EditPaper> createState() => _EditPaperState();
}

class _EditPaperState extends State<EditPaper> {
  late List subjects;
  TextEditingController paperName = TextEditingController();
  TextEditingController maxMarks = TextEditingController();
  String? selectedSubject;
  late int index;

  editPaper(int index) async {
    // for (int i = 0; i < papers.length; i++) {
    //   papers[i]['paperName'] = papers[i]['paperName'].text.trim();
    //   papers[i]['maxMarks'] = papers[i]['maxMarks'].text.trim();
    // }

    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/editPaper');

    var res = await client.post(url, body: {
      'termName': widget.termName,
      'classTitle': widget.selectedClass,
      'schoolCode': widget.schoolCode,
      'paperName': paperName.text.trim(),
      'maxMarks': maxMarks.text.trim(),
      'subject': selectedSubject,
      'index': index.toString()
    });

    print(res.body);
    if (res.body == 'true') {
      widget.refresh();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    subjects = widget.subjects;
    paperName.text = widget.paperName;
    maxMarks.text = widget.maxMarks;
    selectedSubject = widget.selectedSubject;
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Paper',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
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
                            'Paper Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Maximum Marks',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Subject Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                      ]),
                  TableRow(
                    children: [
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFieldWidget(
                            label: 'Paper Name',
                            controller: paperName,
                            isEdit: true),
                      )),
                      TableCell(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFieldWidget(
                            label: 'Enter Marks',
                            controller: maxMarks,
                            isEdit: true),
                      )),
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: DropDownWidget(
                                  items: subjects.map((e) => e).toList(),
                                  title: 'Select Subject',
                                  isEdit: true,
                                  callBack: (p0) {
                                    setState(() {
                                      selectedSubject = p0;
                                    });
                                  },
                                  selected: selectedSubject),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  editPaper(index);
                },
                child: Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddPaper extends StatefulWidget {
  const AddPaper(
      {super.key,
      required this.subjects,
      required this.schoolCode,
      required this.selectedClass,
      required this.termName,
      required this.refresh});
  final List subjects;
  final String schoolCode;
  final String selectedClass;
  final String termName;
  final VoidCallback refresh;

  @override
  State<AddPaper> createState() => _AddPaperState();
}

class _AddPaperState extends State<AddPaper> {
  late List subjects;

  List papers = [
    {
      'paperName': TextEditingController(),
      'maxMarks': TextEditingController(),
      'subject': []
    },
    {
      'paperName': TextEditingController(),
      'maxMarks': TextEditingController(),
      'subject': []
    },
    {
      'paperName': TextEditingController(),
      'maxMarks': TextEditingController(),
      'subject': []
    }
  ];

  addPaper() async {
    for (int i = 0; i < papers.length; i++) {
      papers[i]['paperName'] = papers[i]['paperName'].text.trim();
      papers[i]['maxMarks'] = papers[i]['maxMarks'].text.trim();
    }

    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/addPaper');

    var res = await client.post(url, body: {
      'termName': widget.termName,
      'classTitle': widget.selectedClass,
      'schoolCode': widget.schoolCode,
      'data': jsonEncode(papers)
    });

    print(res.body);
    if (res.body == 'true') {
      widget.refresh();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    subjects = widget.subjects;

    subjects.sort();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Paper',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
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
                            'Paper Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Maximum Marks',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Subject Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                      ]),
                  for (int i = 0; i < 3; i++)
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFieldWidget(
                              label: 'Paper Name',
                              controller: papers[i]['paperName'],
                              isEdit: true),
                        )),
                        TableCell(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFieldWidget(
                              label: 'Enter Marks',
                              controller: papers[i]['maxMarks'],
                              isEdit: true),
                        )),
                        TableCell(
                          child: Wrap(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: listEquals(
                                        papers[i]['subject'], subjects),
                                    onChanged: (value) {
                                      if (value == true) {
                                        papers[i]['subject'] = subjects;
                                      } else {
                                        papers[i]['subject'] = [];
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  Text('Select All')
                                ],
                              ),
                              for (int j = 0; j < subjects.length; j++)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: papers[i]['subject']
                                          .contains(subjects[j]),
                                      onChanged: (value) {
                                        if (value == true) {
                                          setState(() {
                                            papers[i]['subject']
                                                .add(subjects[j]);
                                          });
                                        } else {
                                          setState(() {
                                            papers[i]['subject']
                                                .remove(subjects[j]);
                                          });
                                        }
                                        papers[i]['subject'].sort();
                                      },
                                    ),
                                    Text(subjects[j])
                                  ],
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(onPressed: addPaper, child: Text('Add')))
          ],
        ),
      ),
    );
  }
}

class EditTerm extends StatefulWidget {
  const EditTerm(
      {super.key,
      required this.schoolCode,
      required this.termName,
      required this.admitCardName,
      required this.resultName,
      required this.index,
      required this.refresh});
  final String schoolCode;
  final String termName;
  final String admitCardName;
  final String resultName;
  final int index;
  final VoidCallback refresh;
  @override
  State<EditTerm> createState() => _EditTermState();
}

class _EditTermState extends State<EditTerm> {
  TextEditingController termName = TextEditingController();
  TextEditingController admitCardName = TextEditingController();
  TextEditingController resultName = TextEditingController();
  late int index;
  editTerm() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/editTerm');
    var res = await client.post(url, body: {
      'schoolCode': widget.schoolCode,
      'termName': termName.text.trim(),
      'admitCardName': admitCardName.text.trim(),
      'resultName': resultName.text.trim(),
      'index': index.toString()
    });
    if (res.body == 'true') {
      widget.refresh();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    termName.text = widget.termName;
    admitCardName.text = widget.admitCardName;
    resultName.text = widget.resultName;
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit Term',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 50,
          ),
          TextFieldWidget(
              label: 'Enter Term Name', controller: termName, isEdit: true),
          SizedBox(
            height: 15,
          ),
          TextFieldWidget(
              label: 'Name on Admit Card',
              controller: admitCardName,
              isEdit: true),
          SizedBox(
            height: 15,
          ),
          TextFieldWidget(
              label: 'Name on Term Wise Result',
              controller: resultName,
              isEdit: true),
          SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: editTerm,
              child: Text('Save'),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

class AddTerm extends StatefulWidget {
  const AddTerm({super.key, required this.schoolCode, required this.refresh});
  final String schoolCode;
  final VoidCallback refresh;

  @override
  State<AddTerm> createState() => _AddTermState();
}

class _AddTermState extends State<AddTerm> {
  TextEditingController termName = TextEditingController();
  TextEditingController admitCardName = TextEditingController();
  TextEditingController resultName = TextEditingController();
  addTerm() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addTerm');
    var res = await client.post(url, body: {
      'schoolCode': widget.schoolCode,
      'termName': termName.text.trim(),
      'admitCardName': admitCardName.text.trim(),
      'resultName': resultName.text.trim()
    });
    if (res.body == 'true') {
      widget.refresh();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add New Term',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 50,
          ),
          TextFieldWidget(
              label: 'Enter Term Name', controller: termName, isEdit: true),
          SizedBox(
            height: 15,
          ),
          TextFieldWidget(
              label: 'Name on Admit Card',
              controller: admitCardName,
              isEdit: true),
          SizedBox(
            height: 15,
          ),
          TextFieldWidget(
              label: 'Name on Term Wise Result',
              controller: resultName,
              isEdit: true),
          SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: addTerm,
              child: Text('Add'),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
