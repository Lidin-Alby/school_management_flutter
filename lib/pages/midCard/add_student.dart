import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:html' as html;

import 'package:http/http.dart' as http;

import '../../ip_address.dart';
import '../../widgets/dropdown_widget.dart';
import '../../widgets/textfield_widget.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController admNo = TextEditingController();
  TextEditingController fatherMobNo = TextEditingController();
  String? selectedClass;
  late Future _getClasses;

  getClass() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getMidClasses/${widget.schoolCode}');
    var res = await client.get(url);
    Map data = jsonDecode(res.body);
    return data;
  }

  addNewStudent() async {
    if (_formKey.currentState!.validate()) {
      if (selectedClass == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Text(
                  'Select Class',
                ),
                Icon(
                  Icons.error,
                  color: Colors.white,
                )
              ],
            ),
          ),
        );
      }

      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/addStudentMid');
      var res = await client.post(url, body: {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'admNo': admNo.text.trim(),
        'fatherMobNo': fatherMobNo.text.trim(),
        'schoolCode': widget.schoolCode,
        'classTitle': selectedClass,
        'subCaste': '',
        'email': '',
        'rfid': '',
        'session': '',
        'schoolHosuse': '',
        'address': '',
        'vehicleNo': '',
        'fatherName': '',
        'fatherWhatsapp': '',
        'motherName': '',
        'motherMobNo': '',
        'motherWhatsapp': '',
        'religion': '',
        'caste': '',
        'boardingType': '',
        'gender': '',
        'dob': '',
        'bloodGroup': '',
        'transportMode': '',
        'ready': false.toString(),
        'check': false.toString(),
        'profilePic': ''
      });
      if (res.body == 'true') {
        firstName.clear();
        lastName.clear();
        admNo.clear();
        fatherMobNo.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              content: const Row(
                children: [
                  Text(
                    'Added Sucessfully',
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
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  Text(
                    res.body,
                  ),
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        }
      }
    }
  }

  @override
  void initState() {
    _getClasses = getClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                future: _getClasses,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List classes = [];
                    String? lastNo;
                    classes = snapshot.data['classes']
                        .map((e) => e['title'])
                        .toList();
                    lastNo = snapshot.data['lastNo'];
                    return Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                'Last No.: $lastNo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFieldWidget(
                                isValidted: true,
                                label: 'Full Name',
                                controller: firstName,
                                isEdit: true),
                            SizedBox(
                              height: 15,
                            ),
                            // TextFieldWidget(
                            //     label: 'Last Name',
                            //     controller: lastName,
                            //     isEdit: true),

                            TextFieldWidget(
                                isValidted: true,
                                label: 'Admission No./ Sr. No.',
                                controller: admNo,
                                isEdit: true),
                            SizedBox(
                              height: 15,
                            ),
                            TextFieldWidget(
                                isValidted: true,
                                label: 'Mobile',
                                controller: fatherMobNo,
                                isEdit: true),
                            SizedBox(
                              height: 15,
                            ),
                            DropDownWidget(
                                items: classes,
                                title: 'Select Class',
                                isEdit: true,
                                callBack: (p0) {
                                  setState(() {
                                    selectedClass = p0;
                                  });
                                },
                                selected: selectedClass),
                            SizedBox(
                              height: 15,
                            ),
                            FilledButton(
                                onPressed: addNewStudent,
                                child: Text('Add Student'))
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () async {
                    var data = [
                      [
                        '"schoolCode"',
                        '"admNo"',
                        '"firstName"',
                        '"lastName"',
                        '"dob"',
                        '"className"',
                        '"ready"',
                        '"check"',
                        '"sec"',
                        '"gender"',
                        '"profilePic"',
                        '"fatherName"',
                        '"motherName"',
                        '"fatherMobNo"',
                        '"password"',
                        '"email"',
                        '"fatherProfilePic"',
                        '"fatherWhatsApp"',
                        '"motherMobNo"',
                        '"motherProfilePic"',
                        '"motherWhatsApp"',
                        '"religion"',
                        '"caste"',
                        '"boardingType"',
                        '"schoolHouse"',
                        '"subCaste"',
                        '"address"',
                        '"transportMode"',
                        '"vehicleNo"',
                        '"session"',
                        '"rfid"',
                        "\n"
                      ],
                      [
                        '"your school code"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"dd-mm-yyyy"',
                        '"any"',
                        '"0 This is a required field"',
                        '"0 This is a required field"',
                        '"any"',
                        '"Male/Female"',
                        '"pic name with extension"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"pic name with extension"',
                        '"any"',
                        '"any"',
                        '"pic name with extension"',
                        '"any"',
                        '"Christian/Hindu"',
                        '"General/OBC"',
                        '"Day Scholar/Hostel"',
                        '"any"',
                        '"any"',
                        '"any"',
                        '"Pedistrian/Parent"',
                        '"any"',
                        '"any"',
                        '"any"',
                      ]
                    ];
                    var blob = html.Blob(data, 'text/plain', 'native');

                    html.AnchorElement(
                      href: html.Url.createObjectUrlFromBlob(blob).toString(),
                    )
                      ..setAttribute("download", "Sample.csv")
                      ..click();
                  },
                  child: Text('Sample CSV')),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    Uint8List? fileByte = result!.files.first.bytes;

                    var url = Uri.parse('$ipv4/uploadCSVStudentUsersMid');

                    var req = http.MultipartRequest(
                      'POST',
                      url,
                    );
                    var httpDoc = http.MultipartFile.fromBytes(
                        'csvFile', fileByte!,
                        filename: 'upl_doc.csv');
                    req.files.add(httpDoc);
                    req.fields.addAll({'schoolCode': widget.schoolCode});
                    var res = await req.send();
                    var responded = await http.Response.fromStream(res);
                    if (responded.body == 'true') {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
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
                          ),
                        );
                      }
                      // setState(() {
                      //   _myMidSchools = getMyMidSchools();
                      // });
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red[700],
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              responded.body.toString(),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Upload CSV'))
            ],
          ),
        ),
      ),
    );
  }
}
