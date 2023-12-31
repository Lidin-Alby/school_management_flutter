import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';

import '../ip_address.dart';
import 'edit_widget.dart';

class ClassAttendanceCard extends StatefulWidget {
  const ClassAttendanceCard({super.key});

  @override
  State<ClassAttendanceCard> createState() => _ClassAttendanceCardState();
}

class _ClassAttendanceCardState extends State<ClassAttendanceCard> {
  bool enableEdit = false;
  String formattedDate = DateFormat('dd - MM - yyyy').format(DateTime.now());
  late Future _attendanceData;
  late List students;
  @override
  void initState() {
    _attendanceData = getAttendace();
    super.initState();
  }

  getAttendace() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getAttendance/$formattedDate');

    var res = await client.get(url);
    print(res.body);
    return jsonDecode(res.body);
  }

  addAttendance() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/addAttendance');

    var res = await client.post(url, body: {'data': jsonEncode(students)});
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _attendanceData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              students = snapshot.data;
              //  List status = List.generate(students.length, (index) => null);

              return SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  alignment: AlignmentDirectional.centerStart,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo[100],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                    ),
                                  ),
                                  width: 75,
                                  height: 40,
                                  child: Text(
                                    'Roll No.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  alignment: AlignmentDirectional.centerStart,
                                  color: Colors.indigo[100],
                                  width: 300,
                                  height: 40,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  alignment: AlignmentDirectional.centerStart,
                                  decoration: BoxDecoration(
                                      color: Colors.indigo[100],
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5))),
                                  width: 600,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      formattedDate,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                                if (enableEdit)
                                  TextButton.icon(
                                    onPressed: () async {
                                      final selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate:
                                              DateFormat('dd - MM - yyyy')
                                                  .parse(formattedDate),
                                          // currentDate: DateTime.now(),
                                          firstDate:
                                              DateTime(DateTime.now().year - 1),
                                          lastDate: DateTime.now()) as DateTime;
                                      setState(() {
                                        print(selectedDate);
                                        formattedDate =
                                            DateFormat('dd - MM - yyyy')
                                                .format(selectedDate);
                                        _attendanceData = getAttendace();
                                      });
                                    },
                                    icon: Icon(Icons.edit_calendar_rounded),
                                    label: Text('Select Date'),
                                  ),
                                SizedBox(
                                  width: 20,
                                ),
                                OutlinedButton(
                                  onPressed: !enableEdit
                                      ? () {
                                          setState(() {
                                            enableEdit = true;
                                          });
                                        }
                                      : null,
                                  child: Icon(Icons.edit_outlined),
                                ),
                              ],
                            ),
                            for (int i = 0; i < students.length; i++)
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    alignment: AlignmentDirectional.centerStart,
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: i == students.length
                                            ? BorderRadius.only(
                                                bottomLeft: Radius.circular(5))
                                            : null),
                                    width: 75,
                                    height: 43,
                                    child: Text(
                                      '${i + 1}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    alignment: AlignmentDirectional.centerStart,
                                    color: Colors.indigo,
                                    width: 300,
                                    height: 43,
                                    child: Text(
                                      students[i]['firstName'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: AbsorbPointer(
                                      absorbing: !enableEdit,
                                      child: RadioListTile(
                                        title: Text('Present'),
                                        value: 'present',
                                        groupValue:
                                            students[i]['attendance'].isNotEmpty
                                                ? students[i]['attendance'][0]
                                                    ['status']
                                                : '',
                                        onChanged: (value) {
                                          setState(() {
                                            if (students[i]['attendance']
                                                .isNotEmpty) {
                                              students[i]['attendance'][0]
                                                  ['status'] = value;
                                            } else {
                                              students[i]['attendance'].add({
                                                'status': value,
                                                'date': formattedDate
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: AbsorbPointer(
                                      absorbing: !enableEdit,
                                      child: RadioListTile(
                                        title: Text('Absent'),
                                        value: 'absent',
                                        groupValue:
                                            students[i]['attendance'].isNotEmpty
                                                ? students[i]['attendance'][0]
                                                    ['status']
                                                : '',
                                        onChanged: (value) {
                                          setState(() {
                                            if (students[i]['attendance']
                                                .isNotEmpty) {
                                              students[i]['attendance'][0]
                                                  ['status'] = value;
                                            } else {
                                              students[i]['attendance'].add({
                                                'status': value,
                                                'date': formattedDate
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: AbsorbPointer(
                                      absorbing: !enableEdit,
                                      child: RadioListTile(
                                        title: Text('Leave Taken'),
                                        value: 'leave',
                                        groupValue:
                                            students[i]['attendance'].isNotEmpty
                                                ? students[i]['attendance'][0]
                                                    ['status']
                                                : '',
                                        onChanged: (value) {
                                          setState(() {
                                            if (students[i]['attendance']
                                                .isNotEmpty) {
                                              students[i]['attendance'][0]
                                                  ['status'] = value;
                                            } else {
                                              students[i]['attendance'].add({
                                                'status': value,
                                                'date': formattedDate
                                              });
                                            }

                                            print(students);
                                          });
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                        if (enableEdit)
                          EditWidget(
                            cancel: () {
                              setState(() {
                                enableEdit = false;
                              });
                            },
                            done: addAttendance,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
