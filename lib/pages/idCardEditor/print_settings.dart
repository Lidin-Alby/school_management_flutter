import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../ip_address.dart';

import 'print_settings_class.dart';

class PrintSettings extends StatefulWidget {
  const PrintSettings({super.key});

  @override
  State<PrintSettings> createState() => _PrintSettingsState();
}

class _PrintSettingsState extends State<PrintSettings> {
  late Future _getAllSchools;
  late Future _getPrintDetails;

  String? selectedSchool;
  String? selectedUser;
  List designs = [];
  late PrintSetting printSettings;

  Future<List> getAllSchools() async {
    var url = Uri.parse('$ipv4/getAllMidSchools');

    var res = await http.get(url);

    List schools = jsonDecode(res.body);
    return schools;
  }

  getPrintDetails() async {
    var s = Uri.encodeComponent(selectedSchool!);
    var url = Uri.parse('$ipv4/printDetails/?schoolCode=$s&user=$selectedUser');
    var res = await http.get(url);

    if (res.body == 'null') {
      return 'No students in this school';
    }
    Map printDetails = jsonDecode(res.body);

    PrintSetting data = PrintSetting.fromMap(printDetails);

    return data;
  }

  savePrintSettings() async {
    var url = Uri.parse('$ipv4/savePrintDetails');

    var res = await http.post(url,
        body: printSettings.toMap()..addAll({'schoolCode': selectedSchool}));
    if (res.body == 'true') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Saved Successfully'),
          ),
        );
      }
    }
  }

  getDesigns() async {
    final url = Uri.parse('$ipv4/getDesigns');
    final res = await http.get(url);
    List data = jsonDecode(res.body);

    designs = data;
  }

  @override
  void initState() {
    _getAllSchools = getAllSchools();
    getDesigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getAllSchools,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List schools = snapshot.data;

          Map schoolNames = {};
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownMenu(
                    enableFilter: true,
                    label: Text('Select School'),
                    dropdownMenuEntries: schools.map((e) {
                      schoolNames.addAll({e['schoolCode']: e['schoolName']});
                      return DropdownMenuEntry(
                        label: '${e['schoolCode']} - ${e['schoolName']}',
                        value: e['schoolCode'],
                      );
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        selectedSchool = value.toString();
                        if (selectedUser != null) {
                          _getPrintDetails = getPrintDetails();
                        }
                        // selectedSchoolName = schoolNames[selectedSchool];
                        // _getClasses = getClasses();
                      });
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  DropdownButton(
                    value: selectedUser,
                    hint: Text('Select User'),
                    items: ['Students']
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (selectedSchool != null) {
                        _getPrintDetails = getPrintDetails();
                      }
                      setState(() {
                        selectedUser = value;
                      });
                    },
                  )
                ],
              ),
              if (selectedSchool != null && selectedUser != null)
                FutureBuilder(
                  future: _getPrintDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data is String) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Text(snapshot.data),
                        );
                      } else {
                        printSettings = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Design:  '),
                                  DropdownButton(
                                    value: printSettings.designName,
                                    items: designs
                                        .map(
                                          (e) => DropdownMenuItem(
                                            child: Text(e),
                                            value: e,
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        printSettings.designName =
                                            value.toString();
                                      });
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            child: Text('Page height:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.pageHeight =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text: printSettings.pageHeight
                                                  .toString(),
                                            ),
                                            decoration:
                                                InputDecoration(isDense: true),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Text('inch'),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: 150, child: Text('Page Width:  ')),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      onChanged: (value) {
                                        printSettings.pageWidth =
                                            double.parse(value);
                                      },
                                      controller: TextEditingController(
                                        text:
                                            printSettings.pageWidth.toString(),
                                      ),
                                      decoration:
                                          InputDecoration(isDense: true),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text('inch'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            child:
                                                Text('Margin Horizontal:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.marginHorizontal =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text: printSettings
                                                  .marginHorizontal
                                                  .toString(),
                                            ),
                                            decoration:
                                                InputDecoration(isDense: true),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Text('px'),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: 150,
                                      child: Text('Margin Vertical:  ')),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      onChanged: (value) {
                                        printSettings.marginVertical =
                                            double.parse(value);
                                      },
                                      controller: TextEditingController(
                                        text: printSettings.marginVertical
                                            .toString(),
                                      ),
                                      decoration:
                                          InputDecoration(isDense: true),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text('px'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            child:
                                                Text('Padding Horzontal:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.paddingHorizontal =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text: printSettings
                                                  .paddingHorizontal
                                                  .toString(),
                                            ),
                                            decoration:
                                                InputDecoration(isDense: true),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Text('px'),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: 150,
                                      child: Text('Padding Vertical:  ')),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      onChanged: (value) {
                                        printSettings.paddingVertical =
                                            double.parse(value);
                                      },
                                      controller: TextEditingController(
                                        text: printSettings.paddingVertical
                                            .toString(),
                                      ),
                                      decoration:
                                          InputDecoration(isDense: true),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text('px'),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            child: Text('Card Height:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.cardHeight =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text: printSettings.cardHeight
                                                  .toString(),
                                            ),
                                            decoration:
                                                InputDecoration(isDense: true),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: Text('inch'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      width: 150, child: Text('Card Width:  ')),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      onChanged: (value) {
                                        printSettings.cardWidth =
                                            double.parse(value);
                                      },
                                      controller: TextEditingController(
                                        text:
                                            printSettings.cardWidth.toString(),
                                      ),
                                      decoration:
                                          InputDecoration(isDense: true),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text('inch'),
                                  )
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: savePrintSettings,
                                  child: Text('Save'))
                            ],
                          ),
                        );
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
