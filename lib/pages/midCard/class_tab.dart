import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../../ip_address.dart';
import 'each_student_page.dart';

class ClassTab extends StatefulWidget {
  const ClassTab({super.key, required this.schoolCode, required this.menuName});
  final String schoolCode;
  final String menuName;

  @override
  State<ClassTab> createState() => _ClassTabState();
}

class _ClassTabState extends State<ClassTab> {
  late Future _getClasses;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMidClasses/${widget.schoolCode}');
    var res = await client.get(url);
    Map data = jsonDecode(res.body);

    return data;
  }

  @override
  void initState() {
    _getClasses = getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getClasses,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          List classes = snapshot.data['classes'];
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) => Card(
                child: ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EachClassPage(
                  schoolCode: widget.schoolCode,
                  classTitle: classes[index]['title'],
                  menuName: widget.menuName,
                ),
              )),
              title: Text(classes[index]['title']),
            )),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class EachClassPage extends StatefulWidget {
  const EachClassPage(
      {super.key,
      required this.schoolCode,
      required this.classTitle,
      required this.menuName});
  final String schoolCode;
  final String classTitle;
  final String menuName;

  @override
  State<EachClassPage> createState() => _EachClassPageState();
}

class _EachClassPageState extends State<EachClassPage> {
  late Future _getStudents;
  // late bool printReady;
  late String barTitle;

  Future getStudentsEachClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse(
        '$ipv4/eachClassMid/${widget.schoolCode}/${widget.classTitle}');
    var res = await client.get(url);

    print('done');
    print(res.body);
    List data = jsonDecode(res.body);

    return data;
  }

  @override
  void initState() {
    _getStudents = getStudentsEachClass();
    // switch (widget.menuName) {
    //   case 'print':
    //     // printReady = true;
    //     barTitle='Printing';
    //   case 'unchecked':
    //     // printReady = false;
    //     barTitle='Unchecked';
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.classTitle),
        ),
        body: FutureBuilder(
          future: _getStudents,
          builder: (context, snapshot) {
            List students = [];
            if (snapshot.hasData) {
              students = snapshot.data;
              return RefreshIndicator(
                onRefresh: getStudentsEachClass,
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    bool value = true;
                    switch (widget.menuName) {
                      case 'print':
                        value = students[index]['ready'];
                      case 'unchecked':
                        value = !students[index]['ready'];
                    }

                    if (value) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            onForegroundImageError: (exception, stackTrace) =>
                                Text('data'),
                            child: Icon(
                              Icons.account_circle,
                              size: 40,
                            ),
                            key: UniqueKey(),
                            foregroundImage: NetworkImage(
                                "${Uri.parse('$ipv4/getProfilePicMid/${widget.schoolCode}/${students[index]['admNo']}')}"),
                          ),
                          // FutureBuilder(
                          //   future: _getProfilePic,
                          //   builder: (context, snapshot) {
                          //     if (snapshot.hasData) {
                          //       return CircleAvatar(
                          //         onForegroundImageError: (exception, stackTrace) =>
                          //             Text('data'),
                          //         child: Icon(
                          //           Icons.account_circle,
                          //           size: 100,
                          //         ),
                          //         radius: 50,
                          //         foregroundImage:
                          //             MemoryImage(snapshot.data as Uint8List),
                          //       );
                          //     } else {
                          //       return Icon(Icons.error_outline_rounded);
                          //     }
                          //   },
                          // ),
                          title: Text(students[index]['fullName']),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EachStudentPage(
                                schoolCode: widget.schoolCode,
                                admNo: students[index]['admNo'],
                                listRefresh: () {
                                  setState(() {
                                    _getStudents = getStudentsEachClass();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
