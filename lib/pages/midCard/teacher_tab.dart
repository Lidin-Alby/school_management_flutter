import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../../ip_address.dart';
import 'each_staff_page.dart';

class TeacherTab extends StatefulWidget {
  const TeacherTab(
      {super.key, required this.schoolCode, required this.menuName});

  final String schoolCode;
  final String menuName;

  @override
  State<TeacherTab> createState() => _TeacherTabState();
}

class _TeacherTabState extends State<TeacherTab> {
  late Future _getTeachers;
  getTeachersMid() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMidTeachers/${widget.schoolCode}/teacher');
    var res = await client.get(url);
    List data = jsonDecode(res.body);
    print(data);

    return data;
  }

  @override
  void initState() {
    _getTeachers = getTeachersMid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getTeachers,
      builder: (context, snapshot) {
        List teachers = [];
        if (snapshot.hasData) {
          teachers = snapshot.data;
          return ListView.builder(
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                if (widget.menuName == 'print'
                    ? teachers[index]['ready']
                    : !teachers[index]['ready']) {
                  return Card(
                    child: ListTile(
                      title: Text(teachers[index]['fullName']),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EachStaffPage(
                          schoolCode: widget.schoolCode,
                          mob: teachers[index]['mob'],
                          isTeacher: true,
                          refresh: () {
                            setState(() {
                              _getTeachers = getTeachersMid();
                            });
                          },
                        ),
                      )),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }
              // : SizedBox(),
              );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
