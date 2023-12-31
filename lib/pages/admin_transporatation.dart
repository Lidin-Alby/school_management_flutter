import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/pages/admin_satff_page.dart';
import 'package:school_management/widgets/dropdown_widget.dart';
import 'package:school_management/widgets/textfield_widget.dart';

import '../ip_address.dart';
import '../widgets/search_bar_widget.dart';

class AdminTransport extends StatefulWidget {
  const AdminTransport({super.key});

  @override
  State<AdminTransport> createState() => _AdminTransportState();
}

class _AdminTransportState extends State<AdminTransport> {
  int selected = 0;
  bool addRoute = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
        child: Scaffold(
          // backgroundColor: Color.fromRGBO(232, 217, 193, 0.494),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(115),
            child: AppBar(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              // elevation: ,
              backgroundColor: Colors.indigo[900],
              title: Text('Transportation'),
              // titleSpacing: 10,
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicator: UnderlineTabIndicator(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(width: 4, color: Colors.white)),
                  padding: EdgeInsets.only(left: 12),
                  // indicatorWeight: 25,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.person_rounded,
                      ),
                      text: 'Driver',
                    ),
                    Tab(
                      icon: Icon(Icons.directions_car),
                      text: 'Vehicle',
                    ),
                    Tab(
                      icon: Icon(Icons.route),
                      text: 'Route',
                    ),
                    Tab(
                      icon: Icon(Icons.place_rounded),
                      text: 'Pickup Point',
                    ),
                    Tab(
                      icon: Icon(Icons.arrow_circle_right_rounded),
                      text: 'Assign Students',
                    ),
                  ]),
            ),
          ),
          body: TabBarView(
            children: [
              DriverTab(),
              VehicleTab(),
              RouteTab(),
              PickupTab(),
              AssignTab()
            ],
          ),
        ),
      ),
    );
  }
}

class DriverTab extends StatefulWidget {
  const DriverTab({super.key});

  @override
  State<DriverTab> createState() => _DriverTabState();
}

class _DriverTabState extends State<DriverTab> {
  late Future _getDrivers;
  getDrivers() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/getDrivers');

    var response = await client.get(url);
    var data = jsonDecode(response.body);
    return data;
  }

  Future getStaffProfilePic(fileName) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getStaffPic/$fileName');
    var response = await client.get(url);

    return response.bodyBytes;
  }

  @override
  void initState() {
    _getDrivers = getDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: ElevatedButton.icon(
                onPressed: () => showModalBottomSheet(
                      enableDrag: false,
                      isScrollControlled: true,
                      isDismissible: true,
                      context: context,
                      builder: (context) => AddStaffDialog(
                        isDriver: true,
                        refresh: () => setState(() {
                          // getData = getAllStudentUsers();
                        }),
                      ),
                    ),
                icon: Icon(Icons.add_rounded),
                label: Text('Driver')),
          ),
        ),
        FutureBuilder(
          future: _getDrivers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List drivers = snapshot.data;
              return DataTable(
                  dataRowMaxHeight: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all()),
                  border: TableBorder(
                    verticalInside: BorderSide(),
                  ),
                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  columns: [
                    DataColumn(label: Text('Photo')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Mob No.'))
                  ],
                  rows: drivers
                      .map((e) => DataRow(cells: [
                            DataCell(
                              e['staffProfilePic'] == ''
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.account_circle_rounded,
                                        size: 85,
                                        color: Colors.grey,
                                      ),
                                    )
                                  : FutureBuilder(
                                      future: getStaffProfilePic(
                                          e['staffProfilePic']),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  MemoryImage(snapshot.data),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('Error loading image');
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                            ),
                            DataCell(Text(e['fullName'])),
                            DataCell(Text(e['mob']))
                          ]))
                      .toList());
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}

class AssignTab extends StatefulWidget {
  const AssignTab({
    super.key,
  });

  @override
  State<AssignTab> createState() => _AssignTabState();
}

class _AssignTabState extends State<AssignTab> {
  List vehicleList = [];
  List routeList = [];
  List pickupList = [];
  String? selectedVehicleFilter;
  String? selectedClassFilter;
  List classList = [];
  List unFlitered = [];
  late String schoolCode;
  late Future _getAll;
  final int _sortColumnIndex = 0;
  bool sort = false;
  bool vehicleSort = true;
  String searchText = '';
  int? selectedTile;
  getAllstudentTransport() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/getAllstudentTransport');

