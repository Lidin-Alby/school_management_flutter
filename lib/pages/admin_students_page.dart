import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

import 'add_student_dialog.dart';

class AdminStudents extends StatefulWidget {
  const AdminStudents({super.key});

  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {
  late Future<List> getData;
  // TextEditingController searchController = TextEditingController();
  String searchText = '';
  String? selectedClass = 'All';
  List searchList = [];
  List classes = [
    {'title': 'All'}
  ];
  List selectedStudents = [];
  int pages = 0;
  int currPage = 1;
  int selectedLen = 10;
  int listLen = 0;
  int start = 0;
  int scrollLen = 10;
  int scrollStart = 0;
  bool? selectAll = false;
  bool searchOn = false;
  String? currAdmNo;
  late String schoolCode;
  bool sort = false;
  bool admSort = false;
  bool nameSort = true;
  bool classSort = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    getData = getAllStudentUsers();
    getClass();
    listLen = selectedLen;
    super.initState();
  }

  //functions
  Future<List> getAllStudentUsers() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getStudents');
    http.Response response;
    response = await client.get(url);
    List students = json.decode(response.body);

    print(students);
    if (students.isNotEmpty) {
      currAdmNo = students[0]['admNo'];
    }
    return students;
  }

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassDetails');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List cl = jsonDecode(res.body);
    schoolCode = cl.last['schoolCode'];
    print(cl);
    cl.removeLast();

    setState(() {
      classes.addAll(cl);
    });
  }

  deleteStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/deleteStudent');
    var res = await client
        .post(url, body: {'students': jsonEncode(selectedStudents)});

    if (res.body == 'true') {
      setState(() {
        getData = getAllStudentUsers();
        selectedStudents = [];
      });
    }
  }

  Future<List> oneClass() async {
    var client = BrowserClient()..withCredentials = true;
    print(selectedClass);
    var url = Uri.parse('$ipv4/oneClass/$selectedClass');
    var res = await client.get(url);
    print(res.body);
    var data = jsonDecode(res.body);
    print(data);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: ElevatedButton.icon(
              onPressed: () => showModalBottomSheet(
                  enableDrag: false,
                  isScrollControlled: true,
                  isDismissible: true,

                  // barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AddNewStudent(
                      currAdmNo: currAdmNo,
                      refresh: () => setState(() {
                        getData = getAllStudentUsers();
                      }),
                    );
                  }),
              icon: Icon(Icons.add_rounded),
              label: Text('New Student'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: PopupMenuButton(
                onSelected: (value) async {
                  if (value == 0) {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    Uint8List? fileByte = result!.files.first.bytes;

                    var url = Uri.parse('$ipv4/uploadCSVStudentUsers');
                    print(schoolCode);

                    var req = http.MultipartRequest(
                      'POST',
                      url,
                    );
                    var httpDoc = http.MultipartFile.fromBytes(
                        'csvFile', fileByte!,
                        filename: 'upl_doc.csv');
                    req.files.add(httpDoc);
                    req.fields.addAll({'schoolCode': schoolCode});
                    var res = await req.send();
                    var responded = await http.Response.fromStream(res);
                    if (responded.body == 'true') {
                      if (context.mounted) {
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
                        getData = getAllStudentUsers();
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[700],
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              responded.body.toString(),
                            ),
                          ),
                        );
                      }
                    }
                  }
                  if (value == 1) {
                    //   List<List> sample = [];
                    var client = BrowserClient()..withCredentials = true;
                    var url = Uri.parse('$ipv4/downloadCSVStudentUsers');
                    var response = await client.get(url);
                    final csvBytes = response.bodyBytes;
                    FileSaver.instance.saveFile(
                      name: 'All students',
                      bytes: csvBytes,
                      ext: 'csv',
                      mimeType: MimeType.csv,
                    );
                  }
                  if (value == 2) {
                    var data = [
                      [
                        '"schoolCode"',
                        '"admNo"',
                        '"firstName"',
                        '"lastName"',
                        '"dob"',
                        '"className"',
                        '"sec"',
                        '"gender"',
                        '"profilePic"',
                        '"url"',
                        '"fatherName"',
                        '"motherName"',
                        '"fatherMobNo"',
                        '"perAddressLine1"',
                        '"perAddressLine2"',
                        '"perAddressLine3"',
                        '"perPincode"',
                        '"studentPassword"',
                        '"parentPassword"',
                        '"email"',
                        '"admDate"',
                        '"fatherAadhaar"',
                        '"fatherOccupation"',
                        '"fatherProfilePic"',
                        '"fatherWhatsApp"',
                        '"motherAadhaar"',
                        '"motherMobNo"',
                        '"motherOccupation"',
                        '"motherProfilePic"',
                        '"motherWhatsApp"',
                        '"gaurdianAadhaar"',
                        '"gaurdianMobNo"',
                        '"gaurdianName"',
                        '"gaurdianOccupation"',
                        '"gaurdianProfilePic"',
                        '"gaurdianRelation"',
                        '"gaurdianWhatsApp"',
                        '"curAddressLine1"',
                        '"curAddressLine2"',
                        '"curAddressLine3"',
                        '"curPincode"',
                        '"allergies"',
                        '"birthCertificate"',
                        '"bloodGroup"',
                        '"bloodReport"',
                        '"boardingType"',
                        '"caste"',
                        '"chickenPox"',
                        '"dpt"',
                        '"dt"',
                        '"govIdNo"',
                        '"hepatitisA"',
                        '"hepatitisB"',
                        '"measles"',
                        '"medicalIssue"',
                        '"mmr"',
                        '"operated"',
                        '"polio"',
                        '"religion"',
                        '"schoolHouse"',
                        '"sibling"',
                        '"studentEyeSight"',
                        '"studentHeight"',
                        '"studentWeight"',
                        '"subCaste"',
                        '"tcNo"',
                        '"tetanus"',
                        '"typhoid"',
                        '"vaccine"',
                        '"vehicleNo"',
                        "\n"
                      ],
                      [
                        '"your school code"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"dd-mm-yyyy"',
                        '"any"',
                        '"any"',
                        '"Male/Female"',
                        '"pic name with extension"',
                        '""',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"only small letter and symbols and nos"',
                        '""only capital letter and symbols and nos"',
                        '"any"',
                        '"dd-mm-yyyy"',
                        '"any"',
                        '"any"',
                        "link",
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        "link",
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        "link",
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"A+/B+"',
                        '"any"',
                        '"Day Scholar/Hostel"',
                        '"General/OBC"',
                        '"yes/no"',
                        '"yes/no"',
                        '"yes/no"',
                        '"any"',
                        '"yes/no"',
                        '"yes/no"',
                        '"yes/no"',
                        '"any"',
                        '"yes/no"',
                        '"yes/no"',
                        '"yes/no"',
                        '"Christian/Hindu"',
                        '"house"',
                        '[]',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"yes/no"',
                        '"yes/no"',
                        '"yes/no"',
                        '"any"'
                      ]
                    ];
                    var blob = html.Blob(data, 'text/plain', 'native');

                    html.AnchorElement(
                      href: html.Url.createObjectUrlFromBlob(blob).toString(),
                    )
                      ..setAttribute("download", "data.csv")
                      ..click();
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(value: 0, child: Text('Upload csv')),
                      PopupMenuItem(value: 1, child: Text('Download csv')),
                      PopupMenuItem(value: 2, child: Text('Sample csv'))
                    ]),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        title: Text(
          'Students',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 400,
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Search Student',
                              // isDense: true,
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
                      width: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.indigo,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton(
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.all(4),
                        value: selectedClass,
                        isDense: true,
                        underline: Text(''),
                        hint: Text('Select Class'),
                        items: classes
                            .map((e) => DropdownMenuItem(
                                value: e['title'], child: Text(e['title'])))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value.toString();
                            if (selectedClass == 'All') {
                              getData = getAllStudentUsers();
                            } else {
                              getData = oneClass();
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    DropdownButton(
                        items: [
                          DropdownMenuItem(
                            child: Text('10'),
                            value: 10,
                          ),
                          DropdownMenuItem(
                            child: Text('25'),
                            value: 25,
                          ),
                          DropdownMenuItem(
                            child: Text('50'),
                            value: 50,
                          )
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedLen = value!;
                            start = 0;
                            currPage = 1;
                            listLen = value;
                          });
                        },
                        value: selectedLen),
                    SizedBox(
                      width: 15,
                    ),
                    if (selectedStudents.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 13),
                        child: ElevatedButton.icon(
                            label: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: deleteStudent,
                            icon: Icon(
                              Icons.delete,
                            )),
                      )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: getData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      searchList = snapshot.data!;
                      List students = searchList;
                      if (searchText != '') {
                        students = searchList
                            .where((element) =>
                                element['firstName']
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()) ||
                                element['admNo'].contains(searchText))
                            .toList();
                      }

                      pages = (students.length / selectedLen).ceil();

                      if (pages < 10) {
                        scrollLen = pages;
                      }
                      if (students.isEmpty) {
                        return Text('No enteries made');
                      }
                      return Column(
                        children: [
                          Container(
                            // padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.orange.shade50),
                                headingTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                sortColumnIndex: _sortColumnIndex,
                                sortAscending: sort,
                                showCheckboxColumn: true,
                                columns: [
                                  DataColumn(
                                      onSort: (columnIndex, ascending) {
                                        setState(() {
                                          if (columnIndex == _sortColumnIndex) {
                                            sort = admSort = ascending;
                                          } else {
                                            _sortColumnIndex = columnIndex;
                                            sort = admSort;
                                          }
                                        });
                                        if (ascending) {
                                          students.sort((a, b) =>
                                              a['admNo'].compareTo(b['admNo']));
                                        } else {
                                          students.sort((a, b) =>
                                              b['admNo'].compareTo(a['admNo']));
                                        }
                                      },
                                      label: Text('Adm No.')),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) {
                                        setState(() {
                                          if (columnIndex == _sortColumnIndex) {
                                            sort = nameSort = ascending;
                                          } else {
                                            _sortColumnIndex = columnIndex;
                                            sort = nameSort;
                                          }
                                        });
                                        if (ascending) {
                                          students.sort((a, b) => a['firstName']
                                              .compareTo(b['firstName']));
                                        } else {
                                          students.sort((a, b) => b['firstName']
                                              .compareTo(a['firstName']));
                                        }
                                      },
                                      label: Text('Name')),
                                  DataColumn(
                                      onSort: (columnIndex, ascending) {
                                        setState(() {
                                          if (columnIndex == _sortColumnIndex) {
                                            sort = classSort = ascending;
                                          } else {
                                            _sortColumnIndex = columnIndex;
                                            sort = classSort;
                                          }
                                        });
                                        if (ascending) {
                                          students.sort((a, b) =>
                                              a['classTitle']
                                                  .compareTo(b['classTitle']));
                                        } else {
                                          students.sort((a, b) =>
                                              b['classTitle']
                                                  .compareTo(a['classTitle']));
                                        }
                                      },
                                      label: Text('Class')),
                                  DataColumn(label: Text('Father Name')),
                                  DataColumn(label: Text('Mother Name')),
                                  DataColumn(label: Text('Mobile No.')),
                                  DataColumn(label: Text(''))
                                ],
                                rows: students
                                    .skip(start)
                                    .take(selectedLen)
                                    .map((student) => DataRow(
                                            selected: selectedStudents
                                                .contains(student['admNo']),
                                            onSelectChanged: (value) {
                                              setState(() {
                                                if (selectedStudents.contains(
                                                    student['admNo'])) {
                                                  selectedStudents
                                                      .remove(student['admNo']);
                                                } else {
                                                  selectedStudents
                                                      .add(student['admNo']);
                                                }
                                              });
                                            },
                                            cells: [
                                              DataCell(Text(student['admNo'])),
                                              DataCell(
                                                  Text(student['firstName'])),
                                              DataCell(
                                                  Text(student['classTitle'])),
                                              DataCell(Text(
                                                  student['fatherName']
                                                      .toString())),
                                              DataCell(Text(
                                                  student['motherName']
                                                      .toString())),
                                              DataCell(Text(
                                                  student['fatherMobNo']
                                                      .toString())),
                                              DataCell(IconButton(
                                                  constraints: BoxConstraints(),
                                                  padding: EdgeInsets.zero,
                                                  splashRadius: 20,
                                                  style: IconButton.styleFrom(
                                                      padding: EdgeInsets.zero),
                                                  onPressed: () => context.go(
                                                      '/students/${student['admNo']}'),
                                                  icon: Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: Colors.indigo,
                                                  )))
                                            ]))
                                    .toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (scrollStart != 0)
                                TextButton(
                                    onPressed: () {
                                      scrollLen = scrollLen - 10;
                                      scrollStart = scrollStart - 10;
                                      setState(() {
                                        currPage = scrollStart + 1;
                                        start = selectedLen * (currPage - 1);
                                        listLen = selectedLen * currPage;
                                      });
                                    },
                                    child: Text('prev')),
                              for (int i = scrollStart; i < scrollLen; i++)
                                // if (i < scrollLen)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      start = selectedLen * (i);
                                      listLen = selectedLen * (i + 1);
                                      currPage = i + 1;
                                    });
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: currPage == i + 1
                                              ? Colors.indigo
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      margin: EdgeInsets.all(5),
                                      child: Text(
                                        (i + 1).toString(),
                                        style: currPage == i + 1
                                            ? TextStyle(color: Colors.white)
                                            : null,
                                      )),
                                ),
                              if (pages > 10)
                                Row(
                                  children: [
                                    Text('...'),
                                    TextButton(
                                        onPressed: () {
                                          scrollLen = scrollLen + 10;
                                          if (scrollLen > pages) {
                                            scrollLen = pages;
                                          }
                                          scrollStart = scrollStart + 10;

                                          setState(() {
                                            currPage = scrollStart + 1;
                                            start =
                                                selectedLen * (currPage - 1);
                                            listLen = selectedLen * currPage;
                                          });
                                        },
                                        child: Text('next')),
                                  ],
                                )
                            ],
                          )
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }
}
