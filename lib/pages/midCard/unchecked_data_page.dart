import 'package:flutter/material.dart';

import 'class_tab.dart';

import 'staff_tab.dart';
import 'teacher_tab.dart';

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
            menuName: 'unchecked',
          ),
          TeacherTab(
            schoolCode: widget.schoolCode,
            menuName: 'unchecked',
          ),
          StaffTab(
            schoolCode: widget.schoolCode,
            menuName: 'unchecked',
          ),
        ]),
      ),
    );
  }
}