    var response = await client.get(url);
    var data = jsonDecode(response.body);
    setState(() {
      classList = data
          .map(
            (e) => e['classTitle'],
          )
          .toSet()
          .toList();
    });
    print(data);
    return data;
  }

  Future getAllTransport() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/getAllTransport');

    var response = await client.get(url);
    // print(response.body);

    Map data = jsonDecode(response.body);

    schoolCode = data['schoolCode'].toString();
    if (data.containsKey('vehicle')) {
      vehicleList = data['vehicle'];
    }
    if (data.containsKey('route')) {
      setState(() {
        routeList = data['route'];
      });
    }
    if (data.containsKey('pickupPoint')) {
      setState(() {
        pickupList = data['pickupPoint'];
      });
    }
    if (data.containsKey('pickupPoint')) {
      return data['pickupPoint'];
    } else {
      return [];
    }
  }

  fareFunction(pickAndDrop) {
    final found = pickupList.firstWhere(
      (element) => element['pointName'] == pickAndDrop,
      orElse: () => null,
    );
    if (found != null) {
      return found['fare'];
    } else {
      return 'null';
    }
  }

  @override
  void initState() {
    getAllTransport();
    _getAll = getAllstudentTransport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Align(
          //     alignment: AlignmentDirectional.topEnd,
          //     child:
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 400,
                child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      hintText: 'Search Student',
                      isDense: true,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    }
                    // searchFunction(value),
                    ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    isDense: true,
                    hint: Text('Select Class'),
                    value: selectedClassFilter,
                    items: classList
                        .map((e) => DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e.toString(),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedClassFilter = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (selectedClassFilter != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        setState(() {
                          selectedClassFilter = null;
                        });
                      },
                      child: Row(
                        children: [
                          Text('Filter'),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.close,
                            // color: Colors.grey,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    isDense: true,
                    hint: Text('Select Vehicle'),
                    value: selectedVehicleFilter,
                    items: vehicleList
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text('${e['vehicleType']} ~ ${e['regNo']}'),
                            value: '${e['vehicleType']} ~ ${e['regNo']}',
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVehicleFilter = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (selectedVehicleFilter != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        setState(() {
                          selectedVehicleFilter = null;
                        });
                      },
                      child: Row(
                        children: [
                          Text('Filter'),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.close,
                            // color: Colors.grey,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                  onPressed: () => showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) => AssignStudentsSheet(
                            vehicleList: vehicleList,
                            routeList: routeList,
                            pickupList: pickupList,
                            callback: () {
                              setState(() {
                                _getAll = getAllstudentTransport();
                              });
                            },
                          )),
                  icon: Icon(
                    Icons.add_rounded,
                    size: 20,
                  ),
                  label: Text('Assign\nStudents')),
              SizedBox(
                width: 20,
              )
            ],
          ),
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: _getAll,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                unFlitered = snapshot.data;
                List students = unFlitered;
                if (searchText != '') {
                  students = unFlitered
                      .where((element) =>
                          element['fullName']
                              .toLowerCase()
                              .contains(searchText.toLowerCase()) ||
                          element['admNo'].contains(searchText))
                      .toList();
                }
                if (selectedClassFilter != null) {
                  students = students
                      .where((element) =>
                          element['classTitle'] == selectedClassFilter)
                      .toList();
                }
                if (selectedVehicleFilter != null) {
                  students = students
                      .where((element) =>
                          element['vehicleNo'] == selectedVehicleFilter)
                      .toList();
                }
                return DataTable(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all()),
                    border: TableBorder(
                      verticalInside: BorderSide(),
                    ),
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: sort,
                    columns: [
                      DataColumn(label: Text('Adm No.')),
                      DataColumn(label: Text('Student Name')),
                      DataColumn(label: Text('Class')),
                      DataColumn(
                        label: Text('Vehicle'),
                      ),
                      DataColumn(label: Text('Route')),
                      DataColumn(label: Text('Pickup Point')),
                      DataColumn(label: Text('Fare (₹)')),
                      DataColumn(label: Text(' ')),
                    ],
                    rows: [
                      for (int i = 0; i < students.length; i++)
                        DataRow(cells: [
                          DataCell(Text(students[i]['admNo'].toString())),
                          DataCell(Text(students[i]['fullName'].toString())),
                          DataCell(Text(students[i]['classTitle'].toString())),
                          DataCell(Text(students[i]['vehicleNo'].toString())),
                          DataCell(Text(
                              students[i]['schoolTransportRoute'].toString())),
                          DataCell(Text(students[i]['pickAndDrop'].toString())),
                          // DataCell(Text(pickupList[0].toString()))

                          DataCell(
                              Text(fareFunction(students[i]['pickAndDrop']))),
                          DataCell(IconButton(
                            iconSize: 20,
                            splashRadius: 20,
                            onPressed: () => showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (context) => AssignStudentsSheet(
                                      selectedPickup: students[i]
                                          ['pickAndDrop'],
                                      selectedRoute: students[i]
                                          ['schoolTransportRoute'],
                                      selectedVehicle: students[i]['vehicleNo'],
                                      vehicleList: vehicleList,
                                      routeList: routeList,
                                      pickupList: pickupList,
                                      student:
                                          '${students[i]['fullName']}- ${students[i]['admNo']}',
                                      callback: () {
                                        setState(() {
                                          _getAll = getAllstudentTransport();
                                        });
                                      },
                                    )),
                            //     Ass

                            icon: Icon(Icons.edit),
                          )),
                        ])
                    ]);
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}

class AssignStudentsSheet extends StatefulWidget {
  const AssignStudentsSheet(
      {super.key,
      required this.vehicleList,
      required this.routeList,
      required this.pickupList,
      required this.callback,
      this.selectedPickup,
      this.selectedRoute,
      this.selectedVehicle,
      this.student = ''});
  final List vehicleList;
  final List routeList;
  final List pickupList;
  final String student;
  final String? selectedVehicle;
  final String? selectedRoute;
  final String? selectedPickup;
  final VoidCallback callback;

  @override
  State<AssignStudentsSheet> createState() => _AssignStudentsSheetState();
}

class _AssignStudentsSheetState extends State<AssignStudentsSheet> {
  String? selectedVehicle;
  String? selectedRoute;
  String? selectedPickup;
  List searchList = [];
  TextEditingController searchResult = TextEditingController();
  bool searchOn = false;

  addTransoprt() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/addTransport');

