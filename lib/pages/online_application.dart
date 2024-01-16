import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';
import '../widgets/date_select_widget.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/textfield_widget.dart';

class OnlineApplication extends StatefulWidget {
  const OnlineApplication({super.key, required this.code});
  final String code;

  @override
  State<OnlineApplication> createState() => _OnlineApplicationState();
}

class _OnlineApplicationState extends State<OnlineApplication> {
  final _formKey = GlobalKey<FormState>();

  bool opacity = false;
  Uint8List? _imagebytes;
  PlatformFile? _image;
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
  Uint8List? _fatherImagebytes;
  PlatformFile? _fatherImage;
  PlatformFile? _motherImage;
  Uint8List? _motherImagebytes;
  PlatformFile? _gaurdianImage;
  Uint8List? _gaurdianImagebytes;
  bool _fatherOpacity = false;
  bool _motherOpacity = false;
  bool _gaurdianOpacity = false;

  bool getAll = false;

  Map form = {};

  getFormAccessOnline() async {
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getFormAccessNoLog/$schoolCode');
    var res = await http.get(url);

    Map data = jsonDecode(res.body);

    form = data['studentFormOnline'];

    setState(() {
      getAll = true;
    });
  }

  getSchooldata() async {
    // var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/onlineApplication/${widget.code}');
    var res = await http.get(url);
    print(res.body);
    schoolCode = res.body;
    // setState(() {
    //   getAll = true;
    // });
    getFormAccessOnline();
  }

  @override
  void initState() {
    getSchooldata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Application'),
      ),
      body: getAll
          ? Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          onHover: (value) {
                            setState(() {
                              opacity = value;
                            });
                          },
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
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
                                    backgroundColor:
                                        Colors.black.withOpacity(.60)),
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
                      firstWrap(),
                      Text('Parent details'),
                      Wrap(
                        spacing: 20,
                        children: [
                          firstColumn(),
                          secondColumn(),
                          thirdColumn(),
                        ],
                      ),
                      Text(form['instructions'])

                      // if (!isSaved)
                    ],
                  ),
                ),
              ),
            )
          : CircularProgressIndicator(),
    );
  }

  Wrap firstWrap() {
    return Wrap(
      // alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 20,
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

        //  Text('sec'),

        TextFieldWidget(
          isEdit: true,
          isValidted: true,
          label: 'First Name + Middle Name',
          controller: firstName,
        ),
        TextFieldWidget(
          isEdit: true,
          isValidted: true,
          label: 'Last Name',
          controller: lastName,
        ),
        if (form['gender'] == 'true')
          DropDownWidget(
            isEdit: true,
            selected: gender,
            items: ['Male', 'Female'],
            title: 'Gender',
            callBack: (p0) {
              setState(() {
                gender = p0;
              });
            },
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
        if (form['bloodGroup'] == 'true')
          DropDownWidget(
              isEdit: true,
              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
              title: 'Blood Group',
              callBack: (p0) {
                setState(() {
                  bloodGroup = p0;
                });
              },
              selected: bloodGroup),
        // if (form['fatherName'] == 'true')
        //   TextFieldWidget(
        //     isEdit: true,
        //     label: 'Father\'s Name',
        //     controller: fatherName,
        //     isValidted: true,
        //   ),
        // if (form['motherName'] == 'true')
        //   TextFieldWidget(
        //     isEdit: true,
        //     label: 'Mother\'s Name',
        //     controller: motherName,
        //     isValidted: true,
        //   ),
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
        if (form['caste'] == 'true')
          DropDownWidget(
            isEdit: true,
            items: ['General', 'OBC', 'SC', 'ST'],
            title: 'Caste',
            callBack: (p0) {
              setState(() {
                caste = p0;
              });
            },
            selected: caste,
          ),
        if (form['subCaste'] == 'true')
          TextFieldWidget(
            isEdit: true,
            label: 'Sub-Caste',
            controller: subCaste,
          ),
        if (form['email'] == 'true')
          TextFieldWidget(
            isEdit: true,
            label: 'Email',
            controller: email,
          ),
        // if (form['fatherMobNo'] == 'true')
        //   TextFieldWidget(
        //     isEdit: true,
        //     label: 'Mobile Number(Home)',
        //     controller: fatherMobNo,
        //   ),
        if (form['perAddressLine1'] == 'true')
          TextFieldWidget(
            isEdit: true,
            label: 'Address Line 1',
            controller: perAddressLine1,
          ),

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

        if (form['rfid'] == 'true')
          TextFieldWidget(
            isEdit: true,
            label: 'RFId',
            controller: rfid,
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
          if (form['gaurdianPic'] == 'true')
            Center(
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
            ),
          SizedBox(
            height: 10,
          ),
          if (form['gaurdianRelation'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Relation with Student',
              controller: gaurdianRelation,
            ),
          if (form['gaurdianName'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Gaurdian\'s Name',
              controller: gaurdianName,
            ),
          if (form['gaurdianOccupation'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Occupation',
              controller: gaurdianOccupation,
            ),
          if (form['gaurdianMobNo'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Gaurdian\'s Mobile No.',
              controller: gaurdianMobNo,
            ),
          if (form['gaurdianWhatsApp'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Gaurdian \'s Whatsapp No.',
              controller: gaurdianWhatsApp,
            ),
          if (form['gaurdianAadhaar'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Aadhaar No.',
              controller: gaurdianAadhaar,
            )
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
          if (form['motherPic'] == 'true')
            Center(
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
            ),
          SizedBox(
            height: 10,
          ),
          if (form['motherName'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Mother\'s Name',
              controller: motherName,
            ),
          if (form['motherOccupation'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Occupation',
              controller: motherOccupation,
            ),
          if (form['motherMobNo'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Mother\'s Mobile No.',
              controller: motherMobNo,
            ),
          if (form['fatherWhatsapp'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Mother\'s Whatsapp No.',
              controller: motherWhatsApp,
            ),
          if (form['motherAadhaar'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Aadhaar No.',
              controller: motherAadhaar,
            )
        ],
      ),
    );
  }

  SizedBox firstColumn() {
    return SizedBox(
      width: 250,
      child: Wrap(
        runSpacing: 15,
        children: [
          if (form['fatherPic'] == 'true')
            Center(
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
            ),
          SizedBox(
            height: 10,
          ),
          if (form['fatherName'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Father\'s Name',
              controller: fatherName,
            ),
          if (form['fatherOccupation'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Occupation',
              controller: fatherOccupation,
            ),
          if (form['fatherMobNo'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Father\'s Mobile No.',
              controller: fatherMobNo,
            ),
          if (form['fatherWhatsapp'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Father\'s Whatsapp No.',
              controller: fatherWhatsApp,
            ),
          if (form['fatherAadhaar'] == 'true')
            TextFieldWidget(
              isEdit: true,
              label: 'Aadhaar No.',
              controller: fatherAadhaar,
            )
        ],
      ),
    );
  }
}
