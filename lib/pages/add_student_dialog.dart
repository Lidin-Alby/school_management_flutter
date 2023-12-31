import 'package:flutter/material.dart';
import 'package:school_management/widgets/documents_student.dart';

import '../widgets/contact_info.dart';

import '../widgets/parent_info_student.dart';
import '../widgets/personal_info_student.dart';

class AddNewStudent extends StatefulWidget {
  const AddNewStudent(
      {super.key, required this.refresh, required this.currAdmNo});

  final VoidCallback refresh;
  final String? currAdmNo;
  @override
  State<AddNewStudent> createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {
  String selectedTab = 'personal';
  late String admNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:
          // Dialog(
          //   elevation: 1,
          //   child: Padding(
          //     padding: const EdgeInsets.all(25),
          //     child: SizedBox(
          //       width: 1300,
          //       child:
          Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'Last Adm No.: ${widget.currAdmNo}',
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                width: 30,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.refresh();
                },
                icon: Icon(Icons.close_rounded),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: selectedTab == 'personal'
                          ? OutlinedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white)
                          : null,
                      onPressed: () {},
                      child: Text('Personal Info')),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                      style: selectedTab == 'parent'
                          ? OutlinedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white)
                          : null,
                      onPressed: () {},
                      child: Text('Parent Info')),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                      style: selectedTab == 'contact'
                          ? OutlinedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white)
                          : null,
                      onPressed: () {},
                      child: Text('Contact Info')),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: selectedTab == 'documents'
                        ? OutlinedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white)
                        : null,
                    onPressed: () {},
                    child: Text('Documents'),
                  ),
                ],
              ),
            ),
          ),
          if (selectedTab == 'personal')
            Container(
                height: MediaQuery.of(context).size.height - 200,
                width: 1300,
                padding: EdgeInsets.fromLTRB(20, 20, 0, 3),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: PersonalInfo(
                    isEdit: true,
                    admNo: '',
                    callback: (p0) {
                      admNo = p0;
                      setState(() {
                        selectedTab = 'parent';
                      });
                    },
                  ),
                )),
          if (selectedTab == 'parent')
            Container(
                height: MediaQuery.of(context).size.height - 200,
                width: 1300,
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 4),
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: ParentInfo(
                    isEdit: true,
                    admNo: admNo,
                    callback: () => setState(() {
                      selectedTab = 'contact';
                    }),
                  ),
                )),
          if (selectedTab == 'contact')
            Container(
              height: MediaQuery.of(context).size.height - 200,
              width: 1300,
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo, width: 4),
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: ContactInfo(
                  isEdit: true,
                  admNo: admNo,
                  callback: () => setState(() {
                    selectedTab = 'documents';
                  }),
                ),
              ),
            ),
          if (selectedTab == 'documents')
            Container(
              height: MediaQuery.of(context).size.height - 200,
              width: 1300,
              padding: EdgeInsets.fromLTRB(20, 20, 0, 3),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo, width: 4),
                  borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: StudentDocumet(
                  admNo: admNo,
                  isEdit: true,
                  callback: () => Navigator.of(context).pop(),
                ),
              ),
            ),
        ],
      ),
    );
    //     ),
    //   ),
    // );
  }
}