    var response = await client.post(url, body: {
      'schoolTransportRoute': selectedRoute,
      'vehicleNo': selectedVehicle,
      'pickAndDrop': selectedPickup,
      'student': searchResult.text.trim()
    });
    if (response.body == 'true') {
      print(true);
      searchResult.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            content: const Row(
              children: [
                Text(
                  'Added Successfully ',
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
      widget.callback();
    }
  }

  deleteTransport() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/removeStudentTransport');

    var response = await client.delete(url, body: {
      'schoolTransportRoute': "",
      'vehicleNo': "",
      'pickAndDrop': "",
      'student': searchResult.text.trim()
    });
    if (response.body == 'true') {
      print(true);
      searchResult.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            content: const Row(
              children: [
                Text(
                  'Removed Successfully ',
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                )
              ],
            ),
          ),
        );
        Navigator.of(context).pop();
      }
      widget.callback();
    }
  }

  searchFunction(value) async {
    if (value != '') {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.http(ipv4, '/searchStudent/$value');
      var res = await client.get(url);
      setState(() {
        // searching = false;
        searchList = jsonDecode(res.body);
      });
    } else {
      setState(() {
        searchList = [];
      });
    }
  }

  @override
  void initState() {
    searchResult.text = widget.student;
    selectedPickup = widget.selectedPickup;
    selectedRoute = widget.selectedRoute;
    selectedVehicle = widget.selectedVehicle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close)),
        ),
        Text(
          'Assign Students',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 250,
          child: Column(
            children: [
              if (widget.selectedVehicle != null)
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: deleteTransport,
                    label: Text('Remove'),
                    icon: Icon(Icons.delete),
                  ),
                ),
              SizedBox(
                height: 10,
              ),
              DropDownWidget(
                  isEdit: true,
                  items: widget.vehicleList
                      .map((e) => '${e['vehicleType']} ~ ${e['regNo']}')
                      .toList(),
                  title: 'Select Vehicle',
                  callBack: (p0) {
                    setState(() {
                      selectedVehicle = p0;
                    });
                  },
                  selected: selectedVehicle),
              SizedBox(
                height: 15,
              ),
              DropDownWidget(
                  isEdit: true,
                  items: widget.routeList.map((e) => e['routeName']).toList(),
                  title: 'Select Route',
                  callBack: (p0) {
                    setState(() {
                      selectedRoute = p0;
                    });
                  },
                  selected: selectedRoute),
              SizedBox(
                height: 15,
              ),
              DropDownWidget(
                  isEdit: true,
                  items: widget.pickupList.map((e) => e['pointName']).toList(),
                  title: 'Select Pickup',
                  callBack: (p0) {
                    setState(() {
                      selectedPickup = p0;
                    });
                  },
                  selected: selectedPickup),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: searchResult,
                  onTap: () {
                    searchFunction(searchResult.text);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search Student',
                      isDense: true,
                      prefixIcon: Icon(Icons.search)),
                  onChanged: (value) => searchFunction(value),
                ),
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  Card(
                    child: Container(
                      constraints: BoxConstraints(maxHeight: 180),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (int i = 0; i < searchList.length; i++)
                              InkWell(
                                onTap: () {
                                  searchResult.text =
                                      '${searchList[i]['fullName']}- ${searchList[i]['admNo']}';
                                  setState(() {
                                    searchList = [];
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  width: 250,
                                  child: Text(
                                      '${searchList[i]['fullName']}- ${searchList[i]['admNo']}'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: addTransoprt,
          child: Text('Add'),
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }
}

class PickupTab extends StatefulWidget {
  const PickupTab({
    super.key,
  });

  @override
  State<PickupTab> createState() => _PickupTabState();
}

class _PickupTabState extends State<PickupTab> {
  late String schoolCode;
  List routeList = [];
  late Future _getpickupPoints;
  int? selectedTile;
  List selectedRoute = [];
  List pointName = [];
  List distance = [];
  List fare = [];
  List pickupTime = [];

  Future getPickupPoints() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/getPickupPoints');

    var response = await client.get(url);
    // print(response.body);

    Map data = jsonDecode(response.body);
    print(data);

    schoolCode = data['schoolCode'].toString();
    if (data.containsKey('route')) {
      routeList = data['route'];
    }
    if (data.containsKey('pickupPoint')) {
      var rou = data['pickupPoint'];

      selectedRoute = rou.map((e) => e['route']).toList();
      pointName =
          rou.map((e) => TextEditingController(text: e['pointName'])).toList();
      distance =
          rou.map((e) => TextEditingController(text: e['distance'])).toList();
      fare = rou.map((e) => TextEditingController(text: e['fare'])).toList();
      pickupTime =
          rou.map((e) => TextEditingController(text: e['pickupTime'])).toList();

      return rou;
    } else {
      return [];
    }
  }

  updatePickup(int index) async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/updatePickupPoint');

    var response = await client.post(url, body: {
      'index': index.toString(),
      'schoolCode': schoolCode.toString(),
      'route': selectedRoute[index] ?? '',
      'pointName': pointName[index].text.trim(),
      'distance': distance[index].text.trim(),
      'fare': fare[index].text.trim(),
      'pickupTime': pickupTime[index].text.trim()
    });
    if (response.body == 'true') {
      print(true);
      setState(() {
        selectedTile = null;
        _getpickupPoints = getPickupPoints();
      });
    }
  }

  // getwidth() {
  //   double width = MediaQuery.of(context).size.width - 250;
  //   double w = width / 400;

  //   if (w > 2.9) {
  //     // print((w + 100) * 100);
  //     return (w * 98);
  //   }
  //   if (w > 2.2) {
  //     // print((w + 100) * 100);
  //     return (w * 130);
  //   } else {
  //     return null;
  //   }
  // }

  getwidth() {
    double width = MediaQuery.of(context).size.width - 250;
    double w = width / 500;

    if (w > 2.5) {
      // print((w + 100) * 100);
      return (w * 121);
    }
    if (w > 1.8) {
      // print((w + 100) * 100);
      return (w * 163);
    }
    if (w > 1.2) {
      // print((w + 100) * 100);
      return (w * 250);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _getpickupPoints = getPickupPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: ElevatedButton.icon(
                onPressed: () => showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) => AddPickupPoint(
                        routeList: routeList,
                        schoolCode: schoolCode,
                        callback: () {
                          setState(() {
                            _getpickupPoints = getPickupPoints();
                          });
                        },
                      ),
                    ),
                icon: Icon(Icons.add_rounded),
                label: Text('Pickup Point')),
          ),
        ),
        FutureBuilder(
          future: _getpickupPoints,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              return Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 20,
                    children: [
                      for (int i = 0; i < data.length; i++)
                        SizedBox(
                          width: selectedTile == i ? 350 : getwidth(),
                          child: Material(
                            color: Colors.blue[50],
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (selectedTile != i)
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.indigo,
                                                      width: 3)),
                                              child: Icon(
                                                Icons.location_pin,
                                                color: Colors.black45,
                                                size: 40,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    data[i]['pointName'],
                                                    // overflow:
                                                    style: TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        // fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                    data[i]['route'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '₹ ${data[i]['fare']}',
                                                  // style: TextStyle(fontSize: 24),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '🕐 ${data[i]['pickupTime']}',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    Spacer(),
                                    if (selectedTile == i)
                                      IconButton(
                                        splashRadius: 20,
                                        iconSize: 20,
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          var client = BrowserClient()
                                            ..withCredentials = true;

                                          var url = Uri.http(
                                              ipv4, '/deletePickpoint');

                                          var response = await client.delete(
                                              url,
                                              body: {'index': i.toString()});
                                          if (response.body == 'true') {
                                            print('deleted');
                                            setState(() {
                                              selectedTile = null;
                                              _getpickupPoints =
                                                  getPickupPoints();
                                            });
                                          }
                                        },
                                      ),
                                    IconButton(
                                      splashRadius: 20,
                                      iconSize: 20,
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          if (selectedTile == i) {
                                            selectedTile = null;
                                          } else {
                                            selectedTile = i;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),

                                if (selectedTile == i)
                                  Wrap(
                                    direction: Axis.vertical,
                                    // runSpacing: 15,
                                    spacing: 15,
                                    children: [
                                      DropDownWidget(
                                          isEdit: true,
                                          items: routeList
                                              .map((e) => e['routeName'])
                                              .toList(),
                                          title: 'Select Route',
                                          callBack: (p0) {
                                            setState(() {
                                              selectedRoute[i] = p0;
                                            });
                                          },
                                          selected: selectedRoute[i]),
                                      TextFieldWidget(
                                          label: 'Enter Pickup Point',
                                          controller: pointName[i],
                                          isEdit: true),
                                      TextFieldWidget(
                                          label: 'Distance',
                                          controller: distance[i],
                                          isEdit: true),
                                      TextFieldWidget(
                                          label: 'Fare',
                                          controller: fare[i],
                                          isEdit: true),
                                      TextFieldWidget(
                                          label: 'Pickup Time',
                                          controller: pickupTime[i],
                                          isEdit: true),
                                    ],
                                  ),
                                // SizedBox(
                                //   height: 15,
                                // ),
                                if (selectedTile == i)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: OutlinedButton(
                                      onPressed: () => updatePickup(i),
                                      child: Text('update'),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}

class RouteTab extends StatefulWidget {
  const RouteTab({
    super.key,
  });

  @override
  State<RouteTab> createState() => _RouteTabState();
}

class _RouteTabState extends State<RouteTab> {
  late Future _getRoutes;
  late String schoolCode;
  List vehicleList = [];
  List selectedVehicle = [];
  List routeName = [];
  List descp = [];
  int? selectedTile;

  Future getRoutes() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/getRoutes');

    var response = await client.get(url);
    // print(response.body);

    Map data = jsonDecode(response.body);
    print(data);

    schoolCode = data['schoolCode'].toString();
    if (data.containsKey('vehicle')) {
      vehicleList = data['vehicle'];
    }
    if (data.containsKey('route')) {
      var veh = data['route'];
      var veh1 = veh.map((e) => jsonDecode(e['vehicle']));
      print(veh);
      selectedVehicle =
          veh1.map((e) => '${e['vehicleType']} ~ ${e['regNo']}').toList();
      routeName =
          veh.map((e) => TextEditingController(text: e['routeName'])).toList();
      descp = veh.map((e) => TextEditingController(text: e['descp'])).toList();
      return veh;
    } else {
      return [];
    }
  }

  updateRoute(int index) async {
    var client = BrowserClient()..withCredentials = true;
    var vehicle = selectedVehicle[index].split(" ~ ");

    // Map data = {};
    var url = Uri.http(ipv4, '/updateRoute');

    var response = await client.post(url, body: {
      'index': index.toString(),
      'schoolCode': schoolCode.toString(),
      'vehicle': jsonEncode(
          {'vehicleType': vehicle[0] ?? '', 'regNo': vehicle[1] ?? ''}),
      'routeName': routeName[index].text.trim(),
      'descp': descp[index].text.trim()
    });
    if (response.body == 'true') {
      print(true);
      setState(() {
        selectedTile = null;
        _getRoutes = getRoutes();
      });
    }
  }

  // getwidth() {
  //   double width = MediaQuery.of(context).size.width - 250;
  //   double w = width / 400;

  //   if (w > 2.9) {
  //     // print((w + 100) * 100);
  //     return (w * 98);
  //   }
  //   if (w > 2.2) {
  //     // print((w + 100) * 100);
  //     return (w * 130);
  //   } else {
  //     return null;
  //   }
  // }
  getwidth() {
    double width = MediaQuery.of(context).size.width - 250;
    double w = width / 500;

    if (w > 2.5) {
      // print((w + 100) * 100);
      return (w * 121);
    }
    if (w > 1.8) {
      // print((w + 100) * 100);
      return (w * 163);
    }
    if (w > 1.2) {
      // print((w + 100) * 100);
      return (w * 250);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _getRoutes = getRoutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: ElevatedButton.icon(
                onPressed: () => showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) => AddRoute(
                        vehicleList: vehicleList,
                        schoolCode: schoolCode,
                        callback: () => setState(() {
                          _getRoutes = getRoutes();
                        }),
                      ),
                    ),
                icon: Icon(Icons.add_rounded),
                label: Text('Route')),
          ),
        ),
        FutureBuilder(
          future: _getRoutes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;

              return Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 20,
                    children: [
                      for (int i = 0; i < data.length; i++)
                        SizedBox(
                          width: getwidth(),
                          child: Material(
                            color: Colors.blue[50],
                            shape: RoundedRectangleBorder(
                              side: BorderSide(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (selectedTile != i)
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.indigo,
                                                      width: 3)),
                                              child: Icon(
                                                Icons.route,
                                                color: Colors.black45,
                                                size: 40,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[i]['routeName'],
                                                  style: TextStyle(
                                                      // fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  selectedVehicle[i].toString(),
                                                  // style: TextStyle(fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  constraints: getwidth() !=
                                                          null
                                                      ? BoxConstraints(
                                                          maxWidth:
                                                              getwidth() - 150)
                                                      : BoxConstraints(
                                                          maxWidth: 380),
                                                  child: Text(
                                                    data[i]['descp'].toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    Spacer(),
                                    if (selectedTile == i)
                                      IconButton(
                                          iconSize: 20,
                                          onPressed: () async {
                                            var client = BrowserClient()
                                              ..withCredentials = true;

                                            // Map data = {};
                                            var url =
                                                Uri.http(ipv4, '/deleteRoute');

                                            var response = await client.delete(
                                                url,
                                                body: {'index': i.toString()});
                                            if (response.body == 'true') {
                                              print('deleted');
                                              setState(() {
                                                selectedTile = null;
                                                _getRoutes = getRoutes();
                                              });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete_rounded,
                                            color: Colors.red,
                                          )),
                                    IconButton(
                                      iconSize: 20,
                                      splashRadius: 20,
                                      onPressed: () {
                                        setState(() {
                                          if (selectedTile == i) {
                                            selectedTile = null;
                                          } else {
                                            selectedTile = i;
                                          }
                                        });
                                      },
                                      icon: Icon(Icons.edit),
                                    )
                                  ],
                                ),
                                if (selectedTile == i)
                                  Column(
                                    children: [
                                      AbsorbPointer(
                                        absorbing: !(selectedTile == i),
                                        child: DropDownWidget(
                                            isEdit: true,
                                            items: vehicleList
                                                .map((e) =>
                                                    '${e['vehicleType']} ~ ${e['regNo']}')
                                                .toList(),
                                            title: 'Select Vehicle',
                                            callBack: (p0) {
                                              setState(() {
                                                selectedVehicle[i] = p0;
                                                print(p0);
                                                print(selectedVehicle);
                                              });
                                            },
                                            selected: selectedVehicle[i]),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFieldWidget(
                                          label: 'Enter Route Name',
                                          controller: routeName[i],
                                          isEdit: selectedTile == i),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFieldWidget(
                                          label: 'Description',
                                          controller: descp[i],
                                          isEdit: selectedTile == i),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      OutlinedButton(
                                        onPressed: () => updateRoute(i),
                                        child: Text('update'),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}

class VehicleTab extends StatefulWidget {
  const VehicleTab({
    super.key,
  });

  @override
  State<VehicleTab> createState() => _VehicleTabState();
}

class _VehicleTabState extends State<VehicleTab> {
  late Future _getVehicles;
  late String schoolCode;
  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleNo = TextEditingController();
  TextEditingController regNo = TextEditingController();
  TextEditingController validTill1 = TextEditingController();
  TextEditingController insuranceNo = TextEditingController();
  TextEditingController insuranceValidTill = TextEditingController();
  TextEditingController permitNo = TextEditingController();
  TextEditingController permitValidTill = TextEditingController();
  TextEditingController fitnessCertifiacte = TextEditingController();
  TextEditingController validTill2 = TextEditingController();
  TextEditingController driverName = TextEditingController();
  TextEditingController driverMobile = TextEditingController();
  TextEditingController helperName = TextEditingController();
  TextEditingController helperMobile = TextEditingController();
  TextEditingController driverGmap = TextEditingController();
  TextEditingController helperGmap = TextEditingController();

  int? selectedTile;
  int n = 4;

  Future getVehicles() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/getVehicles');

    var response = await client.get(url);
    // print(response.body);

    Map data = jsonDecode(response.body);
    print(data);

    schoolCode = data['schoolCode'].toString();
    if (data.containsKey('vehicle')) {
      return data['vehicle'];
    } else {
      return [];
    }
  }

  updateVehicle(int? index) async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/updateVehicle');

    var response = await client.post(url, body: {
      // 'schoolCode': widget.schoolCode,
      'index': index.toString(),
      'vehicleType': vehicleType.text.trim(),
      'vehicleNo': vehicleNo.text.trim(),
      'regNo': regNo.text.trim(),
      'validTill1': validTill1.text.trim(),
      'insuranceNo': insuranceNo.text.trim(),
      'insuranceValidTill': insuranceValidTill.text.trim(),
      'permitNo': permitNo.text.trim(),
      'permitValidTill': permitValidTill.text.trim(),
      'fitnessCertifiacte': fitnessCertifiacte.text.trim(),
      'validTill2': validTill2.text.trim(),
      'driverName': driverName.text.trim(),
      'driverMobile': driverMobile.text.trim(),
      'helperName': helperName.text.trim(),
      'helperMobile': helperMobile.text.trim(),
      'driverGmap': driverGmap.text.trim(),
      'helperGmap': helperGmap.text.trim(),
    });
    if (response.body == 'true') {
      print(true);
      setState(() {
        selectedTile = null;
        _getVehicles = getVehicles();
      });
    }
  }

  @override
  void initState() {
    _getVehicles = getVehicles();
    super.initState();
  }

  getwidth() {
    double width = MediaQuery.of(context).size.width - 250;
    double w = width / 500;

    if (w > 2.1) {
      // print((w + 100) * 100);
      return (w * 121);
    }
    if (w > 1.6) {
      // print((w + 100) * 100);
      return (w * 163);
    }
    if (w > 1.1) {
      // print((w + 100) * 100);
      return (w * 250);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: ElevatedButton.icon(
                onPressed: () => showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (context) => AddVehicle(
                        schoolCode: schoolCode,
                        callback: () => setState(() {
                          _getVehicles = getVehicles();
                        }),
                      ),
                    ),
                icon: Icon(Icons.add_rounded),
                label: Text('Vehicle')),
          ),
        ),
        FutureBuilder(
          future: _getVehicles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;

              return Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 15,
                    runSpacing: 20,
                    children: [
                      for (int i = 0; i < data.length; i++)
                        SizedBox(
                          width: selectedTile != i ? getwidth() : null,
                          child: Material(
                              color: selectedTile == i
                                  ? Colors.red[50]
                                  : Colors.blue[50],
                              shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              // color: selectedTile == i
                              //     ? Colors.red[50]
                              //     : Colors.blue[50],
                              // elevation: 2,
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                //required column
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            Container(
                                              // margin: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.indigo,
                                                      width: 3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Icons.drive_eta,
                                                color: Colors.black45,
                                                size: 50,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[i]['regNo'],
                                                  style: TextStyle(
                                                      // fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  data[i]['vehicleType'],
                                                  style: TextStyle(
                                                      // fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  data[i]['driverName']
                                                      .toString(),
                                                  style: TextStyle(
                                                      // fontSize: 16,
                                                      ),
                                                ),
                                                Text(
                                                  data[i]['driverMobile']
                                                      .toString(),
                                                  style: TextStyle(
                                                      // fontSize: 16,
                                                      ),
                                                ),

                                                // if (selectedTile != i) Spacer(),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Column(
                                        children: [
                                          IconButton(
                                            iconSize: 20,
                                            splashRadius: 20,
                                            // color: Colors.grey,
                                            onPressed: () {
                                              var veh = data[i];
                                              vehicleType.text =
                                                  veh['vehicleType'];
                                              vehicleNo.text = veh['vehicleNo'];
                                              regNo.text = veh['regNo'];
                                              validTill1.text =
                                                  veh['validTill1'];
                                              insuranceNo.text =
                                                  veh['insuranceNo'];
                                              insuranceValidTill.text =
                                                  veh['insuranceValidTill'];
                                              permitNo.text = veh['permitNo'];
                                              permitValidTill.text =
                                                  veh['permitValidTill'];
                                              fitnessCertifiacte.text =
                                                  veh['fitnessCertifiacte'];
                                              validTill2.text =
                                                  veh['validTill2'];
                                              driverName.text =
                                                  veh['driverName'];
                                              driverMobile.text =
                                                  veh['driverMobile'];
                                              helperName.text =
                                                  veh['helperName'];
                                              helperMobile.text =
                                                  veh['helperMobile'];
                                              driverGmap.text =
                                                  veh['driverGmap'];
                                              helperGmap.text =
                                                  veh['helperGmap'];
                                              setState(() {
                                                if (selectedTile == i) {
                                                  selectedTile = null;
                                                } else {
                                                  selectedTile = i;
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                          if (selectedTile == i)
                                            IconButton(
                                              color: Colors.red,
                                              iconSize: 35,
                                              onPressed: () async {
                                                var client = BrowserClient()
                                                  ..withCredentials = true;

                                                // Map data = {};
                                                var url = Uri.http(
                                                    ipv4, '/deleteVehicle');

                                                var response = await client
                                                    .delete(url, body: {
                                                  'index': i.toString()
                                                });
                                                if (response.body == 'true') {
                                                  print('deleted');
                                                  setState(() {
                                                    selectedTile = null;
                                                    _getVehicles =
                                                        getVehicles();
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.delete),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (selectedTile == i)
                                    Wrap(
                                      runSpacing: 15,
                                      spacing: 15,
                                      // direction: Axis.vertical,
                                      children: [
                                        TextFieldWidget(
                                            label: 'Vehicle Type',
                                            controller: vehicleType,
                                            isEdit: true),
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Vehicle No.',
                                          controller: vehicleNo,
                                        ),
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Registration No.',
                                          controller: regNo,
                                        ),
                                        TextFieldWidget(
                                            label: 'Valid Till',
                                            controller: validTill1,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Insurance certificate No.',
                                            controller: insuranceNo,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Insurance Valid Till',
                                            controller: insuranceValidTill,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Permit No.',
                                            controller: permitNo,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Permit Valid Till',
                                            controller: permitValidTill,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Fitness Certficate',
                                            controller: fitnessCertifiacte,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Valid Till',
                                            controller: validTill2,
                                            isEdit: true),
                                        SearchBarWidget(
                                          isMob: false,
                                          label: 'Driver Name',
                                          controller: driverName,
                                        ),
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Driver Mobile No.',
                                          controller: driverMobile,
                                        ),
                                        SearchBarWidget(
                                          isMob: false,
                                          label: 'Helper Name',
                                          controller: helperName,
                                        ),
                                        TextFieldWidget(
                                            label: 'Helper Mobile No.',
                                            controller: helperMobile,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Driver Google Map Live',
                                            controller: driverGmap,
                                            isEdit: true),
                                        TextFieldWidget(
                                            label: 'Helper Google Map Live',
                                            controller: helperGmap,
                                            isEdit: true),
                                      ],
                                    ),
                                  if (selectedTile == i)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 30, bottom: 20, top: 20),
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional.bottomEnd,
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              updateVehicle(selectedTile),
                                          child: Text('update'),
                                        ),
                                      ),
                                    )
                                ],
                              )),
                        ),
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        )
      ],
    );
  }
}

class AddPickupPoint extends StatefulWidget {
  const AddPickupPoint(
      {super.key,
      required this.schoolCode,
      required this.routeList,
      required this.callback});
  final String schoolCode;
  final List routeList;
  final VoidCallback callback;

  @override
  State<AddPickupPoint> createState() => _AddPickupPointState();
}

class _AddPickupPointState extends State<AddPickupPoint> {
  TextEditingController pointName = TextEditingController();
  TextEditingController distance = TextEditingController();
  TextEditingController fare = TextEditingController();
  TextEditingController pickupTime = TextEditingController();

  String? selectedRoute;

  addPickupPoint() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/addPickupPoint');

    var response = await client.post(url, body: {
      'schoolCode': widget.schoolCode.toString(),
      'route': selectedRoute ?? '',
      'pointName': pointName.text.trim(),
      'distance': distance.text.trim(),
      'fare': fare.text.trim(),
      'pickupTime': pickupTime.text.trim()
    });
    if (response.body == 'true') {
      print(true);
      if (mounted) {
        Navigator.of(context).pop();
      }
      widget.callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close)),
            ),
            Text(
              'Add Pickup Point',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Wrap(
              direction: Axis.vertical,
              // runSpacing: 15,
              spacing: 15,
              children: [
                DropDownWidget(
                    isEdit: true,
                    items: widget.routeList.map((e) => e['routeName']).toList(),
                    title: 'Select Route',
                    callBack: (p0) {
                      setState(() {
                        selectedRoute = p0;
                      });
                    },
                    selected: selectedRoute),
                TextFieldWidget(
                    label: 'Enter Pickup Point',
                    controller: pointName,
                    isEdit: true),
                TextFieldWidget(
                    label: 'Distance', controller: distance, isEdit: true),
                TextFieldWidget(label: 'Fare', controller: fare, isEdit: true),
                TextFieldWidget(
                    label: 'Pickup Time', controller: pickupTime, isEdit: true),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: addPickupPoint,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRoute extends StatefulWidget {
  const AddRoute(
      {super.key,
      required this.schoolCode,
      required this.callback,
      required this.vehicleList});
  final String schoolCode;
  final List vehicleList;
  final VoidCallback callback;
  @override
  State<AddRoute> createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  TextEditingController routeName = TextEditingController();
  TextEditingController descp = TextEditingController();
  String? selectedVehicle;
  String? selectedVehicleNo;
  String? selectedVehicleType;

  addRoute() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/addRoute');

    var response = await client.post(url, body: {
      'schoolCode': widget.schoolCode.toString(),
      'vehicle': jsonEncode({
        'vehicleType': selectedVehicleType ?? '',
        'regNo': selectedVehicleNo ?? ''
      }),
      'routeName': routeName.text.trim(),
      'descp': descp.text.trim()
    });
    if (response.body == 'true') {
      print(true);
      if (mounted) {
        Navigator.of(context).pop();
      }
      widget.callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 500,
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close)),
            ),
            Text(
              'Add Route',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Wrap(
              direction: Axis.vertical,
              // runSpacing: 15,
              spacing: 15,
              children: [
                DropDownWidget(
                    isEdit: true,
                    items: widget.vehicleList
                        .map((e) => '${e['vehicleType']} ~ ${e['regNo']}')
                        .toList(),
                    title: 'Select Vehicle',
                    callBack: (p0) {
                      setState(() {
                        selectedVehicle = p0;
                        var g = p0.split(' ~ ');
                        print(g);
                        selectedVehicleType = g[0];
                        selectedVehicleNo = g[1].trim();
                      });
                    },
                    selected: selectedVehicle),
                TextFieldWidget(
                    label: 'Enter Route Name',
                    controller: routeName,
                    isEdit: true),
                SizedBox(
                  width: 250,
                  child: TextField(
                    maxLines: 3,
                    readOnly: false,
                    controller: descp,
                    decoration: InputDecoration(
                      isDense: true,
                      alignLabelWithHint: true,
                      label: Text('Description'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: addRoute,
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddDriver extends StatelessWidget {
  const AddDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close)),
        ),
        Wrap(
          children: [],
        )
      ],
    );
  }
}

class AddVehicle extends StatefulWidget {
  const AddVehicle(
      {super.key, required this.schoolCode, required this.callback});
  final String schoolCode;
  final VoidCallback callback;
  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  TextEditingController vehicleType = TextEditingController();
  TextEditingController vehicleNo = TextEditingController();
  TextEditingController regNo = TextEditingController();
  TextEditingController validTill1 = TextEditingController();
  TextEditingController insuranceNo = TextEditingController();
  TextEditingController insuranceValidTill = TextEditingController();
  TextEditingController permitNo = TextEditingController();
  TextEditingController permitValidTill = TextEditingController();
  TextEditingController fitnessCertifiacte = TextEditingController();
  TextEditingController validTill2 = TextEditingController();
  TextEditingController driverName = TextEditingController();
  TextEditingController driverMobile = TextEditingController();
  TextEditingController helperName = TextEditingController();
  TextEditingController helperMobile = TextEditingController();
  TextEditingController driverGmap = TextEditingController();
  TextEditingController helperGmap = TextEditingController();

  addVehicle() async {
    var client = BrowserClient()..withCredentials = true;

    // Map data = {};
    var url = Uri.http(ipv4, '/addVehicle');

    var response = await client.post(url, body: {
      'schoolCode': widget.schoolCode,
      'vehicleType': vehicleType.text.trim(),
      'vehicleNo': vehicleNo.text.trim(),
      'regNo': regNo.text.trim(),
      'validTill1': validTill1.text.trim(),
      'insuranceNo': insuranceNo.text.trim(),
      'insuranceValidTill': insuranceValidTill.text.trim(),
      'permitNo': permitNo.text.trim(),
      'permitValidTill': permitValidTill.text.trim(),
      'fitnessCertifiacte': fitnessCertifiacte.text.trim(),
      'validTill2': validTill2.text.trim(),
      'driverName': driverName.text.trim(),
      'driverMobile': driverMobile.text.trim(),
      'helperName': helperName.text.trim(),
      'helperMobile': helperMobile.text.trim(),
      'driverGmap': driverGmap.text.trim(),
      'helperGmap': helperGmap.text.trim(),
    });
    if (response.body == 'true') {
      print(true);
      if (mounted) {
        Navigator.of(context).pop();
      }
      widget.callback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close)),
            ),
            Text(
              'Add Vehicle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Wrap(
              runSpacing: 15,
              spacing: 15,
              // direction: Axis.vertical,
              children: [
                TextFieldWidget(
                    label: 'Vehicle Type',
                    controller: vehicleType,
                    isEdit: true),
                TextFieldWidget(
                  isEdit: true,
                  label: 'Vehicle No.',
                  controller: vehicleNo,
                ),
                TextFieldWidget(
                  isEdit: true,
                  label: 'Registration No.',
                  controller: regNo,
                ),
                TextFieldWidget(
                    label: 'Valid Till', controller: validTill1, isEdit: true),
                TextFieldWidget(
                    label: 'Insurance certificate No.',
                    controller: insuranceNo,
                    isEdit: true),
                TextFieldWidget(
                    label: 'Insurance Valid Till',
                    controller: insuranceValidTill,
                    isEdit: true),
                TextFieldWidget(
                    label: 'Permit No.', controller: permitNo, isEdit: true),
                TextFieldWidget(
                    label: 'Permit Valid Till',
                    controller: permitValidTill,
                    isEdit: true),
                TextFieldWidget(
                    label: 'Fitness Certficate',
                    controller: fitnessCertifiacte,
                    isEdit: true),
                TextFieldWidget(
                    label: 'Valid Till', controller: validTill2, isEdit: true),
                SearchBarWidget(
                  isMob: false,
                  controller: driverName,
                  label: 'Driver Name',

                  // searchFunction: (p0) => searchFunction(p0),
                ),
                TextFieldWidget(
                  isEdit: true,
                  label: 'Driver Mobile No.',
                  controller: driverMobile,
                ),
                SearchBarWidget(
                  isMob: false,
                  controller: helperName,
                  label: 'Helper Name',

                  // searchFunction: (p0) => searchFunction(p0),
                ),
                TextFieldWidget(
                    label: 'Helper Mobile No.',
                    controller: helperMobile,
                    isEdit: true),
                TextFieldWidget(
                    label: 'Driver Google Map Live',
                    controller: driverGmap,
                    isEdit: true),
                TextFieldWidget(
                    label: 'Helper Google Map Live',
                    controller: helperGmap,
                    isEdit: true),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: addVehicle,
              child: Text('Add'),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
