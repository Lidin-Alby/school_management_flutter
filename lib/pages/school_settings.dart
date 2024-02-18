// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';
import 'attendance_settings.dart';
import 'logo_settings.dart';

class SchoolSettings extends StatefulWidget {
  const SchoolSettings({super.key, this.index = 0});
  final int index;

  @override
  State<SchoolSettings> createState() => _SchoolSettingsState();
}

class _SchoolSettingsState extends State<SchoolSettings> {
  int _selectedIndex = 0;
  late String schoolCode;
  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.indigo[900],
        title: Text('School Settings'),
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider(),
                  SettingsTile(
                    title: 'General Settings',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    selected: _selectedIndex == 0,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Logo',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    selected: _selectedIndex == 1,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Login Page Background',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    selected: _selectedIndex == 2,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Backend Theme',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    },
                    selected: _selectedIndex == 3,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Mobile App',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                      });
                    },
                    selected: _selectedIndex == 4,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Student / Gaurdian Panel',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 5;
                      });
                    },
                    selected: _selectedIndex == 5,
                  ),

                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Fees',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 6;
                      });
                    },
                    selected: _selectedIndex == 6,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'ID Auto Generation',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 7;
                      });
                    },
                    selected: _selectedIndex == 7,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Attendance Type',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 8;
                      });
                    },
                    selected: _selectedIndex == 8,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Form Settings',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 9;
                      });
                    },
                    selected: _selectedIndex == 9,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Form Settings (Online)',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 10;
                      });
                    },
                    selected: _selectedIndex == 10,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Maintainance',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 11;
                      });
                    },
                    selected: _selectedIndex == 11,
                  ),
                  SizedBox(width: 200, child: Divider(height: 1)),
                  SettingsTile(
                    title: 'Miscellaneous',
                    onTap: () {
                      setState(() {
                        _selectedIndex = 12;
                      });
                    },
                    selected: _selectedIndex == 12,
                  )

                  // Divider(),
                ],
              ),
            ),
            if (_selectedIndex == 0)
              GeneralSettings(
                setCode: (p0) {
                  schoolCode = p0;
                  print(p0);
                },
              ),
            if (_selectedIndex == 1) LogoSettings(schoolCode: schoolCode),
            if (_selectedIndex == 3) ThemeSettings(),
            if (_selectedIndex == 5) StudentPanelSettings(),
            if (_selectedIndex == 6) FeesSettings(),
            if (_selectedIndex == 7) IDGenerationSettings(),
            if (_selectedIndex == 8) AttendanceSettings(),
            if (_selectedIndex == 9) FormSettings(),
            if (_selectedIndex == 10) FormSettingsOnline()
          ],
        ),
      ),
    );
  }
}

class FormSettingsOnline extends StatefulWidget {
  const FormSettingsOnline({
    super.key,
  });

  @override
  State<FormSettingsOnline> createState() => _FormSettingsOnlineState();
}

class _FormSettingsOnlineState extends State<FormSettingsOnline> {
  //  bool admDate = false;
  bool gender = false;
  bool dob = false;
  bool bloodgroup = false;
  // bool sibling = false;
  bool religion = false;
  bool caste = false;
  bool subCaste = false;
  bool email = false;
  bool rfid = false;
  // bool session = false;
  bool boardingType = false;
  bool fatherPic = false;
  bool motherPic = false;
  bool studentPic = false;
  bool gaurdianPic = false;

  bool fatherName = false;
  bool fatherOccupation = false;
  bool fatherMobNo = false;
  bool fatherWhatsapp = false;
  bool fatherAadhaar = false;
  bool motherName = false;
  bool motherOccupation = false;
  bool motherMobNo = false;
  bool motherWhatsapp = false;
  bool motherAadhaar = false;
  bool gaurdianName = false;
  bool gaurdianOccupation = false;
  bool gaurdianMobNo = false;
  bool gaurdianWhatsApp = false;
  bool gaurdianAadhaar = false;
  bool gaurdianRelation = false;
  bool curAddressLine1 = false;
  bool curAddressLine2 = false;
  bool curAddressLine3 = false;
  bool curPincode = false;
  bool perAddressLine1 = false;
  bool perAddressLine2 = false;
  bool perAddressLine3 = false;
  bool perPincode = false;
  bool studentWeight = false;
  bool studentHeight = false;
  bool studentEyeSight = false;
  bool medicalIssue = false;
  bool operated = false;
  bool allergies = false;
  bool govIdNo = false;
  bool tcNo = false;
  bool bloodReport = false;
  bool vaccine = false;
  bool birthCertificate = false;
  bool polio = false;
  bool dpt = false;
  bool dt = false;
  bool measles = false;
  bool mmr = false;
  bool tetanus = false;
  bool typhoid = false;
  bool hepatitisA = false;
  bool hepatitisB = false;
  bool chickenPox = false;
  TextEditingController instructions = TextEditingController();
  late Future _getFormAcces;

  getFormAccessStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessOnline');
    var res = await client.get(url);

