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
        ),
      ),
    );
  }
}
