import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';

class ReportCardDownload extends StatefulWidget {
  const ReportCardDownload({super.key});

  @override
  State<ReportCardDownload> createState() => _ReportCardDownloadState();
}

class _ReportCardDownloadState extends State<ReportCardDownload> {
  List sessions =
      List.generate(20, (index) => '${2020 + index}-${20 + index + 1}');
  String? selectedSession;
  String? selectedClass;
  late String schoolCode;
  List classes = [];
  late Future _students;
  // List students = [];

  getSession() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getCurrentSession');
    var res = await client.get(url);

    var data = jsonDecode(res.body);
    setState(() {
      selectedSession =
          data['selectedSession'] == '' ? null : data['selectedSession'];
    });
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    List cl = jsonDecode(res.body);
    schoolCode = cl.last['schoolCode'];

    cl.removeLast();

    getSession();
    classes = cl;
  }

  Future oneClass() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/oneClass/$selectedClass');
    var res = await client.get(url);

    var data = jsonDecode(res.body);
    print(data);

    return data;
  }

  @override
  void initState() {
    getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        title: Text('Report Card Download'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          child: DropdownButton(
                            // borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.all(4),
                            value: selectedSession,
                            isDense: true,
                            isExpanded: true,
                            underline: Text(''),
                            hint: Text('Select Session'),
                            items: sessions
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedSession = value.toString();
                                if (selectedClass != null) {
                                  _students = oneClass();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Class',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(4)),
                          child: DropdownButton(
                            // borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.all(4),
                            value: selectedClass,
                            isDense: true,
                            isExpanded: true,
                            underline: Text(''),
                            hint: Text('Select Class'),
                            items: classes
                                .map((e) => DropdownMenuItem(
                                    value: e['title'], child: Text(e['title'])))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedClass = value.toString();
                                _students = oneClass();
                                if (selectedSession != null) {}
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (selectedClass != null && selectedSession != null)
                FutureBuilder(
                  future: _students,
                  builder: (context, snapshot) {
                    // List students = [];
                    if (snapshot.hasData) {
                      List students = snapshot.data;
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                var client = BrowserClient()
                                  ..withCredentials = true;
                                var url = Uri.parse(
                                    '$ipv4/ReportCardAll/$selectedSession/$selectedClass');
                                var res = await client.get(url);

                                final bytes = res.bodyBytes;
                                final anchor = AnchorElement(
                                  href:
                                      'data:application/zip;base64,${base64Encode(bytes)}',
                                )
                                  ..setAttribute(
                                      'download', '${selectedClass}_ReportCard')
                                  ..click();
                              },
                              label: Text('Download all'),
                              icon: Icon(Icons.download_rounded),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Table(
                              border: TableBorder(
                                horizontalInside: BorderSide(),
                                verticalInside: BorderSide(),
                              ),
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.orange.shade50),
                                    children: [
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Adm No.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Student Name',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Father Name',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Mobile No.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                '',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                                for (int s = 0; s < students.length; s++)
                                  TableRow(
                                    children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            students[s]['admNo'],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            students[s]['fullName'],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            students[s]['fatherName'],
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                students[s]['fatherMobNo'])),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextButton(
                                              child:
                                                  Icon(Icons.download_rounded),
                                              onPressed: () async {
                                                var client = BrowserClient()
                                                  ..withCredentials = true;
                                                var url = Uri.parse(
                                                    '$ipv4/dwldReportCard/$selectedSession/$selectedClass/${students[s]['admNo']}');
                                                var res = await client.get(url);

                                                final bytes = res.bodyBytes;
                                                final anchor = AnchorElement(
                                                  href:
                                                      'data:application/pdf;base64,${base64Encode(bytes)}',
                                                )
                                                  ..setAttribute('download',
                                                      '${students[s]['fullName']}_ReportCard')
                                                  ..click();
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
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
