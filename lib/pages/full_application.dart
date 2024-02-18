import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';

class FullApplication extends StatefulWidget {
  const FullApplication({super.key, required this.formNo});
  final String formNo;

  @override
  State<FullApplication> createState() => _FullApplicationState();
}

class _FullApplicationState extends State<FullApplication> {
  late Future _application;
  // Map application={};
  getFullApplication() async {
    print('helloooo');
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getApplication/${widget.formNo}');
    var res = await client.get(url);
    // print(res.body);
    Map data = jsonDecode(res.body);

    return data;
  }

  @override
  void initState() {
    _application = getFullApplication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _application,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;
            return Column(
              children: [
                for (var key in data.keys)
                  Row(
                    children: [
                      Text(key),
                      SizedBox(
                        width: 5,
                      ),
                      Text(data[key].toString()),
                    ],
                  )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
