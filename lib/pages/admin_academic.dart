import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

import '../widgets/add_class_dialog.dart';

class AdminAcademic extends StatefulWidget {
  const AdminAcademic({super.key});

  @override
  State<AdminAcademic> createState() => _AdminAcademicState();
}

class _AdminAcademicState extends State<AdminAcademic> {
  late Future loadData;
  int _selected = 0;
  int schoolCode = 5;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getClassDetails');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List data = jsonDecode(res.body);
    // print(data.last['schoolCode']);
    // print('dbuygwdu  $schoolCode');

    // print('dbuygwdu  $schoolCode');

    return data;
  }

  @override
  void initState() {
    loadData = getClass();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Academic'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                width: 250,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton.icon(
                      icon: Icon(_selected == 0
                          ? Icons.rectangle_rounded
                          : Icons.rectangle_outlined),
                      onPressed: () {
                        if (_selected != 0) {
                          setState(() {
                            _selected = 0;
                          });
                        }
                      },
                      label: Text('Classes / Department'),
                      style: TextButton.styleFrom(
                          foregroundColor:
                              _selected == 0 ? Colors.indigo : Colors.grey[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                          textStyle: TextStyle(
                            fontSize: 16,
                          ),
                          alignment: AlignmentDirectional.centerStart),
                    ),
                    TextButton.icon(
                      icon: Icon(_selected == 1
                          ? Icons.auto_stories_rounded
                          : Icons.auto_stories_outlined),
                      onPressed: () {
                        if (_selected != 1) {
                          setState(() {
                            _selected = 1;
                          });
                        }
                      },
                      label: Text('Subjects'),
                      style: TextButton.styleFrom(
                          foregroundColor:
                              _selected == 1 ? Colors.indigo : Colors.grey[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                          textStyle: TextStyle(fontSize: 16),
                          alignment: AlignmentDirectional.centerStart),
                    ),
                    TextButton.icon(
                      icon: Icon(_selected == 2
                          ? Icons.keyboard_double_arrow_up_rounded
                          : Icons.keyboard_arrow_up_rounded),
                      onPressed: () {
                        if (_selected != 2) {
                          setState(() {
                            _selected = 2;
                          });
                        }
                      },
                      label: Text('Promotion'),
                      style: TextButton.styleFrom(
                          foregroundColor:
                              _selected == 2 ? Colors.indigo : Colors.grey[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding:
                              EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                          textStyle: TextStyle(fontSize: 16),
                          alignment: AlignmentDirectional.centerStart),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_selected == 0)
            Expanded(
              child: Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton.icon(
                                onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => AddClassDialog(
                                        schoolCode: schoolCode,
                                        callback: () => setState(() {
                                          loadData = getClass();
                                        }),
                                      ),
                                    ),
                                icon: Icon(Icons.add_rounded),
                                label: Text('Class / Departemnt')),
                          ),
                        ),
                        Divider(),
                        FutureBuilder(
                          future: loadData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.last.isNotEmpty) {
                                schoolCode =
                                    int.parse(snapshot.data.last['schoolCode']);
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Wrap(
                                  spacing: 10,
                                  children: [
                                    for (int i = 0;
                                        i < snapshot.data.length - 1;
                                        i++)
                                      Card(
                                        child: InkWell(
                                          onDoubleTap: () => context.push(
                                              '/academic/${snapshot.data[i]['title']}'),
                                          child: SizedBox(
                                            width: 180,
                                            height: 100,
                                            child: Center(
                                              child: Text(
                                                  snapshot.data[i]['title']),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (_selected == 1) InstituteSubjects(),
          if (_selected == 2) StudentsPromotion()
        ],
      ),
    );
  }
}

class InstituteSubjects extends StatefulWidget {
  const InstituteSubjects({super.key});

  @override
  State<InstituteSubjects> createState() => _InstituteSubjectsState();
}

class _InstituteSubjectsState extends State<InstituteSubjects> {
  late Future loadSubjects;
  TextEditingController newSubject = TextEditingController();
  bool addSub = false;
  @override
  void initState() {
    loadSubjects = getInstitueSubjects();
    super.initState();
  }

  getInstitueSubjects() async {
    var url = Uri.http(ipv4, '/getSubjects');
    var res = await http.get(url);

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
    return Expanded(
      child: Card(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            addSub = !addSub;
                          });
                        },
                        icon: Icon(Icons.add_rounded),
                        label: Text('Subject')),
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
                            var client = BrowserClient()
                              ..withCredentials = true;
                            var url = Uri.http(ipv4, '/addSubjects');
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      alignment: AlignmentDirectional.center,
                                      width: 200,
                                      height: 100,
                                      child: Text(i))
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
        ),
      ),
    );
  }
}

