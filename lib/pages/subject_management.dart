import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';

class SubjectManagement extends StatefulWidget {
  const SubjectManagement({super.key});

  @override
  State<SubjectManagement> createState() => _SubjectManagementState();
}

class _SubjectManagementState extends State<SubjectManagement> {
  late Future loadSubjects;
  TextEditingController newSubject = TextEditingController();
  bool addSub = false;
  bool isEdit = false;
  late String schoolCode;
  @override
  void initState() {
    loadSubjects = getInstitueSubjects();
    super.initState();
  }

  getInstitueSubjects() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getSubjects');
    var res = await client.get(url);

    print('hello');
    print(res.body);
    var subjects = {};
    print(res.body);
    if (res.body.isNotEmpty) {
      subjects = jsonDecode(res.body);
    }
    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          addSub = !addSub;
                        });
                      },
                      icon: Icon(Icons.add_rounded),
                      label: Text('Subject')),
                  IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                      onPressed: () {
                        setState(() {
                          isEdit = !isEdit;
                        });
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              if (addSub)
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: newSubject,
                        decoration: InputDecoration(
                            hintText: 'Enter New Subject',
                            isDense: true,
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var client = BrowserClient()..withCredentials = true;
                        var url = Uri.parse('$ipv4/addSubjects');
                        var res = await client
                            .post(url, body: {'subject': newSubject.text});
                        if (res.body == 'true') {
                          print('added');
                          newSubject.clear();
                          setState(() {
                            loadSubjects = getInstitueSubjects();
                          });
                        }
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              Divider(),
              FutureBuilder(
                future: loadSubjects,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isNotEmpty) {
                      schoolCode = snapshot.data['schoolCode'].toString();

                      List subjects = snapshot.data['subjects'];
                      print(subjects);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            for (var i in subjects)
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: AlignmentDirectional.center,
                                width: 200,
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: isEdit
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: isEdit
                                          ? IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 20,
                                              splashRadius: 18,
                                              onPressed: () async {
                                                var url = Uri.parse(
                                                    '$ipv4/deleteSubject');
                                                var res =
                                                    await http.post(url, body: {
                                                  'schoolCode':
                                                      schoolCode.toString(),
                                                  'subject': i,
                                                });
                                                if (res.body == 'true') {
                                                  print('done');

                                                  setState(() {
                                                    loadSubjects =
                                                        getInstitueSubjects();
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ))
                                          : null,
                                    ),
                                    Center(child: Text(i)),
                                  ],
                                ),
                              )
                          ],
                        ),
                      );
                    }
                    return Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Text('No Subjects Entered'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
