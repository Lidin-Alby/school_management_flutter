import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/ip_address.dart';
import 'package:http/http.dart' as http;

class Promotions extends StatefulWidget {
  const Promotions({super.key});

  @override
  State<Promotions> createState() => _PromotionsState();
}

class _PromotionsState extends State<Promotions> {
  late Future _getschools;
  String? selectedSchool;
  late Future _getClasses;
  TextEditingController session = TextEditingController();
  // late List classes;
  bool error = false;

  getAllschools() async {
    var url = Uri.parse('$ipv4/getAllMidSchools');
    var res = await http.get(url);

    return jsonDecode(res.body);
  }

  getClasses() async {
    var url = Uri.parse('$ipv4/getSchoolClassesMid/$selectedSchool');
    var res = await http.get(url);
    List classes = jsonDecode(res.body);
    List newClasses = [];
    classes.add({
      'title': 'alumni',
    });
    for (var element in classes) {
      newClasses.add({
        'title': element['title'],
        'new': ['', '']
      });
    }

    return newClasses;
  }

  promoteClasses(classes) async {
    if (session.text.trim().isEmpty) {
      setState(() {
        error = true;
      });
      return;
    }
    var url = Uri.parse('$ipv4/promoteStudents');
    var res = await http.post(url, body: {
      'schoolCode': selectedSchool,
      'session': session.text.trim(),
      'classes': jsonEncode(classes)
    });
    if (res.statusCode == 201) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved Successfully'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    _getschools = getAllschools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _getschools,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List schools = snapshot.data;
                  return ListView.builder(
                    itemCount: schools.length,
                    itemBuilder: (context, index) => SizedBox(
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              selectedSchool = schools[index]['schoolCode'];
                              _getClasses = getClasses();
                            });
                          },
                          selectedTileColor: Colors.indigo,
                          selectedColor: Colors.white,
                          selected:
                              schools[index]['schoolCode'] == selectedSchool,
                          title: Text(schools[index]['schoolName']),
                          subtitle: Text(schools[index]['schoolCode']),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: selectedSchool != null
                ? FutureBuilder(
                    future: _getClasses,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List classes = snapshot.data;

                        return Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 500,
                              child: TextField(
                                controller: session,
                                decoration: InputDecoration(
                                  errorText:
                                      error ? 'This can\'t be Empty' : null,
                                  labelText: 'Session',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  if (error) {
                                    setState(() {
                                      error = !error;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.height) - 200,
                              child: Wrap(
                                direction: Axis.vertical,
                                children: [
                                  for (Map c in classes)
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(c['title']),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          DropdownButton(
                                            value: c['new'][0] == ''
                                                ? null
                                                : c['new'][1],
                                            hint: Text('Select Class'),
                                            items: classes
                                                .map(
                                                  (e) => DropdownMenuItem(
                                                    child: Text(e['title']),
                                                    value: e['title'],
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                c['new'] = [
                                                  '${value}temp',
                                                  value
                                                ];
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => promoteClasses(classes),
                              child: Text('Save'),
                            )
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
                : SizedBox(),
          )
        ],
      ),
    );
  }
}
