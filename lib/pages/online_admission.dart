import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';
import 'package:school_management/pages/online_application.dart';

import '../ip_address.dart';

class OnlineAdmission extends StatefulWidget {
  const OnlineAdmission({super.key});

  @override
  State<OnlineAdmission> createState() => _OnlineAdmissionState();
}

class _OnlineAdmissionState extends State<OnlineAdmission> {
  late Future _getschoolData;

  getSchooldata() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMyschoolData');
    var res = await client.get(url);
    // print(res.body);
    Map data = jsonDecode(res.body);
    print(data);
    return data;
  }

  @override
  void initState() {
    _getschoolData = getSchooldata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getschoolData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90),
                child: AppBar(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.indigo[900],
                  title: Text('Online Admission'),
                  bottom: TabBar(
                      indicatorColor: Colors.white,
                      indicator: UnderlineTabIndicator(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(width: 4, color: Colors.white)),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      tabs: [
                        Tab(
                          text: 'Applications',
                        ),
                        Tab(
                          text: 'Form',
                        )
                      ]),
                ),
              ),
              body: TabBarView(
                children: [
                  OnlineRequests(),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                              onPressed: () =>
                                  context.go('/school-settings', extra: 10),
                              icon: Icon(Icons.settings),
                              label: Text('Form Settings')),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        OnlineApplication(code: snapshot.data['onlineCode']),
                      ],
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
    );
  }
}

class OnlineRequests extends StatefulWidget {
  const OnlineRequests({
    super.key,
  });

  @override
  State<OnlineRequests> createState() => _OnlineRequestsState();
}

class _OnlineRequestsState extends State<OnlineRequests> {
  late Future _getApplications;

  getApplications() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getOnlineApplications');
    var res = await client.get(url);
    // print(res.body);
    List data = jsonDecode(res.body);
    print(data);
    return data;
  }

  @override
  void initState() {
    _getApplications = getApplications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: _getApplications,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List applications = snapshot.data;
            return Container(
              margin: EdgeInsets.fromLTRB(8, 15, 5, 5),
              // padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.orange.shade50),
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    columns: [
                      DataColumn(
                        label: Text('Application No.'),
                      ),
                      DataColumn(
                        label: Text('Name'),
                      ),
                      DataColumn(
                        label: Text('Submitted On'),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: applications
                        .map(
                          (e) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  e['applicationNo'],
                                ),
                              ),
                              DataCell(Text(e['fullName'])),
                              DataCell(Text(DateFormat('dd-MM-yyyy')
                                  .format(DateTime.parse(e['submittedOn'])))),
                              DataCell(IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () => context.go(
                                    '/online-admission/${e['applicationNo']}'),
                              ))
                            ],
                          ),
                        )
                        .toList()),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
