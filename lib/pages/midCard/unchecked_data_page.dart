import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/pages/midCard/each_student_page.dart';

import '../../ip_address.dart';
import 'each_staff_page.dart';

class UncheckedDataPage extends StatefulWidget {
  const UncheckedDataPage({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<UncheckedDataPage> createState() => _UncheckedDataPageState();
}

class _UncheckedDataPageState extends State<UncheckedDataPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Unchecked Data'),
          bottom: TabBar(tabs: [
            Tab(
              child: Text('Class'),
            ),
            Tab(
              child: Text('Teachers'),
            ),
            Tab(
              child: Text('Staff'),
            ),
          ]),
        ),
        body: TabBarView(children: [
          ClassTab(
            schoolCode: widget.schoolCode,
          ),
          TeacherTab(
            schoolCode: widget.schoolCode,
          ),
          StaffTab(schoolCode: widget.schoolCode),
        ]),
      ),
    );
  }
}

class StaffTab extends StatefulWidget {
  const StaffTab({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends State<StaffTab> {
  late Future _getStaff;
  getStaffsMid() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMidTeachers/${widget.schoolCode}/other');
    var res = await client.get(url);
    List data = jsonDecode(res.body);
    print(data);

    return data;
  }

  @override
  void initState() {
    _getStaff = getStaffsMid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStaff,
      builder: (context, snapshot) {
        List staffs = [];
        if (snapshot.hasData) {
          staffs = snapshot.data;
          return ListView.builder(
            itemCount: staffs.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(staffs[index]['fullName']),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EachStaffPage(
                      schoolCode: widget.schoolCode,
                      mob: staffs[index]['mob'],
                      isTeacher: false,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class TeacherTab extends StatefulWidget {
  const TeacherTab({super.key, required this.schoolCode});

  final String schoolCode;

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
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(teachers[index]['fullName']),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EachStaffPage(
                    schoolCode: widget.schoolCode,
                    mob: teachers[index]['mob'],
                    isTeacher: true,
                  ),
                )),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ClassTab extends StatefulWidget {
  const ClassTab({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<ClassTab> createState() => _ClassTabState();
}

class _ClassTabState extends State<ClassTab> {
  late Future _getClasses;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMidClasses/${widget.schoolCode}');
    var res = await client.get(url);
    List data = jsonDecode(res.body);

    return data;
  }

  @override
  void initState() {
    _getClasses = getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getClasses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List classes = snapshot.data;
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) => Card(
                child: ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EachClassPage(
                  schoolCode: widget.schoolCode,
                  classTitle: classes[index]['title'],
                ),
              )),
              title: Text(classes[index]['title']),
            )),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class EachClassPage extends StatefulWidget {
  const EachClassPage(
      {super.key, required this.schoolCode, required this.classTitle});
  final String schoolCode;
  final String classTitle;

  @override
  State<EachClassPage> createState() => _EachClassPageState();
}

class _EachClassPageState extends State<EachClassPage> {
  late Future _getStudents;

  getStudentsEachClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse(
        '$ipv4/eachClassMid/${widget.schoolCode}/${widget.classTitle}');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List data = jsonDecode(res.body);

    return data;
  }

  @override
  void initState() {
    _getStudents = getStudentsEachClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.classTitle),
        ),
        body: FutureBuilder(
          future: _getStudents,
          builder: (context, snapshot) {
            List students = [];
            if (snapshot.hasData) {
              students = snapshot.data;
              return ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      size: 40,
                    ),
                    title: Text(students[index]['fullName']),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EachStudentPage(
                          schoolCode: widget.schoolCode,
                          admNo: students[index]['admNo'],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }
}
