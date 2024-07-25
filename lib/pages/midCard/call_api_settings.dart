import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;
import 'package:school_management/pages/midCard/each_staff_page.dart';

import '../../ip_address.dart';

class CallApiSettings extends StatefulWidget {
  const CallApiSettings({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<CallApiSettings> createState() => _CallApiSettingsState();
}

class _CallApiSettingsState extends State<CallApiSettings> {
  late Future _getApiSettings;
  bool presentsmsAPI = false;
  bool presentCallAPI = true;
  bool absentsmsAPI = false;
  bool absentCallAPI = false;
  TextEditingController presentCallAudio = TextEditingController();
  TextEditingController absentCallAudio = TextEditingController();

  @override
  void initState() {
    _getApiSettings = getApiSettings();
    super.initState();
  }

  getApiSettings() async {
    print(widget.schoolCode);
    var url = Uri.parse('$ipv4/getApiSettings/${widget.schoolCode}');
    var res = await http.get(url);
    var details = jsonDecode(res.body);
    // smsAPI = details['smsApi'];
    presentCallAPI = details['presentCallApi'];
    absentCallAPI = details['absentCallApi'];
    presentsmsAPI = details['presentsmsApi'];
    absentsmsAPI = details['absentsmsApi'];
    presentCallAudio.text = details['presentCallAudio'];
    absentCallAudio.text = details['absentCallAudio'];
    print(details);
    return details;
  }

  saveApisettings() async {
    var url = Uri.parse('$ipv4/saveApiSettings');
    var res = await http.post(url, body: {
      'schoolCode': widget.schoolCode,
      'presentCallApi': presentCallAPI.toString(),
      'absentCallApi': absentCallAPI.toString(),
      'presentsmsApi': presentsmsAPI.toString(),
      'absentsmsApi': absentsmsAPI.toString(),
      'presentCallAudio': presentCallAudio.text.trim(),
      'absentCallAudio': absentCallAudio.text.trim()
    });
    popBar(res.body);
  }

  popBar(res) {
    if (res == 'true') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
          content: const Row(
            children: [
              Text(
                'Saved Sucessfully',
              ),
              Icon(
                Icons.check_circle,
                color: Colors.white,
              )
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Settings'),
      ),
      body: FutureBuilder(
        future: _getApiSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Map details = snapshot.data;

            return Column(
              children: [
                SwitchListTile(
                  title: Text('Present SMS Api'),
                  value: presentsmsAPI,
                  onChanged: (value) {
                    setState(() {
                      presentsmsAPI = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Absent SMS Api'),
                  value: absentsmsAPI,
                  onChanged: (value) {
                    setState(() {
                      absentsmsAPI = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Present Call Api'),
                  value: presentCallAPI,
                  onChanged: (value) {
                    setState(() {
                      presentCallAPI = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Absent Call Api'),
                  value: absentCallAPI,
                  onChanged: (value) {
                    setState(() {
                      absentCallAPI = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MidTextField(
                      label: 'Present Audio Name',
                      controller: presentCallAudio,
                      isEdit: true),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MidTextField(
                      label: 'Absent Audio Name',
                      controller: absentCallAudio,
                      isEdit: true),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {
                      var res = saveApisettings();
                      if (res == 'true') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green[600],
                            behavior: SnackBarBehavior.floating,
                            content: const Row(
                              children: [
                                Text(
                                  'Saved Sucessfully',
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                    child: Text('Save Settings'))
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
