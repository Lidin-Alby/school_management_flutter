import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';

import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Future _data;
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();
  String? selectedCode;
  List schoolCodesList = [];
  bool logged = false;

  goFun(String state) {
    if (state == 'own') {
      context.go('/myApp');
    } else {
      //context.go('/students');
      print(state);
      context.go('/$state');
    }
  }

  getSchoolCodes() async {
    var url = Uri.http(ipv4, '/getSchoolCodes');
    var res = await http.get(url);
    if (res.body.isEmpty) {
      return;
    } else {
      List data = jsonDecode(res.body);
      print(data);
      schoolCodesList = data.map((e) => e['schoolCode']).toList();
      return data;
    }
  }

  @override
  void initState() {
    _data = getSchoolCodes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.indigo,
              body: Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  //  color: Colors.indigo,
                  child: Padding(
                    padding: const EdgeInsets.all(35),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.indigo[400],
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: userId,
                            decoration: InputDecoration(
                                hintText: 'UserID / Admission No.',
                                filled: true,
                                fillColor: Colors.indigo[50],
                                border: OutlineInputBorder(),
                                isDense: true),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: AlignmentDirectional.center,
                          width: 300,
                          height: 43,
                          // margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                              color: Colors.indigo[50],
                              border: Border.all(
                                color: Colors.grey.shade600,
                              ),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            value: selectedCode,
                            isDense: true,
                            underline: Text(''),
                            hint: Text('School Code'),
                            items: schoolCodesList
                                .map((e) => DropdownMenuItem(
                                    value: e.toString(),
                                    child: Text(e.toString())))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCode = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: password,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.indigo[50],
                                hintText: 'Password',
                                border: OutlineInputBorder(),
                                isDense: true),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            var client = BrowserClient()
                              ..withCredentials = true;

                            http.Response response;
                            var url = Uri.http(ipv4, '/login');

                            response = await client.post(
                              url,
                              body: {
                                'userName': userId.text.trim(),
                                'password': password.text.trim(),
                                'schoolCode': selectedCode ?? ''
                              },
                            );

                            goFun(response.body);
                          },
                          child: Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
