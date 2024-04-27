import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/pages/midCard/all_list.dart';
import 'package:http/http.dart' as http;

import '../../ip_address.dart';
import 'add_menu.dart';
import 'attendance_mid.dart';
import 'mid_tile_widget.dart';
import 'ready_print.dart';
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

class RightMenu extends StatefulWidget {
  const RightMenu(
      {super.key, required this.schoolCode, required this.schoolName});

  final String schoolName;
  final String schoolCode;

  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> {
  late Future _getCount;
  getCount() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/midCount/${widget.schoolCode}');
    var res = await client.get(url);
    Map data = jsonDecode(res.body);
    print(data);
    return data;
  }

  @override
  void initState() {
    _getCount = getCount();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RightMenu oldWidget) {
    if (widget.schoolCode != oldWidget.schoolCode) {
      setState(() {
        _getCount = getCount();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: width > 645 ? Colors.transparent : null,
        elevation: 0,
        title: Text(
          widget.schoolName,
          style: width > 645 ? TextStyle(color: Colors.black) : null,
        ),
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
        future: _getCount,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map counts = snapshot.data;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => BulkUplaodDialog(
                          schoolCode: widget.schoolCode,
                        ),
                      ),
                      child: Text('Bulk Upload'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete All'),
                                content: Text(
                                    'Are you sure you want to delete all data?'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      var client = BrowserClient()
                                        ..withCredentials = true;
                                      var url =
                                          Uri.parse('$ipv4/deleteSchoolData');
                                      var res = await client.post(url, body: {
                                        'schoolCode': widget.schoolCode
                                      });
                                      if (res.body == 'true') {
                                        if (mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Colors.green[600],
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: const Row(
                                                children: [
                                                  Text(
                                                    'Deleted Sucessfully',
                                                  ),
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                  )
                                ],
                              ),
                            ),
                        child: Text('Delete All'))
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    MidTile(
                      icon: Icons.school_rounded,
                      title: 'Unchecked Data',
                      color: Colors.indigo,
                      count:
                          (counts['staffNotReady'] + counts['studentNotReady'])
                              .toString(),
                      callback: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              UncheckedDataPage(schoolCode: widget.schoolCode),
                        ),
                      ),
                    ),
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
                        count: (counts['staffReady'] + counts['studentReady'])
                            .toString(),
                        callback: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReadyPrintPage(
                                  schoolCode: widget.schoolCode,
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
                                  builder: (context) =>
                                      ListAll(schoolCode: widget.schoolCode)),
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
                Row(
                  children: [
                    MidTile(
                      icon: Icons.badge_rounded,
                      title: 'Attendance',
                      color: Colors.purple,
                      callback: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AttendanceMid(
                            schoolCode: widget.schoolCode,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          context: context,
          builder: (context) => AddPage(
            schoolCode: widget.schoolCode,
            schoolName: widget.schoolName,
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

class BulkUplaodDialog extends StatefulWidget {
  const BulkUplaodDialog({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<BulkUplaodDialog> createState() => _BulkUplaodDialogState();
}

class _BulkUplaodDialogState extends State<BulkUplaodDialog> {
  List<PlatformFile?>? files;
  bool isSaved = true;
  int progress = 0;

  savePersonalInfo() async {
    String? messagge;

    setState(() {
      isSaved = false;
    });
    //   var url = Uri.parse('$ipv4/addPersonalInfo');

    for (int i = 0; i < files!.length; i++) {
      var url = Uri.parse('$ipv4/bulkUploadMid');

      var req = http.MultipartRequest(
        'POST',
        url,
      );

      var httpFile = http.MultipartFile.fromBytes(
          'profilePic', files![i]!.bytes!,
          filename: files![i]!.name);
      req.files.add(httpFile);

      req.fields.addAll({'schoolCode': widget.schoolCode});

      var res = await req.send();
      var responded = await http.Response.fromStream(res);

      // var response = await http.post(url, body: {

      //   //  'vehicleNo': vehicleNo,
      // });
      // print(response.statusCode);
      if (responded.body == 'true') {
        setState(() {
          progress++;
          if (progress == files!.length) {
            isSaved = true;
          }
        });
      } else {
        messagge = responded.body.toString();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              content: Text(
                messagge.toString(),
              ),
            ),
          );
        }
        setState(() {
          isSaved = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: 800,
            height: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: true,
                          );
                          if (result != null) {
                            setState(() {
                              files = result.files;
                            });
                          }
                        },
                        child: Text('Select Photos')),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    height: 500,
                    width: 800,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5)),
                    child: files != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Wrap(
                                runSpacing: 20,
                                spacing: 5,
                                direction: Axis.vertical,
                                children: [
                                  for (int i = 0; i < files!.length; i++)
                                    Text(files![i]!.name)
                                ],
                              ),
                            ),
                          )
                        : Center(child: Text('No items selected')),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: isSaved
                      ? ElevatedButton(
                          onPressed: savePersonalInfo, child: Text('upload'))
                      : CircularProgressIndicator(
                          value: progress / files!.length,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
