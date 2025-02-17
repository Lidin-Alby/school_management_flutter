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
  List classes = [];
  late PrintSetting printSettings;
  List transports = [
    'Pedistrian',
    'Parent',
    'School Transport',
    'Cycle',
    'Other'
  ];
  List houses = [];
  List departments = [];
  String? filterClass;
  String? filterGender;
  String? filterTransport;
  String? filterBoarding;
  String? filterHouse;
  String? filterTeacher;
  String? filterDepartment;

  Future<List> getAllSchools() async {
    var url = Uri.parse('$ipv4/getAllMidSchools');

    var res = await http.get(url);

    List schools = jsonDecode(res.body);
    return schools;
  }

//getFields
  getClasses() async {
    var schoolCode = Uri.encodeComponent(selectedSchool!);
    var url = Uri.parse('$ipv4/getMidClasses/$schoolCode');
    var res = await http.get(url);

    Map data = jsonDecode(res.body);
    setState(() {
      classes = data['classes'];
    });
  }

  getHouses() async {
    var schoolCode = Uri.encodeComponent(selectedSchool!);
    var url = Uri.parse('$ipv4/getSchoolHouses/$schoolCode');
    var res = await http.get(url);

    List data = jsonDecode(res.body);
    setState(() {
      houses = data;
    });
  }

  getDepartments() async {
    var schoolCode = Uri.encodeComponent(selectedSchool!);
    var url = Uri.parse('$ipv4/getDepartments/$schoolCode');
    var res = await http.get(url);

    List data = jsonDecode(res.body);
    setState(() {
      departments = data;
    });
  }
  //end

  getPrintDetails() async {
    Map filters = {
      'classTitle': filterClass,
      'gender': filterGender,
      'transportMode': filterTransport,
      'boardingType': filterBoarding,
      'schoolHouse': filterHouse,
      'filterTeacher': filterTeacher,
      'department': filterDepartment
    };
    var s = Uri.encodeComponent(selectedSchool!);
    String query = '';
    for (var filter in filters.keys) {
      if (filters[filter] != null) {
        query += '&$filter=${filters[filter]}';
      }
    }
    var url =
        Uri.parse('$ipv4/printDetails/?schoolCode=$s&user=$selectedUser$query');
    var res = await http.get(url);

    if (res.body == 'null') {
      return 'No students in this school';
    }
    getClasses();
    getHouses();
    getDepartments();

    Map printDetails = jsonDecode(res.body);

    PrintSetting data = PrintSetting.fromMap(printDetails);

    return data;
  }

  savePrintSettings() async {
    Map filters = {
      'classTitle': filterClass,
      'gender': filterGender,
      'transportMode': filterTransport,
      'boardingType': filterBoarding,
      'schoolHouse': filterHouse,
      'filterTeacher': filterTeacher,
      'department': filterDepartment
    };
    var url = Uri.parse('$ipv4/savePrintDetails');
    Map fields = {};
    for (var filter in filters.keys) {
      if (filters[filter] != null) {
        fields.addAll({filter: filters[filter]});
      }
    }
    fields.addAll({'schoolCode': selectedSchool, 'user': selectedUser});

    var res = await http.post(url, body: printSettings.toMap()..addAll(fields));
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
                    items: ['Students', 'Teachers', 'Staffs']
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUser = value;
                        filterClass = filterGender = filterTransport =
                            filterBoarding = filterHouse =
                                filterTeacher = filterDepartment = null;
                        if (selectedSchool != null) {
                          _getPrintDetails = getPrintDetails();
                        }
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
                                  Text('Filters: '),
                                  if (selectedUser == 'Students')
                                    Row(
                                      children: [
                                        DropdownButton(
                                          value: filterClass,
                                          hint: Text('Class'),
                                          items: classes
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e['title'],
                                                  child: Text(e['title']),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              filterClass = value.toString();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        DropdownButton(
                                          hint: Text('Gender'),
                                          value: filterGender,
                                          items: [
                                            DropdownMenuItem(
                                              value: 'Male',
                                              child: Text('Male'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Female',
                                              child: Text('Female'),
                                            )
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              filterGender = value.toString();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        DropdownButton(
                                          value: filterTransport,
                                          hint: Text('Transport'),
                                          items: transports
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              filterTransport =
                                                  value.toString();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        DropdownButton(
                                          value: filterBoarding,
                                          hint: Text('Boarding'),
                                          items: [
                                            DropdownMenuItem(
                                              value: 'Day Scholer',
                                              child: Text('Day Scholer'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Hostel',
                                              child: Text('Hostel'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              filterBoarding = value.toString();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        DropdownButton(
                                          hint: Text('House'),
                                          value: filterHouse,
                                          items: houses
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e['title'],
                                                  child: Text(e['title']),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              filterHouse = value.toString();
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  if (selectedUser == 'Teachers')
                                    Row(
                                      children: [
                                        DropdownButton(
                                          items: [
                                            DropdownMenuItem(
                                              value: 'Class Teacher',
                                              child: Text('Class Teacher'),
                                            )
                                          ],
                                          onChanged: (value) {},
                                        )
                                      ],
                                    ),
                                  if (selectedUser == 'Staffs')
                                    Row(
                                      children: [
                                        DropdownButton(
                                          hint: Text('Depatment'),
                                          value: filterDepartment,
                                          items: departments
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e['title'],
                                                  child: Text(e['title']),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              filterDepartment =
                                                  value.toString();
                                            });
                                          },
                                        )
                                      ],
                                    ),
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
                                            width: 160,
                                            child: Text('Page height:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.pageHeight =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text:
                                                  '${printSettings.pageHeight}',
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
                                        text: '${printSettings.pageWidth}',
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
                                            width: 160,
                                            child: Text(
                                                'Page Margin Horizontal:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.marginHorizontal =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text:
                                                  '${printSettings.marginHorizontal}',
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
                                      child: Text('Page Margin Vertical:  ')),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      onChanged: (value) {
                                        printSettings.marginVertical =
                                            double.parse(value);
                                      },
                                      controller: TextEditingController(
                                        text: '${printSettings.marginVertical}',
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
                                            width: 160,
                                            child: Text(
                                                'Card Margin Horzontal:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.paddingHorizontal =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text:
                                                  '${printSettings.paddingHorizontal}',
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
                                      child: Text('Card Margin Vertical:  ')),
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      onChanged: (value) {
                                        printSettings.paddingVertical =
                                            double.parse(value);
                                      },
                                      controller: TextEditingController(
                                          text:
                                              '${printSettings.paddingVertical}'),
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
                                            width: 160,
                                            child: Text('Card Height:  ')),
                                        SizedBox(
                                          width: 50,
                                          child: TextField(
                                            onChanged: (value) {
                                              printSettings.cardHeight =
                                                  double.parse(value);
                                            },
                                            controller: TextEditingController(
                                              text:
                                                  '${printSettings.cardHeight}',
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
                                        text: '${printSettings.cardWidth}',
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
                                height: 40,
                              ),
                              ElevatedButton(
                                onPressed: savePrintSettings,
                                child: Text('Save'),
                              )
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
