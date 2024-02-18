import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';

class TimeTableManagement extends StatefulWidget {
  const TimeTableManagement({super.key});

  @override
  State<TimeTableManagement> createState() => _TimeTableManagementState();
}

class _TimeTableManagementState extends State<TimeTableManagement> {
  List classes = [];
  String? selectedClass;
  late Future _loadTimeTable;
  late String schoolCode;
  // String? selectedSubject;
  List subjects = [];
  List teachers = [];
  int periods = 3;
  List weeks = ['Period', 'Time', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  dynamic timeTable;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List data = jsonDecode(res.body);
    schoolCode = data.last['schoolCode'];

    data.removeLast();
    setState(() {
      classes = data;
    });
    // return data;
  }

  getTeachers() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getTeachers');
    var res = await client.get(url);

    teachers = jsonDecode(res.body);
    print(teachers);
    setState(() {});
  }

  getInstitueSubjects() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getSubjects');
    var res = await client.get(url);

    print(res.body);
    var data = jsonDecode(res.body);
    subjects = data['subjects'];
  }

  getTimeTable() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getTimeTable/$selectedClass');
    var res = await client.get(url);
    dynamic data = jsonDecode(res.body);
    print(data);
    if (data.isEmpty) {
      data = {
        'Period': ['', '', ''],
        'Time': ['', '', ''],
        'Mon': [
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''}
        ],
        'Tue': [
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''}
        ],
        'Wed': [
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''}
        ],
        'Thu': [
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''}
        ],
        'Fri': [
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''}
        ],
        'Sat': [
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''},
          {'teacher': null, 'subject': ''}
        ]
      };
      return data;
    }
    print(res.body);
    return data['timeTable'];
  }

  addTimeTable() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addTimeTable/$selectedClass');
    var res =
        await client.post(url, body: {'timeTable': jsonEncode(timeTable)});
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
    getInstitueSubjects();
    getTeachers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.indigo,
                ),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.all(4),
              value: selectedClass,
              isDense: true,
              underline: Text(''),
              hint: Text('Select Class'),
              items: classes
                  .map((e) => DropdownMenuItem(
                      value: e['title'], child: Text(e['title'])))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value.toString();
                  _loadTimeTable = getTimeTable();
                });
              },
            ),
          ),
          Divider(),
          if (selectedClass != null)
            FutureBuilder(
              future: _loadTimeTable,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  timeTable = snapshot.data;
                  periods = timeTable['Time'].length;
                  return Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                            onPressed: addTimeTable, child: Text('save')),
                      ),
                      DataTable(
                        dataRowMaxHeight: 100,
                        columns: weeks
                            .map((e) => DataColumn(label: Text(e)))
                            .toList(),
                        rows: [
                          for (int i = 0; i < periods; i++)
                            DataRow(
                              cells: weeks.map((week) {
                                // String? selectedSubject;
                                return DataCell(
                                  week == 'Period'
                                      ? SizedBox(
                                          width: 75,
                                          child: TextField(
                                            onChanged: (value) {
                                              timeTable['Period'][i] = value;
                                            },
                                            controller: TextEditingController(
                                                text: timeTable['Period'][i]),
                                          ))
                                      : week == 'Time'
                                          ? InkWell(
                                              onTap: () => showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    TimeSettingWidget(
                                                  setTime: (p0) {
                                                    setState(() {
                                                      timeTable['Time'][i] = p0;
                                                    });
                                                  },
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    timeTable['Time'][i] == ''
                                                        ? '-- : -- || -- : -- '
                                                        : timeTable['Time'][i]),
                                              ),
                                            )
                                          : SizedBox(
                                              width: 126,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  DropdownMenu(
                                                      enableFilter: true,
                                                      controller:
                                                          TextEditingController(
                                                              text: timeTable[
                                                                      week][i]
                                                                  ['teacher']),
                                                      // initialSelection: timeTable[week][i]
                                                      //     ['teacher'],
                                                      onSelected: (value) {
                                                        timeTable[week][i]
                                                            ['teacher'] = value;
                                                      },
                                                      width: 125,
                                                      hintText: 'Teacher',
                                                      inputDecorationTheme:
                                                          InputDecorationTheme(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxHeight:
                                                                          40),

                                                              // contentPadding: EdgeInsets.zero,
                                                              border:
                                                                  OutlineInputBorder(),
                                                              isDense: true),
                                                      dropdownMenuEntries: teachers
                                                          .map((e) =>
                                                              DropdownMenuEntry(
                                                                  value: e[
                                                                      'fullName'],
                                                                  label: e[
                                                                      'fullName']))
                                                          .toList()),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  DropdownButton(
                                                    isDense: true,
                                                    hint:
                                                        Text('Select Subject'),
                                                    value: timeTable[week][i]
                                                                ['subject'] ==
                                                            ''
                                                        ? null
                                                        : timeTable[week][i]
                                                            ['subject'],
                                                    items: subjects
                                                        .map((e) =>
                                                            DropdownMenuItem(
                                                                value: e,
                                                                child: Text(e)))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        timeTable[week][i]
                                                                ['subject'] =
                                                            value.toString();
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // if (!timeTable.containsKey('Period')) {
                          //   timeTable.addAll({
                          //     'Period': ['', '', '', '']
                          //   });
                          // }
                          for (var week in weeks) {
                            if (week == 'Period') {
                              timeTable['Period'].add('');
                            }
                            if (week == 'Time') {
                              timeTable[week].add('');
                            } else {
                              timeTable[week]
                                  .add({'teacher': null, 'subject': ''});
                            }

                            // print(timeTable);
                          }
                          setState(() {
                            periods++;
                          });
                        },
                        child: Icon(Icons.add_rounded),
                      ),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
        ],
      ),
    );
  }
}

class TimeSettingWidget extends StatefulWidget {
  const TimeSettingWidget({super.key, required this.setTime});
  final Function(String) setTime;
  @override
  State<TimeSettingWidget> createState() => _TimeSettingWidgetState();
}

class _TimeSettingWidgetState extends State<TimeSettingWidget> {
  String? startTime;
  String? endTime;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Start Time'),
                      SizedBox(
                        height: 15,
                      ),
                      Text(startTime.toString()),
                      IconButton(
                          onPressed: () async {
                            TimeOfDay? selectedTimes = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) => Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: child!),
                            );
                            setState(() {
                              startTime = selectedTimes!.format(context);
                            });
                          },
                          icon: Icon(
                            Icons.access_time_filled,
                            color: Colors.indigo,
                          ))
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('End Time'),
                      SizedBox(
                        height: 15,
                      ),
                      Text(endTime.toString()),
                      IconButton(
                          onPressed: () async {
                            TimeOfDay? selectedTimes = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (context, child) => Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: child!),
                            );
                            setState(() {
                              endTime = selectedTimes!.format(context);
                            });
                          },
                          icon: Icon(
                            Icons.access_time_filled,
                            color: Colors.indigo,
                          ))
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: startTime == null || endTime == null
                          ? null
                          : () {
                              widget.setTime('$startTime - $endTime');
                              Navigator.of(context).pop();
                            },
                      child: Text('Save')))
            ],
          ),
        ),
      ),
    );
  }
}
