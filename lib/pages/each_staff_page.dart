import 'package:flutter/material.dart';
import 'package:school_management/widgets/account_info_staff.dart';
import 'package:school_management/widgets/contact_info_staff.dart';
import 'package:school_management/widgets/documents_staff.dart';
import 'package:school_management/widgets/personal_info_staff.dart';

class EachStaff extends StatefulWidget {
  const EachStaff({super.key, required this.mobNo});
  final String mobNo;
  @override
  State<EachStaff> createState() => _EachStaffState();
}

class _EachStaffState extends State<EachStaff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'Personal Info',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Divider(),
              ),
              PersonalInfoStaff(
                mob: widget.mobNo,
                isEdit: false,
                callback: (p0) {},
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  'Account Info',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Divider(),
              ),
              AccountInfoStaff(
                callback: () {},
                mob: widget.mobNo,
                isEdit: false,
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
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Divider(),
              ),
              ContactInfoStaff(
                isEdit: false,
                mob: widget.mobNo,
                callback: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'Documents',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Divider(),
              ),
              StaffDocument(
                mob: widget.mobNo,
                isEdit: false,
                refresh: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}

//  Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Container(
          //         padding: EdgeInsets.all(8),
          //         decoration: BoxDecoration(
          //             color: Colors.indigo,
          //             borderRadius: BorderRadius.circular(6)),
          //         child: Text(
          //           'Personal Info',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //       SizedBox(
          //         height: 3,
          //       ),
          //       PersonalInfoStaff(
          //         mob: widget.mobNo,
          //         isEdit: false,
          //         callback: (p0) {},
          //       ),
          //       SizedBox(
          //         height: 30,
          //       ),
                
          //     ],
          //   ),