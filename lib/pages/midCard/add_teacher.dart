import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/widgets/dropdown_widget.dart';
import 'package:school_management/widgets/textfield_widget.dart';

import '../../ip_address.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mob = TextEditingController();
  List selectedClasses = [];

  late Future _getClasses;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMidClasses/${widget.schoolCode}');
    var res = await client.get(url);
    List data = jsonDecode(res.body);
    return data;
  }

  getTeacherMid() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getTeacherMid/${widget.schoolCode}');
    var res = await client.get(url);

    List staffs = json.decode(res.body);
    print(staffs);
    return staffs;
  }

  addTeacherMid() async {
    if (_formKey.currentState!.validate()) {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/addStaffMid');
      var res = await client.post(url, body: {
        'schoolCode': widget.schoolCode,
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'mob': mob.text.trim(),
        'password': mob.text.trim(),
        'role': 'midTeacher',
        'myClasses': jsonEncode(selectedClasses),
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
      });

      if (res.body == 'true') {
        setState(() {
          firstName.clear();
          lastName.clear();
          mob.clear();
          selectedClasses = [];
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
  void initState() {
    _getClasses = getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Teacher'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: _getClasses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List classes = [];
                classes = snapshot.data.map((e) => e['title']).toList();
                return Form(
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
                            label: 'First Name',
                            controller: firstName,
                            isEdit: true),
                        SizedBox(
                          height: 15,
                        ),
                        TextFieldWidget(
                            isValidted: true,
                            label: 'Last Name',
                            controller: lastName,
                            isEdit: true),
                        SizedBox(
                          height: 15,
                        ),
                        TextFieldWidget(
                            label: 'Mobile', controller: mob, isEdit: true),
                        SizedBox(
                          height: 15,
                        ),
                        DropDownWidget(
                            items: classes,
                            title: 'Select Class',
                            isEdit: true,
                            callBack: (p0) {
                              setState(() {
                                if (!selectedClasses.contains(p0)) {
                                  selectedClasses.add(p0);
                                }
                              });
                            },
                            selected: null),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (String i in selectedClasses)
                              OutlinedButton.icon(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      selectedClasses.remove(i);
                                    });
                                  },
                                  label: Text(i))
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: addTeacherMid,
                            child: Text('Add Teacher'))
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
