import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';

import '../ip_address.dart';

class StudentAttendancePeriod extends StatefulWidget {
  const StudentAttendancePeriod(
      {super.key, required this.admNo, required this.studentName});

  final String studentName;
  final String admNo;

  @override
  State<StudentAttendancePeriod> createState() =>
      _StudentAttendancePeriodState();
}

class _StudentAttendancePeriodState extends State<StudentAttendancePeriod>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Tween<double> _rotationTween = Tween<double>(begin: 0.0, end: pi);
  late Future _attendance;
  double height = 50;
  double width = 50;
  Uint8List? _imagebytes;
  DateTime? tappedDated;
  String? tappedMonth;

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

  calendar(String monthYear, List absents, List holidays, List presents,
      List mixed) {
    print(absents);
    print(presents);
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
            bool isMixed = mixed.contains('${index - skip}-$monthYear');

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
                              : isMixed
                                  ? Colors.blue
                                  : null,
                    ),
                    child: InkWell(
                      onTap: () {
                        print(monthYear);
                        tappedMonth = monthYear;
                        tappedDated = DateFormat('d-MMMM-yyyy')
                            .parse('${(index - skip)}-$monthYear');

                        _animationController.isCompleted
                            ? _animationController.reverse()
                            : _animationController.forward();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: isPresent
                                ? Border(
                                    bottom: BorderSide(
                                        color: Colors.green, width: 8))
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
      for (final value in attendance[i].values) {
        if (m == month && (value == 'absent')) {
          monthAbs++;
        }
        if (m == month && (value == 'present')) {
          monthPres++;
        }
      }
    }
    return Column(
      children: [
        Text('Attendance Count: ${monthPres + monthAbs}'),
        Text(
          'Present: $monthPres',
          style: TextStyle(color: Colors.green),
        ),
        Text(
          'Absent: $monthAbs',
          style: TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  getAttendace() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getSingleAttendancePeriod/${widget.admNo}');

    var res = await client.get(url);
    print(res.body);

    return jsonDecode(res.body);
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
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
              Map attendance = snapshot.data['attendancePeriod'];

              String today =
                  DateFormat('dd - MM - yyyy').format(DateTime.now());

              List fullAbsent = [];
              List fullPresent = [];
              List mixed = [];
              List holidays = [];
              List months = [];

              List dates = [];
              int totalAttDays = 0;
              int thisMonthPres = 0;
              int thisMonthAbs = 0;
              int totalThisMonthDays = 0;
              int presents = 0;
              int absents = 0;

              String now = DateFormat('MMMM-yyyy').format(DateTime.now());

              String todayStatus = 'null';

              for (var i in attendance.keys) {
                DateTime d = DateFormat('dd - MM - yyyy').parse(i);
                String nowMonth = DateFormat('MMMM-yyyy').format(d);

                dates.add(d);
                // print(attendance[i].values.contains('present'));
                if (!attendance[i].containsKey('status')) {
                  totalThisMonthDays++;
                } else {
                  holidays.add(DateFormat('d-MMMM-yyyy').format(d));
                }

                if (attendance[i].values.every((value) => value == 'present')) {
                  fullPresent.add(DateFormat('d-MMMM-yyyy').format(d));
                  presents = presents + (attendance[i].length) as int;
                  if (nowMonth == now) {
                    thisMonthPres =
                        thisMonthPres + (attendance[i].length) as int;
                  }
                  if (i == today) {
                    todayStatus = 'present';
                  }
                } else {
                  if (attendance[i]
                      .values
                      .every((value) => value == 'absent')) {
                    fullAbsent.add(DateFormat('d-MMMM-yyyy').format(d));
                    absents = absents + (attendance[i].length) as int;
                    if (nowMonth == now) {
                      thisMonthAbs =
                          thisMonthAbs + (attendance[i].length) as int;
                    }
                    if (i == today) {
                      todayStatus = 'absent';
                    }
                  } else {
                    mixed.add(DateFormat('d-MMMM-yyyy').format(d));
                    for (final value in attendance[i].values) {
                      if (value == 'absent') {
                        absents++;
                        if (nowMonth == now) {
                          thisMonthAbs++;
                        }
                      }
                      if (value == 'present') {
                        presents++;
                        if (nowMonth == now) {
                          thisMonthPres++;
                        }
                      }
                    }
                    if (i == today) {
                      todayStatus = 'mixed';
                    }
                  }
                }
              }

              totalAttDays = thisMonthAbs + thisMonthPres;

              int totalDays = absents + presents;

              dates.sort();
              for (DateTime date in dates) {
                months.add(DateFormat('MMMM-yyyy').format(date));
                // print(date.day);
              }

              List unique = months.toSet().toList();

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
                                  value: thisMonthAbs / totalAttDays,
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
                                  '${((thisMonthPres / totalAttDays) * 100).toStringAsFixed(2)} %'),
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
                      AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateY(_rotationTween
                                    .evaluate(_animationController)),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _animationController.value < 0.5
                                      ? Column(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Text(
                                                    //     'Working Days: $totalThisMonthDays'),
                                                    Text(
                                                        'Attendance Count: $totalThisMonthDays'),
                                                    Text(
                                                      'Present: $thisMonthPres',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                    Text(
                                                      'Absent: $thisMonthAbs',
                                                      style: TextStyle(
                                                          color: Colors.red),
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))),
                                                SizedBox(
                                                  height: height,
                                                  width: width,
                                                  child: Center(
                                                    child: Text(
                                                      'Mon',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                SizedBox(
                                                    height: height,
                                                    width: width,
                                                    child: Center(
                                                      child: Text(
                                                        'Wed',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                SizedBox(
                                                    height: height,
                                                    width: width,
                                                    child: Center(
                                                      child: Text(
                                                        'Thu',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                SizedBox(
                                                    height: height,
                                                    width: width,
                                                    child: Center(
                                                      child: Text(
                                                        'Fri',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                                SizedBox(
                                                    height: height,
                                                    width: width,
                                                    child: Center(
                                                      child: Text(
                                                        'Sat',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                            calendar(now, fullAbsent, holidays,
                                                fullPresent, mixed),
                                          ],
                                        )
                                      : SizedBox(
                                          width: 350,
                                          height: 360,
                                          child: Transform(
                                            transform: Matrix4.identity()
                                              ..rotateY(-pi)
                                              ..leftTranslate(350),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      _animationController
                                                          .reverse();
                                                    },
                                                    icon: Icon(Icons
                                                        .arrow_back_rounded)),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                for (var i in attendance[
                                                        DateFormat(
                                                                'dd - MM - yyyy')
                                                            .format(
                                                                tappedDated!)]
                                                    .keys)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 30,
                                                            bottom: 4),
                                                    child: Text(
                                                        '$i - ${attendance[DateFormat('dd - MM - yyyy').format(tappedDated!)][i]}'),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                  Divider(),
                  Text('Year Report'),
                  Divider(),
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
                                    value: absents / totalDays,
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
                                        '${((presents / totalDays) * 100).toStringAsFixed(2)} %'),
                                  ],
                                ),
                                Text(
                                  'Working Days: $totalDays',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Present Days: ${presents}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  'Absent Days: ${absents}',
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
                          AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                var rotate = Matrix4.identity()
                                  ..rotateY(_rotationTween
                                      .evaluate(_animationController));
                                return Transform(
                                  alignment: Alignment.center,
                                  transform: tappedMonth == month
                                      ? rotate
                                      : Matrix4.identity(),
                                  child: Card(
                                    color: month ==
                                            DateFormat('MMMM-yyyy')
                                                .format(DateTime.now())
                                        ? Colors.blue[50]
                                        : null,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: _animationController.value < 0.5 ||
                                              tappedMonth != month
                                          ? Column(
                                              // mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      month,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: 120,
                                                    ),
                                                    daysDetails(
                                                        month, attendance),
                                                  ],
                                                ),
                                                // Text()
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                        height: height,
                                                        width: width,
                                                        child: Center(
                                                            child: Text(
                                                          'Sun',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ))),
                                                    SizedBox(
                                                      height: height,
                                                      width: width,
                                                      child: Center(
                                                        child: Text(
                                                          'Mon',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                        height: height,
                                                        width: width,
                                                        child: Center(
                                                          child: Text(
                                                            'Wed',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                        height: height,
                                                        width: width,
                                                        child: Center(
                                                          child: Text(
                                                            'Thu',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                        height: height,
                                                        width: width,
                                                        child: Center(
                                                          child: Text(
                                                            'Fri',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                        height: height,
                                                        width: width,
                                                        child: Center(
                                                          child: Text(
                                                            'Sat',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                                calendar(
                                                    month,
                                                    fullAbsent,
                                                    holidays,
                                                    fullPresent,
                                                    mixed)

                                                // Text(getDaysinMonth(month).toString())
                                              ],
                                            )
                                          : SizedBox(
                                              width: 350,
                                              height: 360,
                                              child: tappedMonth == month
                                                  ? Transform(
                                                      transform:
                                                          Matrix4.identity()
                                                            ..rotateY(-pi)
                                                            ..leftTranslate(
                                                                350),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                _animationController
                                                                    .reverse();
                                                              },
                                                              icon: Icon(Icons
                                                                  .arrow_back_rounded)),
                                                          SizedBox(
                                                            height: 30,
                                                          ),
                                                          for (var i in attendance[
                                                                  DateFormat(
                                                                          'dd - MM - yyyy')
                                                                      .format(
                                                                          tappedDated!)]
                                                              .keys)
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 30,
                                                                      bottom:
                                                                          4),
                                                              child: Text(
                                                                  '$i - ${attendance[DateFormat('dd - MM - yyyy').format(tappedDated!)][i]}'),
                                                            ),
                                                        ],
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                    ),
                                  ),
                                );
                              })
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
