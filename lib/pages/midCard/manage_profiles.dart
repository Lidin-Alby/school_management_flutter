import 'dart:async';
import 'dart:convert';

import 'package:file_saver/file_saver.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

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

  getAllSchools() async {
    var url = Uri.parse('$ipv4/getAllMidSchools');
    var res = await http.get(url);
    print(res.body);
    List schools = jsonDecode(res.body);
    return schools;
  }

  getData() async {
    if (selectedSchool != null &&
        selectedUser != null &&
        selectedStatus != null) {
      var url = Uri.parse('$ipv4/getMidData');
      var res = await http.post(url, body: {
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
      name: selectedSchool.toString(),
      bytes: csvBytes,
      ext: 'csv',
      mimeType: MimeType.csv,
    );
  }

  downloadPhotos() async {
    var url = Uri.parse('$ipv4/downloadZipPhotos/$selectedSchool');
    var res = await http.get(url);
    final csvBytes = res.bodyBytes;
    FileSaver.instance.saveFile(
      name: selectedSchool.toString(),
      bytes: csvBytes,
      ext: 'zip',
      mimeType: MimeType.zip,
    );
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
          FutureBuilder(
            future: _getAllSchools,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List schools = snapshot.data;

                return Row(
                  children: [
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
                              disabledHint: selectedSchool != null
                                  ? Text(
                                      selectedSchool.toString(),
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      'Select School',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                              value: selectedSchool,
                              isExpanded: true,
                              underline: Text(''),
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text('Select School'),
                              ),
                              items: schools
                                  .map((e) => DropdownMenuItem(
                                        child: Text(
                                            '${e['schoolCode']} - ${e['schoolName']}'),
                                        value: e['schoolCode'],
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSchool = value.toString();
                                  _getData = getData();
                                });
                              },
                            ),
                          ),
                          if (selectedSchool != null)
                            Container(
                                margin: EdgeInsets.only(left: 8),
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                color: Colors.blue[50],
                                child: Text(
                                  'Select School',
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                ))
                        ],
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
                                  value: 'check',
                                ),
                                DropdownMenuItem(
                                  child: Text('Ready to Print'),
                                  value: 'ready',
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = value;
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
              child: FutureBuilder(
                future: _getData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List listOf = snapshot.data;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Move to Print'),
                              ),
                              ElevatedButton(
                                onPressed: downloadCSV,
                                child: Text('Download CSV'),
                              ),
                              ElevatedButton(
                                onPressed: downloadPhotos,
                                child: Text('Download Photos'),
                              )
                            ],
                          ),
                        ),
                        // Row(children: [Text('Image Name'),text],),
                        Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                              // physics: NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              itemCount: listOf.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Row(
                                    children: [
                                      Text(
                                        'data',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      Expanded(
                                          child: Text(listOf[index - 1]
                                                  ['profilePic']
                                              .toString())),
                                      Expanded(
                                          child: Text(listOf[index - 1]
                                                  ['fullName']
                                              .toString())),
                                      Expanded(
                                          child: Text(listOf[index - 1]
                                                  ['fatherName']
                                              .toString())),
                                    ],
                                  );
                                }
                              }),
                        ),
                      ],
                    );
                    // DataTable(
                    //     headingTextStyle:
                    //         TextStyle(fontWeight: FontWeight.bold),
                    //     columns: [
                    //       DataColumn(label: Text('Image Name')),
                    //       DataColumn(label: Text('Full Name'))
                    //     ],
                    //     rows: listOf
                    //         .map(
                    //           (e) => DataRow(cells: [
                    //             DataCell(
                    //               Text(e['profilePic'].toString()),
                    //             ),
                    //             DataCell(
                    //               Text(e['fullName'].toString()),
                    //             )
                    //           ]),
                    //         )
                    //         .toList());
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
        ],
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
