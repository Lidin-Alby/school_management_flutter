import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';

import '../ip_address.dart';
import '../pages/student_attendance.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({
    super.key,
    //  required this.date, required this.refresh
  });

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
  List allSubjects = [];
  String? selectedSubject;

  String? status;
  bool loading = false;
  String weekDay = DateFormat('EEE').format(DateTime.now());
  @override
  void initState() {
    getClass();

    super.initState();
  }

  // getTimeTable() async {
  //   allSubjects = [];
  //   var client = BrowserClient()..withCredentials = true;
  //   var url = Uri.parse('$ipv4/getTimeTable/$selectedClass');
  //   var res = await client.get(url);
  //   Map data = jsonDecode(res.body);

  //   Map timeTable = data['timeTable'];

  //   List subs = timeTable[weekDay].map((e) => e['subject']).toList();
  //   for (int i = 0; i < subs.length; i++) {
  //     allSubjects.add('${subs[i]}(${timeTable['Time'][i]})');
  //   }
  //   setState(() {});
  //   print(allSubjects);
  // }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    List cl = jsonDecode(res.body);

    cl.removeLast();
    classes = cl;
    setState(() {});
  }

  getAttendace() async {
    setState(() {
      loading = true;
    });
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getAttendance/$selectedClass/$formattedDate');

    var res = await client.get(url);

    List students = jsonDecode(res.body);
    for (int i = 0; i < students.length; i++) {
      students[i]['attendance'] = {
        formattedDate: {'status': 'present'}
      };
    }
    print(students);
    setState(() {
      loading = false;
    });
    return students;
  }

  addAttendance() async {
    setState(() {
      isSaving = true;
    });
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addAttendance');

    print(students);

    var res = await client.post(
      url,
      body: {
        'data': jsonEncode(students),
        'classTitle': selectedClass,
        'date': formattedDate
      },
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
                              // getTimeTable();

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
                            weekDay = DateFormat('EEE').format(date!);
                            formattedDate =
                                DateFormat('dd - MM - yyyy').format(date);
                            setState(() {
                              _attendanceData = getAttendace();
                              // getTimeTable();
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
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            (selectedClass == null)
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
                                  students = snapshot.data;

                                  if (students.isNotEmpty) {
                                    if (students[0].containsKey('attendance') &&
                                        students[0]['attendance'][formattedDate]
                                                ['status'] ==
                                            'holiday') {
                                      isHoliday = true;
                                    } else {
                                      isHoliday = false;
                                    }
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
                                                            student['attendance']
                                                                        [
                                                                        formattedDate]
                                                                    ['status'] =
                                                                'holiday';
                                                          }
                                                        } else {
                                                          setState(() {
                                                            for (var student
                                                                in students) {
                                                              student['attendance']
                                                                          [
                                                                          formattedDate]
                                                                      [
                                                                      'status'] =
                                                                  'present';
                                                            }
                                                          });
                                                        }

                                                        setState(() {
                                                          isHoliday =
                                                              !isHoliday;
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
                                                                  builder:
                                                                      (context) =>
                                                                          StudentAttendance(
                                                                    admNo: e[
                                                                        'admNo'],
                                                                    studentName:
                                                                        e['firstName'],
                                                                  ),
                                                                )),
                                                        Text(e['firstName'])),
                                                    DataCell(
                                                        Text(e['fatherName'])),
                                                    DataCell(Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: RadioListTile(
                                                            title:
                                                                Text('Present'),
                                                            value: 'present',
                                                            // groupValue: '',
                                                            // onChanged: (value) {},
                                                            groupValue:
                                                                e['attendance'][
                                                                        formattedDate]
                                                                    ['status'],

                                                            onChanged: (value) {
                                                              setState(() {
                                                                e['attendance'][
                                                                        formattedDate]
                                                                    [
                                                                    'status'] = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 150,
                                                          child: RadioListTile(
                                                            title:
                                                                Text('Absent'),
                                                            value: 'absent',
                                                            groupValue: e
                                                                    .containsKey(
                                                                        'attendance')
                                                                ? e['attendance']
                                                                        [
                                                                        formattedDate]
                                                                    ['status']
                                                                : '',
                                                            onChanged: (value) {
                                                              setState(() {
                                                                e['attendance'][
                                                                        formattedDate]
                                                                    [
                                                                    'status'] = value;
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
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
