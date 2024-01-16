import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/ip_address.dart';
import 'package:school_management/pages/access_control_list.dart';
import 'package:school_management/pages/admin_access_control.dart';

import 'package:school_management/pages/admin_page.dart';
import 'package:school_management/pages/admin_transporatation.dart';
import 'package:school_management/pages/each_staff_page.dart';
import 'package:school_management/pages/login_page.dart';
import 'package:school_management/pages/online_application.dart';
import 'package:school_management/pages/owner_page.dart';
import 'package:school_management/pages/school_settings.dart';

import 'attendance_nav.dart';
import 'chapter_content.dart';
import 'chapters_page.dart';
import 'fee_nav.dart';
import 'homework_nav.dart';

import 'pages/admin_academic.dart';
import 'pages/admin_notice.dart';
import 'pages/admin_satff_page.dart';
import 'pages/admin_students_page.dart';
import 'pages/class_menu.dart';
import 'pages/each_student_page.dart';
import 'profile_nav.dart';
import 'result_nav.dart';
import 'study_material_nav.dart';
import 'teacher_page.dart';
import 'time_table_nav.dart';
import 'widgets/add_marks.dart';
import 'widgets/class_attendance_card.dart';
import 'widgets/id_card.dart';
import 'widgets/others.dart';
import 'widgets/student_shell_widget.dart';
import 'package:http/http.dart' as http;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

FutureOr<String?> authFun() async {
  var client = BrowserClient()..withCredentials = true;
  var url = Uri.http(ipv4, '/getCookie');
  http.Response response;
  response = await client.get(url);
  if (response.body == 'false') {
    return '/login';
  }

  return null;
}

final GoRouter router = GoRouter(
  initialLocation: '/login',
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/onlineApplication/:code',
      builder: (context, state) => OnlineApplication(
        code: state.params['code'].toString(),
      ),
    ),
    GoRoute(
      path: '/myApp',
      builder: (context, state) => OwnerPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AdminPage(child: child),
      routes: [
        GoRoute(
          path: '/class-attendance',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ClassAttendanceCard()),
        ),
        GoRoute(
          path: '/id-cards',
          pageBuilder: (context, state) => NoTransitionPage(child: IdCard()),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileNav(),
        ),
        GoRoute(
          path: '/time-table',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: TimeTableNav()),
        ),
        GoRoute(
          path: '/attendance',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: AttendanceNav()),
        ),
        GoRoute(
          path: '/result',
          pageBuilder: (context, state) => NoTransitionPage(child: ResultNav()),
        ),
        GoRoute(
          path: '/fees',
          pageBuilder: (context, state) => NoTransitionPage(child: FeeNav()),
        ),
        GoRoute(
          path: '/homework',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: HomeworkNav()),
        ),
        GoRoute(
          path: '/study-material',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: StudyMaterialNav()),
          routes: [
            GoRoute(
              path: ':subjectName',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ChaptersPage(
                  subjectName: state.params['subjectName'].toString(),
                  //   chapters: state.extra as Map,
                ),
              ),
              routes: [
                GoRoute(
                  path: 'chapter',
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: ChapterContent(
                        // chapterName:
                        //     state.params['chapterName'].toString(),
                        ),
                  ),
                )
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/others',
          pageBuilder: (context, state) => NoTransitionPage(child: AddResult()),
          routes: [
            GoRoute(
              name: 'addMarks',
              path: 'add-marks',
              pageBuilder: (context, state) => NoTransitionPage(
                child: AddMarks(),
              ),
            ),
          ],
        ),
        // GoRoute(
        //   path: '/login',
        //   builder: (context, state) => LoginPage(),
        // ),
        // GoRoute(path: '/studentsMenu'),

        GoRoute(
          path: '/students',
          builder: (context, state) => AdminStudents(),
          redirect: (context, state) => authFun(),
          routes: [
            GoRoute(
              path: ':admNo',
              builder: (context, state) => EachStudent(
                admNo: state.params['admNo'].toString(),
              ),
            ),
          ],
        ),
        GoRoute(
            path: '/staff',
            builder: (context, state) => AdminStaff(),
            redirect: (context, state) => authFun(),
            routes: [
              GoRoute(
                path: ':mobNo',
                builder: (context, state) => EachStaff(
                  mobNo: state.params['mobNo'].toString(),
                ),
              ),
            ]),
        GoRoute(
          path: '/transportation',
          builder: (context, state) => AdminTransport(),
          redirect: (context, state) => authFun(),
        ),
        GoRoute(
          path: '/school-settings',
          builder: (context, state) => SchoolSettings(),
          redirect: (context, state) => authFun(),
        ),
        GoRoute(
            path: '/accessControl',
            builder: (context, state) => AccessControl(
                  isrefered: state.extra.isNull ? false : state.extra as bool,
                ),
            redirect: (context, state) => authFun(),
            routes: [
              GoRoute(
                path: ':userType',
                builder: (context, state) => ControlList(
                  userType: state.params['userType'].toString(),
                ),
              ),
            ]),
        GoRoute(
          path: '/academic',
          builder: (context, state) => AdminAcademic(),
          redirect: (context, state) => authFun(),
          routes: [
            GoRoute(
                path: 'promotion:class',
                builder: (context, state) => PromoteClass(
                      className: state.params['class'].toString(),
                    )),
            GoRoute(
              path: ':class',
              // builder: (context, state) => ClassMenu(
              //   title: state.params['class'].toString(),
              // ),
              pageBuilder: (context, state) => CustomTransitionPage(
                transitionDuration: Duration(milliseconds: 500),
                key: state.pageKey,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        SlideTransition(
                  position:
                      Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                          .animate(animation),
                  child: child,
                ),
                child: ClassMenu(
                  title: state.params['class'].toString(),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/addNotice',
          builder: (context, state) => AdminNotice(),
          redirect: (context, state) => authFun(),
        ),
      ],
    )
  ],
);

ShellRoute teacherShellRoute = ShellRoute(
  navigatorKey: _shellNavigatorKey,
  builder: (context, state, child) => TeacherPage(
    child: child,
  ),
  routes: [
    // GoRoute(
    //   path: '/teacherProfile',
    //   pageBuilder: (context, state) => NoTransitionPage(child: TimeTableCard()),
    // ),
  ],
);

ShellRoute studentShellRoute = ShellRoute(
  navigatorKey: _shellNavigatorKey,
  builder: (context, state, child) => StudentShellWidget(child: child),
  routes: [
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => NoTransitionPage(child: ProfileNav()),
    ),
  ],
);
