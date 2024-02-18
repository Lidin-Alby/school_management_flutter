import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';

import '../ip_address.dart';

class Remarks extends StatefulWidget {
  const Remarks({
    required this.classTitle,
    required this.subject,
    super.key,
  });
  final String classTitle;
  final String subject;

  @override
  State<Remarks> createState() => _RemarksState();
}

class _RemarksState extends State<Remarks> {
  late String schoolCode;
  late Future _remarks;

  getRemarks() async {
    var client = BrowserClient()..withCredentials = true;
    var url =
        Uri.parse('$ipv4/getRemarks/${widget.classTitle}/${widget.subject}');

    var res = await client.get(url);

    print(res.body);

    List data = jsonDecode(res.body);
    schoolCode = data.last;
    data.removeLast();
    return data;
  }

  @override
  void initState() {
    _remarks = getRemarks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: ElevatedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddRemark(
                schoolCode: schoolCode,
                subject: widget.subject,
                classTitle: widget.classTitle,
                refresh: () {
                  setState(() {
                    _remarks = getRemarks();
                  });
                },
              ),
            ),
            label: Text('Give Remark'),
            icon: Icon(Icons.add_rounded),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FutureBuilder(
          future: _remarks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.isEmpty
                  ? Text('Empty')
                  : Column(
                      children: [
                        for (Map remark in snapshot.data)
                          Column(
                            children: [
                              ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(remark['fullName']),
                                ),
                                subtitle: Text(remark['content']),
                                trailing: Text(
                                  DateFormat('dd-MM-yyyy')
                                      .format(DateTime.parse(remark['date'])),
                                ),
                              ),
                              Divider()
                            ],
                          ),
                      ],
                    );
            } else {
              return CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}

class AddRemark extends StatefulWidget {
  const AddRemark({
    required this.classTitle,
    required this.subject,
    required this.schoolCode,
    required this.refresh,
    super.key,
  });
  final String classTitle;
  final String subject;
  final String schoolCode;
  final VoidCallback refresh;

  @override
  State<AddRemark> createState() => _AddRemarkState();
}

class _AddRemarkState extends State<AddRemark> {
  List students = [];
  String? selectedStudent;
  TextEditingController remarkController = TextEditingController();
  String? fullName;

  getClassStudents() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassStudents/${widget.classTitle}');

    var res = await client.get(url);

    print(res.body);

    setState(() {
      students = jsonDecode(res.body);
    });
  }

  addRemarks() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addRemark');

    var res = await client.post(url, body: {
      'schoolCode': widget.schoolCode,
      'subject': widget.subject,
      'classTitle': widget.classTitle,
      'date': DateTime.now().toString(),
      'content': remarkController.text,
      'admNo': selectedStudent,
      'fullName': fullName
    });

    print(res.body);
    if (res.body == 'true') {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    getClassStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 500,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton(
                    isDense: true,
                    hint: Text('Select Student'),
                    value: selectedStudent,
                    items: students.map((e) {
                      return DropdownMenuItem(
                        child: Text(e['fullName']),
                        value: e['admNo'],
                      );
                    }).toList(),
                    onChanged: (value) {
                      for (Map e in students) {
                        if (e['admNo'] == value) {
                          fullName = e['fullName'];
                        }
                      }
                      setState(() {
                        print(fullName);
                        selectedStudent = value.toString();
                      });
                    }),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Remark:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  maxLines: 10,
                  controller: remarkController,
                  decoration: InputDecoration(
                      hintText: 'Write your remark here...',
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ElevatedButton(
                        onPressed: addRemarks, child: Text('Submit')))
              ]),
        ),
      ),
    );
  }
}
