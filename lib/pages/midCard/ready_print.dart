import 'package:flutter/material.dart';

import 'class_tab.dart';
import 'staff_tab.dart';
import 'teacher_tab.dart';

class ReadyPrintPage extends StatelessWidget {
  const ReadyPrintPage({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ready To Print'),
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
            schoolCode: schoolCode,
            menuName: 'print',
          ),
          TeacherTab(
            schoolCode: schoolCode,
            menuName: 'print',
          ),
          StaffTab(
            schoolCode: schoolCode,
            menuName: 'print',
          ),
        ]),
      ),
    );
  }
}
