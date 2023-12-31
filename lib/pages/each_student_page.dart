import 'package:flutter/material.dart';
import 'package:school_management/widgets/documents_student.dart';

import '../widgets/contact_info.dart';
import '../widgets/parent_info_student.dart';
import '../widgets/personal_info_student.dart';

class EachStudent extends StatefulWidget {
  const EachStudent({super.key, required this.admNo});
  final String admNo;

  @override
  State<EachStudent> createState() => _EachStudentState();
}

class _EachStudentState extends State<EachStudent> {
  bool isEdit = false;
  @override
  Widget build(BuildContext context) {
    print(widget.admNo);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Personal Info',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 3),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: PersonalInfo(
                  isEdit: false,
                  admNo: widget.admNo,
                  callback: (p0) {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Parent Info',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: ParentInfo(
                  isEdit: false,
                  admNo: widget.admNo,
                  callback: () {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Contact Info',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 3),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: ContactInfo(
                  isEdit: false,
                  admNo: widget.admNo,
                  callback: () {},
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Documents',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: StudentDocumet(
                  isEdit: false,
                  admNo: widget.admNo,
                  callback: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
