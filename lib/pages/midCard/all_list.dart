import 'package:flutter/material.dart';

import 'class_tab.dart';
import 'staff_tab.dart';
import 'teacher_tab.dart';

class ListAll extends StatelessWidget {
  const ListAll({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('List'),
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
            menuName: 'list',
          ),
          TeacherTab(
            schoolCode: schoolCode,
            menuName: 'list',
          ),
          StaffTab(
            schoolCode: schoolCode,
            menuName: 'list',
          ),
        ]),
      ),
    );
  }
}
