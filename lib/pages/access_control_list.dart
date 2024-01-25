import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';

class ControlList extends StatefulWidget {
  const ControlList({super.key, required this.userType});
  final String userType;

  @override
  State<ControlList> createState() => _ControlListState();
}

class _ControlListState extends State<ControlList> {
  bool students = false;
  bool staff = false;
  bool academic = false;
  bool transportation = false;
  bool addNotice = false;
  bool accessControl = false;
  bool _loading = true;
  late int count;
  @override
  void initState() {
    getAccessDetails();
    super.initState();
  }

  Future getAccessDetails() async {
    var url = Uri.parse('$ipv4/getSingleAccesses/${widget.userType}');
    var res = await http.get(url);

    print('done');
    print(res.body);
    List access = jsonDecode(res.body);
    count = access.length;
    print(count);
    (access.contains('students')) ? students = true : students = false;
    (access.contains('staff')) ? staff = true : staff = false;
    (access.contains('academic')) ? academic = true : academic = false;
    (access.contains('transportation'))
        ? transportation = true
        : transportation = false;
    (access.contains('addNotice')) ? addNotice = true : addNotice = false;
    (access.contains('accessControl'))
        ? accessControl = true
        : accessControl = false;
    setState(() {
      _loading = false;
    });
  }

  Future editAccessControl(String field, bool value) async {
    if (count <= 2 && value == false) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Minimum 2 access has to be provided')));
    } else {
      setState(() {
        _loading = true;
      });
      var url = Uri.parse('$ipv4/editAccesses/${widget.userType}');
      var res = await http.post(url, body: {field: value.toString()});
      print(res.body);
      if (res.body == 'true') {
        value == true ? count++ : count--;
        getAccessDetails().then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              width: 500,
              behavior: SnackBarBehavior.floating,
              content: Text(
                value
                    ? '$field access granted to ${widget.userType}'
                    : '$field access removed from ${widget.userType}',
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(title: Text(widget.userType)),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  AccessCard(
                    icon: Icons.assignment_ind_outlined,
                    title: 'Student',
                    description:
                        'Adding and managing of students at Admin level',
                    toggle: Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        activeColor: Colors.indigo,
                        value: students,
                        onChanged: (value) =>
                            editAccessControl('students', value)),
                  ),
                  AccessCard(
                    icon: Icons.person_outline_rounded,
                    title: 'Staff',
                    description: 'Adding and managing of staff at Admin level',
                    toggle: Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        activeColor: Colors.indigo,
                        value: staff,
                        onChanged: (value) =>
                            editAccessControl('staff', value)),
                  ),
                  AccessCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Transportation',
                    description: 'Managing transportation at Admin level',
                    toggle: Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        activeColor: Colors.indigo,
                        value: transportation,
                        onChanged: (value) =>
                            editAccessControl('transportation', value)),
                  ),
                  AccessCard(
                    icon: Icons.school_outlined,
                    title: 'Academic',
                    description:
                        'Managing of class time table assigning of teachers (admin level) ',
                    toggle: Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        activeColor: Colors.indigo,
                        value: academic,
                        onChanged: (value) =>
                            editAccessControl('academic', value)),
                  ),
                  AccessCard(
                    icon: Icons.assignment_outlined,
                    title: 'Notice',
                    description: 'To send notices from management/institute',
                    toggle: Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        activeColor: Colors.indigo,
                        value: addNotice,
                        onChanged: (value) =>
                            editAccessControl('addNotice', value)),
                  ),
                  AccessCard(
                    icon: Icons.shield_outlined,
                    title: 'Access Control',
                    description:
                        'Managing of which user can access what module',
                    toggle: Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        activeColor: Colors.indigo,
                        value: accessControl,
                        onChanged: (value) =>
                            editAccessControl('accessControl', value)),
                  )
                ],
              ),
            ),
          );
  }
}

class AccessCard extends StatelessWidget {
  const AccessCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.toggle,
  });
  final IconData icon;
  final String title;
  final String description;
  final Switch toggle;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      child: SizedBox(
        width: width > 1000 ? width / 3 : null,
        height: 75,
        child: GridTileBar(
            leading: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                icon,
                color: Colors.indigo,
                size: 35,
              ),
            ),
            title: Text(
              title,
              style:
                  TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                description,
                softWrap: true,
                style: TextStyle(
                  overflow: TextOverflow.visible,
                  color: Colors.indigo[300],
                ),
              ),
            ),
            trailing: toggle),
      ),
    );
  }
}
