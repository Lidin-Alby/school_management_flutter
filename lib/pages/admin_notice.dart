import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

class AdminNotice extends StatefulWidget {
  const AdminNotice({super.key});

  @override
  State<AdminNotice> createState() => _AdminNoticeState();
}

class _AdminNoticeState extends State<AdminNotice> {
  late Future _notices;
  @override
  void initState() {
    _notices = getNotice();
    super.initState();
  }

  getNotice() async {
    var url = Uri.parse('$ipv4/getNotice');
    var res = await http.post(url, body: {'mob': '789'});
    if (res.statusCode == 200) {
      print(res.body);
      return jsonDecode(res.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice'),
      ),
      body: FutureBuilder(
          future: _notices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List notice = snapshot.data['notice'];
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: notice.length,
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo, width: 2.5),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notice[index]['title'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(notice[index]['description']),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddNotice(
            refresh: () => setState(() {
              _notices = getNotice();
            }),
          ),
        ),
        label: Text('Add Notice'),
        icon: Icon(Icons.add_rounded),
      ),
    );
  }
}

class AddNotice extends StatefulWidget {
  const AddNotice({super.key, required this.refresh});
  final VoidCallback refresh;

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  String sendTo = 'All';
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  addNotice() async {
    var url = Uri.parse('$ipv4/addNotice');
    var res = await http.post(url, body: {
      'sendTo': sendTo,
      'title': title.text.trim(),
      'description': description.text.trim()
    });
    if (res.body == 'true') {
      print(res.body);
      widget.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 700,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Notice',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    'Send To  ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        child: Text('All'),
                        value: 'All',
                      )
                    ],
                    onChanged: (value) {},
                    value: sendTo,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 800,
                child: TextField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: ElevatedButton(
                  onPressed: addNotice,
                  child: Text('Send'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
