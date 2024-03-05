import 'dart:convert';
import 'dart:typed_data';

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
  List academic = ['students', 'subject-management', 'online-admission'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool expanded = false;
  int headIndex = 0;
  int? selectedHead;
  bool hide = true;
  late Future _getLogo;
  late Future _schoolName;

  @override
  void initState() {
    loadAccess().then((value) {
      accesses = value;
      academic.retainWhere(
        (element) => accesses.contains(element),
      );
      setState(() {
        loading = false;
      });
    });
    _getLogo = getLogo();
    _schoolName = getSchooldata();
    super.initState();
  }

  getSchooldata() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMyschoolData');
    var res = await client.get(url);
    // print(res.body);
    Map data = jsonDecode(res.body);

    return data['schoolName'];
  }

  Future loadAccess() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getAccesses');
    http.Response res;
    res = await client.get(url);
    print(res.body);
    return jsonDecode(res.body);
  }

  getLogo() async {
    var url2 = Uri.parse('$ipv4/getAdminLogo');
    var client = BrowserClient()..withCredentials = true;
    var response2 = await client.get(url2);

    return (response2.bodyBytes);
  }

  searchFunction(value) async {
    if (value != '') {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/searchStudent/$value');
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
                      var url = Uri.parse('$ipv4/logout');
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
              title: Row(
                children: [
                  FutureBuilder(
                    future: _getLogo,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          // radius: 50,
                          backgroundImage:
                              MemoryImage(snapshot.data as Uint8List),
                        );
                      } else {
                        return Icon(Icons.error_outline_rounded);
                      }
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FutureBuilder(
                    future: _schoolName,
                    builder: (context, snapshot) => Text(
                      snapshot.data.toString(),
                    ),
                  ),
                ],
              ),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                        child: Material(
                          color: Colors.indigo[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onHover: (value) {
                              setState(() {
                                hide = !value;
                              });
                            },
                            onTap: () {},
                            child: Theme(
                              data: ThemeData(
                                  scrollbarTheme: ScrollbarThemeData(
                                thumbVisibility:
                                    MaterialStateProperty.all(true),
                                thumbColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.orange.shade50),
                              )),
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  // height: double.,
                                  width: hide ? 63 : 220,
                                  child: Column(
                                    children: [
                                      // for (int i = 0; i < heads.length; i++)
                                      MyExpandingNavTile(
                                          headIcon: Icons.school_rounded,
                                          headTitle: 'Academic',
                                          head: 0,
                                          subDivsions: academic,
                                          hide: hide),
                                      MyExpandingNavTile(
                                          headIcon: Icons.rectangle_rounded,
                                          headTitle: 'Class Management',
                                          head: 1,
                                          subDivsions: [
                                            'class-management',
                                            'time-table-management',
                                          ],
                                          hide: hide),
                                      MyNavTile(
                                        headIcon: Icons.person_rounded,
                                        headTitle: 'Staff',
                                        link: 'staff',
                                        hide: hide,
                                      ),
                                      MyNavTile(
                                        headIcon: Icons.calendar_month,
                                        headTitle: 'Attendance',
                                        link: 'class-attendance',
                                        hide: hide,
                                      ),
                                      MyNavTile(
                                        headIcon: Icons.assignment_rounded,
                                        headTitle: 'Class Curriculum',
                                        link: 'class-curriculum',
                                        hide: hide,
                                      ),
                                      MyExpandingNavTile(
                                        headIcon:
                                            Icons.playlist_add_check_circle,
                                        head: 2,
                                        headTitle: 'Exam Management',
                                        subDivsions: [
                                          'exam-management',
                                          'marks-management',
                                          'grade-management',
                                          'grade-assignment'
                                        ],
                                        hide: hide,
                                      ),
                                      MyNavTile(
                                        headIcon: Icons.directions_bus,
                                        headTitle: 'Transportation',
                                        link: 'transportation',
                                        hide: hide,
                                      ),
                                      MyNavTile(
                                        headIcon: Icons.shield,
                                        headTitle: 'Access Control',
                                        link: 'accessControl',
                                        hide: hide,
                                      ),
                                      MyNavTile(
                                        headIcon: Icons.settings,
                                        headTitle: 'School Settings',
                                        link: 'school-settings',
                                        hide: hide,
                                      ),

                                      SizedBox(
                                        height: 8,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: widget.child,
                      )),
                    ],
                  )),
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

class MyNavTile extends StatelessWidget {
  const MyNavTile(
      {super.key,
      required this.headIcon,
      required this.headTitle,
      required this.link,
      required this.hide});
  final IconData headIcon;
  final String headTitle;
  final String link;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    bool selected = GoRouter.of(context).location.contains('/$link');
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => context.go('/$link'),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Icon(
                  headIcon,
                  size: 25,
                  color: selected ? Colors.indigo[900] : Colors.white,
                ),
              ),
              if (!hide)
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    headTitle,
                    style: TextStyle(
                      color: selected ? Colors.indigo[900] : Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyExpandingNavTile extends StatefulWidget {
  const MyExpandingNavTile(
      {super.key,
      required this.headIcon,
      required this.headTitle,
      required this.subDivsions,
      required this.head,
      required this.hide});
  final IconData headIcon;
  final String headTitle;
  // final bool selected;
  final int head;

  final List subDivsions;
  final bool hide;

  @override
  State<MyExpandingNavTile> createState() => _MyExpandingNavTileState();
}

class _MyExpandingNavTileState extends State<MyExpandingNavTile> {
  bool expanded = false;
  int selected = 0;
  List accesses = [];
  late List subDivsions;
  int? selectedHead;

  Future loadAccess() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getAccesses');
    http.Response res;
    res = await client.get(url);
    print(res.body);
    setState(() {
      accesses = jsonDecode(res.body);
    });
  }

  String getTitle(String title) {
    switch (title) {
      case 'students':
        return 'Students';
      // case 'staff':
      //   return 'Staff';

      case 'subject-management':
        return 'Subjects';

      case 'class-management':
        return 'Classes';
      case 'time-table-management':
        return 'Time Table';
      case 'online-admission':
        return 'Online Admission';
      case 'exam-management':
        return 'Exam and Papers';
      case 'marks-management':
        return 'Marks Management';
      case 'grade-management':
        return 'Grade Management';
      case 'grade-assignment':
        return 'Grade Assignment';
    }
    return '';
  }

  @override
  void initState() {
    subDivsions = widget.subDivsions;

    loadAccess();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    expanded = !widget.hide;
    int? selectedIndex = subDivsions.indexWhere(
        (element) => GoRouter.of(context).location.startsWith('/$element'));
    String currentRoute = GoRouter.of(context).location;
    switch (currentRoute) {
      case '/students' || '/subject-management' || '/online-admission':
        selectedHead = 0;
        selected = selectedIndex;
        break;
      case '/class-management' || '/time-table-management':
        selectedHead = 1;
        selected = selectedIndex;
      case '/exam-management' ||
            '/marks-management' ||
            '/grade-management' ||
            '/grade-assignment':
        selectedHead = 2;
        selected = selectedIndex;
      case '/staff':
        selectedHead = 3;
        selected = selectedIndex;
        break;
      case '/transportation':
        selectedHead = 3;
        selected = selectedIndex;
        break;
      case '/class-attendance':
        selectedHead = 3;
        selected = selectedIndex;
        break;
      case '/accessControl':
        selectedHead = 3;
        selected = selectedIndex;
        break;
      case '/school-settings':
        selectedHead = 3;
        selected = selectedIndex;
        break;
    }

    // int?selectedHead=
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                color: widget.head == selectedHead
                    ? Colors.white
                    : widget.head != selectedHead && expanded
                        ? Colors.indigo
                        : null,
                borderRadius: expanded
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))
                    : BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Icon(
                          widget.headIcon,
                          size: 25,
                          color: widget.head == selectedHead
                              ? Colors.indigo[900]
                              : Colors.white,
                        ),
                      ),
                      if (!widget.hide)
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            widget.headTitle,
                            style: TextStyle(
                              color: widget.head == selectedHead
                                  ? Colors.indigo[900]
                                  : Colors.white,
                            ),
                          ),
                        ),
                      Spacer(),
                      if (!widget.hide)
                        AnimatedRotation(
                          duration: Duration(milliseconds: 200),
                          turns: expanded ? 0.5 : 0.0,
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: widget.head == selectedHead
                                ? Colors.indigo[900]
                                : Colors.white,
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Ink(
          width: 205,
          decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: AnimatedSize(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 200),
            child: expanded
                ? Column(children: [
                    for (int i = 0; i < subDivsions.length; i++)
                      InkWell(
                        onTap: () {
                          context.go('/${subDivsions[i]}');
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 35,
                              ),
                              Text(
                                getTitle(subDivsions[i]),
                                style: TextStyle(
                                  fontSize: selected == i ? 15 : null,
                                  letterSpacing: .5,
                                  fontWeight:
                                      selected == i ? FontWeight.bold : null,
                                  color: selected == i
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ])
                : Container(),
          ),
        )
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
              // textAlign: TextAlign.center,
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
      case 'school-settings':
        return const NavigationRailDestination(
          selectedIcon: Icon(Icons.settings),
          icon: Icon(Icons.settings_outlined),
          label: Text('School Settings'),
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
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
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
                case 'school-settings':
                  context.go('/school-settings');
                  break;
              }
            },
            destinations: accesses.map((e) => navs(e)).toList(),
            selectedIndex: selectedIndex),
      ),
    );
  }
}
