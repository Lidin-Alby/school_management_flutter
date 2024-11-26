import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentShellWidget extends StatefulWidget {
  const StudentShellWidget({super.key, required this.child});
  final Widget child;
  @override
  State<StudentShellWidget> createState() => _StudentShellWidgetState();
}

class _StudentShellWidgetState extends State<StudentShellWidget> {
  List links = [
    '/profile',
    '/attendance',
    '/time-table',
    '/homework',
    '/study-material',
    '/result',
    '/fees'
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = links.indexWhere((element) =>
        GoRouter.of(context).namedLocation(element).startsWith(element));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('School Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_rounded),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: IconButton(
                //  style: IconButton.styleFrom(shape: RoundedRectangleBorder()),
                padding: EdgeInsets.zero,
                // splashRadius: 20,
                iconSize: 30,
                //   padding: EdgeInsets.all(10),
                onPressed: () => logOut(context),
                icon: Icon(
                  Icons.account_circle,
                  //  size: 50,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    NavigationRail(
                      backgroundColor: Colors.indigo[50],
                      minExtendedWidth: 175,
                      extended: true,
                      // elevation: 4,
                      //   labelType: NavigationRailLabelType.all,
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (value) {
                        selectedIndex = value;

                        if (value == 0) context.go('/profile');
                        if (value == 1) context.go('/attendance');
                        if (value == 2) context.go('/time-table');
                        if (value == 3) context.go('/homework');
                        if (value == 4) context.go('/study-material');
                        if (value == 5) context.go('/result');
                        if (value == 6) context.go('/fees');
                      },
                      destinations: [
                        NavigationRailDestination(
                          icon: Icon(Icons.account_circle),
                          label: Text('Profile'),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 175,
                      child: widget.child,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> logOut(BuildContext context) {
    return showDialog(
      barrierColor: null,
      context: context,
      builder: (context) => Align(
        alignment: AlignmentDirectional.topEnd,
        //  heightFactor: 500,
        child: Padding(
          padding: const EdgeInsets.only(top: 55, right: 10),
          child: SizedBox(
            width: 250,
            child: Card(
              color: Color(0xff4B0082),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Lidin Alby',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(
                              Icons.account_circle_rounded,
                              size: 50,
                            ),
                            subtitle: Text('10908'),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Jibin Alby',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(
                              Icons.account_circle_rounded,
                              size: 50,
                            ),
                            //  subtitle: Text('10908'),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout, color: Colors.white,
                        // size: ,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
