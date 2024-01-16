import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';

import '../ip_address.dart';

class ClassAttendanceCard extends StatefulWidget {
  const ClassAttendanceCard({super.key});

  @override
  State<ClassAttendanceCard> createState() => _ClassAttendanceCardState();
}

class _ClassAttendanceCardState extends State<ClassAttendanceCard> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
        child: Scaffold(
          backgroundColor: Colors.white,
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
                    Tab(child: Text('View Attendance')),
                    Tab(child: Text('Mark Attendance'))
                  ]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              // elevation: 0,
              backgroundColor: Colors.indigo[900],
              title: Text('Class Attendance'),
            ),
          ),
          body: TabBarView(
            children: [ViewAttendance(), MarkAttendance()],
          ),
        ),
      ),
    );
  }
}

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key});

  @override
  State<ViewAttendance> createState() => _ViewAttendanceState();
}

class _ViewAttendanceState extends State<ViewAttendance> {
  String formattedDate = DateFormat('dd - MM - yyyy').format(DateTime.now());
  late Future _attendanceData;
  late List students;
  int totalStudents = 0;
  List classes = [];
  String searchText = '';

  String? _selectedClass;
  bool isHoliday = false;
  @override
  void initState() {
    getClass();
    super.initState();
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getClassDetails');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List cl = jsonDecode(res.body);
    // schoolCode = cl.last['schoolCode'];
    print(cl);
    cl.removeLast();
    classes = cl;
    setState(() {
      // classes.addAll(cl);
    });
  }

  getAttendace() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getAttendance/$_selectedClass/$formattedDate');

    var res = await client.get(url);
    print(res.body);

    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          value: _selectedClass,
                          isDense: true, isExpanded: true,
                          underline: Text(''),
                          hint: Text('Select Class'),
                          items: classes
                              .map((e) => DropdownMenuItem(
                                  value: e['title'], child: Text(e['title'])))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedClass = value.toString();

