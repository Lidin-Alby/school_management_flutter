import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

class AdminAcademic extends StatefulWidget {
  const AdminAcademic({super.key});

  @override
  State<AdminAcademic> createState() => _AdminAcademicState();
}

class _AdminAcademicState extends State<AdminAcademic> {
  late Future loadData;
  int _selected = 0;
  int schoolCode = 5;

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
            if (_selected == 2) StudentsPromotion()
        ],
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
    var url = Uri.parse('$ipv4/classForPromotion');
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
    var url = Uri.parse('$ipv4/promoteClass/${widget.className}');
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
    var url = Uri.parse('$ipv4/getClassDetails');
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
