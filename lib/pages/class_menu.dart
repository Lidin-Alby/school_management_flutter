import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/browser_client.dart';

// import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';
import 'package:school_management/widgets/dropdown_widget.dart';

class ClassMenu extends StatefulWidget {
  const ClassMenu({super.key, required this.title});
  final String title;

  @override
  State<ClassMenu> createState() => _ClassMenuState();
}

class _ClassMenuState extends State<ClassMenu> {
  List days = ['Time', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  List periods = [5, 6, 7, 8, 9, 10, 11, 12];

  int _selected = 0;

  Map timeTable = {};
  bool enableEdit = false;
  List timeControllers = [];

  late int dropDownValue;
  int focus = -2;
  double topPadding = 43;
  List allSubjects = [];
  String classTeacherMob = '';
  List subjectDetail = [null];
  List searchResults = [];
  List teacherControllers = [TextEditingController()];
  TextEditingController classTeacherController = TextEditingController();
  int addNew = 1;

  @override
  void initState() {
    dropDownValue = 5;
    List mon = List.generate(dropDownValue, (index) => null);
    List tue = List.generate(dropDownValue, (index) => null);
    List wed = List.generate(dropDownValue, (index) => null);
    List thu = List.generate(dropDownValue, (index) => null);
    List fri = List.generate(dropDownValue, (index) => null);
    List sat = List.generate(dropDownValue, (index) => null);
    timeTable = {'1': mon, '2': tue, '3': wed, '4': thu, '5': fri, '6': sat};

    // print(timeTable);
    timeControllers =
        List.generate(dropDownValue, (index) => TextEditingController());
    getTimeTable();

    super.initState();
  }

  Future getTimeTable() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getTimeTable/${widget.title}');
    var res = await client.get(url);

    print(res.body);
    Map data = jsonDecode(res.body);
    print(data);
    if (data.isNotEmpty && data['timeTable'].isNotEmpty) {
      print(data['timeTable']['1'].length);
      // setState(() {
      dropDownValue = data['timeTable']['1'].length;
      // });
      timeControllers =
          List.generate(dropDownValue, (index) => TextEditingController());
      timeTable = data['timeTable'];

      print(timeTable['0']);
      for (int i = 0; i < timeTable['0'].length; i++) {
        timeControllers[i].text = timeTable['0'][i];
      }
    }
    getTeacherNames();
    getAllSubjects();
    return;
  }

  Future getAllSubjects() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getSubjects');
    var response = await client.get(url);
    var data = jsonDecode(response.body);

