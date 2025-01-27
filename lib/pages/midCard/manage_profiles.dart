import 'dart:async';
import 'dart:convert';

import 'package:file_saver/file_saver.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/browser_client.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:school_management/pages/midCard/admin__student_edit.dart';

import 'dart:html' as html;

import '../../ip_address.dart';
// import '../../widgets/dropdown_widget.dart';

class ManageProfiles extends StatefulWidget {
  const ManageProfiles({super.key});

  @override
  State<ManageProfiles> createState() => _ManageProfilesState();
}

class _ManageProfilesState extends State<ManageProfiles> {
  late Future _getAllSchools;
  late Future _getData;
  String? selectedSchool;
  String? selectedUser;
  String? selectedStatus;
  String searchText = '';
  List selectedList = [];
  bool ascending = true;
  bool next = false;
  late String selectedSchoolName;

  getAllSchools() async {
    var client = BrowserClient()..withCredentials = true;

    var url = Uri.parse('$ipv4/getAllMidSchools');
    // var res = await http.get(url);
    var res = await client.get(url);
    print(res.body);
    List schools = jsonDecode(res.body);
    return schools;
  }

  getData() async {
    if (selectedSchool != null &&
        selectedUser != null &&
        selectedStatus != null) {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/getMidData');
      var res = await client.post(url, body: {
        'selectedSchool': selectedSchool,
        'selectedUser': selectedUser,
        'selectedStatus': selectedStatus
      });
      print(res.body);
      List data = jsonDecode(res.body);
      return data;
    }
  }

