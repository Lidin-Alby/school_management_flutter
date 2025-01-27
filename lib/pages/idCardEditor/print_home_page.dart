import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ip_address.dart';

import 'pdf_download_dialog.dart';
import 'print_history.dart';
import 'print_settings_class.dart';

class PrintHomePage extends StatefulWidget {
  const PrintHomePage({super.key});

  @override
  State<PrintHomePage> createState() => _PrintHomePageState();
}

class _PrintHomePageState extends State<PrintHomePage> {
  late Future _getStudents;

  // List assignedStudents = [];
  // List unassignedStudents = [];
  List selectedStudnts = [];

  Set wantedDesigns = {};

  int? selectedIndex;

  Future<List> getAllSchools() async {
    var url = Uri.parse('$ipv4/getAllMidSchools');

    var res = await http.get(url);

    List schools = jsonDecode(res.body);
    return schools;
  }

  getStudents() async {
    var url = Uri.parse('$ipv4/getReadyStudents');

    var res = await http.get(url);

    List data = jsonDecode(res.body);

    return data;
  }

  // getDesigns() async {
  //   final url = Uri.parse('$ipv4/getDesigns');
  //   final res = await http.get(url);
  //   List data = jsonDecode(res.body);

  //   designs = data;
  // }

  Uint8List? img;

  @override
  void initState() {
    _getStudents = getStudents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: [Text('Ready'), Text('History')]),
        ),
        body: TabBarView(children: [
          FutureBuilder(
            future: _getStudents,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List unassignedStudents = [];
                List assignedStudents = [];
                for (Map i in snapshot.data) {
                  if (!i.containsKey('pageHeight')) {
                    unassignedStudents += i['students'];
                  } else {
                    assignedStudents.add(i);
                  }
                }
                return Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        if (selectedStudnts.isNotEmpty)
                          FilledButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    var data = PrintSetting.fromMap(
                                        assignedStudents[selectedIndex!]);

                                    return PdfDownloadDialog(
                                      selectedStudnts: selectedStudnts,
                                      wantedDesigns: wantedDesigns,
                                      printSetting: data,
                                      callback: () {
                                        setState(() {
                                          _getStudents = getStudents();
                                          selectedStudnts = [];
                                        });
                                      },
                                    );
                                  }),
                              child: Text('Next')),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: assignedStudents.length,
                            itemBuilder: (context, index) {
                              List students =
                                  assignedStudents[index]['students'];

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: selectedStudnts.length ==
                                                students.length &&
                                            selectedIndex == index,
                                        onChanged: selectedIndex == index ||
                                                selectedIndex == null
                                            ? (value) {
                                                setState(() {
                                                  if (value!) {
                                                    selectedIndex = index;
                                                    selectedStudnts =
                                                        students.toList();

                                                    wantedDesigns =
                                                        selectedStudnts
                                                            .map(
                                                              (e) => e[
                                                                  'designName'],
                                                            )
                                                            .toSet();
                                                  } else {
                                                    selectedStudnts = [];

                                                    wantedDesigns = {};
                                                    if (selectedStudnts
                                                        .isEmpty) {
                                                      selectedIndex = null;
                                                    }
                                                  }
                                                });
                                              }
                                            : null,
                                      ),
                                      const Expanded(
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: students.length,
                                    itemBuilder: (context, i) => Row(
                                      children: [
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Checkbox(
                                          value: selectedStudnts
                                              .contains(students[i]),
                                          onChanged: selectedIndex == index ||
                                                  selectedIndex == null
                                              ? (value) {
                                                  selectedIndex = index;
                                                  if (value!) {
                                                    setState(() {
                                                      selectedStudnts
                                                          .add(students[i]);
                                                      wantedDesigns.add(
                                                          students[i]
                                                              ['designName']);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      selectedStudnts
                                                          .remove(students[i]);

                                                      // wantedDesigns.remove(
                                                      //     students[i]
                                                      //         ['designName']);
                                                      if (selectedStudnts
                                                          .isEmpty) {
                                                        selectedIndex = null;
                                                      }
                                                    });
                                                  }
                                                }
                                              : null,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 20),
                                            child: ListTile(
                                              tileColor: Colors.grey[300],
                                              leading: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${students[i]['admNo']} - ${students[i]['firstName']}'
                                                        .toString(),
                                                  ),
                                                  Text(
                                                    students[i]['schoolCode']
                                                        .toString(),
                                                  ),
                                                  Text(
                                                    students[i]['designName']
                                                        .toString(),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                        Text(
                          'Unassigned Students',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: unassignedStudents.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: ListTile(
                              tileColor: Colors.grey[300],
                              title:
                                  Text(unassignedStudents[index]['firstName']),
                              subtitle: Text(unassignedStudents[index]
                                      ['schoolCode']
                                  .toString()),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          PrintHistory(
            refresh: () {
              setState(() {
                _getStudents = getStudents();
              });
            },
          )
        ]),
      ),
    );
  }
}
