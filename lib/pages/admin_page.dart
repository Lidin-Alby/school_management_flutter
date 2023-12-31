import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.child});
  final Widget child;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool loading = true;
  List accesses = [];
  List searchList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    loadAccess().then((value) {
      accesses = value;
      setState(() {
        loading = false;
      });
    });
    super.initState();
  }

  Future loadAccess() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getAccesses');
    http.Response res;
    res = await client.get(url);
    print(res.body);
    return jsonDecode(res.body);
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.indigo[900],
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  width: 400,
                  child: TextField(
                    // onTapOutside: (event) => setState(() {
                    //   searchList = [];
                    // }),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15),
                        filled: true,
                        fillColor: Colors.orange[50],
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(20)),
                        hintText: 'Search Student',
                        isDense: true,
                        prefixIcon: Icon(Icons.search)),
                    onChanged: (value) => searchFunction(value),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                  iconSize: 35,
                  onPressed: () {
                    var client = BrowserClient()..withCredentials = true;
                    var url = Uri.http(ipv4, '/logout');
                    // http.Response res;
                    client.get(url);

                    context.go('/login');
                  },
                  icon: Icon(
                    Icons.account_circle_rounded,
                  )),
              SizedBox(
                width: 10,
              )
            ],
            title: Text('School Management'),
          ),
          drawerScrimColor: Colors.transparent,
          drawer: width > 800
              ? Drawer(
                  width: 300,
                  // elevation: 1,
                  child: SizedBox(
                    height: 500,
                    child: Column(
                      children: [
                        AppBar(
                          title: Text('School Management'),
                          leading: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                _scaffoldKey.currentState!.closeDrawer();
                              }),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height - 56),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: CustomNavigationRail(
                                accesses: accesses,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
          backgroundColor: Colors.white,
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height - 56),
                        child: IntrinsicHeight(
                          child: width > 800
                              ? SizedBox(
                                  width: 220,
                                  child: CustomNavigationRail(
                                    accesses: accesses,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(child: widget.child),
                  ],
                ),
        ),
        Positioned(
            top: 50,
            right: 90,
            child: Card(
              elevation: 5,
              child: Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var result in searchList)
                        InkWell(
                          onTap: () =>
                              context.go('/students/${result['admNo']}'),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8),
                            width: 400,
                            child: Text(
                                '${result['fullName']} - ${result['admNo']}'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }
}

class CustomNavigationRail extends StatelessWidget {
  const CustomNavigationRail({super.key, required this.accesses});
  final List accesses;

  NavigationRailDestination navs(String e) {
    switch (e) {
      case 'class-attendance':
        return NavigationRailDestination(
            icon: Icon(Icons.calendar_month),
            label: Text(
              'Class\nAttendance',
              textAlign: TextAlign.center,
            ));
      case 'id-cards':
        return NavigationRailDestination(
            icon: Icon(Icons.badge_rounded), label: Text('ID Card'));
      case 'others':
        return NavigationRailDestination(
            icon: Icon(Icons.more_horiz_rounded), label: Text('Others'));
      case 'profile':
        return const NavigationRailDestination(
          selectedIcon: Icon(Icons.account_circle),
          icon: Icon(Icons.account_circle_outlined),
          label: Text('Profile'),
        );
      case 'attendance':
        return NavigationRailDestination(
          selectedIcon: Icon(Icons.calendar_month),
          icon: Icon(Icons.calendar_month_outlined),
          label: Text('Attendance'),
        );
      case 'time-table':
        return NavigationRailDestination(
          selectedIcon: Icon(Icons.table_view),
          icon: Icon(Icons.table_view_outlined),
          label: Text('Time Table'),
        );
      case 'homework':
        return NavigationRailDestination(
          selectedIcon: Icon(Icons.description),
          icon: Icon(Icons.description_outlined),
          label: Text('Homework'),
        );
      case 'study-material':
        return NavigationRailDestination(
          selectedIcon: Icon(Icons.subscriptions),
          icon: Icon(Icons.subscriptions_outlined),
          label: Text('Study Material'),
        );
      case 'result':
        return NavigationRailDestination(
          selectedIcon: Icon(Icons.leaderboard),
          icon: Icon(Icons.leaderboard_outlined),
          label: Text('Result'),
        );
      case 'fees':
        return NavigationRailDestination(
          selectedIcon: Icon(Icons.receipt_long),
          icon: Icon(Icons.receipt_long_rounded),
          label: Text('Fees'),
        );

      case 'students':
        return const NavigationRailDestination(
          selectedIcon: Icon(Icons.assignment_ind),
          icon: Icon(Icons.assignment_ind_outlined),
          label: Text('Students'),
        );

      case 'staff':
        return const NavigationRailDestination(
          selectedIcon: Icon(Icons.person_rounded),
          icon: Icon(Icons.person_outline_rounded),
          label: Text('Staff'),
        );
      case 'academic':
        return const NavigationRailDestination(
          selectedIcon: Icon(Icons.school_rounded),
          icon: Icon(Icons.school_outlined),
          label: Text('Academic'),
        );
      case 'addNotice':
        return const NavigationRailDestination(
          selectedIcon: Icon(Icons.assignment_rounded),
          icon: Icon(Icons.assignment_outlined),
          label: Text('Notice'),
        );
      case 'transportation':
        return const NavigationRailDestination(
          selectedIcon: Icon(Icons.directions_bus),
          icon: Icon(Icons.directions_bus_outlined),
          label: Text('Transportation'),
        );
    }
    return const NavigationRailDestination(
      padding: EdgeInsets.zero,
      selectedIcon: Icon(Icons.shield),
      icon: Icon(Icons.shield_outlined),
      label: Text('Access Control'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    int? selectedIndex = accesses.indexWhere(
        (element) => GoRouter.of(context).location.startsWith('/$element'));
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: NavigationRail(
            backgroundColor: Colors.indigo[900],
            selectedIconTheme: IconThemeData(color: Colors.indigo[700]),
            indicatorColor: Colors.white,
            useIndicator: true,
            unselectedIconTheme: IconThemeData(color: Colors.white),
            unselectedLabelTextStyle: TextStyle(color: Colors.white),
            selectedLabelTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                // fontSize: 15,
                letterSpacing: 1),
            // elevation: 8,
            // labelType: MediaQuery.of(context).size.width > 1300
            //     ? NavigationRailLabelType.none
            //     : NavigationRailLabelType.all,
            extended: true,
            onDestinationSelected: (value) {
              print(value);
              switch (accesses[value]) {
                case 'class-attendance':
                  context.go('/class-attendance');
                  break;
                case 'others':
                  context.go('/others');
                  break;
                case 'id-cards':
                  context.go('/id-cards');
                  break;
                case 'profile':
                  context.go('/profile');
                  break;
                case 'attendance':
                  context.go('/attendance');
                  break;
                case 'time-table':
                  context.go('/time-table');
                  break;
                case 'homework':
                  context.go('/homework');
                  break;
                case 'study-material':
                  context.go('/study-material');
                  break;
                case 'result':
                  context.go('/result');
                  break;
                case 'fees':
                  context.go('/fees');
                  break;
                case 'students':
                  context.go('/students');
                  break;
                case 'staff':
                  context.go('/staff');
                  break;
                case 'academic':
                  context.go('/academic');
                  break;
                case 'addNotice':
                  context.go('/addNotice');
                  break;
                case 'transportation':
                  context.go('/transportation');
                  break;
                case 'accessControl':
                  context.go('/accessControl', extra: false);
                  break;
              }
            },
            destinations: accesses.map((e) => navs(e)).toList(),
            selectedIndex: selectedIndex),
      ),
    );
  }
}