  downloadCSV() async {
    var url = Uri.parse('$ipv4/CSVdownloadMid');
    var res = await http.post(url, body: {
      'selectedSchool': selectedSchool,
      'selectedUser': selectedUser,
      'selectedStatus': selectedStatus
    });
    final csvBytes = res.bodyBytes;
    FileSaver.instance.saveFile(
      name:
          '${selectedSchool}_${selectedSchoolName}_${DateFormat('MMMM dd, yyyy h:mm a').format(DateTime.now())}',
      bytes: csvBytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  printingFunction(Map info) async {
    Navigator.pop(context);
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/setPrintInfo');
    Map body = {
      'selectedUser': selectedUser,
      'selectedSchool': selectedSchool,
      'selectedList': jsonEncode(selectedList),
    };
    body.addAll(info);
    var res = await client.post(url, body: body);
    print(res.body);
    if (res.body == 'true') {
      setState(() {
        _getData = getData();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            content: const Row(
              children: [
                Text(
                  'Updated Successfully ',
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
  }

  @override
  void initState() {
    _getAllSchools = getAllSchools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: selectedUser != null && selectedStatus != null
                  ? () async {
                      var client = BrowserClient()..withCredentials = true;
                      var url = Uri.parse('$ipv4/prepareZipCSV');

                      var res = await client.post(url, body: {
                        'selectedUser': selectedUser,
                        'selectedStatus': selectedStatus
                      });
                      // final dir = await getDownloadsDirectory();

                      final zip = res.bodyBytes;
                      FileSaver.instance.saveFile(
                        name: 'All-Csv',
                        bytes: zip,
                        ext: 'zip',
                        mimeType: MimeType.zip,
                      );
                    }
                  : null,
              child: Text('Download All Csv'),
            ),
          ),
          FutureBuilder(
            future: _getAllSchools,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List schools = snapshot.data;
                Map schoolNames = {};

                return Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: DropdownMenu(
                        enableFilter: true,
                        label: Text('Select School'),
                        dropdownMenuEntries: schools.map((e) {
                          schoolNames
                              .addAll({e['schoolCode']: e['schoolName']});
                          return DropdownMenuEntry(
                            label: '${e['schoolCode']} - ${e['schoolName']}',
                            value: e['schoolCode'],
                          );
                        }).toList(),
                        onSelected: (value) {
                          setState(() {
                            selectedSchool = value.toString();
                            selectedSchoolName = schoolNames[selectedSchool];

                            selectedList = [];
                            _getData = getData();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DropDownWidget(
                      items: ['Students', 'Teachers', 'Staffs'],
                      title: 'Select User',
                      isEdit: true,
                      callBack: (p0) {
                        setState(() {
                          selectedUser = p0;
                          selectedList = [];
                          _getData = getData();
                        });
                      },
                      selected: selectedUser,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            alignment: AlignmentDirectional.center,
                            // width: 250,
                            height: 43,
                            // margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              disabledHint: selectedStatus != null
                                  ? Text(
                                      selectedStatus.toString(),
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      'Select Status',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                              value: selectedStatus,
                              isExpanded: true,
                              underline: Text(''),
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text('Select Status'),
                              ),
                              items: [
                                DropdownMenuItem(
                                  child: Text('List'),
                                  value: 'list',
                                ),
                                DropdownMenuItem(
                                  child: Text('Unchecked'),
                                  value: 'unCheck',
                                ),
                                DropdownMenuItem(
                                  child: Text('Checked'),
                                  value: 'check',
                                ),
                                DropdownMenuItem(
                                  child: Text('Not Ready to Print'),
                                  value: 'not ready',
                                ),
                                DropdownMenuItem(
                                  child: Text('Ready to Print'),
                                  value: 'ready',
                                ),
                                DropdownMenuItem(
                                  child: Text('Printing'),
                                  value: 'printing',
                                ),
                                DropdownMenuItem(
                                  child: Text('Printed'),
                                  value: 'printed',
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value;
                                  selectedList = [];
                                  _getData = getData();
                                });
                              },
                            ),
                          ),
                          if (selectedStatus != null)
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              color: Colors.blue[50],
                              child: Text(
                                'Select Status',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
          if (selectedSchool != null &&
              selectedUser != null &&
              selectedStatus != null)
            Expanded(
                child: LayoutBuilder(
              builder: (context, constraints) => FutureBuilder(
                future: _getData,
                builder: (context, snapshot) {
                  double width = constraints.maxWidth / 7;
                  if (snapshot.hasData) {
                    List listOf = snapshot.data;
                    if (searchText != '') {
                      listOf = listOf
                          .where((element) =>
                              element['admNo']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchText.toString().toLowerCase()) ||
                              element['fullName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      searchText.toString().toLowerCase()))
                          .toList();
                    }
                    List admList = listOf.map((e) => e['admNo']).toList();
                    List mobList = listOf.map((e) => e['mob']).toList();
                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: selectedList.isEmpty
                                    ? null
                                    : () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Perform Action'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  selectedList.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Are you sure you want to perform the action?'),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Cancel')),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    printingFunction({
                                                      'ready': false.toString()
                                                    });
                                                  },
                                                  child: Text('Confirm'))
                                            ],
                                          ),
                                        ),
                                child: Text('Move out of Print'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: selectedList.isEmpty
                                    ? null
                                    : () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Perform Action'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  selectedList.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Are you sure you want to perform the action?'),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Cancel')),
                                              ElevatedButton(
                                                  onPressed: () =>
                                                      printingFunction({
                                                        'ready': true.toString()
                                                      }),
                                                  child: Text('Confirm'))
                                            ],
                                          ),
                                        ),
                                child: Text('Move Ready to Print'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow[700]),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: selectedList.isEmpty
                                    ? null
                                    : () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Perform Action'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  selectedList.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Are you sure you want to perform the action?'),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Cancel')),
                                              ElevatedButton(
                                                  onPressed: () =>
                                                      printingFunction({
                                                        'printed':
                                                            false.toString()
                                                      }),
                                                  child: Text('Confirm'))
                                            ],
                                          ),
                                        ),
                                child: Text(
                                  'Move to Printing',
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: selectedList.isEmpty
                                    ? null
                                    : () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Perform Action'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  selectedList.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Are you sure you want to perform the action?'),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Cancel')),
                                              ElevatedButton(
                                                  onPressed: () =>
                                                      printingFunction({
                                                        'printed':
                                                            true.toString()
                                                      }),
                                                  child: Text('Confirm'))
                                            ],
                                          ),
                                        ),
                                child: Text('Move to Printed'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: downloadCSV,
                                child: Text('Download CSV'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () => showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => DownloadDialog(
                                    selectedSchool: selectedSchool!,
                                  ),
                                ),
                                child: Text('Download Photos'),
                              )
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 400,
                              child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                            SizedBox(
                              width: 10,
                            ),
                            FilterChip(
                              selected: next,
                              showCheckmark: false,
                              selectedColor: Colors.indigo,
                              labelStyle:
                                  TextStyle(color: next ? Colors.white : null),
                              label: Text('Next'),
                              onSelected: (value) {
                                setState(() {
                                  next = value;
                                });
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Row(children: [Text('Image Name'),text],),
                        selectedUser == 'Students'
                            ? Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    // physics: NeverScrollableScrollPhysics(),
                                    // shrinkWrap: true,
                                    itemCount: listOf.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: width - 100,
                                              child: Checkbox(
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value!) {
                                                      selectedList = admList;
                                                    } else {
                                                      selectedList = [];
                                                    }
                                                  });
                                                },
                                                value: admList.every(
                                                    (element) => selectedList
                                                        .contains(element)),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (ascending) {
                                                    listOf.sort((a, b) =>
                                                        a['admNo'].compareTo(
                                                          b['admNo']!,
                                                        ));
                                                  } else {
                                                    listOf.sort((a, b) =>
                                                        b['admNo'].compareTo(
                                                          a['admNo']!,
                                                        ));
                                                  }
                                                });
                                                ascending = !ascending;
                                              },
                                              child: SizedBox(
                                                width: width - 100,
                                                child: Text(
                                                  'Adm No.',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            if (!next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['profilePic']
                                                              .toString()
                                                              .compareTo(
                                                                b['profilePic']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['profilePic']
                                                              .toString()
                                                              .compareTo(
                                                                a['profilePic']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width: width + 75,
                                                  child: Text(
                                                    'Image Name',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (!next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['fullName']
                                                              .compareTo(
                                                            b['fullName']
                                                                .toString(),
                                                          ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['fullName']
                                                              .compareTo(
                                                            a['fullName']
                                                                .toString(),
                                                          ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width: width,
                                                  child: Text(
                                                    'Full Name',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (!next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['classTitle']
                                                              .toString()
                                                              .compareTo(
                                                                b['classTitle']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['classTitle']
                                                              .toString()
                                                              .compareTo(
                                                                a['classTitle']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width: width - 75,
                                                  child: Text(
                                                    'Class',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (!next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['fatherName']
                                                              .toString()
                                                              .compareTo(
                                                                b['fatherName']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['fatherName']
                                                              .toString()
                                                              .compareTo(
                                                                a['fatherName']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width: width,
                                                  child: Text(
                                                    'Father Name',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (!next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['fatherMobNo']
                                                              .toString()
                                                              .compareTo(
                                                                b['fatherMobNo']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['fatherMobNo']
                                                              .toString()
                                                              .compareTo(
                                                                a['fatherMobNo']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width: (width) - 50,
                                                  child: Text(
                                                    'Mobile',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (!next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['address']
                                                              .toString()
                                                              .compareTo(
                                                                b['address']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['address']
                                                              .toString()
                                                              .compareTo(
                                                                a['address']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width: width + 50,
                                                  child: Text(
                                                    'Address',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['motherName']
                                                              .toString()
                                                              .compareTo(
                                                                b['motherName']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort(
                                                        (a, b) =>
                                                            b['motherName']
                                                                .toString()
                                                                .compareTo(
                                                                  a['motherName']
                                                                      .toString(),
                                                                ),
                                                      );
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width:
                                                      constraints.maxWidth / 5,
                                                  child: Text(
                                                    'Mother Name',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['schoolHouse']
                                                              .toString()
                                                              .compareTo(
                                                                b['schoolHouse']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['schoolHouse']
                                                              .toString()
                                                              .compareTo(
                                                                a['schoolHouse']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width:
                                                      constraints.maxWidth / 5,
                                                  child: Text(
                                                    'House',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['dob']
                                                              .toString()
                                                              .compareTo(
                                                                b['dob']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['dob']
                                                              .toString()
                                                              .compareTo(
                                                                a['dob']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width:
                                                      constraints.maxWidth / 5,
                                                  child: Text(
                                                    'DOB',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            if (next)
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (ascending) {
                                                      listOf.sort((a, b) =>
                                                          a['transportMode']
                                                              .toString()
                                                              .compareTo(
                                                                b['transportMode']
                                                                    .toString(),
                                                              ));
                                                    } else {
                                                      listOf.sort((a, b) =>
                                                          b['transportMode']
                                                              .toString()
                                                              .compareTo(
                                                                a['transportMode']
                                                                    .toString(),
                                                              ));
                                                    }
                                                  });
                                                  ascending = !ascending;
                                                },
                                                child: SizedBox(
                                                  width:
                                                      constraints.maxWidth / 5,
                                                  child: Text(
                                                    'Mode of Transport',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: width - 100,
                                              child: Checkbox(
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value!) {
                                                      selectedList.add(
                                                          listOf[index - 1]
                                                              ['admNo']);
                                                    } else {
                                                      selectedList.remove(
                                                          listOf[index - 1]
                                                              ['admNo']);
                                                    }
                                                  });
                                                },
                                                value: selectedList.contains(
                                                    listOf[index - 1]['admNo']),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width - 100,
                                              child: Text(listOf[index - 1]
                                                      ['admNo']
                                                  .toString()),
                                            ),
                                            if (!next)
                                              SizedBox(
                                                width: width + 75,
                                                child: InkWell(
                                                  onTap: () => html.window.open(
                                                      '$ipv4/img/$selectedSchool/${listOf[index - 1]['profilePic']}',
                                                      'Image'),
                                                  child: Text(listOf[index - 1]
                                                          ['profilePic']
                                                      .toString()),
                                                ),
                                              ),
                                            if (!next)
                                              SizedBox(
                                                width: width,
                                                child: Text(listOf[index - 1]
                                                        ['fullName']
                                                    .toString()),
                                              ),
                                            if (!next)
                                              SizedBox(
                                                width: width - 75,
                                                child: Text(listOf[index - 1]
                                                        ['classTitle']
                                                    .toString()),
                                              ),
                                            if (!next)
                                              SizedBox(
                                                width: width,
                                                child: Text(listOf[index - 1]
                                                        ['fatherName']
                                                    .toString()),
                                              ),
                                            if (!next)
                                              SizedBox(
                                                width: (width) - 50,
                                                child: Text(listOf[index - 1]
                                                        ['fatherMobNo']
                                                    .toString()),
                                              ),
                                            if (!next)
                                              SizedBox(
                                                width: width,
                                                child: Text(listOf[index - 1]
                                                        ['address']
                                                    .toString()),
                                              ),
                                            if (!next)
                                              IconButton(
                                                  onPressed: () => showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AdminStudentEditPage(
                                                          schoolCode:
                                                              selectedSchool!,
                                                          admNo:
                                                              listOf[index - 1]
                                                                  ['admNo'],
                                                          listRefresh: () {
                                                            setState(() {
                                                              _getData =
                                                                  getData();
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                  icon: Icon(Icons.edit)),
                                            if (next)
                                              SizedBox(
                                                width: constraints.maxWidth / 5,
                                                child: Text(listOf[index - 1]
                                                        ['motherName']
                                                    .toString()),
                                              ),
                                            if (next)
                                              SizedBox(
                                                width: constraints.maxWidth / 5,
                                                child: Text(listOf[index - 1]
                                                        ['schoolHouse']
                                                    .toString()),
                                              ),
                                            if (next)
                                              SizedBox(
                                                width: constraints.maxWidth / 5,
                                                child: Text(listOf[index - 1]
                                                        ['dob']
                                                    .toString()),
                                              ),
                                            if (next)
                                              SizedBox(
                                                width: constraints.maxWidth / 5,
                                                child: Text(listOf[index - 1]
                                                        ['transportMode']
                                                    .toString()),
                                              ),
                                            if (next)
                                              IconButton(
                                                  onPressed: () => showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AdminStudentEditPage(
                                                          schoolCode:
                                                              selectedSchool!,
                                                          admNo:
                                                              listOf[index - 1]
                                                                  ['admNo'],
                                                          listRefresh: () {
                                                            setState(() {
                                                              _getData =
                                                                  getData();
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                  icon: Icon(Icons.edit)),
                                          ],
                                        );
                                      }
                                    }),
                              )
                            : Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    // physics: NeverScrollableScrollPhysics(),
                                    // shrinkWrap: true,
                                    itemCount: listOf.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: width - 100,
                                              child: Checkbox(
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value!) {
                                                      selectedList = mobList;
                                                    } else {
                                                      selectedList = [];
                                                    }
                                                  });
                                                },
                                                value: mobList.every(
                                                    (element) => selectedList
                                                        .contains(element)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(
                                                'Image Name',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(
                                                'Full Name',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(
                                                'Mobile No.',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(
                                                'Address',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          children: [
                                            SizedBox(
                                              width: width - 100,
                                              child: Checkbox(
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      if (value!) {
                                                        selectedList.add(
                                                            listOf[index - 1]
                                                                ['mob']);
                                                      } else {
                                                        selectedList.remove(
                                                            listOf[index - 1]
                                                                ['mob']);
                                                      }
                                                    },
                                                  );
                                                },
                                                value: selectedList.contains(
                                                    listOf[index - 1]['mob']),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(
                                                listOf[index - 1]['profilePic']
                                                    .toString(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(listOf[index - 1]
                                                      ['fullName']
                                                  .toString()),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(listOf[index - 1]
                                                      ['mob']
                                                  .toString()),
                                            ),
                                            SizedBox(
                                              width: width,
                                              child: Text(listOf[index - 1]
                                                      ['address']
                                                  .toString()),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                              ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ))
        ],
      ),
    );
  }
}

class DownloadDialog extends StatefulWidget {
  const DownloadDialog({super.key, required this.selectedSchool});
  final String selectedSchool;

  @override
  State<DownloadDialog> createState() => _DownloadDialogState();
}

class _DownloadDialogState extends State<DownloadDialog> {
  bool isDone = false;
  preparePhotos() async {
    var url = Uri.parse('$ipv4/prepareZipPhotos/${widget.selectedSchool}');
    var res = await http.get(url);

    if (res.body == 'true') {
      setState(() {
        isDone = true;
      });
    }
  }

  downloadPhotos() async {
    var url = Uri.parse('$ipv4/downloadZipPhotos/${widget.selectedSchool}');
    var res = await http.get(url);
    final csvBytes = res.bodyBytes;
    FileSaver.instance.saveFile(
      name:
          '${widget.selectedSchool}_${DateFormat('MMMM dd, yyyy h:mm a').format(DateTime.now())}',
      bytes: csvBytes,
      ext: 'zip',
      mimeType: MimeType.zip,
    );
  }

  @override
  void initState() {
    preparePhotos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 200,
        width: 400,
        child: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close),
                ),
              ),
              Text(
                'Preparing Zip...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              isDone
                  ? ElevatedButton(
                      onPressed: downloadPhotos, child: Text('Download'))
                  : SizedBox(
                      width: 50, height: 50, child: CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }
}

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    Key? key,
    required this.items,
    required this.title,
    required this.isEdit,
    required this.callBack,
    required this.selected,
  }) : super(key: key);
  final List items;
  final dynamic selected;
  final String title;
  final bool isEdit;
  final Function(dynamic) callBack;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: !isEdit,
            child: Container(
              margin: EdgeInsets.only(top: 3),
              alignment: AlignmentDirectional.center,
              // width: 250,
              height: 43,
              // margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                disabledHint: selected != null
                    ? Text(
                        selected.toString(),
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        title,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                value: selected,
                isExpanded: true,
                underline: Text(''),
                hint: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(title),
                ),
                items: items
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (value) {
                  callBack(value);
                },
              ),
            ),
          ),
          if (selected != null)
            Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 3),
                color: Colors.blue[50],
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ))
        ],
      ),
    );
  }
}
