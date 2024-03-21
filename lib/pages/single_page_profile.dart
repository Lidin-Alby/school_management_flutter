import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../ip_address.dart';

class SinglePageProfile extends StatefulWidget {
  const SinglePageProfile(
      {super.key, required this.schoolCode, required this.admNo});
  final String schoolCode;
  final String admNo;

  @override
  State<SinglePageProfile> createState() => _SinglePageProfileState();
}

class _SinglePageProfileState extends State<SinglePageProfile> {
  late Future _getDetails;
  late Future _schoolDetails;
  late Future _getLogo;
  late Future _getPic;
  late Future _getAttendance;
  late Future _getHomeworks;
  late String classTitle;
  bool loaded = false;
  String thisDay = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // getProfilePic() async {
  //   var client = BrowserClient()..withCredentials = true;
  //   var url = Uri.parse('$ipv4/getProfilePic/${admNo.text}');
  //   var response = await client.get(url);

  //   if (response.body == 'false') {
  //     _imagebytes = null;
  //   } else {
  //     setState(() {
  //       _imagebytes = response.bodyBytes;
  //     });
  //   }
  // }

  Future getStudentDetails() async {
    print('hello');
    // var client = BrowserClient()..withCredentials = true;
    // getProfilePic();

    var url = Uri.parse('$ipv4/getSingle/${widget.schoolCode}/${widget.admNo}');

    var response = await http.get(url);

    Map data = jsonDecode(response.body);
    print(data);
    return data;
  }

  Future getSchoolDetails() async {
    var url = Uri.parse('$ipv4/MyschoolData/${widget.schoolCode}');

    var response = await http.get(url);

    Map data = jsonDecode(response.body);
    print(data);
    return data;
  }

  getImg(String fileName) async {
    var url2 = Uri.parse('$ipv4/img/${widget.schoolCode}/$fileName');
    var client = BrowserClient()..withCredentials = true;
    var response2 = await client.get(url2);

    return (response2.bodyBytes);
  }

  getAttendace() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse(
        '$ipv4/getSingleAttendanceOpen/${widget.schoolCode}/${widget.admNo}');

    var res = await client.get(url);
    print(res.body);

