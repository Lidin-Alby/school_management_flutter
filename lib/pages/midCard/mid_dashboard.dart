import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/pages/midCard/ready_to_print_list.dart';

import '../../ip_address.dart';

import 'package:http/http.dart' as http;

class MidDashboard extends StatefulWidget {
  const MidDashboard({super.key});

  @override
  State<MidDashboard> createState() => _MidDashboardState();
}

class _MidDashboardState extends State<MidDashboard> {
  late Future _getStats;

  @override
  void initState() {
    _getStats = getStats();
    super.initState();
  }

  getStats() async {
    var url = Uri.parse('$ipv4/getStats');
    var res = await http.get(url);

    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getStats,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map stats = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Card(
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AllLogins(),
                        )),
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Logins'),
                              Text(stats['logins'].toString())
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AllAgents(),
                        )),
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Agents'),
                              Text(stats['agents'].toString())
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Students'),
                            Text(stats['students'].toString())
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Staff / Teachers'),
                            Text(stats['staffs'].toString())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 500,
                  child: Divider(),
                ),
                Wrap(
                  children: [
                    Card(
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadyToPrintList(),
                            )),
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ready To Print',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text((stats['staffReadyCount'] +
                                      stats['studentReadyCount'])
                                  .toString()),
                              SizedBox(
                                height: 5,
                              ),
                              Text('Student: ${stats['studentReadyCount']}'),
                              SizedBox(
                                height: 2,
                              ),
                              Text('Staff: ${stats['staffReadyCount']}')
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Printing',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text((stats['staffPrintingCount'] +
                                    stats['studentPrintingCount'])
                                .toString()),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Students: ${stats['studentPrintingCount']}'),
                            SizedBox(
                              height: 2,
                            ),
                            Text('Staffs: ${stats['staffPrintingCount']}'),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: SizedBox(
                        width: 200,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Delivered',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text((stats['staffPrintedCount'] +
                                    stats['studentPrintedCount'])
                                .toString()),
                            SizedBox(
                              height: 5,
                            ),
                            Text('Student: ${stats['studentPrintedCount']}'),
                            SizedBox(
                              height: 2,
                            ),
                            Text('Staff: ${stats['staffPrintedCount']}')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class AllAgents extends StatefulWidget {
  const AllAgents({super.key});

  @override
  State<AllAgents> createState() => _AllAgentsState();
}

class _AllAgentsState extends State<AllAgents> {
  late Future _getAgents;

  getAgents() async {
    var url = Uri.parse('$ipv4/getAgents');
    var res = await http.get(url);
    return jsonDecode(res.body);
  }

  @override
  void initState() {
    _getAgents = getAgents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agents'),
      ),
      body: FutureBuilder(
        future: _getAgents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List agents = snapshot.data;
            return ListView.builder(
              itemCount: agents.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(agents[index]['fullName']),
                  subtitle: Text('Mobile - ${agents[index]['mob']}'),
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

class AllLogins extends StatefulWidget {
  const AllLogins({
    super.key,
  });

  @override
  State<AllLogins> createState() => _AllLoginsState();
}

class _AllLoginsState extends State<AllLogins> {
  late Future _getLogins;
  String searchText = '';

  getLogins() async {
    var url = Uri.parse('$ipv4/getMidLogins');
    var res = await http.get(url);

    List schools = jsonDecode(res.body);
    return schools;
  }

  @override
  void initState() {
    _getLogins = getLogins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logins'),
      ),
      body: FutureBuilder(
        future: _getLogins,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List logins = snapshot.data;
            if (searchText != '') {
              logins = logins
                  .where((element) => element['userName']
                      .toString()
                      .toLowerCase()
                      .contains(searchText.toString().toLowerCase()))
                  .toList();
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 400,
                    child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            hintText: 'Search',
                            isDense: true,
                            prefixIcon: Icon(Icons.search)),
                        onChanged: (value) {
                          setState(() {
                            searchText = value;
                          });
                        }
                        // searchFunction(value),
                        ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: logins.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                          title: Text(logins[index]['userName']),
                          subtitle: Text(logins[index]['schoolCode']),
                          trailing: IconButton(
                            onPressed: () async {
                              var url = Uri.parse('$ipv4/deleteMidLogin');
                              var res = await http.delete(url, body: {
                                'userName': logins[index]['userName']
                              });
                              if (res.body == 'true') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green[600],
                                    behavior: SnackBarBehavior.floating,
                                    content: const Row(
                                      children: [
                                        Text(
                                          'Deleted Successfully ',
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                                setState(() {
                                  _getLogins = getLogins();
                                });
                              }
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
