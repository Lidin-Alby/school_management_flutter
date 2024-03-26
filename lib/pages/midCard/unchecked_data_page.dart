import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../../ip_address.dart';

class UncheckedDataPage extends StatefulWidget {
  const UncheckedDataPage({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<UncheckedDataPage> createState() => _UncheckedDataPageState();
}

class _UncheckedDataPageState extends State<UncheckedDataPage> {
  late Future _getClasses;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMidClasses/${widget.schoolCode}');
    var res = await client.get(url);
    List data = jsonDecode(res.body);

    return data;
  }

  @override
  void initState() {
    _getClasses = getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Unchecked Data'),
          bottom: TabBar(tabs: [
            Tab(
              child: Text('Teachers'),
            ),
            Tab(
              child: Text('Staff'),
            ),
            Tab(
              child: Text('Class'),
            ),
          ]),
        ),
        body: TabBarView(children: [
          Text('teachers'),
          Text('staff'),
          FutureBuilder(
            future: _getClasses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List classes = snapshot.data;
                return ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                    title: Text(classes[index]['title']),
                  )),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ]),
      ),
    );
  }
}