    print('done');
    print(res.body);
    Map data = jsonDecode(res.body);
    if (data.containsKey('studentFormOnline')) {
      data = data['studentFormOnline'];
      instructions.text = data['instructions'] ?? '';
      data.remove('instructions');
      data = {...data.map((key, value) => MapEntry(key, bool.parse(value)))};
      initialize(data);
    }
    return data;
    // schoolCode = cl.last['schoolCode'];
  }

  initialize(Map data) {
    // admDate = data['admDate'];
    gender = data['gender'];
    dob = data['dob'];
    bloodgroup = data['bloodgroup'];
    // sibling = data['sibling'];
    religion = data['religion'];
    caste = data['caste'];
    subCaste = data['subCaste'];

    email = data['email'];
    rfid = data['rfid'];
    // session = data['session'];
    boardingType = data['boardingType'];
    // schoolHosuse = data['schoolHosuse'];

    // schoolTransportRoute = data['schoolTransportRoute'];
    // pickAndDrop = data['pickAndDrop'];

    // vehicleNo = data['vehicleNo'];

    fatherName = data['fatherName'];
    fatherOccupation = data['fatherOccupation'];

    fatherMobNo = data['fatherMobNo'];
    studentPic = data['studentPic'];
    fatherPic = data['fatherPic'];
    motherPic = data['motherPic'];
    gaurdianPic = data['gaurdianPic'];

    fatherWhatsapp = data['fatherWhatsapp'];
    fatherAadhaar = data['fatherAadhaar'];

    motherName = data['motherName'];
    motherOccupation = data['motherOccupation'];
    motherMobNo = data['motherMobNo'];

    motherWhatsapp = data['motherWhatsapp'];
    motherAadhaar = data['motherAadhaar'];
    gaurdianName = data['gaurdianName'];

    gaurdianOccupation = data['gaurdianOccupation'];
    gaurdianMobNo = data['gaurdianMobNo'];
    gaurdianWhatsApp = data['gaurdianWhatsApp'];
    gaurdianAadhaar = data['gaurdianAadhaar'];
    gaurdianRelation = data['gaurdianRelation'];
    curAddressLine1 = data['curAddressLine1'];
    curAddressLine2 = data['curAddressLine2'];
    curAddressLine3 = data['curAddressLine3'];
    curPincode = data['curPincode'];
    perAddressLine1 = data['perAddressLine1'];
    perAddressLine2 = data['perAddressLine2'];

    perAddressLine3 = data['perAddressLine3'];
    perPincode = data['perPincode'];
    studentWeight = data['studentWeight'];
    studentHeight = data['studentHeight'];
    studentEyeSight = data['studentEyeSight'];
    medicalIssue = data['medicalIssue'];
    operated = data['operated'];
    allergies = data['allergies'];
    govIdNo = data['govIdNo'];
    tcNo = data['tcNo'];
    bloodReport = data['bloodReport'];
    vaccine = data['vaccine'];
    birthCertificate = data['birthCertificate'];
    polio = data['polio'];
    dpt = data['dpt'];
    dt = data['dt'];
    measles = data['measles'];
    mmr = data['mmr'];
    tetanus = data['tetanus'];
    typhoid = data['typhoid'];
    hepatitisA = data['hepatitisA'];
    hepatitisB = data['hepatitisB'];
    chickenPox = data['chickenPox'];
  }

  addFormAccessStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addFormAccessOnline');
    var res = await client.post(url, body: {
      // 'admDate': admDate.toString(),
      'gender': gender.toString(),
      'dob': dob.toString(),
      'bloodgroup': bloodgroup.toString(),
      // 'sibling': sibling.toString(),
      'religion': religion.toString(),
      'caste': caste.toString(),
      'subCaste': subCaste.toString(),
      'email': email.toString(),
      'rfid': rfid.toString(),
      // 'session': session.toString(),
      'boardingType': boardingType.toString(),
      // 'schoolHosuse': schoolHosuse.toString(),
      // 'schoolTransportRoute': schoolTransportRoute.toString(),
      // 'pickAndDrop': pickAndDrop.toString(),
      // 'vehicleNo': vehicleNo.toString(),
      'studentPic': studentPic.toString(),
      'fatherPic': fatherPic.toString(),
      'motherPic': motherPic.toString(),
      'gaurdianPic': gaurdianPic.toString(),
      'fatherName': fatherName.toString(),
      'fatherOccupation': fatherOccupation.toString(),
      'fatherMobNo': fatherMobNo.toString(),
      'fatherWhatsapp': fatherWhatsapp.toString(),
      'fatherAadhaar': fatherAadhaar.toString(),
      'motherName': motherName.toString(),
      'motherOccupation': motherOccupation.toString(),
      'motherMobNo': motherMobNo.toString(),
      'motherWhatsapp': motherWhatsapp.toString(),
      'motherAadhaar': motherAadhaar.toString(),
      'gaurdianName': gaurdianName.toString(),
      'gaurdianOccupation': gaurdianOccupation.toString(),
      'gaurdianMobNo': gaurdianMobNo.toString(),
      'gaurdianWhatsApp': gaurdianWhatsApp.toString(),
      'gaurdianAadhaar': gaurdianAadhaar.toString(),
      'gaurdianRelation': gaurdianRelation.toString(),
      'curAddressLine1': curAddressLine1.toString(),
      'curAddressLine2': curAddressLine2.toString(),
      'curAddressLine3': curAddressLine3.toString(),
      'curPincode': curPincode.toString(),
      'perAddressLine1': perAddressLine1.toString(),
      'perAddressLine2': perAddressLine2.toString(),
      'perAddressLine3': perAddressLine3.toString(),
      'perPincode': perPincode.toString(),
      'studentWeight': studentWeight.toString(),
      'studentHeight': studentHeight.toString(),
      'studentEyeSight': studentEyeSight.toString(),
      'medicalIssue': medicalIssue.toString(),
      'operated': operated.toString(),
      'allergies': allergies.toString(),
      'govIdNo': govIdNo.toString(),
      'tcNo': tcNo.toString(),
      'bloodReport': bloodReport.toString(),
      'vaccine': vaccine.toString(),
      'birthCertificate': birthCertificate.toString(),
      'polio': polio.toString(),
      'dpt': dpt.toString(),
      'dt': dt.toString(),
      'measles': measles.toString(),
      'mmr': mmr.toString(),
      'tetanus': tetanus.toString(),
      'typhoid': typhoid.toString(),
      'hepatitisA': hepatitisA.toString(),
      'hepatitisB': hepatitisB.toString(),
      'chickenPox': chickenPox.toString(),
      'instructions': instructions.text.trim(),
    });
  }

  @override
  void initState() {
    _getFormAcces = getFormAccessStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: FutureBuilder(
      future: _getFormAcces,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Map data = snapshot.data;

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: addFormAccessStudent,
                      child: Text('Save'),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Date of Birth'),
                  value: dob,
                  onChanged: (value) {
                    setState(() {
                      dob = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gender'),
                  value: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Religion'),
                  value: religion,
                  onChanged: (value) {
                    setState(() {
                      religion = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Caste'),
                  value: caste,
                  onChanged: (value) {
                    setState(() {
                      caste = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Sub-Caste'),
                  value: subCaste,
                  onChanged: (value) {
                    setState(() {
                      subCaste = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Student Picture'),
                  value: studentPic,
                  onChanged: (value) {
                    setState(() {
                      studentPic = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Father Picture'),
                  value: fatherPic,
                  onChanged: (value) {
                    setState(() {
                      fatherPic = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Mother Picture'),
                  value: motherPic,
                  onChanged: (value) {
                    setState(() {
                      motherPic = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gaurdian Picture'),
                  value: gaurdianPic,
                  onChanged: (value) {
                    setState(() {
                      gaurdianPic = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Blood group'),
                  value: bloodgroup,
                  onChanged: (value) {
                    setState(() {
                      bloodgroup = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Father Name'),
                  value: fatherName,
                  onChanged: (value) {
                    setState(() {
                      fatherName = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Father Occupation'),
                  value: fatherOccupation,
                  onChanged: (value) {
                    setState(() {
                      fatherOccupation = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Father Mobile No.'),
                  value: fatherMobNo,
                  onChanged: (value) {
                    setState(() {
                      fatherMobNo = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Father Whatsapp No.'),
                  value: fatherWhatsapp,
                  onChanged: (value) {
                    setState(() {
                      fatherWhatsapp = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Father Aadhaar'),
                  value: fatherAadhaar,
                  onChanged: (value) {
                    setState(() {
                      fatherAadhaar = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Mother\'s Name'),
                  value: motherName,
                  onChanged: (value) {
                    setState(() {
                      motherName = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Mother Occupation'),
                  value: motherOccupation,
                  onChanged: (value) {
                    setState(() {
                      motherOccupation = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Mother Mobile No.'),
                  value: motherMobNo,
                  onChanged: (value) {
                    setState(() {
                      motherMobNo = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Mother Whatsapp No.'),
                  value: motherWhatsapp,
                  onChanged: (value) {
                    setState(() {
                      motherWhatsapp = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Mother Aadhaar'),
                  value: motherAadhaar,
                  onChanged: (value) {
                    setState(() {
                      motherAadhaar = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gaurdian Name'),
                  value: gaurdianName,
                  onChanged: (value) {
                    setState(() {
                      gaurdianName = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gaurdian Mobile No.'),
                  value: gaurdianMobNo,
                  onChanged: (value) {
                    setState(() {
                      gaurdianMobNo = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gaurdian Whatsapp'),
                  value: gaurdianWhatsApp,
                  onChanged: (value) {
                    setState(() {
                      gaurdianWhatsApp = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gaurdian Occupation'),
                  value: gaurdianOccupation,
                  onChanged: (value) {
                    setState(() {
                      gaurdianOccupation = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gaurdian Aadhar'),
                  value: gaurdianAadhaar,
                  onChanged: (value) {
                    setState(() {
                      gaurdianAadhaar = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Gaurdian Relation'),
                  value: gaurdianRelation,
                  onChanged: (value) {
                    setState(() {
                      gaurdianRelation = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Current Address Line 1'),
                  value: curAddressLine1,
                  onChanged: (value) {
                    setState(() {
                      curAddressLine1 = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Current Address Line 2'),
                  value: curAddressLine2,
                  onChanged: (value) {
                    setState(() {
                      curAddressLine2 = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Current Address Line 3'),
                  value: curAddressLine3,
                  onChanged: (value) {
                    setState(() {
                      curAddressLine3 = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Current Pincode'),
                  value: curPincode,
                  onChanged: (value) {
                    setState(() {
                      curPincode = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Permanent Address Line 1'),
                  value: perAddressLine1,
                  onChanged: (value) {
                    setState(() {
                      perAddressLine1 = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Permanent Address Line 2'),
                  value: perAddressLine2,
                  onChanged: (value) {
                    setState(() {
                      perAddressLine2 = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Permanant Address Line 3'),
                  value: perAddressLine3,
                  onChanged: (value) {
                    setState(() {
                      perAddressLine3 = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Permanent Pincode'),
                  value: perPincode,
                  onChanged: (value) {
                    setState(() {
                      perPincode = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Email'),
                  value: email,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('RFID'),
                  value: rfid,
                  onChanged: (value) {
                    setState(() {
                      rfid = value;
                    });
                  },
                ),
                SwitchListTile(
                  dense: true,
                  title: Text('Boarding Type'),
                  value: boardingType,
                  onChanged: (value) {
                    setState(() {
                      boardingType = value;
                    });
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Instructions/Rules/Declaration etc. :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: instructions,
                    decoration: InputDecoration(
                      hintText: 'Write here...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 10,
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}

class FormSettings extends StatefulWidget {
  const FormSettings({
    super.key,
  });

  @override
  State<FormSettings> createState() => _FormSettingsState();
}

class _FormSettingsState extends State<FormSettings> {
  int _selected = 0;
  bool joiningDate = false;
  bool reportsTo = false;
  bool department = false;
  bool designation = false;
  bool rfid = false;
  bool gender = false;
  bool dob = false;
  bool bloodgroup = false;
  bool wardInSchool = false;
  bool email = false;
  bool fatherorHusName = false;
  bool qualification = false;
  bool experience = false;
  bool religion = false;
  bool caste = false;
  bool subCaste = false;
  bool aadhaar = false;
  bool pan = false;
  bool uan = false;
  bool bankName = false;
  bool accountNo = false;
  bool ifscCode = false;
  bool nameOnRecord = false;
  bool dlNo = false;
  bool dlValidity = false;
  bool basicSalary = false;
  bool salaryType = false;
  bool contractType = false;
  bool curAddressLine1 = false;
  bool curAddressLine2 = false;
  bool curAddressLine3 = false;
  bool curPincode = false;
  bool perAddressLine1 = false;
  bool perAddressLine2 = false;
  bool perAddressLine3 = false;
  bool perPincode = false;
  bool aadhaarNo = false;
  bool panNo = false;
  bool bloodReport = false;
  bool joiningLetter = false;
  bool drivingLicence = false;
  bool schoolTransportRoute = false;
  bool pickAndDrop = false;
  bool vehicleNo = false;

  late Future _getFormStaff;

  getFormAccessStaff() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessStaff');
    var res = await client.get(url);

    print('done');
    print(res.body);
    Map data = jsonDecode(res.body);
    if (data.containsKey('staffForm')) {
      data = data['staffForm'];
      data = {...data.map((key, value) => MapEntry(key, bool.parse(value)))};
      initialize(data);
    }
    return data;
    // schoolCode = cl.last['schoolCode'];
  }

  initialize(Map data) {
    joiningDate = data['joiningDate'];
    reportsTo = data['reportsTo'];
    department = data['department'];
    designation = data['designation'];
    rfid = data['rfid'];
    gender = data['gender'];
    dob = data['dob'];
    bloodgroup = data['bloodgroup'];
    wardInSchool = data['wardInSchool'];
    email = data['email'];
    fatherorHusName = data['fatherorHusName'];
    qualification = data['qualification'];
    experience = data['experience'];
    religion = data['religion'];
    caste = data['caste'];
    subCaste = data['subCaste'];
    aadhaarNo = data['aadhaarNo'];
    panNo = data['panNo'];
    uan = data['uan'];
    bankName = data['bankName'];
    accountNo = data['accountNo'];
    ifscCode = data['ifscCode'];
    nameOnRecord = data['nameOnRecord'];
    dlNo = data['dlNo'];
    dlValidity = data['dlValidity'];
    basicSalary = data['basicSalary'];
    salaryType = data['salaryType'];
    contractType = data['contractType'];
    curAddressLine1 = data['curAddressLine1'];
    curAddressLine2 = data['curAddressLine2'];
    curAddressLine3 = data['curAddressLine3'];
    curPincode = data['curPincode'];
    perAddressLine1 = data['perAddressLine1'];
    perAddressLine2 = data['perAddressLine2'];
    perAddressLine3 = data['perAddressLine3'];
    perPincode = data['perPincode'];
    aadhaar = data['aadhaar'];
    pan = data['pan'];
    bloodReport = data['bloodReport'];
    joiningLetter = data['joiningLetter'];
    drivingLicence = data['drivingLicence'];
    schoolTransportRoute = data['schoolTransportRoute'];
    pickAndDrop = data['pickAndDrop'];
    vehicleNo = data['vehicleNo'];
  }

  addFormAccessStaff() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addFormAccessStaff');
    var res = await client.post(url, body: {
      'joiningDate': joiningDate.toString(),
      'reportsTo': reportsTo.toString(),
      'department': department.toString(),
      'designation': designation.toString(),
      'rfid': rfid.toString(),
      'gender': gender.toString(),
      'dob': dob.toString(),
      'bloodgroup': bloodgroup.toString(),
      'wardInSchool': wardInSchool.toString(),
      'email': email.toString(),
      'fatherorHusName': fatherorHusName.toString(),
      'qualification': qualification.toString(),
      'experience': experience.toString(),
      'religion': religion.toString(),
      'caste': caste.toString(),
      'subCaste': subCaste.toString(),
      'aadhaarNo': aadhaarNo.toString(),
      'panNo': panNo.toString(),
      'uanNo': uan.toString(),
      'bankName': bankName.toString(),
      'accountNo': accountNo.toString(),
      'ifscCode': ifscCode.toString(),
      'nameOnRecord': nameOnRecord.toString(),
      'dlNo': dlNo.toString(),
      'dlValidity': dlValidity.toString(),
      'basicSalary': basicSalary.toString(),
      'salaryType': salaryType.toString(),
      'contractType': contractType.toString(),
      'schoolTransportRoute': schoolTransportRoute.toString(),
      'pickAndDrop': pickAndDrop.toString(),
      'vehicleNo': vehicleNo.toString(),
      'curAddressLine1': curAddressLine1.toString(),
      'curAddressLine2': curAddressLine2.toString(),
      'curAddressLine3': curAddressLine3.toString(),
      'curPincode': curPincode.toString(),
      'perAddressLine1': perAddressLine1.toString(),
      'perAddressLine2': perAddressLine2.toString(),
      'perAddressLine3': perAddressLine3.toString(),
      'perPincode': perPincode.toString(),
      'aadhaar': aadhaar.toString(),
      'pan': pan.toString(),
      'bloodReport': bloodReport.toString(),
      'joiningLetter': joiningLetter.toString(),
      'drivingLicence': drivingLicence.toString(),
    });
  }

  @override
  void initState() {
    _getFormStaff = getFormAccessStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selected = 0;
                    });
                  },
                  child: Text('Student'),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: _selected == 0 ? Colors.indigo : null,
                      foregroundColor: _selected == 0 ? Colors.white : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  width: 5,
                ),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selected = 1;
                    });
                  },
                  child: Text('Staff'),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: _selected == 1 ? Colors.indigo : null,
                      foregroundColor: _selected == 1 ? Colors.white : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            if (_selected == 0) FormSettingsCardStudent(),
            if (_selected == 1)
              FutureBuilder(
                future: _getFormStaff,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: addFormAccessStaff,
                                  child: Text('Save'),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Joining Date'),
                              value: joiningDate,
                              onChanged: (value) {
                                setState(() {
                                  joiningDate = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Reports To'),
                              value: reportsTo,
                              onChanged: (value) {
                                setState(() {
                                  reportsTo = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Department'),
                              value: department,
                              onChanged: (value) {
                                setState(() {
                                  department = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Designation'),
                              value: designation,
                              onChanged: (value) {
                                setState(() {
                                  designation = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Date of Birth'),
                              value: dob,
                              onChanged: (value) {
                                setState(() {
                                  dob = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Blood group'),
                              value: bloodgroup,
                              onChanged: (value) {
                                setState(() {
                                  bloodgroup = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Ward In School'),
                              value: wardInSchool,
                              onChanged: (value) {
                                setState(() {
                                  wardInSchool = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Religion'),
                              value: religion,
                              onChanged: (value) {
                                setState(() {
                                  religion = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Caste'),
                              value: caste,
                              onChanged: (value) {
                                setState(() {
                                  caste = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Sub-Caste'),
                              value: subCaste,
                              onChanged: (value) {
                                setState(() {
                                  subCaste = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Email'),
                              value: email,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Father or Husband Name'),
                              value: fatherorHusName,
                              onChanged: (value) {
                                setState(() {
                                  fatherorHusName = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Qualification'),
                              value: qualification,
                              onChanged: (value) {
                                setState(() {
                                  qualification = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Experience'),
                              value: experience,
                              onChanged: (value) {
                                setState(() {
                                  experience = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('RFID'),
                              value: rfid,
                              onChanged: (value) {
                                setState(() {
                                  rfid = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Current Address Line 1'),
                              value: curAddressLine1,
                              onChanged: (value) {
                                setState(() {
                                  curAddressLine1 = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Current Address Line 2'),
                              value: curAddressLine2,
                              onChanged: (value) {
                                setState(() {
                                  curAddressLine2 = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Current Address Line 3'),
                              value: curAddressLine3,
                              onChanged: (value) {
                                setState(() {
                                  curAddressLine3 = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Current Pincode'),
                              value: curPincode,
                              onChanged: (value) {
                                setState(() {
                                  curPincode = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Permanent Address Line 1'),
                              value: perAddressLine1,
                              onChanged: (value) {
                                setState(() {
                                  perAddressLine1 = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Permanent Address Line 2'),
                              value: perAddressLine2,
                              onChanged: (value) {
                                setState(() {
                                  perAddressLine2 = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Permanant Address Line 3'),
                              value: perAddressLine3,
                              onChanged: (value) {
                                setState(() {
                                  perAddressLine3 = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Permanent Pincode'),
                              value: perPincode,
                              onChanged: (value) {
                                setState(() {
                                  perPincode = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Aadhar No.'),
                              value: aadhaarNo,
                              onChanged: (value) {
                                setState(() {
                                  aadhaarNo = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Pan No.'),
                              value: panNo,
                              onChanged: (value) {
                                setState(() {
                                  panNo = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Uan Card'),
                              value: uan,
                              onChanged: (value) {
                                setState(() {
                                  uan = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Bank Name'),
                              value: bankName,
                              onChanged: (value) {
                                setState(() {
                                  bankName = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Account No.'),
                              value: accountNo,
                              onChanged: (value) {
                                setState(() {
                                  accountNo = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('IFSC Code'),
                              value: ifscCode,
                              onChanged: (value) {
                                setState(() {
                                  ifscCode = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Name on Record'),
                              value: nameOnRecord,
                              onChanged: (value) {
                                setState(() {
                                  nameOnRecord = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('DL No.'),
                              value: dlNo,
                              onChanged: (value) {
                                setState(() {
                                  dlNo = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('DL Validity'),
                              value: dlValidity,
                              onChanged: (value) {
                                setState(() {
                                  dlValidity = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Basic Salary'),
                              value: basicSalary,
                              onChanged: (value) {
                                setState(() {
                                  basicSalary = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Salary Type'),
                              value: salaryType,
                              onChanged: (value) {
                                setState(() {
                                  salaryType = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Contract Type'),
                              value: contractType,
                              onChanged: (value) {
                                setState(() {
                                  contractType = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Pan'),
                              value: pan,
                              onChanged: (value) {
                                setState(() {
                                  pan = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Aadhar'),
                              value: aadhaar,
                              onChanged: (value) {
                                setState(() {
                                  aadhaar = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Blood Report'),
                              value: bloodReport,
                              onChanged: (value) {
                                setState(() {
                                  bloodReport = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Joining Letter'),
                              value: joiningLetter,
                              onChanged: (value) {
                                setState(() {
                                  joiningLetter = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              dense: true,
                              title: Text('Driving Licence'),
                              value: drivingLicence,
                              onChanged: (value) {
                                setState(() {
                                  drivingLicence = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
          ],
        ),
      ),
    );
  }
}

class FormSettingsCardStudent extends StatefulWidget {
  const FormSettingsCardStudent({super.key});

  @override
  State<FormSettingsCardStudent> createState() =>
      _FormSettingsCardStudentState();
}

class _FormSettingsCardStudentState extends State<FormSettingsCardStudent> {
  bool admDate = false;
  bool gender = false;
  bool dob = false;
  bool bloodgroup = false;
  bool sibling = false;
  bool religion = false;
  bool caste = false;
  bool subCaste = false;
  bool email = false;
  bool rfid = false;
  bool session = false;
  bool boardingType = false;
  bool schoolHosuse = false;
  bool schoolTransportRoute = false;
  bool pickAndDrop = false;
  bool vehicleNo = false;
  bool fatherName = false;
  bool fatherOccupation = false;
  bool fatherMobNo = false;
  bool fatherWhatsapp = false;
  bool fatherAadhaar = false;
  bool fatherPic = false;
  bool motherPic = false;
  bool studentPic = false;
  bool gaurdianPic = false;
  bool motherName = false;
  bool motherOccupation = false;
  bool motherMobNo = false;
  bool motherWhatsapp = false;
  bool motherAadhaar = false;
  bool gaurdianName = false;
  bool gaurdianOccupation = false;
  bool gaurdianMobNo = false;
  bool gaurdianWhatsApp = false;
  bool gaurdianAadhaar = false;
  bool gaurdianRelation = false;
  bool curAddressLine1 = false;
  bool curAddressLine2 = false;
  bool curAddressLine3 = false;
  bool curPincode = false;
  bool perAddressLine1 = false;
  bool perAddressLine2 = false;
  bool perAddressLine3 = false;
  bool perPincode = false;
  bool studentWeight = false;
  bool studentHeight = false;
  bool studentEyeSight = false;
  bool medicalIssue = false;
  bool operated = false;
  bool allergies = false;
  bool govIdNo = false;
  bool tcNo = false;
  bool bloodReport = false;
  bool vaccine = false;
  bool birthCertificate = false;
  bool polio = false;
  bool dpt = false;
  bool dt = false;
  bool measles = false;
  bool mmr = false;
  bool tetanus = false;
  bool typhoid = false;
  bool hepatitisA = false;
  bool hepatitisB = false;
  bool chickenPox = false;
  late Future _getFormAcces;

  getFormAccessStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessStudent');
    var res = await client.get(url);

    print('done');
    print(res.body);
    Map data = jsonDecode(res.body);
    if (data.containsKey('studentForm')) {
      data = data['studentForm'];
      data = {...data.map((key, value) => MapEntry(key, bool.parse(value)))};
      initialize(data);
    }
    return data;
    // schoolCode = cl.last['schoolCode'];
  }

  initialize(Map data) {
    admDate = data['admDate'];
    gender = data['gender'];
    dob = data['dob'];
    bloodgroup = data['bloodgroup'];
    sibling = data['sibling'];
    religion = data['religion'];
    caste = data['caste'];
    subCaste = data['subCaste'];

    email = data['email'];
    rfid = data['rfid'];
    session = data['session'];
    boardingType = data['boardingType'];
    schoolHosuse = data['schoolHosuse'];

    schoolTransportRoute = data['schoolTransportRoute'];
    pickAndDrop = data['pickAndDrop'];

    vehicleNo = data['vehicleNo'];
    studentPic = data['studentPic'];
    fatherPic = data['fatherPic'];
    motherPic = data['motherPic'];
    gaurdianPic = data['gaurdianPic'];

    fatherName = data['fatherName'];
    fatherOccupation = data['fatherOccupation'];

    fatherMobNo = data['fatherMobNo'];

    fatherWhatsapp = data['fatherWhatsapp'];
    fatherAadhaar = data['fatherAadhaar'];

    motherName = data['motherName'];
    motherOccupation = data['motherOccupation'];
    motherMobNo = data['motherMobNo'];

    motherWhatsapp = data['motherWhatsapp'];
    motherAadhaar = data['motherAadhaar'];
    gaurdianName = data['gaurdianName'];

    gaurdianOccupation = data['gaurdianOccupation'];
    gaurdianMobNo = data['gaurdianMobNo'];
    gaurdianWhatsApp = data['gaurdianWhatsApp'];
    gaurdianAadhaar = data['gaurdianAadhaar'];
    gaurdianRelation = data['gaurdianRelation'];
    curAddressLine1 = data['curAddressLine1'];
    curAddressLine2 = data['curAddressLine2'];
    curAddressLine3 = data['curAddressLine3'];
    curPincode = data['curPincode'];
    perAddressLine1 = data['perAddressLine1'];
    perAddressLine2 = data['perAddressLine2'];

    perAddressLine3 = data['perAddressLine3'];
    perPincode = data['perPincode'];
    studentWeight = data['studentWeight'];
    studentHeight = data['studentHeight'];
    studentEyeSight = data['studentEyeSight'];
    medicalIssue = data['medicalIssue'];
    operated = data['operated'];
    allergies = data['allergies'];
    govIdNo = data['govIdNo'];
    tcNo = data['tcNo'];
    bloodReport = data['bloodReport'];
    vaccine = data['vaccine'];
    birthCertificate = data['birthCertificate'];
    polio = data['polio'];
    dpt = data['dpt'];
    dt = data['dt'];
    measles = data['measles'];
    mmr = data['mmr'];
    tetanus = data['tetanus'];
    typhoid = data['typhoid'];
    hepatitisA = data['hepatitisA'];
    hepatitisB = data['hepatitisB'];
    chickenPox = data['chickenPox'];
  }

  addFormAccessStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addFormAccessStudent');
    var res = await client.post(url, body: {
      'admDate': admDate.toString(),
      'gender': gender.toString(),
      'dob': dob.toString(),
      'bloodgroup': bloodgroup.toString(),
      'sibling': sibling.toString(),
      'religion': religion.toString(),
      'caste': caste.toString(),
      'subCaste': subCaste.toString(),
      'email': email.toString(),
      'rfid': rfid.toString(),
      'session': session.toString(),
      'boardingType': boardingType.toString(),
      'schoolHosuse': schoolHosuse.toString(),
      'schoolTransportRoute': schoolTransportRoute.toString(),
      'pickAndDrop': pickAndDrop.toString(),
      'vehicleNo': vehicleNo.toString(),
      'fatherName': fatherName.toString(),
      'fatherOccupation': fatherOccupation.toString(),
      'fatherPic': fatherPic.toString(),
      'motherPic': motherPic.toString(),
      'studentPic': studentPic.toString(),
      'fatherMobNo': fatherMobNo.toString(),
      'fatherWhatsapp': fatherWhatsapp.toString(),
      'gaurdianPic': gaurdianPic.toString(),
      'fatherAadhaar': fatherAadhaar.toString(),
      'motherName': motherName.toString(),
      'motherOccupation': motherOccupation.toString(),
      'motherMobNo': motherMobNo.toString(),
      'motherWhatsapp': motherWhatsapp.toString(),
      'motherAadhaar': motherAadhaar.toString(),
      'gaurdianName': gaurdianName.toString(),
      'gaurdianOccupation': gaurdianOccupation.toString(),
      'gaurdianMobNo': gaurdianMobNo.toString(),
      'gaurdianWhatsApp': gaurdianWhatsApp.toString(),
      'gaurdianAadhaar': gaurdianAadhaar.toString(),
      'gaurdianRelation': gaurdianRelation.toString(),
      'curAddressLine1': curAddressLine1.toString(),
      'curAddressLine2': curAddressLine2.toString(),
      'curAddressLine3': curAddressLine3.toString(),
      'curPincode': curPincode.toString(),
      'perAddressLine1': perAddressLine1.toString(),
      'perAddressLine2': perAddressLine2.toString(),
      'perAddressLine3': perAddressLine3.toString(),
      'perPincode': perPincode.toString(),
      'studentWeight': studentWeight.toString(),
      'studentHeight': studentHeight.toString(),
      'studentEyeSight': studentEyeSight.toString(),
      'medicalIssue': medicalIssue.toString(),
      'operated': operated.toString(),
      'allergies': allergies.toString(),
      'govIdNo': govIdNo.toString(),
      'tcNo': tcNo.toString(),
      'bloodReport': bloodReport.toString(),
      'vaccine': vaccine.toString(),
      'birthCertificate': birthCertificate.toString(),
      'polio': polio.toString(),
      'dpt': dpt.toString(),
      'dt': dt.toString(),
      'measles': measles.toString(),
      'mmr': mmr.toString(),
      'tetanus': tetanus.toString(),
      'typhoid': typhoid.toString(),
      'hepatitisA': hepatitisA.toString(),
      'hepatitisB': hepatitisB.toString(),
      'chickenPox': chickenPox.toString(),
    });
  }

  @override
  void initState() {
    _getFormAcces = getFormAccessStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getFormAcces,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Card(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: addFormAccessStudent,
                        child: Text('Save'),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Admission Date'),
                    value: admDate,
                    onChanged: (value) {
                      setState(() {
                        admDate = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gender'),
                    value: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Date of Birth'),
                    value: dob,
                    onChanged: (value) {
                      setState(() {
                        dob = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Blood group'),
                    value: bloodgroup,
                    onChanged: (value) {
                      setState(() {
                        bloodgroup = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Sibiling'),
                    value: sibling,
                    onChanged: (value) {
                      setState(() {
                        sibling = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Religion'),
                    value: religion,
                    onChanged: (value) {
                      setState(() {
                        religion = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Student Picture'),
                    value: studentPic,
                    onChanged: (value) {
                      setState(() {
                        studentPic = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Father Picture'),
                    value: fatherPic,
                    onChanged: (value) {
                      setState(() {
                        fatherPic = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Mother Picture'),
                    value: motherPic,
                    onChanged: (value) {
                      setState(() {
                        motherPic = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gaurdian Picture'),
                    value: gaurdianPic,
                    onChanged: (value) {
                      setState(() {
                        gaurdianPic = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Caste'),
                    value: caste,
                    onChanged: (value) {
                      setState(() {
                        caste = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Sub-Caste'),
                    value: subCaste,
                    onChanged: (value) {
                      setState(() {
                        subCaste = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Email'),
                    value: email,
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('RFID'),
                    value: rfid,
                    onChanged: (value) {
                      setState(() {
                        rfid = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Session'),
                    value: session,
                    onChanged: (value) {
                      setState(() {
                        session = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Boarding Type'),
                    value: boardingType,
                    onChanged: (value) {
                      setState(() {
                        boardingType = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('School House'),
                    value: schoolHosuse,
                    onChanged: (value) {
                      setState(() {
                        schoolHosuse = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('School Transport Route'),
                    value: schoolTransportRoute,
                    onChanged: (value) {
                      setState(() {
                        schoolTransportRoute = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Pick And Drop'),
                    value: pickAndDrop,
                    onChanged: (value) {
                      setState(() {
                        pickAndDrop = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Vehicle No.'),
                    value: vehicleNo,
                    onChanged: (value) {
                      setState(() {
                        vehicleNo = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Father Name'),
                    value: fatherName,
                    onChanged: (value) {
                      setState(() {
                        fatherName = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Father Occupation'),
                    value: fatherOccupation,
                    onChanged: (value) {
                      setState(() {
                        fatherOccupation = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Father Mobile No.'),
                    value: fatherMobNo,
                    onChanged: (value) {
                      setState(() {
                        fatherMobNo = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Father Whatsapp No.'),
                    value: fatherWhatsapp,
                    onChanged: (value) {
                      setState(() {
                        fatherWhatsapp = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Father Aadhaar'),
                    value: fatherAadhaar,
                    onChanged: (value) {
                      setState(() {
                        fatherAadhaar = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Mother\'s Name'),
                    value: motherName,
                    onChanged: (value) {
                      setState(() {
                        motherName = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Mother Occupation'),
                    value: motherOccupation,
                    onChanged: (value) {
                      setState(() {
                        motherOccupation = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Mother Mobile No.'),
                    value: motherMobNo,
                    onChanged: (value) {
                      setState(() {
                        motherMobNo = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Mother Whatsapp No.'),
                    value: motherWhatsapp,
                    onChanged: (value) {
                      setState(() {
                        motherWhatsapp = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Mother Aadhaar'),
                    value: motherAadhaar,
                    onChanged: (value) {
                      setState(() {
                        motherAadhaar = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gaurdian Name'),
                    value: gaurdianName,
                    onChanged: (value) {
                      setState(() {
                        gaurdianName = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gaurdian Mobile No.'),
                    value: gaurdianMobNo,
                    onChanged: (value) {
                      setState(() {
                        gaurdianMobNo = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gaurdian Whatsapp'),
                    value: gaurdianWhatsApp,
                    onChanged: (value) {
                      setState(() {
                        gaurdianWhatsApp = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gaurdian Occupation'),
                    value: gaurdianOccupation,
                    onChanged: (value) {
                      setState(() {
                        gaurdianOccupation = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gaurdian Aadhar'),
                    value: gaurdianAadhaar,
                    onChanged: (value) {
                      setState(() {
                        gaurdianAadhaar = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Gaurdian Relation'),
                    value: gaurdianRelation,
                    onChanged: (value) {
                      setState(() {
                        gaurdianRelation = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Current Address Line 1'),
                    value: curAddressLine1,
                    onChanged: (value) {
                      setState(() {
                        curAddressLine1 = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Current Address Line 2'),
                    value: curAddressLine2,
                    onChanged: (value) {
                      setState(() {
                        curAddressLine2 = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Current Address Line 3'),
                    value: curAddressLine3,
                    onChanged: (value) {
                      setState(() {
                        curAddressLine3 = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Current Pincode'),
                    value: curPincode,
                    onChanged: (value) {
                      setState(() {
                        curPincode = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Permanent Address Line 1'),
                    value: perAddressLine1,
                    onChanged: (value) {
                      setState(() {
                        perAddressLine1 = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Permanent Address Line 2'),
                    value: perAddressLine2,
                    onChanged: (value) {
                      setState(() {
                        perAddressLine2 = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Permanant Address Line 3'),
                    value: perAddressLine3,
                    onChanged: (value) {
                      setState(() {
                        perAddressLine3 = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Permanent Pincode'),
                    value: perPincode,
                    onChanged: (value) {
                      setState(() {
                        perPincode = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Student Weight'),
                    value: studentWeight,
                    onChanged: (value) {
                      setState(() {
                        studentWeight = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Student Height'),
                    value: studentHeight,
                    onChanged: (value) {
                      setState(() {
                        studentHeight = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Student Eye Sight'),
                    value: studentEyeSight,
                    onChanged: (value) {
                      setState(() {
                        studentEyeSight = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Medical Issue'),
                    value: medicalIssue,
                    onChanged: (value) {
                      setState(() {
                        medicalIssue = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Operated'),
                    value: operated,
                    onChanged: (value) {
                      setState(() {
                        operated = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Allergies'),
                    value: allergies,
                    onChanged: (value) {
                      setState(() {
                        allergies = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Government Id'),
                    value: govIdNo,
                    onChanged: (value) {
                      setState(() {
                        govIdNo = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Transfer Certificate No.'),
                    value: tcNo,
                    onChanged: (value) {
                      setState(() {
                        tcNo = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Blood Report'),
                    value: bloodReport,
                    onChanged: (value) {
                      setState(() {
                        bloodReport = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Vaccine'),
                    value: vaccine,
                    onChanged: (value) {
                      setState(() {
                        vaccine = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Birth Certificate'),
                    value: birthCertificate,
                    onChanged: (value) {
                      setState(() {
                        birthCertificate = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Polio'),
                    value: polio,
                    onChanged: (value) {
                      setState(() {
                        polio = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('DPT'),
                    value: dpt,
                    onChanged: (value) {
                      setState(() {
                        dpt = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('DT'),
                    value: dt,
                    onChanged: (value) {
                      setState(() {
                        dt = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Measles'),
                    value: measles,
                    onChanged: (value) {
                      setState(() {
                        measles = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('MMR'),
                    value: mmr,
                    onChanged: (value) {
                      setState(() {
                        mmr = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Tetanus'),
                    value: tetanus,
                    onChanged: (value) {
                      setState(() {
                        tetanus = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Typhoid'),
                    value: typhoid,
                    onChanged: (value) {
                      setState(() {
                        typhoid = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Hepatitus A'),
                    value: hepatitisA,
                    onChanged: (value) {
                      setState(() {
                        hepatitisA = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Hepatitus B'),
                    value: hepatitisB,
                    onChanged: (value) {
                      setState(() {
                        hepatitisB = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    dense: true,
                    title: Text('Chicken Pox'),
                    value: chickenPox,
                    onChanged: (value) {
                      setState(() {
                        chickenPox = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class IDGenerationSettings extends StatefulWidget {
  const IDGenerationSettings({
    super.key,
  });

  @override
  State<IDGenerationSettings> createState() => _IDGenerationSettingsState();
}

class _IDGenerationSettingsState extends State<IDGenerationSettings> {
  String? autoAdmNo;
  String? autoStaffId;
  TextEditingController prefixAdmNo = TextEditingController();
  String? admNoDigit;
  TextEditingController startAdmNo = TextEditingController();
  TextEditingController prefixStaffId = TextEditingController();
  String? staffDigit;
  TextEditingController startStaffId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Auto ID Generation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Student',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Auto Admission No.')),
                  Radio(
                    groupValue: autoAdmNo,
                    value: 'disable',
                    onChanged: (value) {
                      setState(() {
                        autoAdmNo = value.toString();
                      });
                    },
                  ),
                  Text('Disabled'),
                  Radio(
                    groupValue: autoAdmNo,
                    value: 'enable',
                    onChanged: (value) {
                      setState(() {
                        autoAdmNo = value.toString();
                      });
                    },
                  ),
                  Text('Enabled'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Admission No. Prefix')),
                  SmallTextField(width: 400, controller: prefixAdmNo),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Admission No. Digit')),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    alignment: AlignmentDirectional.center,
                    width: 350,
                    height: 30,
                    // margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton(
                      padding: EdgeInsets.only(left: 4),
                      isDense: true,
                      hint: Text('Select Session'),
                      isExpanded: true,
                      underline: Text(''),
                      value: admNoDigit,
                      items: [],
                      onChanged: (value) {
                        setState(() {
                          admNoDigit = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Admission Start From')),
                  SmallTextField(width: 400, controller: startAdmNo)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Staff',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Auto Staff Id')),
                  Radio(
                    groupValue: autoStaffId,
                    value: 'disable',
                    onChanged: (value) {
                      setState(() {
                        autoStaffId = value.toString();
                      });
                    },
                  ),
                  Text('Disabled'),
                  Radio(
                    groupValue: autoStaffId,
                    value: 'enable',
                    onChanged: (value) {
                      setState(() {
                        autoStaffId = value.toString();
                      });
                    },
                  ),
                  Text('Enabled'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Staff Id Prefix')),
                  SmallTextField(width: 400, controller: prefixStaffId),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Staff No. Digit')),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    alignment: AlignmentDirectional.center,
                    width: 350,
                    height: 30,
                    // margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton(
                      padding: EdgeInsets.only(left: 4),
                      isDense: true,
                      hint: Text('Select Session'),
                      isExpanded: true,
                      underline: Text(''),
                      value: staffDigit,
                      items: [],
                      onChanged: (value) {
                        setState(() {
                          staffDigit = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 250, child: Text('Staff Id Start From')),
                  SmallTextField(width: 400, controller: startStaffId)
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentPanelSettings extends StatefulWidget {
  const StudentPanelSettings({
    super.key,
  });

  @override
  State<StudentPanelSettings> createState() => _StudentPanelSettingsState();
}

class _StudentPanelSettingsState extends State<StudentPanelSettings> {
  bool? studentLogin = false;
  bool? parentLogin = false;
  bool? useAdmNo = false;
  bool? useEmail = false;
  String? allowTimeline;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Student / Gaurdian Panel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(width: 350, child: Text('User Login option')),
                Checkbox(
                  value: studentLogin,
                  onChanged: (value) {
                    setState(() {
                      studentLogin = value;
                    });
                  },
                ),
                Text('Student Login'),
                Checkbox(
                  value: parentLogin,
                  onChanged: (value) {
                    setState(() {
                      parentLogin = value;
                    });
                  },
                ),
                Text('Parent Login'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                    width: 350,
                    child:
                        Text('Additional Username Option for Student Login')),
                Checkbox(
                  value: useAdmNo,
                  onChanged: (value) {
                    setState(() {
                      useAdmNo = value;
                    });
                  },
                ),
                Text('Admission No.'),
                Checkbox(
                  value: useEmail,
                  onChanged: (value) {
                    setState(() {
                      useEmail = value;
                    });
                  },
                ),
                Text('Email'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                    width: 350, child: Text('Allow student To Add Timeline')),
                Radio(
                  groupValue: allowTimeline,
                  value: 'disable',
                  onChanged: (value) {
                    setState(() {
                      allowTimeline = value.toString();
                    });
                  },
                ),
                Text('Disabled'),
                Radio(
                  groupValue: allowTimeline,
                  value: 'enable',
                  onChanged: (value) {
                    setState(() {
                      allowTimeline = value.toString();
                    });
                  },
                ),
                Text('Enabled'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }
}

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({
    super.key,
  });

  @override
  State<ThemeSettings> createState() => _ThemeSettingsState();
}

class _ThemeSettingsState extends State<ThemeSettings> {
  String theme = 'light';
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            Text(
              'Theme Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              height: 200,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'light',
                    groupValue: theme,
                    onChanged: (value) {
                      setState(() {
                        theme = value.toString();
                      });
                    },
                  ),
                  Text('Light'),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(5)),
              height: 200,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: 'dark',
                    groupValue: theme,
                    onChanged: (value) {
                      setState(() {
                        theme = value.toString();
                      });
                    },
                  ),
                  Text('Dark'),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

class FeesSettings extends StatefulWidget {
  const FeesSettings({super.key});

  @override
  State<FeesSettings> createState() => _FeesSettingsState();
}

class _FeesSettingsState extends State<FeesSettings> {
  String? offlinePanel;
  String? lockStudentpanel;
  bool? officeCopy = false;
  bool? studentCopy = false;
  bool? bankCopy = false;
  String? singlePageFees;
  String? collectOnOldDate;
  TextEditingController carryFees = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fees',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Row(
              children: [
                // SizedBox(
                //   width: 20,
                // ),
                SizedBox(
                    width: 350,
                    child: Text('Offline Bank Payment in Student Panel')),
                Radio(
                  value: 'disabled',
                  groupValue: offlinePanel,
                  onChanged: (value) {
                    setState(() {
                      offlinePanel = value.toString();
                    });
                  },
                ),
                Text('Disabled'),
                Radio(
                  value: 'enabled',
                  groupValue: offlinePanel,
                  onChanged: (value) {
                    setState(() {
                      offlinePanel = value.toString();
                    });
                  },
                ),
                Text('Enabled'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // SizedBox(
                //   width: 20,
                // ),
                SizedBox(
                    width: 350,
                    child: Text('Lock Student Panel if Fees Remaining')),
                Radio(
                  value: 'disabled',
                  groupValue: lockStudentpanel,
                  onChanged: (value) {
                    setState(() {
                      lockStudentpanel = value.toString();
                    });
                  },
                ),
                Text('Disabled'),
                Radio(
                  value: 'enabled',
                  groupValue: lockStudentpanel,
                  onChanged: (value) {
                    setState(() {
                      lockStudentpanel = value.toString();
                    });
                  },
                ),
                Text('Enabled'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(width: 350, child: Text('Print Fees Receipt For')),
                Checkbox(
                  value: officeCopy,
                  onChanged: (value) {
                    setState(() {
                      officeCopy = value;
                    });
                  },
                ),
                Text('Office Copy'),
                Checkbox(
                  value: studentCopy,
                  onChanged: (value) {
                    setState(() {
                      studentCopy = value;
                    });
                  },
                ),
                Text('Student Copy'),
                Checkbox(
                  value: bankCopy,
                  onChanged: (value) {
                    setState(() {
                      bankCopy = value;
                    });
                  },
                ),
                Text('Bank Copy'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                    width: 350, child: Text('Carry Forward Fees Due Days')),
                SmallTextField(
                  controller: carryFees,
                  // width: 400,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // SizedBox(
                //   width: 20,
                // ),
                SizedBox(width: 350, child: Text('Single Page Fees Print')),
                Radio(
                  value: 'disabled',
                  groupValue: singlePageFees,
                  onChanged: (value) {
                    setState(() {
                      singlePageFees = value.toString();
                    });
                  },
                ),
                Text('Disabled'),
                Radio(
                  value: 'enabled',
                  groupValue: singlePageFees,
                  onChanged: (value) {
                    setState(() {
                      singlePageFees = value.toString();
                    });
                  },
                ),
                Text('Enabled'),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // SizedBox(
                //   width: 20,
                // ),
                SizedBox(width: 350, child: Text('Collect Fees in Back Date')),
                Radio(
                  value: 'disabled',
                  groupValue: collectOnOldDate,
                  onChanged: (value) {
                    setState(() {
                      collectOnOldDate = value.toString();
                    });
                  },
                ),
                Text('Disabled'),
                Radio(
                  value: 'enabled',
                  groupValue: collectOnOldDate,
                  onChanged: (value) {
                    setState(() {
                      collectOnOldDate = value.toString();
                    });
                  },
                ),
                Text('Enabled'),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key, required this.setCode});
  final Function(String) setCode;

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  List sessions =
      List.generate(20, (index) => '${2020 + index}-${20 + index + 1}');
  List months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String? selectedSession;
  String? selectedMonth;
  TextEditingController schoolName = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController schoolAddress = TextEditingController();
  TextEditingController schoolPhone = TextEditingController();
  TextEditingController schoolMail = TextEditingController();

  getGeneralSettings() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getGeneralSettings');
    var res = await client.get(url);

    Map data = jsonDecode(res.body);
    print(data);
    selectedSession =
        data['selectedSession'] == '' ? null : data['selectedSession'];
    selectedMonth = data['selectedMonth'] == '' ? null : data['selectedMonth'];
    schoolName.text = data['schoolName'];
    code.text = data['schoolCode'].toString();
    schoolAddress.text = data['schoolAddress'];
    schoolPhone.text = data['schoolPhone'];
    schoolMail.text = data['schoolMail'];
    print(data['schoolCode']);
    widget.setCode(data['schoolCode'].toString());
    setState(() {});
  }

  saveGeneralSettings() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/saveGeneralSettings');
    var res = await client.post(url, body: {
      'selectedSession': selectedSession ?? '',
      'selectedMonth': selectedMonth ?? '',
      'schoolName': schoolName.text.trim(),
      'schoolAddress': schoolAddress.text.trim(),
      'schoolPhone': schoolPhone.text.trim(),
      'schoolMail': schoolMail.text.trim(),
    });
    print(res.body);
  }

  @override
  void initState() {
    getGeneralSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
          child: SizedBox(
        // width: med,
        // height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'General Settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      onPressed: saveGeneralSettings, child: Text('Save'))
                ],
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 20,
                children: [
                  SingleLineTextField(
                    label: 'School Name',
                    controller: schoolName,
                    width: 400,
                  ),
                  SingleLineTextField(
                    label: 'School Code',
                    controller: code,
                    width: 250,
                  ),
                  SingleLineTextField(
                      label: 'Address ', controller: schoolAddress),
                  SingleLineTextField(
                    label: 'Phone',
                    controller: schoolPhone,
                    width: 400,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      Flexible(
                        child: SizedBox(
                            width: 250,
                            height: 35,
                            child: TextField(
                              controller: schoolMail,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.only(top: 10, left: 10),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'Academic Session',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 20,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      'Session',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    alignment: AlignmentDirectional.center,
                    width: 350,
                    height: 30,
                    // margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton(
                      padding: EdgeInsets.only(left: 4),
                      isDense: true,
                      hint: Text('Select Session'),
                      isExpanded: true,
                      underline: Text(''),
                      value: selectedSession,
                      items: sessions
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSession = value.toString();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          'Session Start Month',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        alignment: AlignmentDirectional.center,
                        width: 250,
                        height: 30,
                        // margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton(
                          padding: EdgeInsets.only(left: 4),
                          isDense: true,
                          hint: Text('Select Session'),
                          isExpanded: true,
                          underline: Text(''),
                          value: selectedMonth,
                          items: months
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMonth = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      )),
    );
  }
}

class SingleLineTextField extends StatelessWidget {
  const SingleLineTextField(
      {super.key, required this.label, required this.controller, this.width});
  final String label;
  final TextEditingController controller;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        // SizedBox(
        //   width: 20,
        // ),
        Flexible(
          child: SizedBox(
              width: width,
              height: 35,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(top: 10, left: 10),
                ),
              )),
        ),
      ],
    );
  }
}

class SmallTextField extends StatelessWidget {
  const SmallTextField({super.key, required this.controller, this.width});
  final TextEditingController controller;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
          width: width,
          height: 35,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.only(top: 10, left: 10),
            ),
          )),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile(
      {super.key,
      required this.title,
      required this.onTap,
      this.selected = false});
  final String title;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 200,
          height: 30,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '  $title',
              style: TextStyle(
                  color: selected ? Colors.indigo : null,
                  fontWeight: selected ? FontWeight.bold : null),
            ),
          ),
        ));
  }
}
