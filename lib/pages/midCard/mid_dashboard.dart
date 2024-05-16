import 'dart:convert';

import 'package:flutter/material.dart';

import '../../ip_address.dart';

import 'package:http/http.dart' as http;

class MidDashboard extends StatefulWidget {
  const MidDashboard({super.key});

  @override
  State<MidDashboard> createState() => _MidDashboardState();
}

class _MidDashboardState extends State<MidDashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllLogins(),
                  )),
              child: SizedBox(
                  width: 200,
                  height: 100,
                  child: Center(child: Text('Logins')))),
        )
      ],
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
                              print(res.body);
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
