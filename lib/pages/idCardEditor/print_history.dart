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
  late Future _getStudents;
  getStudents() async {
    var url = Uri.parse('$ipv4/getPrinted');

    var res = await http.get(url);
    List data = jsonDecode(res.body);

    data.sort(
      (a, b) {
        if (a['printDate'] == null) {
          return 1; // Place null values at the end
        } else if (b['printDate'] == null) {
          return -1; // Place null values at the end
        } else {
          DateTime dateA = DateFormat('dd-MMM-yy').parse(a['printDate']);
          DateTime dateB = DateFormat('dd-MMM-yy').parse(b['printDate']);
          return dateB.compareTo(dateA);
        }
      },
    );

    return data;
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
        _getStudents = getStudents();
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    _getStudents = getStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStudents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List data = snapshot.data;
          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) => Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 15),
                            child: Text(
                              data[i]['printDate'] ?? 'No Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: data[i]['students'].length,
                          itemBuilder: (context, index) {
                            List students = data[i]['students'];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style:
                                            TextStyle(color: Colors.grey[600]),
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
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                    child: Text('Not Ready'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  OutlinedButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            'Not Print, ${students[index]['firstName']}'),
                                        content: Text(
                                            'The data will be moved out and will be set as not printed.'),
                                        actions: [
                                          OutlinedButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
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
                                    child: Text('Not Print'),
                                  )
                                ],
                              ),
                            );
                          })
                    ],
                  ));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
