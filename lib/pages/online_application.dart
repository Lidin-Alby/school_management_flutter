import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../ip_address.dart';

// import '../widgets/textfield_widget.dart';

class OnlineApplication extends StatefulWidget {
  const OnlineApplication({super.key, required this.code});
  final String code;

  @override
  State<OnlineApplication> createState() => _OnlineApplicationState();
}

class _OnlineApplicationState extends State<OnlineApplication> {
  final _formKey = GlobalKey<FormState>();

  bool opacity = false;

  String? classNo;
  String? boardingType;
  String? religion;
  String? caste;
  String? gender;
  String? dob;
  String? bloodGroup;
  TextEditingController rfid = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController subCaste = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fatherMobNo = TextEditingController();
  TextEditingController perAddressLine1 = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController motherName = TextEditingController();
  late String schoolCode;
  List classDropdownList = [];
  List religionDropdownList = [
    'Hindu',
    'Islam',
    'Christian',
    'Sikh',
    'Budh',
    'Jain',
    'Parsi',
    'Yahudi',
    'Other'
  ];
  List boardingDropdownList = ['Day Scholer', 'Hostel'];

  // TextEditingController fatherName = TextEditingController();
  TextEditingController fatherOccupation = TextEditingController();
  // TextEditingController fatherMobNo = TextEditingController();
  TextEditingController fatherWhatsApp = TextEditingController();
  TextEditingController fatherAadhaar = TextEditingController();
  // TextEditingController motherName = TextEditingController();
  TextEditingController motherOccupation = TextEditingController();
  TextEditingController motherMobNo = TextEditingController();
  TextEditingController motherWhatsApp = TextEditingController();
  TextEditingController motherAadhaar = TextEditingController();
  TextEditingController gaurdianName = TextEditingController();
  TextEditingController gaurdianOccupation = TextEditingController();
  TextEditingController gaurdianMobNo = TextEditingController();
  TextEditingController gaurdianWhatsApp = TextEditingController();
  TextEditingController gaurdianAadhaar = TextEditingController();
  TextEditingController gaurdianRelation = TextEditingController();
  // late int schoolCode;
  Uint8List? _imagebytes;
  PlatformFile? _image;
  Uint8List? _fatherImagebytes;
  PlatformFile? _fatherImage;
  PlatformFile? _motherImage;
  Uint8List? _motherImagebytes;
  PlatformFile? _gaurdianImage;
  Uint8List? _gaurdianImagebytes;
  bool _fatherOpacity = false;
  bool _motherOpacity = false;
  bool _gaurdianOpacity = false;

  String? schoolName;
  Map schoolDetails = {};
  bool getAll = false;
  bool isSaved = false;
  late int randomNo;
  late Future _getLogo;

  Map form = {};

  getLogo(String filename) async {
    print(filename);
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/img/$schoolCode/$filename');
    var res = await http.get(url);

    return res.bodyBytes;
  }

  getFormAccessOnline() async {
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessNoLog/$schoolCode');
    var res = await http.get(url);

    Map data = jsonDecode(res.body);

    form = data['studentFormOnline'];
    print(form['bloodgroup']);

    setState(() {
      getAll = true;
    });
  }

  getSchooldata() async {
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/onlineApplication/${widget.code}');
    var res = await http.get(url);
    // print(res.body);
    schoolDetails = jsonDecode(res.body);
    // print(data);
    schoolCode = schoolDetails['schoolCode'].toString();
    schoolName = schoolDetails['schoolName'];
    _getLogo = getLogo(schoolDetails['adminLogo'].split('\\').last);
    getFormAccessOnline();
  }

