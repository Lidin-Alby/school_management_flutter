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
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
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
    if (_formKey.currentState!.validate()) {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/addStaffMid');
      var res = await client.post(url, body: {
        'schoolCode': widget.schoolCode,
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'mob': mob.text.trim(),
        'password': mob.text.trim(),
        'role': role.text.trim(),
        'myClasses': jsonEncode([]),
        'subCaste': '',
        'email': '',
        'rfid': '',
        'address': '',
        'fatherOrHusName': '',
        'religion': '',
        'caste': '',
        'gender': '',
        'dob': '',
        'bloodGroup': '',
        'qualification': '',
        'panNo': '',
        'dlValidity': '',
        'dlNo': '',
        'aadhaarNo': '',
        'ready': false.toString()
      });

      if (res.body == 'true') {
        setState(() {
          firstName.clear();
          lastName.clear();
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
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo, width: 3),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldWidget(
                          isValidted: true,
                          label: 'Full Name',
                          controller: firstName,
                          isEdit: true),
                      SizedBox(
                        height: 15,
                      ),
                      // TextFieldWidget(
                      //     label: 'Last Name',
                      //     controller: lastName,
                      //     isEdit: true),

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
                ),
              )),
        ));
  }
}
