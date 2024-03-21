import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';

import '../ip_address.dart';

class StudentAttendance extends StatefulWidget {
  const StudentAttendance(
      {super.key, required this.studentName, required this.admNo});
  final String studentName;
  final String admNo;

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  // late AnimationController _animationController;
  // final Tween<double> _rotationTween = Tween<double>(begin: 0.0, end: pi);

  late Future _attendance;
  double height = 50;
  double width = 50;
  Uint8List? _imagebytes;
  // DateTime? tappedDated;

  getProfilePic() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getProfilePic/${widget.admNo}');
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
                        child: Text(
                          (index - skip).toString(),
                          style: TextStyle(
                              color: index % 7 == 1
                                  ? Colors.red
                                  : isAbsent
                                      ? Colors.white
                                      : null),
                        ),
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

  daysDetails(String month, Map attendance) {
    int monthAbs = 0;
    int monthPres = 0;
    for (var i in attendance.keys) {
      DateTime d = DateFormat('dd - MM - yyyy').parse(i);
      String m = DateFormat('MMMM-yyyy').format(d);
      if (m == month && (attendance[i]['status'] == 'absent')) {
        monthAbs++;
      }
      if (m == month && (attendance[i]['status'] == 'present')) {
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
    var url = Uri.parse('$ipv4/getSingleAttendance/${widget.admNo}');

    var res = await client.get(url);
    print(res.body);

    return jsonDecode(res.body);
  }

  @override
  void initState() {
    // _animationController = AnimationController(
    //   vsync: this,
    //   duration: Duration(milliseconds: 500),
    // );
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
              Map attendance = snapshot.data['attendance'];
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
              for (var i in attendance.keys) {
                DateTime d = DateFormat('dd - MM - yyyy').parse(i);
                String nowMonth = DateFormat('MMMM-yyyy').format(d);

                dates.add(d);
                if (attendance[i]['status'] == 'absent') {
                  absents.add(DateFormat('d-MMMM-yyyy').format(d));
                  if (nowMonth == now) {
                    thisMonthAbs++;
                  }
                }
                if (attendance[i]['status'] == 'holiday') {
                  holidays.add(DateFormat('d-MMMM-yyyy').format(d));
                }
                if (attendance[i]['status'] == 'present') {
                  presents.add(DateFormat('d-MMMM-yyyy').format(d));
                  if (nowMonth == now) {
                    thisMonthPres++;
                  }
                }
                if (i == today) {
                  todayStatus = attendance[i]['status'];
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
             

              return Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      // AnimatedContainer(duration: Duration(milliseconds: 500,),transform: ),

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
                                        Text(
                                            'Working Days: $totalThisMonthDays'),
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
                            )),
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
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