  submitForm() async {
    setState(() {
      isSaved = false;
    });
    var url = Uri.parse('$ipv4/submitApplication');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_imagebytes == null) {
      req.fields['studentPic'] = '';
    } else if (_image != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'studentPic',
        _imagebytes!,
        filename:
            '${randomNo}_${schoolCode}_student_ProfilePic.${_image!.extension}',
      );
      req.files.add(httpImage);
    }
    if (_fatherImagebytes == null) {
      req.fields['fatherProfilePic'] = '';
    } else if (_fatherImage != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'fatherProfilePic',
        _fatherImagebytes!,
        filename:
            '${randomNo}_${schoolCode}_father_ProfilePic.${_fatherImage!.extension}',
      );
      req.files.add(httpImage);
    }
    if (_motherImagebytes == null) {
      req.fields['motherProfilePic'] = '';
    } else if (_motherImage != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'motherProfilePic',
        _motherImagebytes!,
        filename:
            '${randomNo}_${schoolCode}_mother_ProfilePic.${_motherImage!.extension}',
      );
      req.files.add(httpImage);
    }
    if (_gaurdianImagebytes == null) {
      req.fields['gaurdianProfilePic'] = '';
    } else if (_gaurdianImage != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'gaurdianProfilePic',
        _gaurdianImagebytes!,
        filename:
            '${randomNo}_${schoolCode}_gaurdian_ProfilePic.${_gaurdianImage!.extension}',
      );
      req.files.add(httpImage);
    }
    //   req.fields['admNo'] = admNo.text.trim();
    req.fields.addAll({
      'applicationNo': randomNo.toString(),
      'schoolCode': schoolCode.toString(),
      'classTitle': classNo ?? '',
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'fatherName': fatherName.text.trim(),
      'motherName': motherName.text.trim(),
      'gender': gender ?? '',
      'dob': dob ?? '',
      'bloodGroup': bloodGroup ?? '',
      'religion': religion ?? '',
      'caste': caste ?? '',
      'subCaste': subCaste.text.trim(),
      'email': email.text.trim(),
      'fatherMobNo': fatherMobNo.text.trim(),
      'perAddressLine1': perAddressLine1.text.trim(),
      'boardingType': boardingType ?? '',
      'rfid': rfid.text.trim(),
      'fatherOccupation': fatherOccupation.text.trim(),
      'fatherWhatsApp': fatherWhatsApp.text.trim(),
      'fatherAadhaar': fatherAadhaar.text.trim(),
      'motherOccupation': motherOccupation.text.trim(),
      'motherMobNo': motherMobNo.text.trim(),
      'motherWhatsApp': motherWhatsApp.text.trim(),
      'motherAadhaar': motherAadhaar.text.trim(),
      'gaurdianName': gaurdianName.text.trim(),
      'gaurdianOccupation': gaurdianOccupation.text.trim(),
      'gaurdianMobNo': gaurdianMobNo.text.trim(),
      'gaurdianWhatsApp': gaurdianWhatsApp.text.trim(),
      'gaurdianAadhaar': gaurdianAadhaar.text.trim(),
      'gaurdianRelation': gaurdianRelation.text.trim()
    });

    var res = await req.send();
    var responded = await http.Response.fromStream(res);

    if (responded.body == 'true') {
      setState(() {
        isSaved = true;
      });
    }
  }

  @override
  void initState() {
    getSchooldata();
    randomNo = Random().nextInt(900000) + 100000;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getAll
        ? LayoutBuilder(
            builder: (context, constraints) => Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: _getLogo,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CircleAvatar(
                                    // radius: 50,
                                    backgroundImage:
                                        MemoryImage(snapshot.data as Uint8List),
                                  );
                                } else {
                                  return Icon(Icons.error_outline_rounded);
                                }
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              schoolName.toString(),
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                Text(
                                  schoolDetails['schoolAddress'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  schoolDetails['schoolPhone'] +
                                      ', ' +
                                      schoolDetails['schoolMail'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),

                        // Text(),
                        SizedBox(
                          height: 15,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Personal Details'),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: constraints.maxWidth - 350,
                                  child: Column(
                                    children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // firstWrap(),
                                          TextFieldWidget(
                                            isEdit: true,
                                            isValidted: true,
                                            label: 'First Name + Middle Name',
                                            controller: firstName,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          TextFieldWidget(
                                            isEdit: true,
                                            isValidted: true,
                                            label: 'Last Name',
                                            controller: lastName,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          if (form['gender'] == 'true')
                                            DropDownWidget(
                                              isEdit: true,
                                              selected: gender,
                                              items: const ['Male', 'Female'],
                                              title: 'Gender',
                                              callBack: (p0) {
                                                setState(() {
                                                  gender = p0;
                                                });
                                              },
                                            ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          if (form['dob'] == 'true')
                                            DateSelectWidget(
                                              isEdit: true,
                                              title: 'Date of Birth',
                                              selectedDate: dob,
                                              callBack: (p0) {
                                                setState(() {
                                                  dob = p0;
                                                });
                                              },
                                            ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          if (form['bloodgroup'] == 'true')
                                            DropDownWidget(
                                                isEdit: true,
                                                items: const [
                                                  'A+',
                                                  'A-',
                                                  'B+',
                                                  'B-',
                                                  'O+',
                                                  'O-',
                                                  'AB+',
                                                  'AB-'
                                                ],
                                                title: 'Blood Group',
                                                callBack: (p0) {
                                                  setState(() {
                                                    bloodGroup = p0;
                                                  });
                                                },
                                                selected: bloodGroup),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          if (form['religion'] == 'true')
                                            DropDownWidget(
                                              isEdit: true,
                                              items: religionDropdownList,
                                              title: 'Religion',
                                              callBack: (p0) {
                                                setState(() {
                                                  religion = p0;
                                                });
                                              },
                                              selected: religion,
                                            ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          if (form['caste'] == 'true')
                                            DropDownWidget(
                                              isEdit: true,
                                              items: [
                                                'General',
                                                'OBC',
                                                'SC',
                                                'ST'
                                              ],
                                              title: 'Caste',
                                              callBack: (p0) {
                                                setState(() {
                                                  caste = p0;
                                                });
                                              },
                                              selected: caste,
                                            ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          if (form['subCaste'] == 'true')
                                            TextFieldWidget(
                                              isEdit: true,
                                              label: 'Sub-Caste',
                                              controller: subCaste,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  padding: EdgeInsets.all(40),
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    onHover: (value) {
                                      setState(() {
                                        opacity = value;
                                      });
                                    },
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform
                                              .pickFiles(type: FileType.image);
                                      if (result != null) {
                                        _image = result.files.first;

                                        setState(() {
                                          _imagebytes = _image!.bytes;
                                        });
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        _imagebytes == null
                                            ? Icon(
                                                color: Colors.grey,
                                                Icons.account_circle_rounded,
                                                size: 100,
                                              )
                                            : CircleAvatar(
                                                radius: 50,
                                                backgroundImage: MemoryImage(
                                                  _imagebytes!,
                                                  //  fit: BoxFit.contain,
                                                ),
                                              ),
                                        if (opacity)
                                          CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Colors.black
                                                  .withOpacity(.60)),
                                        if (opacity)
                                          Positioned(
                                            top: 35,
                                            left: 35,
                                            child: Icon(
                                              color: Colors.white,
                                              Icons.edit_outlined,
                                              size: 30,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                if (form['email'] == 'true')
                                  TextFieldWidget(
                                    isEdit: true,
                                    label: 'Email',
                                    controller: email,
                                  ),
                                SizedBox(
                                  width: 20,
                                ),
                                if (form['perAddressLine1'] == 'true')
                                  TextFieldWidget(
                                    isEdit: true,
                                    label: 'Address',
                                    controller: perAddressLine1,
                                  ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                if (form['boardingType'] == 'true')
                                  DropDownWidget(
                                      isEdit: true,
                                      items: boardingDropdownList,
                                      title: 'Boarding Type',
                                      callBack: (p0) {
                                        setState(() {
                                          boardingType = p0;
                                        });
                                      },
                                      selected: boardingType),
                                SizedBox(
                                  width: 20,
                                ),
                                if (form['rfid'] == 'true')
                                  TextFieldWidget(
                                    isEdit: true,
                                    label: 'RFId',
                                    controller: rfid,
                                  ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Parent Details')),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            if (form['fatherPic'] == 'true')
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                padding: EdgeInsets.all(40),
                                child: InkWell(
                                  hoverColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  onHover: (value) {
                                    setState(() {
                                      _fatherOpacity = value;
                                    });
                                  },
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image);
                                    _fatherImage = result!.files.first;
                                    setState(() {
                                      _fatherImagebytes = _fatherImage!.bytes;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      _fatherImagebytes == null
                                          ? Icon(
                                              color: Colors.grey,
                                              Icons.account_circle_rounded,
                                              size: 100,
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: MemoryImage(
                                                _fatherImagebytes!,
                                                //  fit: BoxFit.contain,
                                              ),
                                            ),
                                      if (_fatherOpacity)
                                        CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                Colors.black.withOpacity(.60)),
                                      if (_fatherOpacity)
                                        Positioned(
                                          top: 35,
                                          left: 35,
                                          child: Icon(
                                            color: Colors.white,
                                            Icons.edit_outlined,
                                            size: 30,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: constraints.maxWidth - 350,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      if (form['fatherName'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Father\'s Name',
                                          controller: fatherName,
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (form['fatherOccupation'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Occupation',
                                          controller: fatherOccupation,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      if (form['fatherMobNo'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Father\'s Mobile No.',
                                          controller: fatherMobNo,
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (form['fatherWhatsapp'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Father\'s Whatsapp No.',
                                          controller: fatherWhatsApp,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      if (form['fatherAadhaar'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Aadhaar No.',
                                          controller: fatherAadhaar,
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth - 350,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      if (form['motherName'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Mother\'s Name',
                                          controller: motherName,
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (form['motherOccupation'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Occupation',
                                          controller: motherOccupation,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      if (form['motherMobNo'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Mother\'s Mobile No.',
                                          controller: motherMobNo,
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (form['motherWhatsapp'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Mother\'s Whatsapp No.',
                                          controller: motherWhatsApp,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      if (form['motherAadhaar'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Aadhaar No.',
                                          controller: motherAadhaar,
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            if (form['motherPic'] == 'true')
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                padding: EdgeInsets.all(40),
                                child: InkWell(
                                  hoverColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  onHover: (value) {
                                    setState(() {
                                      _motherOpacity = value;
                                    });
                                  },
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image);
                                    _motherImage = result!.files.first;
                                    setState(() {
                                      _motherImagebytes = _motherImage!.bytes;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      _motherImagebytes == null
                                          ? Icon(
                                              color: Colors.grey,
                                              Icons.account_circle_rounded,
                                              size: 100,
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: MemoryImage(
                                                _motherImagebytes!,
                                                //  fit: BoxFit.contain,
                                              ),
                                            ),
                                      if (_motherOpacity)
                                        CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                Colors.black.withOpacity(.60)),
                                      if (_motherOpacity)
                                        Positioned(
                                          top: 35,
                                          left: 35,
                                          child: Icon(
                                            color: Colors.white,
                                            Icons.edit_outlined,
                                            size: 30,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Gaurdian Details (if Any)')),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            if (form['gaurdianPic'] == 'true')
                              Container(
                                decoration: BoxDecoration(border: Border.all()),
                                padding: EdgeInsets.all(40),
                                child: InkWell(
                                  hoverColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  onHover: (value) {
                                    setState(() {
                                      _gaurdianOpacity = value;
                                    });
                                  },
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image);
                                    _gaurdianImage = result!.files.first;
                                    setState(() {
                                      _gaurdianImagebytes =
                                          _gaurdianImage!.bytes;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      _gaurdianImagebytes == null
                                          ? Icon(
                                              color: Colors.grey,
                                              Icons.account_circle_rounded,
                                              size: 100,
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: MemoryImage(
                                                _gaurdianImagebytes!,
                                                //  fit: BoxFit.contain,
                                              ),
                                            ),
                                      if (_gaurdianOpacity)
                                        CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                Colors.black.withOpacity(.60)),
                                      if (_gaurdianOpacity)
                                        Positioned(
                                          top: 35,
                                          left: 35,
                                          child: Icon(
                                            color: Colors.white,
                                            Icons.edit_outlined,
                                            size: 30,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: constraints.maxWidth - 350,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      if (form['gaurdianRelation'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Relation with Student',
                                          controller: gaurdianRelation,
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (form['gaurdianName'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Gaurdian\'s Name',
                                          controller: gaurdianName,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      if (form['gaurdianOccupation'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Occupation',
                                          controller: gaurdianOccupation,
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (form['gaurdianMobNo'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Gaurdian\'s Mobile No.',
                                          controller: gaurdianMobNo,
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      if (form['gaurdianWhatsApp'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Gaurdian \'s Whatsapp No.',
                                          controller: gaurdianWhatsApp,
                                        ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (form['gaurdianAadhaar'] == 'true')
                                        TextFieldWidget(
                                          isEdit: true,
                                          label: 'Aadhaar No.',
                                          controller: gaurdianAadhaar,
                                        )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: submitForm,
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 12)),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(form['instructions']))

                        // if (!isSaved)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : CircularProgressIndicator();
  }

  Row firstWrap() {
    return Row(
      // alignment: WrapAlignment.center,
      // crossAxisAlignment: WrapCrossAlignment.center,
      // spacing: 20,
      // runSpacing: 20,
      children: [
        if (form['classTitle'] == 'true')
          DropDownWidget(
            isEdit: true,
            selected: classNo,
            title: 'Class/Course',
            items: classDropdownList,
            callBack: (p0) {
              setState(() {
                classNo = p0;
              });
            },
          ),
      ],
    );
  }

  SizedBox thirdColumn() {
    return SizedBox(
      width: 250,
      child: Wrap(
        runSpacing: 15,
        children: [
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  SizedBox secondColumn() {
    return SizedBox(
      width: 250,
      child: Wrap(
        runSpacing: 15,
        children: [
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      required this.label,
      required this.controller,
      this.isValidted = false,
      required this.isEdit})
      : super(key: key);
  final String label;
  final TextEditingController controller;

  final bool isValidted;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        validator: isValidted
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : null,
        readOnly: !isEdit,
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          label: Text(label),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class DateSelectWidget extends StatelessWidget {
  const DateSelectWidget({
    Key? key,
    required this.title,
    required this.selectedDate,
    required this.isEdit,
    required this.callBack,
  }) : super(key: key);
  final String title;
  final String? selectedDate;
  final bool isEdit;
  final Function(dynamic) callBack;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: MouseRegion(
        cursor:
            //  isAdd ? SystemMouseCursors.text :
            SystemMouseCursors.basic,
        child: InkWell(
          onTap: isEdit
              ? () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now());
                  String selected = DateFormat('dd-MM-yyyy').format(date!);
                  callBack(selected);
                }
              : null,
          child: SizedBox(
            height: 43,
            // width: 250,
            child: InputDecorator(
              decoration: InputDecoration(
                  isDense: true,
                  labelText: selectedDate == null ? null : title,
                  border: OutlineInputBorder()),
              child: selectedDate == null
                  ? Text(title,
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade600))
                  : Text(
                      selectedDate!,
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    Key? key,
    required this.items,
    required this.title,
    required this.isEdit,
    required this.callBack,
    required this.selected,
  }) : super(key: key);
  final List items;
  final dynamic selected;
  final String title;
  final bool isEdit;
  final Function(dynamic) callBack;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: !isEdit,
            child: Container(
              margin: EdgeInsets.only(top: 3),
              alignment: AlignmentDirectional.center,
              // width: 250,
              height: 43,
              // margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                disabledHint: selected != null
                    ? Text(
                        selected.toString(),
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        title,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                value: selected,
                isExpanded: true,
                underline: Text(''),
                hint: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(title),
                ),
                items: items
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (value) {
                  callBack(value);
                },
              ),
            ),
          ),
          if (selected != null)
            Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 3),
                color: Colors.blue[50],
                child: Text(
                  title,
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ))
        ],
      ),
    );
  }
}
