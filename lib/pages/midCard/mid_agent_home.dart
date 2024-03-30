import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../../ip_address.dart';
import 'add_menu.dart';
import 'mid_tile_widget.dart';
import 'unchecked_data_page.dart';

class MidAgentHome extends StatefulWidget {
  const MidAgentHome({super.key});

  @override
  State<MidAgentHome> createState() => _MidAgentHomeState();
}

class _MidAgentHomeState extends State<MidAgentHome> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController schoolCode = TextEditingController();
  TextEditingController schoolName = TextEditingController();
  TextEditingController schoolPassword = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController email = TextEditingController();
  late Future _myMidSchools;
  late String agentMob;
  int? _selectedIndex;
  List schools = [];

  getMyMidSchools() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getMyMidSchools');
    var res = await client.get(url);
    print(res.body);
    var data = jsonDecode(res.body);
    agentMob = data['mob'];

    return data['schools'];
  }

  addMidSchool() async {
    if (_formKey.currentState!.validate()) {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/addNewSchoolMid');
      var res = await client.post(url, body: {
        'schoolCode': schoolCode.text.trim(),
        'mob': mob.text.trim(),
        'schoolName': schoolName.text.trim(),
        'schoolPassword': schoolPassword.text.trim(),
        'agentMob': agentMob,
        'email': email.text.trim()
      });

      if (res.body == 'true') {
        if (mounted) {
          Navigator.of(context).pop();
        }
        setState(() {
          schoolCode.clear();
          schoolName.clear();
          schoolPassword.clear();
          mob.clear();
          email.clear();
          _myMidSchools = getMyMidSchools();
        });
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  Text(
                    res.body,
                  ),
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    _myMidSchools = getMyMidSchools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (width < 645) {
      _selectedIndex = null;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: OutlinedButton(
                        onPressed: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 250,
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: schoolCode,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'This field is required';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: 'School Code',
                                                    isDense: true,
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                controller: mob,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'This field is required';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: 'Mobile No.',
                                                    isDense: true,
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                controller: schoolPassword,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'This field is required';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    suffixIcon: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 2,
                                                          horizontal: 4),
                                                      child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              foregroundColor:
                                                                  Colors.white,
                                                              backgroundColor:
                                                                  Colors
                                                                      .indigo),
                                                          //   splashRadius: 25,
                                                          child: Icon(Icons
                                                              .refresh_rounded),
                                                          onPressed: () {
                                                            const chars =
                                                                'abcdefghijklmnopqrstuvwxyz1234567890@#%!*';

                                                            setState(() {
                                                              schoolPassword
                                                                      .text =
                                                                  String
                                                                      .fromCharCodes(
                                                                Iterable
                                                                    .generate(
                                                                  6,
                                                                  (_) => chars
                                                                      .codeUnitAt(
                                                                    Random().nextInt(
                                                                        chars
                                                                            .length),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                          }),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: 'School Password',
                                                    isDense: true,
                                                    helperStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                controller: schoolName,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'This field is required';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: 'School Name',
                                                    isDense: true,
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextFormField(
                                                controller: email,
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText: 'Email',
                                                    isDense: true,
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                  onPressed: addMidSchool,
                                                  child: Text('Add'))
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        child: Text('Add School')),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: FutureBuilder(
                    future: _myMidSchools,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        schools = snapshot.data;

                        return schools.isEmpty
                            ? Center(child: Text('No schools Added'))
                            : ListView.builder(
                                itemCount: schools.length,
                                itemBuilder: (context, index) => Card(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.indigo, width: 2),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    selected: index == _selectedIndex,
                                    selectedColor: Colors.white,
                                    selectedTileColor: Colors.indigo,
                                    onTap: width > 645
                                        ? () {
                                            setState(() {
                                              _selectedIndex = index;
                                            });
                                          }
                                        : () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) => RightMenu(
                                                schoolCode: schools[index]
                                                    ['schoolCode'],
                                                schoolName: schools[index]
                                                    ['schoolName'],
                                              ),
                                            )),
                                    title: Text(
                                      schools[index]['schoolName'],
                                    ),
                                    trailing:
                                        Text(schools[index]['schoolCode']),
                                  ),
                                ),
                              );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
                ],
              ),
            ),
            if (width > 645) VerticalDivider(),
            if (width > 645)
              Expanded(
                flex: 3,
                child: _selectedIndex != null
                    ? RightMenu(
                        schoolCode: schools[_selectedIndex!]['schoolCode'],
                        schoolName: schools[_selectedIndex!]['schoolName'],
                      )
                    : schools.isNotEmpty
                        ? SizedBox()
                        : Center(child: Text('Select School to show menu')),
              )
          ],
        ),
      ),
    );
  }
}

class RightMenu extends StatelessWidget {
  const RightMenu(
      {super.key, required this.schoolCode, required this.schoolName});

  final String schoolName;
  final String schoolCode;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: width > 645 ? Colors.transparent : null,
        elevation: 0,
        title: Text(
          schoolName,
          style: width > 645 ? TextStyle(color: Colors.black) : null,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                MidTile(
                    icon: Icons.school_rounded,
                    title: 'Unchecked Data',
                    color: Colors.indigo,
                    callback: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                UncheckedDataPage(schoolCode: schoolCode),
                          ),
                        )),
                MidTile(
                    icon: Icons.no_photography_rounded,
                    title: 'Without Photos',
                    color: Colors.pink,
                    callback: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text('Without Photos'),
                              ),
                            ),
                          ),
                        )),
              ],
            ),
            Row(
              children: [
                MidTile(
                    icon: Icons.print_rounded,
                    title: 'Ready to Print',
                    color: Colors.green,
                    callback: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text('Ready to Print'),
                              ),
                            ),
                          ),
                        )),
                MidTile(
                  icon: Icons.login_rounded,
                  title: 'Login Pending',
                  color: Colors.teal,
                  callback: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Login Pending'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                MidTile(
                    icon: Icons.list_alt_rounded,
                    title: 'List',
                    color: Colors.orange.shade200,
                    callback: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text('List'),
                              ),
                            ),
                          ),
                        )),
                MidTile(
                  icon: Icons.badge_rounded,
                  title: 'Card Designs',
                  color: Colors.cyan,
                  callback: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Card Designs'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) => AddPage(
            schoolCode: schoolCode,
            schoolName: schoolName,
          ),
        ),
      ),
    );
  }
}

class Newpage extends StatelessWidget {
  const Newpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
