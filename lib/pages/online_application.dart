import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import '../ip_address.dart';

class OnlineApplication extends StatefulWidget {
  const OnlineApplication({super.key, required this.code});
  final String code;

  @override
  State<OnlineApplication> createState() => _OnlineApplicationState();
}

class _OnlineApplicationState extends State<OnlineApplication> {
  late String schoolCode;

  Map schoolDetails = {};
  String? schoolName;
  bool getAll = false;
  List classDropdownList = [];
  late String logoLoc;

  Map form = {};

  getFormAccessOnline() async {
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessNoLog/$schoolCode');
    var res = await http.get(url);

    Map data = jsonDecode(res.body);

    form = data['studentFormOnline'];
    print(form);
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

    if (schoolDetails['adminLogo'].contains('/')) {
      logoLoc = schoolDetails['adminLogo'].split('/').last;
    } else {
      logoLoc = schoolDetails['adminLogo'].split('\\').last;
    }

    getClassNames();
    getFormAccessOnline();
  }

  getClassNames() async {
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getClassNames/$schoolCode');
    var res = await http.get(url);

    classDropdownList = jsonDecode(res.body);
    // print(data);
    classDropdownList = classDropdownList.map((e) => e['className']).toList();

    classDropdownList = classDropdownList.toSet().toList();
  }

  @override
  void initState() {
    getSchooldata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getAll
        ? OnlineForm(
            schoolDetails: schoolDetails,
            form: form,
            classDropdownList: classDropdownList,
            logoLoc: logoLoc,
            schoolCode: schoolCode)
        : CircularProgressIndicator();
  }
}

class OnlineForm extends StatefulWidget {
  const OnlineForm(
      {super.key,
      required this.schoolDetails,
      required this.form,
      required this.classDropdownList,
      required this.logoLoc,
      required this.schoolCode});
  final Map form;
  final String schoolCode;
  final List classDropdownList;
  final String logoLoc;
  final Map schoolDetails;

  @override
  State<OnlineForm> createState() => _OnlineFormState();
}

class _OnlineFormState extends State<OnlineForm> {
  final _formKey = GlobalKey<FormState>();
  pw.Document pdf = pw.Document();
  ScreenshotController screenshotController = ScreenshotController();

  bool opacity = false;
  bool isSaved = true;
  late int randomNo;

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
  TextEditingController fatherOccupation = TextEditingController();
  TextEditingController fatherWhatsApp = TextEditingController();
  TextEditingController fatherAadhaar = TextEditingController();
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
  TextEditingController recommend = TextEditingController();
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
  late String schoolCode;
  late Map form;
  late List classDropdownList;
  late String logoLoc;
  late Map schoolDetails;
  Uint8List? image;
  late Uint8List iconImage;

