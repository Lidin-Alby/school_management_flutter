import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../../ip_address.dart';
import 'each_staff_page.dart';

class StaffTab extends StatefulWidget {
  const StaffTab({super.key, required this.schoolCode, required this.menuName});
  final String schoolCode;
  final String menuName;

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
            itemBuilder: (context, index) {
              if (widget.menuName == 'print'
                  ? staffs[index]['ready']
                  : !staffs[index]['ready']) {
                return Card(
                  child: ListTile(
                    title: Text(staffs[index]['fullName']),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EachStaffPage(
                          schoolCode: widget.schoolCode,
                          mob: staffs[index]['mob'],
                          isTeacher: false,
                          refresh: () {
                            setState(() {
                              _getStaff = getStaffsMid();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
