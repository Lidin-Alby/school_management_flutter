import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';
import '../widgets/add_class_dialog.dart';

class ClassManagement extends StatefulWidget {
  const ClassManagement({super.key});

  @override
  State<ClassManagement> createState() => _ClassManagementState();
}

class _ClassManagementState extends State<ClassManagement> {
  late Future _loadData;
  String? schoolCode;
  bool isEdit = false;
  TextEditingController className = TextEditingController();
  TextEditingController section = TextEditingController();
  bool validate = false;
  List teachers = [];
  Map savedTeachers = {};
  TextEditingController teacherName = TextEditingController();
  getTeachers() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getTeachers');
    var res = await client.get(url);

    teachers = jsonDecode(res.body);
    print(teachers);
    setState(() {});
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    List data = jsonDecode(res.body);

    getTeachers();

    return data;
  }

  updateClassTeacher() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/updateClassTeacher');
    var res = await client.post(url, body: savedTeachers);
    if (res.body == 'true') {
      print(true);
      setState(() {
        isEdit = false;
      });
    }
  }

  @override
  void initState() {
    _loadData = getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  style: IconButton.styleFrom(padding: EdgeInsets.all(2)),
                  padding: EdgeInsets.all(2),
                  onPressed: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                  },
                  icon: Icon(Icons.edit),
                ),
                if (isEdit)
                  ElevatedButton(
                      onPressed: updateClassTeacher, child: Text('Save')),
                if (width < 750)
                  ElevatedButton.icon(
                      onPressed: () => showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            context: context,
                            builder: (context) => AddClassDialog(
                              schoolCode: schoolCode!,
                              callback: () => setState(() {
                                _loadData = getClass();
                              }),
                            ),
                          ),
                      icon: Icon(Icons.add_rounded),
                      label: Text('Class / Departemnt')),
              ],
            ),
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (width > 750)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: className,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Class / Departmrnt',
                              errorText:
                                  validate ? 'This Field is required' : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: section,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Section',
                              errorText:
                                  validate ? 'This Field is required' : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownMenu(
                            enableFilter: true,
                            controller: teacherName,
                            // initialSelection: timeTable[week][i]
                            //     ['teacher'],

                            width: 300,
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
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              section.text.trim().isEmpty ||
                                      className.text.trim().isEmpty
                                  ? validate = true
                                  : validate = false;
                            });
                            if (!validate) {
                              var url = Uri.parse('$ipv4/addClassOrBranch');
                              var res = await http.post(url, body: {
                                'schoolCode': schoolCode.toString(),
                                'title':
                                    '${className.text.trim()}-${section.text.trim()}',
                                'className': className.text.trim(),
                                'sec': section.text.trim()
                              });
                              if (res.body == 'true') {
                                print('done');
                                className.clear();
                                section.clear();
                                setState(() {
                                  _loadData = getClass();
                                });
                              }
                            }
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: FutureBuilder(
                  future: _loadData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.last.isNotEmpty) {
                        schoolCode = snapshot.data.last['schoolCode'];
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        child: Wrap(
                          spacing: 10,
                          children: [
                            for (int i = 0; i < snapshot.data.length - 1; i++)
                              Card(
                                child: ListTile(
                                    dense: true,
                                    title: Text(snapshot.data[i]['title']),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DropdownMenu(
                                            enabled: isEdit,
                                            enableFilter: true,
                                            controller: TextEditingController(
                                                text: snapshot.data[i]
                                                        .containsKey(
                                                            'classTeacher')
                                                    ? snapshot.data[i]
                                                        ['classTeacher']
                                                    : ''),
                                            onSelected: (value) {
                                              savedTeachers[snapshot.data[i]
                                                  ['title']] = value;
                                            },
                                            width: 300,
                                            hintText: 'Teacher',
                                            inputDecorationTheme:
                                                InputDecorationTheme(
                                                    constraints: BoxConstraints(
                                                        maxHeight: 40),
                                                    border: isEdit
                                                        ? OutlineInputBorder()
                                                        : InputBorder.none,
                                                    isDense: true),
                                            dropdownMenuEntries: teachers
                                                .map((e) => DropdownMenuEntry(
                                                    value: e['fullName'],
                                                    label: e['fullName']))
                                                .toList()),
                                        if (isEdit)
                                          IconButton(
                                            color: Colors.red,
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              var url = Uri.parse(
                                                  '$ipv4/deleteClassDetails');
                                              var res =
                                                  await http.delete(url, body: {
                                                'schoolCode':
                                                    schoolCode.toString(),
                                                'title': snapshot.data[i]
                                                    ['title'],
                                              });
                                              if (res.body == 'true') {
                                                print('done');

                                                setState(() {
                                                  _loadData = getClass();
                                                });
                                              }
                                            },
                                          ),
                                      ],
                                    )),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
