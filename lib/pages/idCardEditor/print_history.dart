import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../ip_address.dart';

class PrintHistory extends StatefulWidget {
  const PrintHistory({super.key, required this.refresh});
  final VoidCallback refresh;

  @override
  State<PrintHistory> createState() => _PrintHistoryState();
}

class _PrintHistoryState extends State<PrintHistory> {
  late Future _getDates;
  int _currentPage = 1;
  // List data = [];
  List students = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  late String selectedDate;

  @override
  void initState() {
    _getDates = getDates();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          getStudents();
        }
      },
    );
    super.initState();
  }

  getDates() async {
    var url = Uri.parse('$ipv4/getPrintedDates');

    var res = await http.get(url);
    List dates = jsonDecode(res.body);
    dates.remove(null);

    dates.sort(
      (a, b) {
        // if (a['printDate'] == null) {
        //   return 1; // Place null values at the end
        // } else if (b['printDate'] == null) {
        //   return -1; // Place null values at the end
        // } else {
        DateTime dateA = DateFormat('dd-MMM-yy').parse(a);
        DateTime dateB = DateFormat('dd-MMM-yy').parse(b);
        return dateB.compareTo(dateA);
        // }
      },
    );
    if (dates.isNotEmpty) {
      selectedDate = dates.first;
      getStudents();
    }

    return dates;
  }

  getStudents() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(
        '$ipv4/getPrinted?page=$_currentPage&limit=50&date=$selectedDate');
    var res = await http.get(url);
    List data = jsonDecode(res.body);
    _currentPage++;
    setState(() {
      students.addAll(data);
      isLoading = false;
    });
  }

  printedInfo(List selectedStudents, {required print, required ready}) async {
    selectedStudents = selectedStudents.map(
      (e) {
        return {
          'schoolCode': e['schoolCode'],
          'admNo': e['admNo'],
          'printed': print,
          'ready': ready,
          'printDate': DateFormat('dd-MMM-yy').format(DateTime.now())
        };
      },
    ).toList();

    var url = Uri.parse('$ipv4/printedInfo');

    var res =
        await http.post(url, body: {'data': jsonEncode(selectedStudents)});

    if (res.body == 'true') {
      widget.refresh();
      setState(() {
        students = [];
        getStudents();
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDates,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List dates = snapshot.data;
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (String date in dates)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FilterChip(
                          selected: selectedDate == date,
                          label: Text(date),
                          onSelected: (value) {
                            setState(() {
                              selectedDate = date;
                              students = [];
                              _currentPage = 1;
                              getStudents();
                            });
                          },
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: students.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < students.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(students[index]['admNo']),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(students[index]['firstName']),
                                  ],
                                ),
                                Text(
                                  students[index]['schoolCode'],
                                  style: TextStyle(color: Colors.grey[600]),
                                )
                              ],
                            ),
                            Spacer(),
                            OutlinedButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      'Not Ready, ${students[index]['firstName']}'),
                                  content: Text(
                                      'The data will be moved out and will be set as not Ready.'),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () => printedInfo(
                                          [students[index]],
                                          print: false, ready: false),
                                      child: Text('Confirm'),
                                    )
                                  ],
                                ),
                              ),
                              child: Text('Incorrect data (Not Ready)'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            OutlinedButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      'Print Again, ${students[index]['firstName']}'),
                                  content: Text(
                                      'The data will be moved out and will be set as not printed.'),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () => printedInfo(
                                          [students[index]],
                                          print: false, ready: true),
                                      child: Text('Confirm'),
                                    )
                                  ],
                                ),
                              ),
                              child: Text('Print Again'),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // ListView.builder(
    //     controller: _scrollController,
    //     itemCount: data.length + (isLoading ? 1 : 0),
    //     itemBuilder: (context, i) {
    //       if (i < data.length) {
    //         return Column(
    //           children: [
    //             if (i != 0
    //                 ? data[i - 1]['printDate'] != data[i]['printDate']
    //                 : true)
    //               Row(
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.symmetric(
    //                         horizontal: 8, vertical: 15),
    //                     child: Text(
    //                       data[i]['printDate'] ?? 'No Date',
    //                       style: TextStyle(fontWeight: FontWeight.bold),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ListView.builder(
    //                 shrinkWrap: true,
    //                 itemCount: data[i]['students'].length,
    //                 itemBuilder: (context, index) {
    //                   List students = data[i]['students'];
    //                   return
    //                    Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Row(
    //                       children: [
    //                         Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             Row(
    //                               children: [
    //                                 Text(students[index]['admNo']),
    //                                 SizedBox(
    //                                   width: 10,
    //                                 ),
    //                                 Text(students[index]['firstName']),
    //                               ],
    //                             ),
    //                             Text(
    //                               students[index]['schoolCode'],
    //                               style: TextStyle(color: Colors.grey[600]),
    //                             )
    //                           ],
    //                         ),
    //                         Spacer(),
    //                         OutlinedButton(
    //                           onPressed: () => showDialog(
    //                             context: context,
    //                             builder: (context) => AlertDialog(
    //                               title: Text(
    //                                   'Not Ready, ${students[index]['firstName']}'),
    //                               content: Text(
    //                                   'The data will be moved out and will be set as not Ready.'),
    //                               actions: [
    //                                 OutlinedButton(
    //                                   onPressed: () => Navigator.pop(context),
    //                                   child: Text('Cancel'),
    //                                 ),
    //                                 FilledButton(
    //                                   onPressed: () => printedInfo(
    //                                       [students[index]],
    //                                       print: false, ready: false),
    //                                   child: Text('Confirm'),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                           child: Text('Not Ready'),
    //                         ),
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         OutlinedButton(
    //                           onPressed: () => showDialog(
    //                             context: context,
    //                             builder: (context) => AlertDialog(
    //                               title: Text(
    //                                   'Not Print, ${students[index]['firstName']}'),
    //                               content: Text(
    //                                   'The data will be moved out and will be set as not printed.'),
    //                               actions: [
    //                                 OutlinedButton(
    //                                   onPressed: () => Navigator.pop(context),
    //                                   child: Text('Cancel'),
    //                                 ),
    //                                 FilledButton(
    //                                   onPressed: () => printedInfo(
    //                                       [students[index]],
    //                                       print: false, ready: true),
    //                                   child: Text('Confirm'),
    //                                 )
    //                               ],
    //                             ),
    //                           ),
    //                           child: Text('Not Print'),
    //                         )
    //                       ],
    //                     ),
    //                   );
    //                 })
    //           ],
    //         );
    //       } else {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //     });
  }
}
