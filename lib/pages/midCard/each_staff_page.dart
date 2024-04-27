import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../ip_address.dart';

class EachStaffPage extends StatefulWidget {
  const EachStaffPage(
      {super.key,
      required this.schoolCode,
      required this.mob,
      required this.isTeacher,
      required this.refresh});
  final String schoolCode;
  final String mob;
  final bool isTeacher;
  final VoidCallback refresh;

  @override
  State<EachStaffPage> createState() => _EachStaffPageState();
}

class _EachStaffPageState extends State<EachStaffPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController subCaste = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController fatherOrHusName = TextEditingController();
  TextEditingController aadhaarNo = TextEditingController();
  TextEditingController panNo = TextEditingController();
  TextEditingController dlNo = TextEditingController();
  TextEditingController rfid = TextEditingController();
  TextEditingController address = TextEditingController();
  String? joiningDate;
  String? gender;
  String? dob;
  String? bloodGroup;
  String? religion;
  String? caste;
  String? dlValidity;

  late Future _getProfilePic;
  Uint8List? _staffImagebytes;
  PlatformFile? _staffImage;
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

  bool isEdit = false;
  bool getAll = false;
  bool opacity = false;
  Map form = {};

  getFormAccessStaff() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessStaffMid/${widget.schoolCode}');
    var res = await client.get(url);

    Map data = jsonDecode(res.body);
    // Map form = data['studentForm'];
    print(data);
    form = data['staffFormMid'];

    setState(() {
      getAll = true;
    });
  }

  getFormAccessTeacher() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessTeacherMid/${widget.schoolCode}');
    var res = await client.get(url);

    print('done');
    print(res.body);
    Map data = jsonDecode(res.body);
    form = data['teacherFormMid'];
    setState(() {
      getAll = true;
    });
  }

  getOneStaff() async {
    print('helllo');
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getOneStaff/${widget.schoolCode}/${widget.mob}');
    var res = await client.get(url);

    Map data = jsonDecode(res.body);
    print(res.body);

    firstName.text = data['firstName'];
    lastName.text = data['lastName'];
    mob.text = data['mob'];
    subCaste.text = data['subCaste'];
    email.text = data['email'];
    rfid.text = data['rfid'];
    address.text = data['address'];
    fatherOrHusName.text = data['fatherOrHusName'];
    religion = data['religion'] == '' ? null : data['religion'];
    caste = data['caste'] == '' ? null : data['caste'];
    gender = data['gender'] == '' ? null : data['gender'];
    dob = data['dob'];
    bloodGroup = data['bloodGroup'] == '' ? null : data['bloodGroup'];
    qualification.text = data['qualification'];
    panNo.text = data['panNo'];
    dlValidity = data['dob'];
    aadhaarNo.text = data['aadhaarNo'];

    if (widget.isTeacher) {
      getFormAccessTeacher();
    } else {
      getFormAccessStaff();
    }
  }

  getProfilePic() async {
    var url2 =
        Uri.parse('$ipv4/getStaffPicMid/${widget.schoolCode}/${widget.mob}');
    var client = BrowserClient()..withCredentials = true;
    var response2 = await client.get(url2);

    return (response2.bodyBytes);
  }

  saveStaffPic() async {
    var url = Uri.parse('$ipv4/saveStaffPicMid');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    var httpImage = http.MultipartFile.fromBytes(
      'profilePic',
      _staffImagebytes!,
      filename: '${mob.text}-staff-Profile-Pic.${_staffImage!.extension}',
    );
    req.files.add(httpImage);
    req.fields.addAll({'mob': widget.mob, 'schoolCode': widget.schoolCode});
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

  saveStaffInfo() async {
    if (_formKey.currentState!.validate()) {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/updateStaffInfoMid');
      var res = await client.post(url, body: {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'mob': mob.text.trim(),
        'subCaste': subCaste.text.trim(),
        'email': email.text.trim(),
        'rfid': rfid.text.trim(),
        'address': address.text.trim(),
        'fatherOrHusName': fatherOrHusName.text.trim(),
        'religion': religion ?? '',
        'caste': caste ?? '',
        'gender': gender ?? '',
        'dob': dob ?? '',
        'bloodGroup': bloodGroup ?? '',
        'qualification': qualification.text.trim(),
        'panNo': panNo.text.trim(),
        'dlValidity': dlValidity ?? '',
        'dlNo': dlNo.text.trim(),
        'aadhaarNo': aadhaarNo.text.trim(),
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
  }

  @override
  void initState() {
    getOneStaff();
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
                                    _staffImage = result.files.first;
                                    _staffImagebytes = _staffImage!.bytes;
                                    // profileStatus = true;
                                    saveStaffPic();

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
                      child: Form(
                        key: _formKey,
                        child: Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (form['joiningDate'] == 'true')
                              MidDateSelectWidget(
                                isEdit: isEdit,
                                title: 'Joining Date',
                                selectedDate: joiningDate,
                                callBack: (p0) {
                                  setState(() {
                                    joiningDate = p0;
                                  });
                                },
                              ),
                            MidTextField(
                              isEdit: isEdit,
                              isValidted: true,
                              label: 'First Name + Middle Name',
                              controller: firstName,
                            ),
                            MidTextField(
                              isEdit: isEdit,
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
                                selected: bloodGroup,
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
                            if (form['rfid'] == 'true')
                              MidTextField(
                                isEdit: isEdit,
                                label: 'RFId',
                                controller: rfid,
                              ),
                            MidTextField(
                              isEdit: isEdit,
                              isValidted: true,
                              label: 'Mobile Number',
                              controller: mob,
                            ),
                            if (form['qualification'] == 'true')
                              MidTextField(
                                isEdit: isEdit,
                                label: 'Qualification',
                                controller: qualification,
                              ),
                            if (form['fatherorHusName'] == 'true')
                              MidTextField(
                                isEdit: isEdit,
                                label: 'Father/Husband Name',
                                controller: fatherOrHusName,
                              ),
                            if (form['address'] == 'true')
                              MidTextField(
                                  label: 'Address',
                                  controller: address,
                                  isEdit: isEdit),
                            if (form['aadhaarNo'] == 'true')
                              MidTextField(
                                  label: 'Aadhaar No.',
                                  controller: aadhaarNo,
                                  isEdit: isEdit),
                            if (form['panNo'] == 'true')
                              MidTextField(
                                label: 'Pan No.',
                                controller: panNo,
                                isEdit: isEdit,
                              ),
                            if (form['dlNo'] == 'true')
                              MidTextField(
                                  label: 'DL No.',
                                  controller: dlNo,
                                  isEdit: isEdit),
                            if (form['dlValidity'] == 'true')
                              MidDateSelectWidget(
                                isEdit: isEdit,
                                title: 'DL Validity',
                                selectedDate: dlValidity,
                                callBack: (p0) {
                                  setState(() {
                                    dlValidity = p0;
                                  });
                                },
                              )
                          ],
                        ),
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
                              onPressed: saveStaffInfo,
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
                      ),
                      Column(
                        children: [
                          IconButton(
                              color: Colors.indigo,
                              onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Warning'),
                                      content: Text(
                                        'The data send to printing can\'t be edited further. Confirm before submiting.',
                                      ),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            var client = BrowserClient()
                                              ..withCredentials = true;
                                            var url =
                                                Uri.parse('$ipv4/readyStaff');
                                            var res = await client
                                                .post(url, body: {
                                              'mob': widget.mob,
                                              'schoolCode': widget.schoolCode
                                            });
                                            if (res.body == 'true') {
                                              if (mounted) {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.green[600],
                                                    behavior: SnackBarBehavior
                                                        .floating,
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
                                                widget.refresh();
                                              }
                                            }
                                          },
                                          child: Text('Submit'),
                                        )
                                      ],
                                    ),
                                  ),
                              icon: Icon(Icons.print)),
                          Text(
                            'Send print',
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
