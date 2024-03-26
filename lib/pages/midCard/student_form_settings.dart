import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/browser_client.dart';
import '../../ip_address.dart';

class StudentFormMid extends StatefulWidget {
  const StudentFormMid({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<StudentFormMid> createState() => _StudentFormMidState();
}

class _StudentFormMidState extends State<StudentFormMid> {
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
    var url = Uri.parse('$ipv4/getFormAccessStudentMid/${widget.schoolCode}');
    var res = await client.get(url);

    print('done');
    print(res.body);
    Map data = jsonDecode(res.body);
    if (data.containsKey('studentFormMid')) {
      data = data['studentFormMid'];
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
    var url = Uri.parse('$ipv4/addFormAccessStudentMid');
    var res = await client.post(url, body: {
      'schoolCode': widget.schoolCode,
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
    if (res.body == 'true') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            content: const Row(
              children: [
                Text(
                  'Updated Sucessfully',
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
  }

  @override
  void initState() {
    _getFormAcces = getFormAccessStudent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
