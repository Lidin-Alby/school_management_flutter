import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';
import 'package:school_management/pages/student_attendance_period.dart';
import 'package:school_management/widgets/mark_attendance_period.dart';

import '../ip_address.dart';
import '../pages/student_attendance.dart';
import 'mark_attendance.dart';

class ClassAttendanceCard extends StatefulWidget {
  const ClassAttendanceCard({super.key});

  @override
  State<ClassAttendanceCard> createState() => _ClassAttendanceCardState();
}

class _ClassAttendanceCardState extends State<ClassAttendanceCard> {
  String? attendanceType;
  late Future _getSettings;

  getAttendanceSettings() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getAttendanceSettings');
    var res = await client.get(url);

    Map data = jsonDecode(res.body);

    if (data['attendanceSettings'].containsKey('type')) {
      attendanceType = data['attendanceSettings']['type'];
    }
    return attendanceType;
  }

  @override
  void initState() {
    _getSettings = getAttendanceSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                              borderSide:
                                  BorderSide(width: 4, color: Colors.white)),
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
                    children: [
                      ViewAttendance(
                        type: snapshot.data,
                      ),
                      snapshot.data == 'no'
                          ? AttendancePeriod()
                          : MarkAttendance()
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ViewAttendance extends StatefulWidget {
  const ViewAttendance({super.key, required this.type});
  final String type;

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
  bool loading = false;
  @override
  void initState() {
    getClass();
    super.initState();
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
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
    setState(() {
      loading = true;
    });
    var client = BrowserClient()..withCredentials = true;
    var url = widget.type == 'no'
        ? Uri.parse('$ipv4/getAttendancePeriod/$_selectedClass/$formattedDate')
        : Uri.parse('$ipv4/getAttendance/$_selectedClass/$formattedDate');

    var res = await client.get(url);
    List students = jsonDecode(res.body);
    print(students);
    setState(() {
      loading = false;
    });

    return students;
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
                      child: loading
                          ? CircularProgressIndicator()
                          : FutureBuilder(
                              future: _attendanceData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  int i = 0;
                                  int presentStudents = 0;

                                  bool marked = false;
                                  students = snapshot.data;
                                  print(students);
                                  totalStudents = snapshot.data.length;
                                  if (students.isNotEmpty) {
                                    if (students[0].containsKey('attendance')) {
                                      // if (students[0]['attendance'][formattedDate]
                                      //         ['status'] !=
                                      //     '') {
                                      marked = true;
                                      // }
                                      isHoliday = students[0]['attendance']
                                              [formattedDate]['status'] ==
                                          'holiday';
                                      for (var i in students) {
                                        if (i['attendance'][formattedDate]
                                                ['status'] ==
                                            'present') {
                                          presentStudents++;
                                        }
                                      }
                                    } else {
                                      for (int i = 0;
                                          i < students.length;
                                          i++) {
                                        if (!students[i]
                                            .containsKey('attendance')) {
                                          students[i]['attendance'] = {
                                            formattedDate: {'status': ''}
                                          };
                                        }
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 400,
                                        child: TextField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
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
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                            Text(
                                              'Absent Students: ${marked ? totalStudents - presentStudents : 'Not Marked'}',
                                              style:
                                                  TextStyle(color: Colors.red),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                              i++;
                                              return DataRow(
                                                  color: e['attendance']
                                                                  [formattedDate]
                                                              ['status'] ==
                                                          'absent'
                                                      ? MaterialStateColor.resolveWith(
                                                          (states) => Colors
                                                              .red.shade100)
                                                      : e['attendance'][formattedDate]
                                                                  ['status'] ==
                                                              'holiday'
                                                          ? MaterialStateColor
                                                              .resolveWith(
                                                                  (states) => Colors
                                                                      .amber
                                                                      .shade100)
                                                          : null,
                                                  cells: [
                                                    DataCell(
                                                        Text(i.toString())),
                                                    DataCell(
                                                        onTap: () =>
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => widget
                                                                              .type ==
                                                                          'no'
                                                                      ? StudentAttendancePeriod(
                                                                          admNo:
                                                                              e['admNo'],
                                                                          studentName:
                                                                              e['firstName'],
                                                                        )
                                                                      : StudentAttendance(
                                                                          admNo:
                                                                              e['admNo'],
                                                                          studentName:
                                                                              e['firstName'],
                                                                        ),
                                                                )),
                                                        Text(e['firstName'])),
                                                    DataCell(
                                                        Text(e['fatherName'])),
                                                    DataCell(
                                                      widget.type == 'no'
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Column(
                                                                children: [
                                                                  if (e.containsKey(
                                                                          'attendancePeriod') &&
                                                                      e['attendancePeriod']
                                                                          .containsKey(
                                                                              formattedDate))
                                                                    for (var i
                                                                        in e['attendancePeriod'][formattedDate]
                                                                            .keys)
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(3),
                                                                        child: Text(
                                                                            '$i - ${e['attendancePeriod'][formattedDate][i]}'),
                                                                      )
                                                                ],
                                                              ),
                                                            )
                                                          : Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 150,
                                                                  child:
                                                                      RadioListTile(
                                                                    title: Text(
                                                                        'Present'),
                                                                    value:
                                                                        'present',
                                                                    // groupValue: '',
                                                                    // onChanged: (value) {},
                                                                    groupValue: e['attendance']
                                                                            [
                                                                            formattedDate]
                                                                        [
                                                                        'status'],

                                                                    onChanged:
                                                                        (value) {},
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 150,
                                                                  child:
                                                                      RadioListTile(
                                                                    title: Text(
                                                                        'Absent'),
                                                                    value:
                                                                        'absent',
                                                                    groupValue: e.containsKey(
                                                                            'attendance')
                                                                        ? e['attendance'][formattedDate]
                                                                            [
                                                                            'status']
                                                                        : '',
                                                                    onChanged:
                                                                        (value) {},
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                    ),
                                                    DataCell(e['attendance']
                                                                [formattedDate]
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
                                                                    child: Text(e['attendance']
                                                                            [
                                                                            formattedDate]
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
