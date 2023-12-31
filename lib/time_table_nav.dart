import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import 'ip_address.dart';

class TimeTableNav extends StatefulWidget {
  const TimeTableNav({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeTableNav> createState() => _TimeTableNavState();
}

class _TimeTableNavState extends State<TimeTableNav> {
  late Map timeTable;
  late Map teachers;
  late Future _details;
  String classTeacher = '';
  getTimeTable() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getTimeTable/common');
    var res = await client.get(url);

    Map details = jsonDecode(res.body);
    print(details);
    timeTable = details['timeTable'];
    if (details.containsKey('teachers')) {
      teachers = details['teachers'];
      classTeacher = teachers['Class Teacher'];
      teachers.remove('Class Teacher');
    }
    return true;
  }

  convertingFun(String s) {
    switch (s) {
      case '0':
        return "Time";
      case '1':
        return "Monday";
      case '2':
        return "Tuesday";
      case '3':
        return "Wednesday";
      case '4':
        return "Thursday";
      case '5':
        return "Friday";
      case '6':
        return "Saturday";
    }
  }

  @override
  void initState() {
    _details = getTimeTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black,
        title: Text('Time Table'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _details,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                    // Padding(
                    //     padding: const EdgeInsets.all(50),
                    //     child: ProfileContainer(
                    //       text: 'Class: X - A',
                    //     )),
                    Container(
                      alignment: AlignmentDirectional.center,
                      width: MediaQuery.of(context).size.width - 175,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(20)),
                              color: Colors.white, shadowColor: Colors.blue,
                              elevation: 15,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var day in timeTable.keys)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 140,
                                              child: Text(
                                                convertingFun(day).toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  top: 12,
                                                  bottom: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.indigo,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                // border: Border.all(color: Colors.white)
                                              ),
                                            ),
                                            for (var subject in timeTable[day])
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),

                                                  color: day == 'Time'
                                                      ? Colors.indigo
                                                      : Colors.indigo[100],
                                                  // border: Border.all(
                                                  //     color: Colors.black),
                                                ),
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    top: 12,
                                                    bottom: 12),
                                                width: 110,
                                                child: Text(
                                                  subject.toString(),
                                                  style: TextStyle(
                                                      color: day == 'Time'
                                                          ? Colors.white
                                                          : null,
                                                      fontSize: 18,
                                                      fontWeight: day == 'Time'
                                                          ? FontWeight.w500
                                                          : null),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Class Teacher - $classTeacher'),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.indigo[100],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  for (var teacher in teachers.entries)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RichText(
                                        text: TextSpan(
                                            //   text: '',

                                            children: [
                                              TextSpan(
                                                  text: '${teacher.key} - ',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text:
                                                      teacher.value.toString(),
                                                  style: TextStyle(
                                                    fontSize: 19,
                                                  )),
                                            ]),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
