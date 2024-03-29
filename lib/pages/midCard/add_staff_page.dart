import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../../ip_address.dart';
import '../../widgets/textfield_widget.dart';

class AddStaffPage extends StatefulWidget {
  const AddStaffPage({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<AddStaffPage> createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  TextEditingController fullName = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController role = TextEditingController();
  // List selectedClasses = [];

  // late Future _getClasses;

  // getClass() async {
  //   var client = BrowserClient()..withCredentials = true;
  //   var url = Uri.parse('$ipv4/getMidClasses/${widget.schoolCode}');
  //   var res = await client.get(url);
  //   List data = jsonDecode(res.body);
  //   return data;
  // }

  // getTeacherMid() async {
  //   var client = BrowserClient()..withCredentials = true;
  //   var url = Uri.parse('$ipv4/getTeacherMid/${widget.schoolCode}');
  //   var res = await client.get(url);

  //   List staffs = json.decode(res.body);
  //   print(staffs);
  //   return staffs;
  // }

  addStaffMid() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addStaffMid');
    var res = await client.post(url, body: {
      'schoolCode': widget.schoolCode,
      'fullName': fullName.text.trim(),
      'mob': mob.text.trim(),
      'password': mob.text.trim(),
      'role': role.text.trim(),
      'myClasses': jsonEncode([])
    });

    if (res.body == 'true') {
      setState(() {
        fullName.clear();
        mob.clear();
        role.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            content: const Row(
              children: [
                Text(
                  'Added Sucessfully',
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Staff'),
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 3),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFieldWidget(
                        label: 'Full Name', controller: fullName, isEdit: true),
                    SizedBox(
                      height: 15,
                    ),
                    TextFieldWidget(
                        label: 'Mobile', controller: mob, isEdit: true),
                    SizedBox(
                      height: 15,
                    ),
                    TextFieldWidget(
                        label: 'Designation', controller: role, isEdit: true),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: addStaffMid, child: Text('Add Staff'))
                  ],
                ),
              )),
        ));
  }
}