    setState(() {
      allSubjects = data['subjects'];
    });
    return;
  }

  Future getTeacherNames() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getTeachers/${widget.title}');
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['teachers'] != null) {
        Map teachers = data['teachers'];
        classTeacherController.text = teachers['Class Teacher'];
        if (teachers['Class Teacher'] != "") {
          classTeacherMob = 'null';
        }
        teachers.remove('Class Teacher');
        teacherControllers.clear();
        for (int i = 0; i < teachers.length; i++) {
          subjectDetail = teachers.keys.toList();
          teacherControllers.add(TextEditingController());
          teacherControllers[i].text = teachers.values.toList()[i];
        }
        addNew = teachers.length;
      }
    }
  }

  addTimeTable() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/addTimeTable/${widget.title}');
    List times = timeControllers.map((e) => e.text).toList();

    timeTable.addAll({'0': times});
    print(timeTable.toString());
    var res =
        await client.post(url, body: {'timeTable': json.encode(timeTable)});
    print('done');
    print(res.body);
    var data = jsonDecode(res.body);
    return data;
  }

  searchFunction(value) async {
    var client = BrowserClient()..withCredentials = true;
    if (value.trim() != '') {
      var url = Uri.http(ipv4, '/searchStaff/$value');
      var response = await client.get(url);

      setState(() {
        searchResults = jsonDecode(response.body);
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          insideMenu(),
          if (_selected == 0) Expanded(child: timeTableAndTeachers(context))
        ],
      ),
    );
  }

  Card timeTableAndTeachers(BuildContext context) {
    saveTeachers() async {
      print('hello');
      print(classTeacherMob);
      print('hello');
      List names = [];
      Map teachers = {};
      var client = BrowserClient()..withCredentials = true;
      for (var i in teacherControllers) {
        names.add(i.text.trim());
      }
      teachers = Map.fromIterables(subjectDetail, names);
      teachers.addAll({
        'Class Teacher': classTeacherController.text.trim(),
        'classTeacherMob': classTeacherMob
      });

      var url = Uri.http(ipv4, '/addTeachers/${widget.title}');
      var response = await client.post(url, body: teachers);
      if (response.body == 'true') {}
    }

    return Card(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (enableEdit)
                        ElevatedButton(
                          onPressed: saveTeachers,
                          child: Text('save'),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        onPressed: () => setState(() {
                          enableEdit = !enableEdit;
                        }),
                        child: enableEdit
                            ? Text('Cancel')
                            : Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('No. of Periods'),
                      SizedBox(
                        width: 5,
                      ),
                      AbsorbPointer(
                        absorbing: !enableEdit,
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          value: dropDownValue,
                          items: periods
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.toString())))
                              .toList(),
                          onChanged: (value) {
                            int newValue = value as int;
                            if (newValue > dropDownValue) {
                              timeControllers.addAll(List.generate(
                                  newValue - dropDownValue,
                                  (index) => TextEditingController()));

                              List newBoxes = List.generate(
                                  newValue - dropDownValue, (index) => null);

                              for (var day in timeTable.entries) {
                                day.value.addAll(newBoxes);
                              }
                            }

                            setState(() {
                              dropDownValue = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          for (int i = 0; i < days.length; i++)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Container(
                                    constraints: BoxConstraints(minWidth: 100),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        borderRadius: BorderRadius.circular(5)),
                                    //   width: 140,
                                    child: Text(
                                      days[i],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                                for (int j = 0; j < dropDownValue; j++)
                                  Flexible(
                                    child: SizedBox(
                                      width: 125,
                                      child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: i == 0
                                              ? TextField(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  onTap: () async {
                                                    TimeOfDay? selectedTimes =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                      builder: (context,
                                                              child) =>
                                                          Directionality(
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                              child: child!),
                                                    );
                                                    setState(() {
                                                      timeControllers[j].text =
                                                          selectedTimes!
                                                              .format(context);
                                                    });
                                                  },
                                                  textAlign: TextAlign.center,
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.indigo,
                                                    border: enableEdit
                                                        ? OutlineInputBorder()
                                                        : OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide.none,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                  ),
                                                  controller:
                                                      timeControllers[j],
                                                )
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.indigo[100],
                                                  ),
                                                  child: AbsorbPointer(
                                                    absorbing: !enableEdit,
                                                    child: DropdownButton(
                                                      underline: Text(''),
                                                      isExpanded: true,
                                                      hint: Text(
                                                          'Subject ${j + 1}'),
                                                      value: !timeTable[
                                                                  i.toString()]
                                                              .asMap()
                                                              .containsKey(j)
                                                          ? null
                                                          : timeTable[
                                                              i.toString()][j],
                                                      items: allSubjects
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                child: Text(e),
                                                                value: e,
                                                              ))
                                                          .toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          timeTable[
                                                                  i.toString()]
                                                              [j] = value;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                )),
                                    ),
                                  ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (enableEdit)
                            ElevatedButton(
                              onPressed: addTimeTable,
                              child: Text('Save Table'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      subjectDetail.add('');
                      print(subjectDetail);
                      setState(() {
                        addNew++;
                        teacherControllers.add(TextEditingController());
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 250,
                                    child: InputDecorator(
                                      child: Text('Class Teacher'),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      readOnly: !enableEdit,
                                      onTap: () => setState(() {
                                        focus = -1;
                                        classTeacherController.clear();
                                        // topPadding =
                                        //     43.0 * (i + 1) + (i * 20);
                                      }),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[a-zA-Z]+$'))
                                      ],
                                      controller: classTeacherController,
                                      onChanged: (value) =>
                                          searchFunction(value),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        hintText: 'Search Teacher',
                                        suffixIcon: Icon(Icons.search),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 250),
                                    child: Column(
                                      // shrinkWrap: true,
                                      // crossAxisCount: 2,
                                      children: [
                                        for (int i = 0; i < addNew; i++)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AbsorbPointer(
                                                absorbing: !enableEdit,
                                                child: DropDownWidget(
                                                  isEdit: true,
                                                  items: allSubjects,
                                                  title: 'Select Subject',
                                                  callBack: (p0) {
                                                    setState(() {
                                                      subjectDetail[i] = p0;
                                                      print(subjectDetail);
                                                    });
                                                  },
                                                  selected:
                                                      subjectDetail[i] == ''
                                                          ? null
                                                          : subjectDetail[i],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                child: TextField(
                                                  readOnly: !enableEdit,
                                                  onTap: () => setState(() {
                                                    focus = i;

                                                    teacherControllers[i]
                                                        .clear();
                                                    topPadding =
                                                        43.0 * (i + 1) +
                                                            (i * 20);
                                                  }),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^[a-zA-Z]+$'))
                                                  ],
                                                  controller:
                                                      teacherControllers[i],
                                                  onChanged: (value) =>
                                                      searchFunction(value),
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                    hintText: 'Search Teacher',
                                                    suffixIcon:
                                                        Icon(Icons.search),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (focus >= 0)
                                    Positioned(
                                      left: 260,
                                      top: topPadding,
                                      child: Container(
                                        // height: 150,
                                        width: 200,
                                        constraints: BoxConstraints(
                                          maxHeight: 150,
                                        ),
                                        child: Card(
                                          elevation: 5,
                                          child: (teacherControllers[focus]
                                                      .text
                                                      .isNotEmpty &&
                                                  searchResults.isEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'No results found',
                                                    style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      searchResults.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          InkWell(
                                                    onTap: () => setState(() {
                                                      // teacherControllers[i][]
                                                      //  classTeacherController.

                                                      teacherControllers[focus]
                                                          .text = searchResults[
                                                                  index]
                                                              ['firstName'] +
                                                          ' ' +
                                                          searchResults[index]
                                                              ['lastName'] +
                                                          ' - ' +
                                                          searchResults[index]
                                                              ['mob'];

                                                      //focus = -2;
                                                      searchResults = [];
                                                    }),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 5),
                                                      child: Text(searchResults[
                                                                  index]
                                                              ['firstName'] +
                                                          ' ' +
                                                          searchResults[index]
                                                              ['lastName']),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (focus == -1)
                          Positioned(
                            left: 260,
                            top: 56,
                            child: Container(
                              width: 200,
                              constraints: const BoxConstraints(
                                maxHeight: 150,
                              ),
                              child: Card(
                                elevation: 5,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () => setState(() {
                                      classTeacherMob =
                                          searchResults[index]['mob'];
                                      classTeacherController.text =
                                          searchResults[index]['firstName'] +
                                              ' ' +
                                              searchResults[index]['lastName'] +
                                              ' - ' +
                                              searchResults[index]['mob'];
                                      searchResults = [];
                                    }),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 5),
                                      child: Text(searchResults[index]
                                              ['firstName'] +
                                          ' ' +
                                          searchResults[index]['lastName']),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Card insideMenu() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                    ? Icons.table_chart
                    : Icons.table_chart_outlined),
                onPressed: () {
                  if (_selected != 0) {
                    setState(() {
                      _selected = 0;
                    });
                  }
                },
                label: Text('Time Tables and Teachers'),
                style: TextButton.styleFrom(
                    foregroundColor:
                        _selected == 0 ? Colors.indigo : Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                    alignment: AlignmentDirectional.centerStart),
              ),
              TextButton.icon(
                icon: Icon(_selected == 1 ? Icons.badge : Icons.badge_outlined),
                onPressed: () {
                  if (_selected != 1) {
                    setState(() {
                      _selected = 1;
                    });
                  }
                },
                label: Text('ID Cards'),
                style: TextButton.styleFrom(
                    foregroundColor:
                        _selected == 1 ? Colors.indigo : Colors.grey[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    textStyle: TextStyle(fontSize: 16),
                    alignment: AlignmentDirectional.centerStart),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class TimeTableCard extends StatefulWidget {
//   const TimeTableCard(
//       {super.key,
//       required this.classTitle,
//       required this.dropDownValue,
//       required this.enableEdit,
//       required this.giveDropDown});
//   final String classTitle;
//   final int dropDownValue;
//   final bool enableEdit;
//   final Function(dynamic) giveDropDown;

//   @override
//   State<TimeTableCard> createState() => _TimeTableCardState();
// }

// class _TimeTableCardState extends State<TimeTableCard> {
//   late List timeControllers;

//   List allSubjects = [];

//   late int newDropDown;

//   @override
//   void initState() {
//     getAllSubjects().then((value) => allSubjects = value['subjects']);
//     getTimeTable().then((value) {
//       print('nic$value');
//       if (value.isEmpty) {
//         return;
//       } else {
//         widget.giveDropDown(value[0].length);
//         selectedSubs = value;
//       }
//     });

//     super.initState();
//   }

//   Future getAllSubjects() async {
//     var url = Uri.http('localhost:3000', '/getSubjects');
//     var response = await http.get(url);
//     var allSubjects = jsonDecode(response.body);

//     return allSubjects;
//   }
// }
