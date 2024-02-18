import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';

class AttendanceSettings extends StatefulWidget {
  const AttendanceSettings({
    super.key,
  });

  @override
  State<AttendanceSettings> createState() => _AttendanceSettingsState();
}

class _AttendanceSettingsState extends State<AttendanceSettings> {
  late Future _getSettings;
  String? attendanceType;

  getAttendanceSettings() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getAttendanceSettings');
    var res = await client.get(url);
    print(res.body);
    Map data = jsonDecode(res.body);
    if (data['attendanceSettings'].containsKey('type')) {
      attendanceType = data['attendanceSettings']['type'];
      print(attendanceType);
    }
  }

  saveAttendanceSettings() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/saveAttendanceSettings');
    var res = await client.post(url, body: {'type': attendanceType});
    if (res.body == 'true') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          content: const Row(
            children: [
              Text(
                'Updated Successfully ',
              ),
              Icon(
                Icons.check_circle,
                color: Colors.white,
              )
            ],
          ),
        ));
      }
    }
  }

  @override
  void initState() {
    _getSettings = getAttendanceSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSettings,
      builder: (context, snapshot) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attendance Type',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: saveAttendanceSettings,
                      child: Text('Save'),
                    )
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text('Attendance'),
                    SizedBox(
                      width: 300,
                      child: RadioListTile(
                        dense: true,
                        title: Text('Daywise'),
                        value: 'yes',
                        groupValue: attendanceType,
                        onChanged: (value) {
                          setState(() {
                            attendanceType = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: RadioListTile(
                        dense: true,
                        title: Text('PeriodWise'),
                        value: 'no',
                        groupValue: attendanceType,
                        onChanged: (value) {
                          setState(() {
                            attendanceType = value;
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
