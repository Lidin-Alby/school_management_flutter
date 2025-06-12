import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/ip_address.dart';
import 'package:http/http.dart' as http;

class ReadyToPrintList extends StatefulWidget {
  const ReadyToPrintList({super.key});

  @override
  State<ReadyToPrintList> createState() => _ReadyToPrintListState();
}

class _ReadyToPrintListState extends State<ReadyToPrintList> {
  late Future _getPrintList;
  getPrintList() async {
    var url = Uri.parse('$ipv4/getAllReady');
    var res = await http.get(url);

    return jsonDecode(res.body);
  }

  @override
  void initState() {
    _getPrintList = getPrintList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ready To Print List'),
      ),
      body: FutureBuilder(
          future: _getPrintList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List users = snapshot.data;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    dense: true,
                    title: Text(
                        '${users[index]['userName']} - ${users[index]['fullName']}'),
                    subtitle: Text(users[index]['schoolCode']),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
