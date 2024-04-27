import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../ip_address.dart';

class AttendanceDetails extends StatefulWidget {
  const AttendanceDetails(
      {super.key, required this.admNo, required this.schoolCode});
  final String admNo;
  final String schoolCode;

  @override
  State<AttendanceDetails> createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  late Future _getAttendance;
  // bool attendance = false;

  getMidAttendance() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse(
        '$ipv4/getMyAttendanceMid/${widget.schoolCode}/${widget.admNo}');
    var res = await client.get(url);
    print(res.body);
    Map data = jsonDecode(res.body);
    return data;
  }

  @override
  void initState() {
    _getAttendance = getMidAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
      ),
      body: Center(
          child: FutureBuilder(
        future: _getAttendance,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map student = {};
            student = snapshot.data;
            Map attendance = {};
            if (snapshot.data.containsKey('attendance')) {
              attendance = snapshot.data['attendance'];
            }
            return Column(
              children: [
                QrImageView(
                  data: widget.admNo,
                  size: 200,
                ),
                Text('Name: ${student['fullName']}'),
                Text('Adm. No.${student['admNo']}'),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Absent'),
                    Switch(
                      activeColor: Colors.green[600],
                      inactiveTrackColor: Colors.red[600],
                      value: true,
                      onChanged: (value) {},
                    ),
                    Text('Present'),
                  ],
                ),
                Container(
                  width: 700,
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
                              child: Text('Date'),
                            )),
                            TableCell(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Status'),
                            )),
                          ]),
                      for (var i in attendance.keys)
                        TableRow(children: [
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(i.toString()),
                              )),
                          TableCell(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Absent'),
                                  Switch(
                                    activeColor: Colors.green[600],
                                    inactiveTrackColor: Colors.red[600],
                                    value: attendance[i] == 'present',
                                    onChanged: (value) {
                                      setState(() {
                                        if (value) {
                                          attendance[i] = 'present';
                                        } else {
                                          attendance[i] = 'absent';
                                        }
                                      });
                                    },
                                  ),
                                  Text('Present'),
                                ],
                              ),
                            ),
                          )
                        ])
                    ],
                  ),
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
    );
  }
}
