import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../../ip_address.dart';

class StaffFormMid extends StatefulWidget {
  const StaffFormMid({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<StaffFormMid> createState() => _StaffFormMidState();
}

class _StaffFormMidState extends State<StaffFormMid> {
  bool joiningDate = false;
  // bool reportsTo = false;
  bool department = false;
  bool designation = false;
  bool rfid = false;
  bool gender = false;
  bool dob = false;
  bool bloodgroup = false;
  // bool wardInSchool = false;
  bool email = false;
  bool fatherorHusName = false;
  bool qualification = false;
  bool address = false;
  // bool experience = false;
  bool religion = false;
  bool caste = false;
  bool subCaste = false;
  bool aadhaar = false;
  bool pan = false;
  bool uan = false;
  // bool bankName = false;
  // bool accountNo = false;
  // bool ifscCode = false;
  // bool nameOnRecord = false;
  bool dlNo = false;
  bool dlValidity = false;
  // bool basicSalary = false;
  // bool salaryType = false;
  // bool contractType = false;
  // bool curAddressLine1 = false;
  // bool curAddressLine2 = false;
  // bool curAddressLine3 = false;
  // bool curPincode = false;
  // bool perAddressLine1 = false;
  // bool perAddressLine2 = false;
  // bool perAddressLine3 = false;
  // bool perPincode = false;
  // bool aadhaarNo = false;
  // bool panNo = false;
  // bool bloodReport = false;
  // bool joiningLetter = false;
  // bool drivingLicence = false;
  // bool schoolTransportRoute = false;
  // bool pickAndDrop = false;
  // bool vehicleNo = false;

  late Future _getFormStaff;

  getFormAccessStaff() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessStaffMid/${widget.schoolCode}');
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

    department = data['department'];
    designation = data['designation'];
    rfid = data['rfid'];
    gender = data['gender'];
    dob = data['dob'];
    bloodgroup = data['bloodgroup'];

    email = data['email'];
    fatherorHusName = data['fatherorHusName'];
    qualification = data['qualification'];

    religion = data['religion'];
    caste = data['caste'];
    subCaste = data['subCaste'];

    uan = data['uan'];

    dlNo = data['dlNo'];
    dlValidity = data['dlValidity'];

    aadhaar = data['aadhaar'];
    pan = data['pan'];
    address = data['address'];
  }

  addFormAccessStaff() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/addFormAccessStaff');
    var res = await client.post(url, body: {
      'joiningDate': joiningDate.toString(),
      'department': department.toString(),
      'designation': designation.toString(),
      'rfid': rfid.toString(),
      'gender': gender.toString(),
      'dob': dob.toString(),
      'bloodgroup': bloodgroup.toString(),
      'email': email.toString(),
      'fatherorHusName': fatherorHusName.toString(),
      'qualification': qualification.toString(),
      'religion': religion.toString(),
      'caste': caste.toString(),
      'subCaste': subCaste.toString(),
      'uanNo': uan.toString(),
      'dlNo': dlNo.toString(),
      'dlValidity': dlValidity.toString(),
      'aadhaar': aadhaar.toString(),
      'pan': pan.toString(),
    });
  }

  @override
  void initState() {
    _getFormStaff = getFormAccessStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
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
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
