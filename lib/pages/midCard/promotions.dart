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
    var url = Uri.parse('$ipv4/getMidClasses/$selectedSchool');
    var res = await http.get(url);
    Map data = jsonDecode(res.body);
    List classes = data['classes'];
    List newClasses = [];
    classes.add({
      'title': 'alumni',
    });
    for (var element in classes) {
      newClasses.add({
        'title': element['title'],
        'count': element['count'],
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) => AddClassDialog(
                                            refresh: (className, section) {
                                              setState(() {
                                                classes.add({
                                                  'title':
                                                      '$className-$section',
                                                  'count': 0,
                                                  'new': ['', '']
                                                });
                                              });
                                            },
                                            schoolCode: selectedSchool!)),
                                    child: Icon(Icons.add))
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Expanded(
                              child: GridView.builder(
                                  itemCount: classes.length,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    mainAxisSpacing: 3,
                                    crossAxisSpacing: 3,
                                    childAspectRatio: 1.5,
                                  ),
                                  itemBuilder: (context, index) {
                                    Map c = classes[index];
                                    return Container(
                                      color: Colors.grey[200],
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
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
                                          Text('Total: ${c['count']}')
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: ElevatedButton(
                                onPressed: () => promoteClasses(classes),
                                child: Text('Save'),
                              ),
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

class AddClassDialog extends StatefulWidget {
  const AddClassDialog(
      {super.key, required this.schoolCode, required this.refresh});
  final String schoolCode;
  final Function(String className, String section) refresh;

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  TextEditingController className = TextEditingController();
  TextEditingController section = TextEditingController();
  bool validate = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 300,
            child: TextField(
              controller: className,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Class / Department',
                errorText: validate ? 'This Field is required' : null,
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
                errorText: validate ? 'This Field is required' : null,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                section.text.trim().isEmpty || className.text.trim().isEmpty
                    ? validate = true
                    : validate = false;
              });
              if (!validate) {
                var url = Uri.parse('$ipv4/addClassOrBranchMid');
                var res = await http.post(url, body: {
                  'schoolCode': widget.schoolCode,
                  'title': '${className.text.trim()}-${section.text.trim()}',
                  'className': className.text.trim(),
                  'sec': section.text.trim()
                });
                Navigator.pop(context);
                if (res.body == 'true') {
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

                  widget.refresh(className.text.trim(), section.text.trim());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red[600],
                      behavior: SnackBarBehavior.floating,
                      content: Row(
                        children: [
                          Text(
                            res.body,
                          ),
                          Icon(
                            Icons.error,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  );
                }
              }
            },
            child: Text('Add Class'),
          )
        ]),
      ),
    );
  }
}