                              _attendanceData = getAttendace();
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
                        'Date',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateFormat('dd - MM - yyyy')
                                    .parse(formattedDate),
                                firstDate: DateTime(2018),
                                lastDate: DateTime.now());
                            setState(() {
                              formattedDate =
                                  DateFormat('dd - MM - yyyy').format(date!);
                              _attendanceData = getAttendace();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4)),
                            padding: EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formattedDate),
                                Icon(
                                  Icons.edit_calendar,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            _selectedClass == null
                ? Center(child: Text('Select class to take attendance'))
                : Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder(
                          future: _attendanceData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              int i = 0;
                              int presentStudents = 0;

                              bool marked = false;
                              students = snapshot.data;
                              totalStudents = snapshot.data.length;
                              if (students[0]['attendance'].isNotEmpty) {
                                marked = true;
                                isHoliday = students[0]['attendance'][0]
                                        ['status'] ==
                                    'holiday';
                                for (var i in students) {
                                  if (i['attendance'][0]['status'] ==
                                      'present') {
                                    presentStudents++;
                                  }
                                }
                              }
                              if (searchText != '') {
                                students = students
                                    .where((element) => element['firstName']
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase()))
                                    .toList();
                              }

                              return Column(
                                // mainAxisSize: MainAxisSize.min,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 400,
                                    child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            hintText: 'Search Student',
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 900,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'Total Students: $totalStudents',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Present Students:  ${marked ? presentStudents : 'Not Marked'}',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        Text(
                                          'Absent Students: ${marked ? totalStudents - presentStudents : 'Not Marked'}',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: DataTable(
                                        // dataRowMinHeight: double.infinity,
                                        dataRowMaxHeight: double.infinity,
                                        border: TableBorder(
                                          verticalInside: BorderSide(),
                                        ),
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    Colors.orange.shade50),
                                        headingTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        columns: [
                                          DataColumn(
                                            // numeric: true,
                                            label: Text('Roll No.'),
                                          ),
                                          DataColumn(
                                            label: Text('Name'),
                                          ),
                                          DataColumn(
                                            label: Text('Father\'s Name'),
                                          ),
                                          DataColumn(
                                            label: Text('Status'),
                                          ),
                                          DataColumn(
                                            label: Text('Notes'),
                                          )
                                        ],
                                        rows: students.map((e) {
                                          e['attendance'].add({
                                            'status': 'present',
                                            'date': formattedDate
                                          });
                                          i++;
                                          return DataRow(
                                              color: e['attendance'][0]
                                                          ['status'] ==
                                                      'absent'
                                                  ? MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.red.shade100)
                                                  : e['attendance'][0]
                                                              ['status'] ==
                                                          'holiday'
                                                      ? MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .amber
                                                                  .shade100)
                                                      : null,
                                              cells: [
                                                DataCell(Text(i.toString())),
                                                DataCell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StudentAttendance(
                                                            admNo: e['admNo'],
                                                            studentName:
                                                                e['firstName'],
                                                          ),
                                                        )),
                                                    Text(e['firstName'])),
                                                DataCell(Text(e['fatherName'])),
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: AbsorbPointer(
                                                        absorbing: false,
                                                        child: RadioListTile(
                                                          title:
                                                              Text('Present'),
                                                          value: 'present',
                                                          // groupValue: '',
                                                          // onChanged: (value) {},
                                                          groupValue: e[
                                                                      'attendance']
                                                                  .isNotEmpty
                                                              ? e['attendance']
                                                                  [0]['status']
                                                              : 'present',
                                                          onChanged: (value) {
                                                            setState(() {
                                                              if (e['attendance']
                                                                  .isNotEmpty) {
                                                                e['attendance']
                                                                            [0][
                                                                        'status'] =
                                                                    value;
                                                              } else {
                                                                e['attendance']
                                                                    .add({
                                                                  'status':
                                                                      value,
                                                                  'date':
                                                                      formattedDate
                                                                });
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      child: AbsorbPointer(
                                                        absorbing: false,
                                                        child: RadioListTile(
                                                          title: Text('Absent'),
                                                          value: 'absent',
                                                          // groupValue: '',
                                                          // onChanged: (value) {},
                                                          groupValue: e[
                                                                      'attendance']
                                                                  .isNotEmpty
                                                              ? e['attendance']
                                                                  [0]['status']
                                                              : '',
                                                          onChanged: (value) {
                                                            setState(() {
                                                              if (e['attendance']
                                                                  .isNotEmpty) {
                                                                e['attendance']
                                                                            [0][
                                                                        'status'] =
                                                                    value;
                                                              } else {
                                                                e['attendance']
                                                                    .add({
                                                                  'status':
                                                                      value,
                                                                  'date':
                                                                      formattedDate
                                                                });
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                                DataCell(
                                                    e['attendance'][0]
                                                            .containsKey(
                                                                'reason')
                                                        ? ElevatedButton.icon(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              elevation: 0,
                                                              // side: BorderSide(
                                                              //     width: 2,
                                                              //     color: Colors
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ),
                                                            onPressed: () =>
                                                                showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  SimpleDialog(
                                                                titlePadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            20,
                                                                            20,
                                                                            0),
                                                                title: Text(
                                                                    'Leave Application'),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20),
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: 'Name - ',
                                                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                                                          TextSpan(
                                                                            text:
                                                                                e['firstName'],
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: 'Father\'s Name - ',
                                                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                                                          TextSpan(
                                                                            text:
                                                                                e['fatherName'],
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'Reason:',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Container(
                                                                    height: 200,
                                                                    width: 400,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        border:
                                                                            Border.all()),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                        e['attendance'][0]
                                                                            [
                                                                            'reason']),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            icon: Icon(Icons
                                                                .open_in_new_rounded),
                                                            label: Text(
                                                                'Leave Applied'),
                                                          )
                                                        : Text(''))
                                              ]);
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({
    super.key,
    //  required this.date, required this.refresh
  });
  // final String date;

  // final VoidCallback refresh;

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  // bool enableEdit = false;
  String formattedDate = DateFormat('dd - MM - yyyy').format(DateTime.now());
  late Future _attendanceData;
  late List students;
  List classes = [];
  bool isSaving = false;
  String? selectedClass;
  bool isHoliday = false;
  String searchText = '';
  @override
  void initState() {
    // formattedDate = widget.date;

    _attendanceData = getAttendace();
    getClass();
    super.initState();
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getClassDetails');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List cl = jsonDecode(res.body);
    // schoolCode = cl.last['schoolCode'];
    print(cl);
    cl.removeLast();
    classes = cl;
    setState(() {
      // classes.addAll(cl);
    });
  }

  getAttendace() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getAttendance/$selectedClass/$formattedDate');

    var res = await client.get(url);
    print(res.body);

    return jsonDecode(res.body);
  }

  addAttendance() async {
    // print('oooooooooo');
    // print(students);
    // print('oooooooooo');
    setState(() {
      isSaving = true;
    });
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/addAttendance');

    var res = await client.post(
      url,
      body: {'data': jsonEncode(students), 'classTitle': selectedClass},
    );
    print(res.body);
    if (res.body == 'true') {
      setState(() {
        isSaving = false;
        // enableEdit = false;
      });
      // widget.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

                              _attendanceData = getAttendace();
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
                        'Date',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: InkWell(
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateFormat('dd - MM - yyyy')
                                    .parse(formattedDate),
                                firstDate: DateTime(2018),
                                lastDate: DateTime.now());
                            setState(() {
                              formattedDate =
                                  DateFormat('dd - MM - yyyy').format(date!);
                              _attendanceData = getAttendace();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4)),
                            padding: EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formattedDate),
                                Icon(
                                  Icons.edit_calendar,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            selectedClass == null
                ? Center(child: Text('Select class to take attendance'))
                : Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder(
                          future: _attendanceData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              int i = 0;
                              students = snapshot.data;
                              if (students[0]['attendance'].isNotEmpty) {
                                isHoliday = students[0]['attendance'][0]
                                        ['status'] ==
                                    'holiday';
                              }
                              if (searchText != '') {
                                students = students
                                    .where((element) => element['firstName']
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase()))
                                    .toList();
                              }
                              //  List status = List.generate(students.length, (index) => null);

                              return Column(
                                // mainAxisSize: MainAxisSize.min,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 400,
                                    child: TextField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            hintText: 'Search Student',
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      if (!isSaving)
                                        Container(
                                          // color: Colors.red,
                                          constraints:
                                              BoxConstraints(maxWidth: 875),
                                          child: Row(
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                child: CheckboxListTile(
                                                  title: const Text(
                                                      'Mark as Holiday'),
                                                  value: isHoliday,
                                                  onChanged: (value) {
                                                    if (value == true) {
                                                      for (var student
                                                          in students) {
                                                        if (student[
                                                                'attendance']
                                                            .isNotEmpty) {
                                                          student['attendance']
                                                                      [0]
                                                                  ['status'] =
                                                              'holiday';
                                                        } else {
                                                          student['attendance']
                                                              .add({
                                                            'status': 'holiday',
                                                            'date':
                                                                formattedDate
                                                          });
                                                        }
                                                      }
                                                    } else {
                                                      setState(() {
                                                        for (var student
                                                            in students) {
                                                          if (student[
                                                                  'attendance']
                                                              .isNotEmpty) {
                                                            student['attendance']
                                                                        [0]
                                                                    ['status'] =
                                                                'present';
                                                          } else {
                                                            student['attendance']
                                                                .add({
                                                              'status':
                                                                  'present',
                                                              'date':
                                                                  formattedDate
                                                            });
                                                          }
                                                        }
                                                      });
                                                    }

                                                    setState(() {
                                                      isHoliday = !isHoliday;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Spacer(),
                                              if (isSaving)
                                                CircularProgressIndicator(),
                                              // Spacer(),

                                              ElevatedButton(
                                                onPressed: addAttendance,
                                                child: Text('Save'),
                                              )
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: DataTable(
                                        // dataRowMinHeight: double.infinity,
                                        dataRowMaxHeight: double.infinity,
                                        border: TableBorder(
                                          verticalInside: BorderSide(),
                                        ),
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) =>
                                                    Colors.orange.shade50),
                                        headingTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        columns: [
                                          DataColumn(
                                            // numeric: true,
                                            label: Text('Roll No.'),
                                          ),
                                          DataColumn(
                                            label: Text('Name'),
                                          ),
                                          DataColumn(
                                            label: Text('Father\'s Name'),
                                          ),
                                          DataColumn(
                                            label: Text('Status'),
                                          ),
                                          DataColumn(
                                            label: Text('Notes'),
                                          )
                                        ],
                                        rows: students.map((e) {
                                          e['attendance'].add({
                                            'status': 'present',
                                            'date': formattedDate
                                          });
                                          i++;
                                          return DataRow(
                                              color: e['attendance'][0]
                                                          ['status'] ==
                                                      'absent'
                                                  ? MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.red.shade100)
                                                  : e['attendance'][0]
                                                              ['status'] ==
                                                          'holiday'
                                                      ? MaterialStateColor
                                                          .resolveWith(
                                                              (states) => Colors
                                                                  .amber
                                                                  .shade100)
                                                      : null,
                                              cells: [
                                                DataCell(Text(i.toString())),
                                                DataCell(
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StudentAttendance(
                                                            admNo: e['admNo'],
                                                            studentName:
                                                                e['firstName'],
                                                          ),
                                                        )),
                                                    Text(e['firstName'])),
                                                DataCell(Text(e['fatherName'])),
                                                DataCell(Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 150,
                                                      child: RadioListTile(
                                                        title: Text('Present'),
                                                        value: 'present',
                                                        // groupValue: '',
                                                        // onChanged: (value) {},
                                                        groupValue:
                                                            e['attendance']
                                                                    .isNotEmpty
                                                                ? e['attendance']
                                                                        [0]
                                                                    ['status']
                                                                : 'present',
                                                        onChanged: (value) {
                                                          setState(() {
                                                            if (e['attendance']
                                                                .isNotEmpty) {
                                                              e['attendance'][0]
                                                                      [
                                                                      'status'] =
                                                                  value;
                                                            } else {
                                                              e['attendance']
                                                                  .add({
                                                                'status': value,
                                                                'date':
                                                                    formattedDate
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      child: RadioListTile(
                                                        title: Text('Absent'),
                                                        value: 'absent',
                                                        // groupValue: '',
                                                        // onChanged: (value) {},
                                                        groupValue:
                                                            e['attendance']
                                                                    .isNotEmpty
                                                                ? e['attendance']
                                                                        [0]
                                                                    ['status']
                                                                : '',
                                                        onChanged: (value) {
                                                          setState(() {
                                                            if (e['attendance']
                                                                .isNotEmpty) {
                                                              e['attendance'][0]
                                                                      [
                                                                      'status'] =
                                                                  value;
                                                            } else {
                                                              e['attendance']
                                                                  .add({
                                                                'status': value,
                                                                'date':
                                                                    formattedDate
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                                DataCell(
                                                    e['attendance'][0]
                                                            .containsKey(
                                                                'reason')
                                                        ? ElevatedButton.icon(
                                                            style:
                                                                OutlinedButton
                                                                    .styleFrom(
                                                              elevation: 0,
                                                              // side: BorderSide(
                                                              //     width: 2,
                                                              //     color: Colors
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ),
                                                            onPressed: () =>
                                                                showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  SimpleDialog(
                                                                titlePadding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            20,
                                                                            20,
                                                                            0),
                                                                title: Text(
                                                                    'Leave Application'),
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20),
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: 'Name - ',
                                                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                                                          TextSpan(
                                                                            text:
                                                                                e['firstName'],
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                              text: 'Father\'s Name - ',
                                                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                                                          TextSpan(
                                                                            text:
                                                                                e['fatherName'],
                                                                          )
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    'Reason:',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Container(
                                                                    height: 200,
                                                                    width: 400,
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                5),
                                                                        border:
                                                                            Border.all()),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                        e['attendance'][0]
                                                                            [
                                                                            'reason']),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            icon: Icon(Icons
                                                                .open_in_new_rounded),
                                                            label: Text(
                                                                'Leave Applied'),
                                                          )
                                                        : Text(''))
                                              ]);
                                        }).toList(),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

//to be to next page

class StudentAttendance extends StatefulWidget {
  const StudentAttendance(
      {super.key, required this.studentName, required this.admNo});
  final String studentName;
  final String admNo;

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  late Future _attendance;
  double height = 50;
  double width = 50;
  Uint8List? _imagebytes;

  getProfilePic() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getProfilePic/${widget.admNo}');
    var response = await client.get(url);

    if (response.body == 'false') {
      setState(() {
        _imagebytes = null;
      });
    } else {
      setState(() {
        _imagebytes = response.bodyBytes;
      });
    }
  }

  getDaysinMonth(String monthYear) {
    String month = monthYear.split('-')[0];
    int year = int.parse(monthYear.split('-')[1]);
    List ones = [
      'January',
      'March',
      'May',
      'July',
      'August',
      'October',
      'December'
    ];
    if (month == 'February') {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    if (ones.contains(month)) {
      return 31;
    } else {
      return 30;
    }
  }

  calendar(String monthYear, List absents, List holidays, List presents) {
    int total = getDaysinMonth(monthYear);
    List weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    String week = DateFormat('EEE')
        .format(DateFormat('d-MMMM-yyyy').parse('1-$monthYear'));
    int skip = weekdays.indexOf(week);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (rowNumber) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(7, (columnNumber) {
            final index = rowNumber * 7 + columnNumber + 1;
            if (index <= skip) {
              return SizedBox(
                width: width,
                height: height,
              );
            }
            bool isAbsent = absents.contains('${index - skip}-$monthYear');
            bool isHoliday = holidays.contains('${index - skip}-$monthYear');
            bool isPresent = presents.contains('${index - skip}-$monthYear');

            // final actualIndex = index - (rowNumber * 3);
            if (index <= total + skip) {
              return SizedBox(
                width: width,
                height: height,
                child: Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: isAbsent
                          ? Colors.red[600]
                          : isHoliday
                              ? Colors.amber
                              : null,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: isPresent
                              ? Border(
                                  bottom:
                                      BorderSide(color: Colors.green, width: 8))
                              : null),
                      child: Center(
                        child: Text((index - skip).toString(),
                            style: TextStyle(
                                color: index % 7 == 1
                                    ? Colors.red
                                    : isAbsent
                                        ? Colors.white
                                        : null)),
                      ),
                    )),
              );
            } else {
              return Text('');
            }
          }),
        );
      }),
    );
  }

  daysDetails(String month, List attendance) {
    print('oooooo');
    print(attendance);
    print('oooooo');
    int monthAbs = 0;
    int monthPres = 0;
    for (var i in attendance) {
      DateTime d = DateFormat('dd - MM - yyyy').parse(i['date']);
      String m = DateFormat('MMMM-yyyy').format(d);
      if (m == month && (i['status'] == 'absent')) {
        monthAbs++;
      }
      if (m == month && (i['status'] == 'present')) {
        monthPres++;
      }
    }
    return Column(
      children: [
        Text('Working Days: ${monthPres + monthAbs}'),
        Text(
          'Present Days: $monthPres',
          style: TextStyle(color: Colors.green),
        ),
        Text(
          'Absent Days: $monthAbs',
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  getAttendace() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getSingleAttendance/${widget.admNo}');

    var res = await client.get(url);
    print(res.body);

    return jsonDecode(res.body);
  }

  @override
  void initState() {
    _attendance = getAttendace();
    getProfilePic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _attendance,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map student = snapshot.data;
              List attendance = snapshot.data['attendance'];
              String today =
                  DateFormat('dd - MM - yyyy').format(DateTime.now());
              List absents = [];
              List holidays = [];
              List months = [];
              List presents = [];
              List dates = [];
              int thisMonthPres = 0;
              int thisMonthAbs = 0;
              String now = DateFormat('MMMM-yyyy').format(DateTime.now());

              String todayStatus = 'null';
              for (var i in attendance) {
                DateTime d = DateFormat('dd - MM - yyyy').parse(i['date']);
                String nowMonth = DateFormat('MMMM-yyyy').format(d);

                dates.add(d);
                if (i['status'] == 'absent') {
                  absents.add(DateFormat('d-MMMM-yyyy').format(d));
                  if (nowMonth == now) {
                    thisMonthAbs++;
                  }
                }
                if (i['status'] == 'holiday') {
                  holidays.add(DateFormat('d-MMMM-yyyy').format(d));
                }
                if (i['status'] == 'present') {
                  presents.add(DateFormat('d-MMMM-yyyy').format(d));
                  if (nowMonth == now) {
                    thisMonthPres++;
                  }
                }
                if (i['date'] == today) {
                  todayStatus = i['status'];
                }
              }
              int totalThisMonthDays = thisMonthAbs + thisMonthPres;

              int totalDays = absents.length + presents.length;

              dates.sort();
              for (DateTime date in dates) {
                months.add(DateFormat('MMMM-yyyy').format(date));
                // print(date.day);
              }

              List unique = months.toSet().toList();
              print(unique);
              // var a = attendance
              //     .firstWhere((element) => element['date'] == today)?['status'];
              // print(a);

              return Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 88),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _imagebytes == null
                                  ? Icon(
                                      color: Colors.grey,
                                      Icons.account_circle_rounded,
                                      size: 200,
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(
                                        _imagebytes!,
                                        //  fit: BoxFit.contain,
                                      ),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${student['firstName']}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Adm No.: ${student['admNo']}'),
                                  Text('Father Name: ${student['fatherName']}'),
                                  Text('Mobile: ${student['fatherMobNo']}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(65),
                          child: Column(
                            children: [
                              Text(
                                'Attendance Report',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: 75,
                                height: 75,
                                child: CircularProgressIndicator(
                                  strokeWidth: 25,
                                  value: thisMonthAbs / totalThisMonthDays,
                                  color: Colors.red,
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'This Month',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  '${((thisMonthPres / totalThisMonthDays) * 100).toStringAsFixed(2)} %'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Today:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(todayStatus.toUpperCase())
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    now,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width: 120,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Working Days: $totalThisMonthDays'),
                                      Text(
                                        'Present Days: $thisMonthPres',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Text(
                                        'Absent Days: $thisMonthAbs',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Text()
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      height: height,
                                      width: width,
                                      child: Center(
                                          child: Text(
                                        'Sun',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ))),
                                  SizedBox(
                                    height: height,
                                    width: width,
                                    child: Center(
                                      child: Text(
                                        'Mon',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: height,
                                      width: width,
                                      child: Center(
                                        child: Text(
                                          'Tue',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  SizedBox(
                                      height: height,
                                      width: width,
                                      child: Center(
                                        child: Text(
                                          'Wed',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  SizedBox(
                                      height: height,
                                      width: width,
                                      child: Center(
                                        child: Text(
                                          'Thu',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  SizedBox(
                                      height: height,
                                      width: width,
                                      child: Center(
                                        child: Text(
                                          'Fri',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                  SizedBox(
                                      height: height,
                                      width: width,
                                      child: Center(
                                        child: Text(
                                          'Sat',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                ],
                              ),
                              calendar(now, absents, holidays, presents),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Divider(),
                  // Text('Year Report'),
                  // Divider(),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // height: 300,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Yearly Report',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Wrap(
                              spacing: 20,
                              children: [
                                SizedBox(
                                  width: 75,
                                  height: 75,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 25,
                                    value: absents.length / totalDays,
                                    color: Colors.red,
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Overall',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        '${((presents.length / totalDays) * 100).toStringAsFixed(2)} %'),
                                  ],
                                ),
                                Text(
                                  'Working Days: $totalDays',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Present Days: ${presents.length}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Absent Days: ${absents.length}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (String month in unique)
                          Card(
                            color: month ==
                                    DateFormat('MMMM-yyyy')
                                        .format(DateTime.now())
                                ? Colors.blue[50]
                                : null,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        month,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 120,
                                      ),
                                      daysDetails(month, attendance),
                                    ],
                                  ),
                                  // Text()
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          height: height,
                                          width: width,
                                          child: Center(
                                              child: Text(
                                            'Sun',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ))),
                                      SizedBox(
                                        height: height,
                                        width: width,
                                        child: Center(
                                          child: Text(
                                            'Mon',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: height,
                                          width: width,
                                          child: Center(
                                            child: Text(
                                              'Tue',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      SizedBox(
                                          height: height,
                                          width: width,
                                          child: Center(
                                            child: Text(
                                              'Wed',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      SizedBox(
                                          height: height,
                                          width: width,
                                          child: Center(
                                            child: Text(
                                              'Thu',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      SizedBox(
                                          height: height,
                                          width: width,
                                          child: Center(
                                            child: Text(
                                              'Fri',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                      SizedBox(
                                          height: height,
                                          width: width,
                                          child: Center(
                                            child: Text(
                                              'Sat',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ))
                                    ],
                                  ),
                                  calendar(month, absents, holidays, presents)

                                  // Text(getDaysinMonth(month).toString())
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              );

              //  Column(
              //   children: [
              //     SizedBox(
              //       height: 20,
              //     ),
              //     Align(
              //       alignment: Alignment.centerLeft,
              //       child:

              //     ),
              //     SizedBox(
              //       height: 10,
              //     ),

              //     SizedBox(
              //       height: 5,
              //     ),
              //     Row(
              //       children: [

              //       ],
              //     ),
              //     SizedBox(
              //       height: 5,
              //     ),

              //     SizedBox(
              //       height: 5,
              //     ),

              //     Align(
              //       alignment: Alignment.centerLeft,
              //       child:

              //     ),
              //   ],
              // );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
