import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/ip_address.dart';

class AccessControl extends StatefulWidget {
  const AccessControl({super.key, required this.isrefered});
  final bool isrefered;

  @override
  State<AccessControl> createState() => _AccessControlState();
}

class _AccessControlState extends State<AccessControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Future _userTypes;
  bool newUser = false;
  TextEditingController newUserType = TextEditingController();
  @override
  void initState() {
    _userTypes = getUserTypes();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  getUserTypes() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getUserType');

    var response = await client.get(url);
    print(response.body);
    return jsonDecode(response.body);
  }

  addUserType() async {
    var client = BrowserClient()..withCredentials = true;
    if (newUserType.text.trim().isEmpty) {
      return;
    }
    var url = Uri.http(ipv4, '/addUserType');

    var response = await client.post(
      url,
      body: {
        'userType': newUserType.text.trim(),
      },
    );
    if (response.body == 'true') {
      print('done');
      _userTypes = getUserTypes();
      newUserType.clear();
      setState(() {
        newUser = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Access Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: widget.isrefered
                  ? FadeTransition(
                      opacity: _animationController,
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() {
                          _animationController.forward();
                          newUser = true;
                        }),
                        icon: Icon(Icons.add_rounded),
                        label: Text('New User Type'),
                      ),
                    )
                  : ElevatedButton.icon(
                      onPressed: () => setState(() {
                        _animationController.forward();
                        newUser = true;
                      }),
                      icon: Icon(Icons.add_rounded),
                      label: Text('New User Type'),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            if (newUser)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: newUserType,
                      decoration: InputDecoration(
                        hintText: 'Enter User Type',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  OutlinedButton(
                    onPressed: addUserType,
                    child: Text('Add'),
                  ),
                ],
              ),
            Divider(),
            FutureBuilder(
              future: _userTypes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List data = snapshot.data;
                  print('da');
                  print(data);
                  return Expanded(
                    child: GridView.builder(
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 3, crossAxisCount: 5),
                      itemBuilder: (context, index) => Card(
                        color: Colors.indigo[100],
                        child: InkWell(
                          onDoubleTap: () => context.push(
                              '/accessControl/${data[index]['userType']}'),
                          child: Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              data[index]['userType'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
