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
  late Future _getPrintTypes;
  Map? selectedType;
  int _currentPage = 1;

  // List assignedStudents = [];
  // List unassignedStudents = [];
  List selectedStudnts = [];
  List students = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Set wantedDesigns = {};

  // int? selectedIndex;

  // Future<List> getAllSchools() async {
  //   var url = Uri.parse('$ipv4/getAllMidSchools');

  //   var res = await http.get(url);

  //   List schools = jsonDecode(res.body);
  //   return schools;
  // }

  getPrintTypes() async {
    var url = Uri.parse('$ipv4/getPrintTypes');

    var res = await http.get(url);

    List data = jsonDecode(res.body);

    data.removeWhere(
      (element) => element.isEmpty,
    );

    if (data.isNotEmpty) {
      selectedType = data.first;
    }
    getStudents();

    return data;
  }

  getStudents() async {
    setState(() {
      isLoading = true;
    });
    Uri url;
    List newData = [];
    if (selectedType != null) {
      String ph = selectedType!['pageHeight'].toString();
      String pw = selectedType!['pageWidth'].toString();
      String mh = selectedType!['marginHorizontal'].toString();
      String mv = selectedType!['marginVertical'].toString();
      String pdh = selectedType!['paddingHorizontal'].toString();
      String pdv = selectedType!['paddingVertical'].toString();
      String ch = selectedType!['cardHeight'].toString();
      String cw = selectedType!['cardWidth'].toString();

      url = Uri.parse(
          '$ipv4/getReadyStudents?ph=$ph&pw=$pw&mh=$mh&mv=$mv&pdh=$pdh&pdv=$pdv&ch=$ch&cw=$cw&page=$_currentPage&limit=50');
    } else {
      url = Uri.parse(
          '$ipv4/getReadyStudents?ph=nill&page=$_currentPage&limit=50');
    }
    var res = await http.get(url);
    newData = jsonDecode(res.body);
    // if(newData.isEmpty){}
    _currentPage++;
    setState(() {
      students.addAll(newData);
      isLoading = false;
    });
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
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          getStudents();
        }
      },
    );
    _getPrintTypes = getPrintTypes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Container(
            color: Colors.indigo,
            child: const TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                unselectedLabelColor: Colors.white,
                padding: EdgeInsets.only(top: 50),
                labelPadding: EdgeInsets.only(bottom: 10),
                tabs: [Text('Ready'), Text('History')]),
          ),
        ),
        body: TabBarView(children: [
          FutureBuilder(
            future: _getPrintTypes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List printTypes = snapshot.data;
                return Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          for (int type = 0; type < printTypes.length; type++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FilterChip(
                                label: Text('Type ${type + 1}'),
                                selected: selectedType == printTypes[type],
                                onSelected: (value) {
                                  setState(() {
                                    selectedType = printTypes[type];
                                    selectedStudnts = [];
                                    students = [];
                                    _currentPage = 1;
                                    getStudents();
                                  });
                                },
                              ),
                            ),
                          FilterChip(
                            label: Text('Unassigned'),
                            selected: selectedType == null,
                            onSelected: (value) {
                              setState(() {
                                selectedType = null;
                                selectedStudnts = [];
                                students = [];
                                _currentPage = 1;
                                getStudents();
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (selectedStudnts.isNotEmpty)
                      FilledButton(
                        onPressed: () => showDialog(
                            context: context,
                            builder: (context) {
                              var data = PrintSetting.fromMap(selectedType!);

                              return PdfDownloadDialog(
                                selectedStudnts: selectedStudnts,
                                wantedDesigns: wantedDesigns,
                                printSetting: data,
                                callback: () {
                                  setState(() {
                                    getStudents();
                                    selectedStudnts = [];
                                  });
                                },
                              );
                            }),
                        child: Text('Next'),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: selectedType != null
                            ? Text(
                                '${selectedStudnts.length} of ${students.length} students selected')
                            : Text('unassigned - ${students.length}'),
                      ),
                    ),
                    if (selectedType != null)
                      Row(
                        children: [
                          Checkbox(
                            value: selectedStudnts.length == students.length &&
                                selectedStudnts.isNotEmpty,
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  selectedStudnts = students.toList();

                                  wantedDesigns = selectedStudnts
                                      .map(
                                        (e) => e['designName'],
                                      )
                                      .toSet();
                                } else {
                                  selectedStudnts = [];

                                  wantedDesigns = {};
                                }
                              });
                            },
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: students.length + (isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < students.length) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 35,
                                ),
                                if (selectedType != null)
                                  Checkbox(
                                    value: selectedStudnts
                                        .contains(students[index]),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          selectedStudnts.add(students[index]);
                                          wantedDesigns.add(
                                              students[index]['designName']);
                                        } else {
                                          selectedStudnts
                                              .remove(students[index]);
                                        }
                                      });
                                    },
                                  ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 20),
                                    child: Material(
                                      child: ListTile(
                                        tileColor: Colors.grey[300],
                                        leading: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${students[index]['admNo'] ?? students[index]['mob']} - ${students[index]['firstName']}'
                                                  .toString(),
                                            ),
                                            Text(
                                              students[index]['schoolCode']
                                                  .toString(),
                                            ),
                                            Text(
                                              students[index]['designName']
                                                  .toString(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    )
                  ],
                );
                // Align(
                //   alignment: Alignment.topCenter,
                //   child: SingleChildScrollView(
                //     child: Column(
                //       children: [
                //         SizedBox(
                //           height: 30,
                //         ),
                //         if (selectedStudnts.isNotEmpty)

                //         ListView.builder(
                //             physics: NeverScrollableScrollPhysics(),
                //             shrinkWrap: true,
                //             itemCount: assignedStudents.length,
                //             itemBuilder: (context, index) {
                //               List students =
                //                   assignedStudents[index]['students'];

                //               return Column(
                //                 children: [

                //                   ListView.builder(
                //                     physics: NeverScrollableScrollPhysics(),
                //                     shrinkWrap: true,
                //                     itemCount: 40,
                //                     itemBuilder: (context, i) =>

                //         Text(
                //           'Unassigned Students',
                //           style: TextStyle(
                //               fontSize: 20, fontWeight: FontWeight.bold),
                //         ),
                //         // ListView.builder(
                //         //   shrinkWrap: true,
                //         //   physics: NeverScrollableScrollPhysics(),
                //         //   itemCount: unassignedStudents.length,
                //         //   itemBuilder: (context, index) => Padding(
                //         //     padding: const EdgeInsets.symmetric(
                //         //         vertical: 8, horizontal: 20),
                //         //     child: ListTile(
                //         //       tileColor: Colors.grey[300],
                //         //       title:
                //         //           Text(unassignedStudents[index]['firstName']),
                //         //       subtitle: Text(unassignedStudents[index]
                //         //               ['schoolCode']
                //         //           .toString()),
                //         //     ),
                //         //   ),
                //         // )
                //       ],
                //     ),
                //   ),
                // );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          PrintHistory(
            refresh: () {
              setState(() {
                _getPrintTypes = getPrintTypes();
              });
            },
          )
        ]),
      ),
    );
  }
}