    return jsonDecode(res.body);
  }

  getHomework() async {
    var client = BrowserClient()..withCredentials = true;
    var url =
        Uri.parse('$ipv4/getHomeworksOpen/${widget.schoolCode}/$classTitle');

    var res = await client.get(url);
    print(res.body);
    setState(() {
      loaded = true;
    });

    return jsonDecode(res.body);
  }

  @override
  void initState() {
    _getDetails = getStudentDetails();
    _schoolDetails = getSchoolDetails();
    _getAttendance = getAttendace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.indigo[50],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FutureBuilder(
                  future: _schoolDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map schoolDeails = snapshot.data;

                      _getLogo = getImg(schoolDeails['adminLogo']);
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                future: _getLogo,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(
                                          snapshot.data as Uint8List),
                                    );
                                  } else {
                                    return Icon(Icons.error_outline_rounded);
                                  }
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Text(
                                    schoolDeails['schoolName'],
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(schoolDeails['schoolAddress']),
                                  Text(
                                      '${schoolDeails['schoolPhone']}, ${schoolDeails['schoolMail']}'),
                                ],
                              ),
                            ],
                          )
                        ],
                      );
                    } else
                      return SizedBox();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Wrap(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: _getDetails,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map student = snapshot.data;
                          classTitle = student['classTitle'];
                          if (!loaded) {
                            _getHomeworks = getHomework();
                          }
                          _getPic = getImg(student['profilePic']);
                          return Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(10)),
                                            color: Colors.indigo[900],
                                          ),
                                          width: width > 860 ? 400 : width,
                                          height: 150,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                          ),
                                          width: 400,
                                          height: 150,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        FutureBuilder(
                                          future: _getPic,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 73,
                                                child: CircleAvatar(
                                                  radius: 70,
                                                  backgroundImage: MemoryImage(
                                                      snapshot.data
                                                          as Uint8List),
                                                ),
                                              );
                                            } else {
                                              return Icon(
                                                  Icons.error_outline_rounded);
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              student['fullName'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(student['classTitle']),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(student['admNo'])
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  margin: EdgeInsets.all(8),
                                  width: width > 860 ? 384 : width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.indigo.shade900,
                                          width: 3),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'More Details',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.indigo),
                                      ),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_month),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Date of Birth:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Text(student['dob']),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.person_rounded),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Father\'s Name:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Text(student['fatherName']),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.person_2_rounded),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Mother\'s Name:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Text(student['motherName']),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(Icons.phone),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Father\'s Mobile:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Text(
                                            '${student['fatherMobNo']}, ${student['fatherWhatsApp']}'),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.phone),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Mother\'s Mobile:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Text(
                                            '${student['motherMobNo']}, ${student['motherWhatsApp']}'),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(Icons.home_rounded),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Address:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35),
                                        child: Text(
                                            '${student['perAddressLine1']},\n${student['perAddressLine2']},\n${student['perAddressLine3']} - ${student['perPincode']}'),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    Column(
                      children: [
                        FutureBuilder(
                          future: _getAttendance,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.containsKey('attendance')) {
                                Map attendance = snapshot.data['attendance'];

                                String today = DateFormat('dd - MM - yyyy')
                                    .format(DateTime.now());
                                List absents = [];
                                // List holidays = [];
                                // List months = [];
                                List presents = [];
                                List dates = [];
                                int thisMonthPres = 0;
                                int thisMonthAbs = 0;
                                String now = DateFormat('MMMM-yyyy')
                                    .format(DateTime.now());

                                String todayStatus = 'null';
                                for (var i in attendance.keys) {
                                  DateTime d =
                                      DateFormat('dd - MM - yyyy').parse(i);
                                  String nowMonth =
                                      DateFormat('MMMM-yyyy').format(d);

                                  dates.add(d);
                                  if (attendance[i]['status'] == 'absent') {
                                    absents.add(
                                        DateFormat('d-MMMM-yyyy').format(d));
                                    if (nowMonth == now) {
                                      thisMonthAbs++;
                                    }
                                  }
                                  if (attendance[i]['status'] == 'present') {
                                    presents.add(
                                        DateFormat('d-MMMM-yyyy').format(d));
                                    if (nowMonth == now) {
                                      thisMonthPres++;
                                    }
                                  }
                                  if (i == today) {
                                    todayStatus = attendance[i]['status'];
                                  }
                                }
                                int totalThisMonthDays =
                                    thisMonthAbs + thisMonthPres;
                                int totalDays =
                                    absents.length + presents.length;
                                return Card(
                                  child: Container(
                                    width: width > 860 ? width - 450 : width,
                                    height: 284,
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.indigo.shade900,
                                            width: 3),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Attendance Report',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                              color: Colors.indigo),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'This Month',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    '${((thisMonthPres / totalThisMonthDays) * 100).toStringAsFixed(2)} %'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Overall',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                SizedBox(
                                                  width: 75,
                                                  height: 75,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 25,
                                                    value: absents.length /
                                                        totalDays,
                                                    color: Colors.red,
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Text(
                                                    '${((presents.length / totalDays) * 100).toStringAsFixed(2)} %'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  'Today:',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(todayStatus.toUpperCase()),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return SizedBox();
                            }
                          },
                        ),
                        if (loaded)
                          FutureBuilder(
                            future: _getHomeworks,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data.containsKey('homeworks')) {
                                  Map homeworks = snapshot.data['homeworks'];
                                  return Card(
                                    child: Container(
                                      width: width > 860 ? width - 450 : width,
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.indigo.shade900,
                                            width: 3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Homeworks',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                color: Colors.indigo),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          for (var i in homeworks.keys)
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    i,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
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
                                                                color: Colors
                                                                    .orange
                                                                    .shade50),
                                                            children: [
                                                              TableCell(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                    'Title'),
                                                              )),
                                                              TableCell(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                    'DueDate'),
                                                              ))
                                                            ]),
                                                        for (Map j
                                                            in homeworks[i])
                                                          if (thisDay ==
                                                              DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(DateTime
                                                                      .parse(j[
                                                                          'uploadDate'])))
                                                            TableRow(children: [
                                                              TableCell(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                    j['title']),
                                                              )),
                                                              TableCell(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(DateFormat(
                                                                        'dd - MM - yyyy')
                                                                    .format(DateTime
                                                                        .parse(j[
                                                                            'dueDate']))),
                                                              ))
                                                            ])
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  )
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox();
                                }
                              } else {
                                return SizedBox();
                              }
                            },
                          )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