class StudentsPromotion extends StatefulWidget {
  const StudentsPromotion({super.key});

  @override
  State<StudentsPromotion> createState() => _StudentsPromotionState();
}

class _StudentsPromotionState extends State<StudentsPromotion> {
  late Future _loadData;
  @override
  void initState() {
    _loadData = getClassForPromotion();
    super.initState();
  }

  getClassForPromotion() async {
    var url = Uri.http(ipv4, '/classForPromotion');
    var res = await http.get(url);
    print(res.body);
    return (jsonDecode(res.body));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: FutureBuilder(
          future: _loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                    child: Wrap(
                  children: [
                    for (var i in snapshot.data)
                      Card(
                        child: InkWell(
                          onDoubleTap: () =>
                              context.go('/academic/promotion$i'),
                          child: SizedBox(
                            width: 200,
                            height: 100,
                            child: Center(
                                child: Text(
                              i,
                              style: TextStyle(fontSize: 16),
                            )),
                          ),
                        ),
                      ),
                  ],
                )),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class PromoteClass extends StatefulWidget {
  const PromoteClass({super.key, required this.className});
  final String className;

  @override
  State<PromoteClass> createState() => _PromoteClassState();
}

class _PromoteClassState extends State<PromoteClass> {
  late Future _loadStudents;
  List classDropDownList = [];
  late List<bool> checks;
  bool? selectAll = false;
  String? selectedClass;
  TextEditingController nos = TextEditingController();
  int selectedNos = 0;
  @override
  void initState() {
    getClasses();
    _loadStudents = getClassStudents();
    super.initState();
  }

  getClassStudents() async {
    var url = Uri.http(ipv4, '/promoteClass/${widget.className}');
    var res = await http.get(url);
    print(res.body);
    var data = jsonDecode(res.body);
    checks = List.generate(
      data.length,
      (index) => false,
    );
    // getClasses();
    return data;
  }

  getClasses() async {
    var url = Uri.http(ipv4, '/getClassDetails');
    var res = await http.get(url);
    print(res.body);
    // setState(() {

    classDropDownList = jsonDecode(res.body);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.className)),
      body: FutureBuilder(
        future: _loadStudents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 600,
                      child: Column(
                        children: [
                          Text('Total Students: ${data.length}'),
                          SizedBox(
                            height: 20,
                          ),
                          // CheckboxListTile(
                          //   value: selectAll,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       selectAll = value;
                          //     });
                          //   },
                          //   title: Text('Select All'),
                          // ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) => Card(
                                child: CheckboxListTile(
                                    value: checks[index],
                                    onChanged: (value) {
                                      setState(() {
                                        checks[index] = !checks[index];
                                      });
                                    },
                                    title: Text(data[index]['firstName'] +
                                        '  ' +
                                        data[index]['lastName'])),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              DropdownButton(
                                hint: Text('To Class'),
                                value: selectedClass,
                                items: classDropDownList
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(e['title']),
                                        value: e['title'],
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedClass = value.toString();
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text("Submit"),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: nos,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Transform.scale(
                      scale: 1.6,
                      child: Checkbox(
                          value: selectAll,
                          onChanged: (value) {
                            selectedNos = nos.text != ''
                                ? int.parse(nos.text.trim())
                                : -1;

                            if (selectedNos <= data.length &&
                                selectedNos >= 0) {
                              if (value == true) {
                                checks.fillRange(0, selectedNos, true);
                              } else {
                                checks = checks.map((e) => false).toList();
                              }
                              setState(() {
                                selectAll = value;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Value is out of limit'),
                                ),
                              );
                            }
                          }),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(elevation: 0),
                        icon: Icon(Icons.shuffle_rounded),
                        onPressed: () {
                          setState(() {
                            checks.shuffle();
                          });
                        },
                        label: Text('Shuffle')),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}