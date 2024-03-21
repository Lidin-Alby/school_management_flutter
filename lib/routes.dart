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
import 'package:school_management/pages/admit_cards.dart';
import 'package:school_management/pages/class_management.dart';
import 'package:school_management/pages/each_staff_page.dart';
import 'package:school_management/pages/exam_management.dart';
import 'package:school_management/pages/form_submit_dialog.dart';
import 'package:school_management/pages/full_application.dart';
import 'package:school_management/pages/grade_assignment.dart';
import 'package:school_management/pages/grade_management.dart';
import 'package:school_management/pages/login_page.dart';
import 'package:school_management/pages/marks_management.dart';
import 'package:school_management/pages/online_admission.dart';
import 'package:school_management/pages/online_application.dart';
import 'package:school_management/pages/owner_page.dart';
import 'package:school_management/pages/report_card_download.dart';
import 'package:school_management/pages/school_settings.dart';
import 'package:school_management/pages/single_page_profile.dart';
import 'package:school_management/pages/subject_management.dart';
import 'package:school_management/pages/time_table_management.dart';

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
import 'pages/test.dart';
import 'profile_nav.dart';
import 'result_nav.dart';
import 'study_material_nav.dart';
import 'teacher_page.dart';
import 'time_table_nav.dart';
import 'widgets/add_marks.dart';
import 'widgets/class_attendance_card.dart';
import 'widgets/id_card.dart';
import 'pages/class_curriculum.dart';
import 'widgets/student_shell_widget.dart';
import 'package:http/http.dart' as http;

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

FutureOr<String?> authFun() async {
  var client = BrowserClient()..withCredentials = true;
  var url = Uri.parse('$ipv4/getCookie');
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
      path: '/shareProfile/:scCode/:admNo',
      builder: (context, state) => SinglePageProfile(
        schoolCode: state.params['scCode'].toString(),
        admNo: state.params['admNo'].toString(),
      ),
    ),
    GoRoute(
      path: '/onlineApplication/:code',
      builder: (context, state) => OnlyForm(
        code: state.params['code'].toString(),
      ),
    ),
    GoRoute(
      path: '/submitionComplete',
      builder: (context, state) => SubmitDialog(),
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
          path: '/test',
          pageBuilder: (context, state) => NoTransitionPage(child: Test()),
        ),
        GoRoute(
          path: '/exam-management',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ExamManagement()),
        ),
        GoRoute(
          path: '/marks-management',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: MarksManagement()),
        ),
        GoRoute(
          path: '/grade-management',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: GradeManagement()),
        ),
        GoRoute(
          path: '/grade-assignment',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: GradeAssignment()),
        ),
        GoRoute(
          path: '/report-card-download',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ReportCardDownload()),
        ),
        GoRoute(
          path: '/admit-card-download',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: AdmitCardDownload()),
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
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ClassCurriculum()),
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
          path: '/subject-management',
          builder: (context, state) => SubjectManagement(),
          redirect: (context, state) => authFun(),
        ),
        GoRoute(
          path: '/class-management',
          builder: (context, state) => ClassManagement(),
          redirect: (context, state) => authFun(),
        ),

        GoRoute(
          path: '/class-curriculum',
          builder: (context, state) => ClassCurriculum(),
          redirect: (context, state) => authFun(),
        ),
        GoRoute(
          path: '/time-table-management',
          builder: (context, state) => TimeTableManagement(),
          redirect: (context, state) => authFun(),
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
            path: '/online-admission',
            builder: (context, state) => OnlineAdmission(),
            redirect: (context, state) => authFun(),
            routes: [
              GoRoute(
                  path: ':formNo',
                  builder: (context, state) => FullApplication(
                        formNo: state.params['formNo'].toString(),
                      ),
                  redirect: (context, state) => authFun())
            ]),
        GoRoute(
          path: '/school-settings',
          builder: (context, state) => SchoolSettings(
              index: state.extra.isNull ? 0 : state.extra as int),
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
