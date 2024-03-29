import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../ip_address.dart';

class EachStudentPage extends StatefulWidget {
  const EachStudentPage(
      {super.key, required this.schoolCode, required this.admNo});
  final String schoolCode;
  final String admNo;

  @override
  State<EachStudentPage> createState() => _EachStudentPageState();
}

class _EachStudentPageState extends State<EachStudentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController admNo = TextEditingController();
  TextEditingController subCaste = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController rfid = TextEditingController();
  TextEditingController session = TextEditingController();

  TextEditingController schoolHosuse = TextEditingController();
  TextEditingController address = TextEditingController();
  // TextEditingController  = TextEditingController();

  TextEditingController vehicleNo = TextEditingController();
  TextEditingController fatherName = TextEditingController();

  TextEditingController fatherMobNo = TextEditingController();
  TextEditingController fatherWhatsapp = TextEditingController();

  // TextEditingController fatherPic = TextEditingController();
  // TextEditingController motherPic = TextEditingController();
  // TextEditingController studentPic = TextEditingController();

  TextEditingController motherName = TextEditingController();

  TextEditingController motherMobNo = TextEditingController();
  TextEditingController motherWhatsapp = TextEditingController();
  List boardingDropdownList = ['Day Scholer', 'Hostel'];
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
  List classDropdownList = [];
  String? religion;
  String? caste;
  String? schoolHouse;
  String? boardingType;
  String? classNo;
  String? gender;
  String? dob;
  String? bloodGroup;
  String? transportMode;

  bool isEdit = false;
  Map form = {};
  bool getAll = false;
  bool opacity = false;
  Uint8List? _imagebytes;
  PlatformFile? _image;
  Map oneStudent = {};
  late Future _getProfilePic;

  getFormAccessStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessStudentMid/${widget.schoolCode}');
    var res = await client.get(url);

    Map data = jsonDecode(res.body);
    // Map form = data['studentForm'];
    print(data);
    form = data['studentFormMid'];

    setState(() {
      getAll = true;
    });
  }

  getOneStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url =
        Uri.parse('$ipv4/getOneStudent/${widget.schoolCode}/${widget.admNo}');
    var res = await client.get(url);

    Map data = jsonDecode(res.body);

    print(data);
    firstName.text = data['firstName'];
    lastName.text = data['lastName'];
    fatherName.text = data['fatherName'];
    motherName.text = data['motherName'];
    classNo = data['classTitle'] == '' ? null : data['classTitle'];
    gender = data['gender'] == '' ? null : data['gender'];
    dob = data['dob'];
    admNo.text = data['admNo'];

    bloodGroup = data['bloodGroup'] == '' ? null : data['bloodGroup'];

    // religion = data['religion'] == '' ? null : data['religion'];
    caste = data['caste'] == '' ? null : data['caste'];
    subCaste.text = data['subCaste'];
    email.text = data['email'];
    fatherMobNo.text = data['fatherMobNo'].toString();

    boardingType = data['boardingType'] == '' ? null : data['boardingType'];
    // schoolHouse = data['schoolHouse'] == '' ? null : data['schoolHouse'];

    vehicleNo.text = data['vehicleNo'];
    transportMode = data['transportMode'];

    rfid.text = data['rfid'] == '' ? null : data['rfid'];
    // address.text = data['address'];
    // session.text = data['session'] == '' ? null : data['session'];

    getFormAccessStudent();
  }

  getProfilePic() async {
    var url2 = Uri.parse(
        '$ipv4/getProfilePicMid/${widget.schoolCode}/${widget.admNo}');
    var client = BrowserClient()..withCredentials = true;
    var response2 = await client.get(url2);

    return (response2.bodyBytes);
  }

  saveStudentPic() async {
    var url = Uri.parse('$ipv4/saveStudentPicMid');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    var httpImage = http.MultipartFile.fromBytes(
      'profilePic',
      _imagebytes!,
      filename:
          '${widget.schoolCode}_${admNo.text.trim()}_${firstName.text.trim()}_${lastName.text.trim()}.${_image!.extension}',
    );
    req.files.add(httpImage);
    req.fields.addAll({'admNo': widget.admNo, 'schoolCode': widget.schoolCode});
    var res = await req.send();
    var responded = await http.Response.fromStream(res);
    if (responded.body == 'true') {
      _getProfilePic = getProfilePic();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            content: const Row(
              children: [
                Text(
                  'Profile Picture Updated Sucessfully',
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

  saveStudentInfo() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/updateStudentInfoMid');
    var res = await client.post(url, body: {
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'admNo': admNo.text.trim(),
      'subCaste': subCaste.text.trim(),
      'email': email.text.trim(),
      'rfid': rfid.text.trim(),
      'session': session.text.trim(),
      'schoolHosuse': schoolHosuse.text.trim(),
      'address': address.text.trim(),
      'vehicleNo': vehicleNo.text.trim(),
      'fatherName': fatherName.text.trim(),
      'fatherMobNo': fatherMobNo.text.trim(),
      'fatherWhatsapp': fatherWhatsapp.text.trim(),
      'motherName': motherName.text.trim(),
      'motherMobNo': motherMobNo.text.trim(),
      'motherWhatsapp': motherWhatsapp.text.trim(),
      'religion': religion ?? '',
      'caste': caste ?? '',
      'boardingType': boardingType ?? '',
      'classTitle': classNo ?? '',
      'gender': gender ?? '',
      'dob': dob ?? '',
      'bloodGroup': bloodGroup ?? '',
      'transportMode': transportMode ?? '',
      'schoolCode': widget.schoolCode,
    });
    if (res.body == 'true') {
      _getProfilePic = getProfilePic();
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
    getOneStudent();
    _getProfilePic = getProfilePic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        elevation: 0,
      ),
      body: getAll
          ? Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                          onHover: (value) {
                            setState(() {
                              opacity = value;
                            });
                          },
                          onTap: !isEdit
                              ? () {}
                              : () async {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.image);
                                  if (result != null) {
                                    _image = result.files.first;
                                    _imagebytes = _image!.bytes;
                                    // profileStatus = true;
                                    saveStudentPic();

                                    // setState(() {
                                    // });
                                  }
                                },
                          child: Stack(
                            children: [
                              FutureBuilder(
                                future: _getProfilePic,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      onForegroundImageError:
                                          (exception, stackTrace) =>
                                              Text('data'),
                                      child: Icon(
                                        Icons.account_circle,
                                        size: 100,
                                      ),
                                      radius: 50,
                                      foregroundImage: MemoryImage(
                                          snapshot.data as Uint8List),
                                    );
                                  } else {
                                    return Icon(Icons.error_outline_rounded);
                                  }
                                },
                              ),
                              // _imagebytes == null
                              //     ? Icon(
                              //         color: Colors.grey,
                              //         Icons.account_circle_rounded,
                              //         size: 100,
                              //       )
                              //     : CircleAvatar(
                              //         radius: 50,
                              //         backgroundImage: MemoryImage(
                              //           _imagebytes!,
                              //           //  fit: BoxFit.contain,
                              //         ),
                              //       ),
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Wrap(
                            runSpacing: 20,
                            spacing: 20,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (form['classTitle'] == 'true')
                                MidDropDownWidget(
                                  isEdit: isEdit,
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

                              MidTextField(
                                isEdit: isEdit,
                                isValidted: true,
                                label: 'Admission No.',
                                controller: admNo,
                              ),

                              if (form['session'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Session',
                                  controller: session,
                                ),
                              MidTextField(
                                isEdit: isEdit,
                                isValidted: true,
                                label: 'First Name + Middle Name',
                                controller: firstName,
                              ),
                              MidTextField(
                                isEdit: isEdit,
                                isValidted: true,
                                label: 'Last Name',
                                controller: lastName,
                              ),
                              if (form['gender'] == 'true')
                                MidDropDownWidget(
                                  isEdit: isEdit,
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
                                MidDateSelectWidget(
                                  isEdit: isEdit,
                                  title: 'Date of Birth',
                                  selectedDate: dob,
                                  callBack: (p0) {
                                    setState(() {
                                      dob = p0;
                                    });
                                  },
                                ),
                              if (form['bloodGroup'] == 'true')
                                MidDropDownWidget(
                                    isEdit: isEdit,
                                    items: [
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
                              if (form['fatherName'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Father\'s Name',
                                  controller: fatherName,
                                  isValidted: true,
                                ),
                              if (form['fatherMobNo'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Father\'s Mobile No.',
                                  controller: fatherMobNo,
                                ),
                              if (form['fatherWhatsapp'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Father\'s Whatsapp No.',
                                  controller: fatherWhatsapp,
                                ),
                              if (form['motherName'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Mother\'s Name',
                                  controller: motherName,
                                  isValidted: true,
                                ),
                              if (form['motherMobNo'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Mother\'s Mobile No.',
                                  controller: motherMobNo,
                                ),
                              if (form['motherWhatsapp'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Mother\'s Whatsapp No.',
                                  controller: motherWhatsapp,
                                ),
                              if (form['religion'] == 'true')
                                MidDropDownWidget(
                                  isEdit: isEdit,
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
                                MidDropDownWidget(
                                  isEdit: isEdit,
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
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Sub-Caste',
                                  controller: subCaste,
                                ),
                              if (form['email'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Email',
                                  controller: email,
                                ),
                              if (form['address'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'Address',
                                  controller: address,
                                ),

                              if (form['boardingType'] == 'true')
                                MidDropDownWidget(
                                    isEdit: isEdit,
                                    items: boardingDropdownList,
                                    title: 'Boarding Type',
                                    callBack: (p0) {
                                      setState(() {
                                        boardingType = p0;
                                      });
                                    },
                                    selected: boardingType),

                              if (form['transportMode'] == 'true')
                                MidDropDownWidget(
                                    isEdit: isEdit,
                                    items: [
                                      'Pedistrian',
                                      'Parent',
                                      'School Transport',
                                      'Cycle',
                                      'Other'
                                    ],
                                    title: 'Transport Mode',
                                    callBack: (p0) {
                                      setState(() {
                                        transportMode = p0;
                                      });
                                    },
                                    selected: transportMode),

                              if (form['vehicleNo'] == 'true')
                                MidTextField(
                                    label: 'Vehicle No.',
                                    controller: vehicleNo,
                                    isEdit: isEdit),
                              if (form['rfid'] == 'true')
                                MidTextField(
                                  isEdit: isEdit,
                                  label: 'RFId',
                                  controller: rfid,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isEdit)
                        Column(
                          children: [
                            IconButton(
                              color: Colors.indigo,
                              onPressed: () {
                                setState(() {
                                  isEdit = true;
                                });
                              },
                              icon: Icon(Icons.edit_square),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            )
                          ],
                        ),
                      if (isEdit)
                        Column(
                          children: [
                            IconButton(
                              color: Colors.green[600],
                              onPressed: saveStudentInfo,
                              icon: Icon(Icons.save_outlined),
                            ),
                            Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            )
                          ],
                        ),
                      Column(
                        children: [
                          IconButton(
                              color: Colors.red[600],
                              onPressed: () {},
                              icon: Icon(Icons.delete)),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                              color: Colors.indigo,
                              onPressed: () {},
                              icon: Icon(Icons.close)),
                          Text(
                            'Unchecked',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class MidTextField extends StatelessWidget {
  const MidTextField(
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
    return TextFormField(
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
    );
  }
}

class MidDropDownWidget extends StatelessWidget {
  const MidDropDownWidget({
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
    return Stack(
      children: [
        IgnorePointer(
          ignoring: !isEdit,
          child: Container(
            margin: EdgeInsets.only(top: 3),
            alignment: AlignmentDirectional.center,
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
    );
  }
}

class MidDateSelectWidget extends StatelessWidget {
  const MidDateSelectWidget({
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
    return MouseRegion(
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
          child: InputDecorator(
            decoration: InputDecoration(
                isDense: true,
                labelText: selectedDate == null ? null : title,
                border: OutlineInputBorder()),
            child: selectedDate == null
                ? Text(title,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600))
                : Text(
                    selectedDate!,
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}
