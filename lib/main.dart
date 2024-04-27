import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/attendance_nav.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _loggedRouter = router;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _loggedRouter,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: false),
    );
  }
}

class ShareProfilePage extends StatelessWidget {
  const ShareProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'St. Vincent Pallotti School',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text('Suraj nagar, near palloti school, Maharashtra 440013'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone),
                Text('0712-259372, '),
                Icon(Icons.mail_rounded),
                Text('school@gmail,com'),
              ],
            ),
            Text('www.school.com'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 30),
                //       child: ProfileCard(),
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     MoreDetailsCard()
                //   ],
                // ),
                AttendanceCard()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
