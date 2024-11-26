import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key, required this.child});
  final Widget child;

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  List links = [
    '/class-attendance',
    '/teacherProfile',
    '/id-cards',
    '/others',
  ];

  @override
  void initState() {
    //  print(controllers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = links.indexWhere((element) =>
        GoRouter.of(context).namedLocation(links[element]).startsWith(element));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('School Management')),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height,
          child: Row(
            children: [
              NavigationRail(
                backgroundColor: Colors.indigo[50],
                elevation: 1,
                minExtendedWidth: 200,
                extended: true,
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  selectedIndex = value;
                  if (value == 0) context.go('/class-attendance');
                  if (value == 1) context.go('/teacherProfile');
                  if (value == 2) context.go('/id-cards');
                  if (value == 3) context.go('/others');
                },
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.table_view),
                      label: Text('Class Time Table')),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 200,
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height,
                child: widget.child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
