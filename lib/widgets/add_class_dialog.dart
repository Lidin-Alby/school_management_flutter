import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

class AddClassDialog extends StatefulWidget {
  const AddClassDialog(
      {super.key, required this.schoolCode, required this.callback});
  final String schoolCode;
  final VoidCallback callback;

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  TextEditingController className = TextEditingController();
  TextEditingController section = TextEditingController();
  bool validate = false;

  List teachers = [];
  TextEditingController teacherName = TextEditingController();
  getTeachers() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getTeachers');
    var res = await client.get(url);

    teachers = jsonDecode(res.body);
    print(teachers);
    setState(() {});
  }

  @override
  void initState() {
    getTeachers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 400,
            child: TextField(
              controller: className,
              decoration: InputDecoration(
                hintText: 'Class / Department',
                errorText: validate ? 'This Field is required' : null,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 400,
            child: TextField(
              controller: section,
              decoration: InputDecoration(
                hintText: 'Section',
                errorText: validate ? 'This Field is required' : null,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          DropdownMenu(
              enableFilter: true,
              controller: teacherName,
              // initialSelection: timeTable[week][i]
              //     ['teacher'],

              width: 350,
              hintText: 'Teacher',
              inputDecorationTheme: InputDecorationTheme(
                  constraints: BoxConstraints(maxHeight: 40),

                  // contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(),
                  isDense: true),
              dropdownMenuEntries: teachers
                  .map((e) => DropdownMenuEntry(
                      value: e['fullName'], label: e['fullName']))
                  .toList()),
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  section.text.trim().isEmpty || className.text.trim().isEmpty
                      ? validate = true
                      : validate = false;
                });
                if (!validate) {
                  var url = Uri.parse('$ipv4/addClassOrBranch');
                  var res = await http.post(url, body: {
                    'schoolCode': widget.schoolCode.toString(),
                    'title': '${className.text.trim()}-${section.text.trim()}',
                    'className': className.text.trim(),
                    'sec': section.text.trim()
                  });
                  if (res.body == 'true') {
                    print('done');
                    className.clear();
                    section.clear();
                    widget.callback();
                  }
                }
              },
              child: Text('Add'),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