  getLogo(String filename) async {
    print(filename);
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/img/$schoolCode/$filename');
    var res = await http.get(url);
    setState(() {
      image = res.bodyBytes;
    });
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
      'submittedOn': DateTime.now().toString(),
      'classTitle': classNo ?? '',
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'fatherName': fatherName.text.trim(),
      'motherName': motherName.text.trim(),
      'recommend': recommend.text.trim(),
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
      if (mounted) {
        context.go('/submitionComplete');
      }
    }
  }

  @override
  void initState() {
    schoolCode = widget.schoolCode;
    randomNo = Random().nextInt(900000) + 100000;
    schoolDetails = widget.schoolDetails;
    form = widget.form;
    classDropdownList = widget.classDropdownList;
    logoLoc = widget.logoLoc;
    // _getLogo = getLogo(logoLoc);
    screenshotController
        .captureFromWidget(
            Icon(
              Icons.account_circle_rounded,
              size: 100,
              color: Colors.grey,
            ),
            delay: Duration(milliseconds: 10))
        .then((capturedImage) async {
      iconImage = capturedImage;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget one = TextFieldWidget(
      isEdit: true,
      isValidted: true,
      label: 'First Name + Middle Name',
      controller: firstName,
    );
    Widget two = TextFieldWidget(
      isEdit: true,
      isValidted: true,
      label: 'Last Name',
      controller: lastName,
    );
    Widget three = form['gender'] == 'true'
        ? DropDownWidget(
            isEdit: true,
            selected: gender,
            items: const ['Male', 'Female'],
            title: 'Gender',
            callBack: (p0) {
              setState(() {
                gender = p0;
              });
            },
          )
        : SizedBox();
    Widget four = DropDownWidget(
      isEdit: true,
      selected: classNo,
      items: classDropdownList,
      title: 'Class',
      callBack: (p0) {
        setState(() {
          classNo = p0;
        });
      },
    );
    Widget five = form['dob'] == 'true'
        ? DateSelectWidget(
            isEdit: true,
            title: 'Date of Birth',
            selectedDate: dob,
            callBack: (p0) {
              setState(() {
                dob = p0;
              });
            },
          )
        : SizedBox();
    Widget six = form['bloodgroup'] == 'true'
        ? DropDownWidget(
            isEdit: true,
            items: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
            title: 'Blood Group',
            callBack: (p0) {
              setState(() {
                bloodGroup = p0;
              });
            },
            selected: bloodGroup)
        : SizedBox();
    Widget seven = form['religion'] == 'true'
        ? DropDownWidget(
            isEdit: true,
            items: religionDropdownList,
            title: 'Religion',
            callBack: (p0) {
              setState(() {
                religion = p0;
              });
            },
            selected: religion,
          )
        : SizedBox();
    Widget eight = form['caste'] == 'true'
        ? DropDownWidget(
            isEdit: true,
            items: ['General', 'OBC', 'SC', 'ST'],
            title: 'Caste',
            callBack: (p0) {
              setState(() {
                caste = p0;
              });
            },
            selected: caste,
          )
        : SizedBox();
    Widget nine = form['subCaste'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Sub-Caste',
            controller: subCaste,
          )
        : SizedBox();
    Widget profilePic = Container(
      decoration: BoxDecoration(border: Border.all()),
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
              await FilePicker.platform.pickFiles(type: FileType.image);
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
                  radius: 50, backgroundColor: Colors.black.withOpacity(.60)),
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
    );
    Widget ten = form['email'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Email',
            controller: email,
          )
        : SizedBox();
    Widget eleven = form['perAddressLine1'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Address',
            controller: perAddressLine1,
          )
        : SizedBox();
    Widget twelve = form['boardingType'] == 'true'
        ? DropDownWidget(
            isEdit: true,
            items: boardingDropdownList,
            title: 'Boarding Type',
            callBack: (p0) {
              setState(() {
                boardingType = p0;
              });
            },
            selected: boardingType)
        : SizedBox();
    Widget thirteen = form['rfid'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'RFId',
            controller: rfid,
          )
        : SizedBox();

    List<Widget> col1 = [];
    Widget fatherPic = form['fatherPic'] == 'true'
        ? Container(
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
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.image);
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
                        backgroundColor: Colors.black.withOpacity(.60)),
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
          )
        : SizedBox();
    Widget first = form['fatherName'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Father\'s Name',
            controller: fatherName,
          )
        : SizedBox();
    Widget second = form['fatherOccupation'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Occupation',
            controller: fatherOccupation,
          )
        : SizedBox();
    Widget third = form['fatherMobNo'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Father\'s Mobile No.',
            controller: fatherMobNo,
          )
        : SizedBox();
    Widget fourth = form['fatherWhatsapp'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Father\'s Whatsapp No.',
            controller: fatherWhatsApp,
          )
        : SizedBox();
    Widget fifth = form['fatherAadhaar'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Aadhaar No.',
            controller: fatherAadhaar,
          )
        : SizedBox();
    Widget sixth = form['motherName'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Mother\'s Name',
            controller: motherName,
          )
        : SizedBox();
    Widget seventh = form['motherOccupation'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Occupation',
            controller: motherOccupation,
          )
        : SizedBox();
    Widget eighth = form['motherMobNo'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Mother\'s Mobile No.',
            controller: motherMobNo,
          )
        : SizedBox();
    Widget ninth = form['motherWhatsapp'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Mother\'s Whatsapp No.',
            controller: motherWhatsApp,
          )
        : SizedBox();
    Widget tenth = form['motherAadhaar'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Aadhaar No.',
            controller: motherAadhaar,
          )
        : SizedBox();
    Widget motherPic = form['motherPic'] == 'true'
        ? Container(
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
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.image);
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
                        backgroundColor: Colors.black.withOpacity(.60)),
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
          )
        : SizedBox();

    List<Widget> col2 = [];

    Widget a = form['gaurdianRelation'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Relation with Student',
            controller: gaurdianRelation,
          )
        : SizedBox();
    Widget b = form['gaurdianName'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Gaurdian\'s Name',
            controller: gaurdianName,
          )
        : SizedBox();
    Widget c = form['gaurdianOccupation'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Occupation',
            controller: gaurdianOccupation,
          )
        : SizedBox();
    Widget d = form['gaurdianMobNo'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Gaurdian\'s Mobile No.',
            controller: gaurdianMobNo,
          )
        : SizedBox();
    Widget e = form['gaurdianWhatsApp'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Gaurdian \'s Whatsapp No.',
            controller: gaurdianWhatsApp,
          )
        : SizedBox();
    Widget f = form['gaurdianAadhaar'] == 'true'
        ? TextFieldWidget(
            isEdit: true,
            label: 'Aadhaar No.',
            controller: gaurdianAadhaar,
          )
        : SizedBox();
    Widget gaurdianPic = form['gaurdianPic'] == 'true'
        ? Container(
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
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                _gaurdianImage = result!.files.first;
                setState(() {
                  _gaurdianImagebytes = _gaurdianImage!.bytes;
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
                        backgroundColor: Colors.black.withOpacity(.60)),
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
          )
        : SizedBox();

    List<Widget> col3 = [];
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 850) {
        col1 = [];
        col2 = [];
        col3 = [];
      } else {
        col1 = [
          profilePic,
          one,
          two,
          three,
          four,
          five,
          six,
          seven,
          eight,
          nine
        ];
        col2 = [
          fatherPic,
          first,
          second,
          third,
          fourth,
          fifth,
          motherPic,
          sixth,
          seventh,
          eighth,
          ninth,
          tenth
        ];
        col3 = [gaurdianPic, a, b, c, d, e, f];
      }
      return Form(
        key: _formKey,
        child: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       setState(() {
            //         isPrint = true;
            //       });
            //     },
            //     child: Text('add')),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: Text(
                    'Lidin Alby',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 18,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[50]),
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'First Name',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  pdf.addPage(
                    pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (context) => pw.Container(
                        // alignment: pw.Alignment.center,
                        child: pw.SizedBox(
                          width: double.infinity,
                          child: pw.Column(
                            children: [
                              pw.Row(
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  if (image != null)
                                    // CircleAvatar(
                                    //   // radius: 50,
                                    //   backgroundImage: MemoryImage(image!),
                                    // ),
                                    pw.SizedBox(
                                      width: 10,
                                    ),
                                  pw.Text(
                                    schoolDetails['schoolName'].toString(),
                                    style: pw.TextStyle(
                                        fontSize: 28,
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                ],
                              ),
                              pw.SizedBox(
                                height: 3,
                              ),
                              pw.Container(
                                  padding: pw.EdgeInsets.all(5),
                                  decoration: pw.BoxDecoration(
                                      color: PdfColors.indigo,
                                      borderRadius:
                                          pw.BorderRadius.circular(5)),
                                  child: pw.Column(
                                    children: [
                                      pw.Text(
                                        schoolDetails['schoolAddress']
                                            .toString(),
                                        style: pw.TextStyle(
                                            color: PdfColors.white),
                                      ),
                                      pw.SizedBox(
                                        height: 3,
                                      ),
                                      pw.Text(
                                        schoolDetails['schoolPhone']
                                                .toString() +
                                            ', ' +
                                            schoolDetails['schoolMail']
                                                .toString(),
                                        style: pw.TextStyle(
                                            color: PdfColors.white),
                                      ),
                                    ],
                                  )),

                              // Text(),
                              pw.SizedBox(
                                height: 15,
                              ),

                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Personal Details'),
                                  pw.Divider(),
                                  pw.SizedBox(
                                    height: 10,
                                  ),
                                  pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Column(
                                        children: [
                                          pw.Row(
                                            children: [
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'First Name + Middle Name',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 180,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      'Lidin',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Last Name',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 180,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      'Alby',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Row(
                                            children: [
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Gender',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 120,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      'Male',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Class',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 120,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      'VII',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Date of Birth',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 120,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      '02-04-2000',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          pw.SizedBox(height: 5),
                                          pw.Row(
                                            children: [
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Blood Group',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 120,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      'A+',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Religion',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 120,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      'Christian',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Caste',
                                                    style: pw.TextStyle(
                                                        fontSize: 10),
                                                  ),
                                                  pw.Container(
                                                    padding:
                                                        pw.EdgeInsets.all(3),
                                                    width: 120,
                                                    height: 20,
                                                    decoration:
                                                        pw.BoxDecoration(
                                                            border: pw.Border
                                                                .all()),
                                                    child: pw.Text(
                                                      '',
                                                      style: pw.TextStyle(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      pw.Container(
                                        margin: pw.EdgeInsets.symmetric(
                                            horizontal: 5),
                                        padding: pw.EdgeInsets.all(8),
                                        decoration: pw.BoxDecoration(
                                            border: pw.Border.all()),
                                        child: pw.Container(
                                          width: 100,
                                          height: 100,
                                          decoration: pw.BoxDecoration(
                                              image: pw.DecorationImage(
                                                  image: pw.MemoryImage(
                                                      _imagebytes ??
                                                          iconImage)),
                                              shape: pw.BoxShape.circle),
                                        ),
                                      )
                                    ],
                                  ),

                                  pw.Row(
                                    children: [
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'Sub-Caste',
                                            style: pw.TextStyle(fontSize: 10),
                                          ),
                                          pw.Container(
                                            padding: pw.EdgeInsets.all(3),
                                            width: 120,
                                            height: 20,
                                            decoration: pw.BoxDecoration(
                                                border: pw.Border.all()),
                                            child: pw.Text(
                                              '',
                                              style: pw.TextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'Email',
                                            style: pw.TextStyle(fontSize: 10),
                                          ),
                                          pw.Container(
                                            padding: pw.EdgeInsets.all(3),
                                            width: 120,
                                            height: 20,
                                            decoration: pw.BoxDecoration(
                                                border: pw.Border.all()),
                                            child: pw.Text(
                                              '',
                                              style: pw.TextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'RFId',
                                            style: pw.TextStyle(fontSize: 10),
                                          ),
                                          pw.Container(
                                            padding: pw.EdgeInsets.all(3),
                                            width: 120,
                                            height: 20,
                                            decoration: pw.BoxDecoration(
                                                border: pw.Border.all()),
                                            child: pw.Text(
                                              ' ',
                                              style: pw.TextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(height: 5),
                                  pw.Row(
                                    children: [
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'Address',
                                            style: pw.TextStyle(fontSize: 10),
                                          ),
                                          pw.Container(
                                            padding: pw.EdgeInsets.all(3),
                                            width: 180,
                                            height: 20,
                                            decoration: pw.BoxDecoration(
                                                border: pw.Border.all()),
                                            child: pw.Text(
                                              ' ',
                                              style: pw.TextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text(
                                            'Borading Type',
                                            style: pw.TextStyle(fontSize: 10),
                                          ),
                                          pw.Container(
                                            padding: pw.EdgeInsets.all(3),
                                            width: 180,
                                            height: 20,
                                            decoration: pw.BoxDecoration(
                                                border: pw.Border.all()),
                                            child: pw.Text(
                                              ' ',
                                              style: pw.TextStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // thirteen
                                ],
                              ),

                              pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text('Parent Details')),
                              pw.Divider(),
                              pw.SizedBox(
                                height: 10,
                              ),

                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 100,
                                    height: 100,
                                    decoration: pw.BoxDecoration(
                                        image: pw.DecorationImage(
                                            image: pw.MemoryImage(
                                                _fatherImagebytes ??
                                                    iconImage)),
                                        shape: pw.BoxShape.circle),
                                  ),
                                  pw.Column(
                                    children: [
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),

                              pw.Row(
                                children: [
                                  pw.Column(
                                    children: [
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  pw.Container(
                                    width: 100,
                                    height: 100,
                                    decoration: pw.BoxDecoration(
                                        image: pw.DecorationImage(
                                            image: pw.MemoryImage(
                                                _motherImagebytes ??
                                                    iconImage)),
                                        shape: pw.BoxShape.circle),
                                  )
                                ],
                              ),

                              pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text('Gaurdian Details (if Any)')),
                              pw.Divider(),

                              pw.Row(
                                children: [
                                  pw.Container(
                                    width: 100,
                                    height: 100,
                                    decoration: pw.BoxDecoration(
                                        image: pw.DecorationImage(
                                            image: pw.MemoryImage(
                                                _gaurdianImagebytes ??
                                                    iconImage)),
                                        shape: pw.BoxShape.circle),
                                  ),
                                  pw.Column(
                                    children: [
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                          pw.Text(
                                            'Lidin Alby',
                                            style: pw.TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              pw.Padding(
                                padding:
                                    const pw.EdgeInsets.symmetric(vertical: 4),
                                child: pw.Align(
                                  alignment: pw.Alignment.bottomLeft,
                                  child: pw.SizedBox(
                                    width: constraints.maxWidth - 150,
                                    child: pw.Row(
                                      children: [pw.Text(recommend.text)],
                                    ),
                                  ),
                                ),
                              ),

                              pw.Align(
                                  alignment: pw.Alignment.centerLeft,
                                  child: pw.Text(form['instructions']))

                              // if (!isSaved)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                  var savedFile = await pdf.save();
                  List<int> fileInts = List.from(savedFile);
                  html.AnchorElement(
                      href:
                          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(fileInts)}")
                    ..setAttribute("download",
                        "${DateTime.now().millisecondsSinceEpoch}.pdf")
                    ..click();
                },
                child: Text('do')),
            Screenshot(
              controller: screenshotController,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (image != null)
                            // CircleAvatar(
                            //   // radius: 50,
                            //   backgroundImage: MemoryImage(image!),
                            // ),
                            SizedBox(
                              width: 10,
                            ),
                          Text(
                            schoolDetails['schoolName'].toString(),
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
                                schoolDetails['schoolAddress'].toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                schoolDetails['schoolPhone'].toString() +
                                    ', ' +
                                    schoolDetails['schoolMail'].toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),

                      // Text(),
                      SizedBox(
                        height: 15,
                      ),
                      if (constraints.maxWidth < 850)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Personal Details'),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            for (Widget i in col1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [i],
                                ),
                              ),
                          ],
                        ),
                      if (constraints.maxWidth > 850)
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
                                        children: [
                                          one,
                                          SizedBox(
                                            width: 20,
                                          ),
                                          two
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          three,
                                          SizedBox(
                                            width: 20,
                                          ),
                                          four,
                                          SizedBox(
                                            width: 20,
                                          ),
                                          five
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        children: [
                                          six,
                                          SizedBox(
                                            width: 20,
                                          ),
                                          seven,
                                          SizedBox(
                                            width: 20,
                                          ),
                                          eight
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                profilePic
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                nine,
                                SizedBox(
                                  width: 20,
                                ),
                                ten,
                                SizedBox(
                                  width: 20,
                                ),
                                thirteen
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                eleven,
                                SizedBox(
                                  width: 20,
                                ),
                                twelve
                              ],
                            ),
                            // thirteen
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
                      if (constraints.maxWidth < 850)
                        for (Widget i in col2)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [i],
                            ),
                          ),
                      if (constraints.maxWidth > 850)
                        Row(
                          children: [
                            fatherPic,
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: constraints.maxWidth - 350,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      first,
                                      SizedBox(
                                        width: 20,
                                      ),
                                      second
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      third,
                                      SizedBox(
                                        width: 20,
                                      ),
                                      fourth
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [fifth],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 40,
                      ),
                      if (constraints.maxWidth > 850)
                        Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth - 350,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      sixth,
                                      SizedBox(
                                        width: 20,
                                      ),
                                      seventh
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      eighth,
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ninth
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [tenth],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            motherPic
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
                      if (constraints.maxWidth < 850)
                        for (Widget i in col3)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [i],
                            ),
                          ),
                      if (constraints.maxWidth > 850)
                        Row(
                          children: [
                            gaurdianPic,
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: constraints.maxWidth - 350,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      a,
                                      SizedBox(
                                        width: 20,
                                      ),
                                      b,
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      c,
                                      SizedBox(
                                        width: 20,
                                      ),
                                      d,
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      e,
                                      SizedBox(
                                        width: 20,
                                      ),
                                      f
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: constraints.maxWidth - 150,
                            child: Row(
                              children: [
                                TextFieldWidget(
                                    label: 'Recommended from',
                                    controller: recommend,
                                    isEdit: true),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: isSaved
                            ? ElevatedButton(
                                onPressed: submitForm,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 12)),
                              )
                            : CircularProgressIndicator(),
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
          ],
        ),
      );
    });
  }
}

class OnlyForm extends StatelessWidget {
  const OnlyForm({super.key, required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnlineApplication(code: code),
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
