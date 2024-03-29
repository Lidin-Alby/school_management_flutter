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
  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController schoolCode = TextEditingController();
  late String logSchoolCode;
  int _selected = 0;

  List schoolCodesList = [];
  bool logged = false;

  goFun(String state) {
    if (state == 'own') {
      context.go('/myApp');
    } else if (state == 'agent') {
      context.go('/midCardHome');
    } else {
      //context.go('/students');
      print(state);
      logSchoolCode = schoolCode.text.trim();
      context.go('/$state');
    }
  }

  // getSchoolCodes() async {
  //   var url = Uri.parse('$ipv4/getSchoolCodes');
  //   print(url);
  //   var res = await http.get(url);
  //   if (res.body.isEmpty) {
  //     return;
  //   } else {
  //     List data = jsonDecode(res.body);
  //     print(data);
  //     schoolCodesList = data.map((e) => e['schoolCode']).toList();
  //     return data;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _selected = 0;
                        });
                      },
                      child: Text('Edumid'),
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          // elevation: 0,
                          backgroundColor:
                              _selected == 0 ? Colors.indigo : null,
                          foregroundColor:
                              _selected == 0 ? Colors.white : null)),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selected = 1;
                      });
                    },
                    child: Text('Mid'),
                    style: _selected == 1
                        ? TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            // elevation: 0,
                            backgroundColor:
                                _selected == 1 ? Colors.indigo : null,
                            foregroundColor:
                                _selected == 1 ? Colors.white : null)
                        : null,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
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
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: schoolCode,
                        decoration: InputDecoration(
                            hintText: 'School Code',
                            filled: true,
                            fillColor: Colors.indigo[50],
                            border: OutlineInputBorder(),
                            isDense: true),
                      ),
                    ),
                    // Container(
                    //   alignment: AlignmentDirectional.center,
                    //   width: 300,
                    //   height: 43,
                    //   // margin: EdgeInsets.only(top: 10),
                    //   decoration: BoxDecoration(
                    //       color: Colors.indigo[50],
                    //       border: Border.all(
                    //         color: Colors.grey.shade600,
                    //       ),
                    //       borderRadius: BorderRadius.circular(5)),
                    //   child: DropdownButton(
                    //     isExpanded: true,
                    //     borderRadius: BorderRadius.circular(10),
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: 12, vertical: 4),
                    //     value: selectedCode,
                    //     isDense: true,
                    //     underline: Text(''),
                    //     hint: Text('School Code'),
                    //     items: schoolCodesList
                    //         .map((e) => DropdownMenuItem(
                    //             value: e.toString(),
                    //             child: Text(e.toString())))
                    //         .toList(),
                    //     onChanged: (value) {
                    //       setState(() {
                    //         selectedCode = value;
                    //       });
                    //     },
                    //   ),
                    // ),
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
                        if (_selected == 0) {
                          var client = BrowserClient()..withCredentials = true;

                          http.Response response;
                          var url = Uri.parse('$ipv4/login');
                          print(url);
                          response = await client.post(
                            url,
                            body: {
                              'userName': userId.text.trim(),
                              'password': password.text.trim(),
                              'schoolCode': schoolCode.text.trim()
                            },
                          );

                          goFun(response.body);
                        } else {
                          var client = BrowserClient()..withCredentials = true;

                          http.Response response;
                          var url = Uri.parse('$ipv4/loginMid');
                          print(url);
                          response = await client.post(
                            url,
                            body: {
                              'userName': userId.text.trim(),
                              'password': password.text.trim(),
                              'schoolCode': schoolCode.text.trim()
                            },
                          );

                          goFun(response.body);
                        }
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
