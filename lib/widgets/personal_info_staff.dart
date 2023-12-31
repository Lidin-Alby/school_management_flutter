import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';
import 'package:school_management/widgets/search_bar_widget.dart';

import 'date_select_widget.dart';
import 'dropdown_widget.dart';
import 'textfield_widget.dart';

class PersonalInfoStaff extends StatefulWidget {
  const PersonalInfoStaff(
      {super.key,
      required this.callback,
      required this.isEdit,
      required this.mob,
      this.isDriver = false});
  final Function(dynamic) callback;
  final String mob;
  final bool isEdit;
  final bool isDriver;

  @override
  State<PersonalInfoStaff> createState() => _PersonalInfoStaffState();
}

class _PersonalInfoStaffState extends State<PersonalInfoStaff> {
  final _formKey = GlobalKey<FormState>();

  List designationDropdownList = [];
  List roleDropdownList = [];
  List departmentDropDownList = [];
  // List reportsToDropdownList = [];
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
  String? joiningDate;
  TextEditingController reportsTo = TextEditingController();
  String? department;
  String? role;
  String? designation;
  String? gender;
  String? dob;
  String? bloodGroup;
  String? religion;
  String? caste;

  late String schoolCode;

  TextEditingController wardInSchool = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController rfid = TextEditingController();
  TextEditingController mob = TextEditingController();
  TextEditingController fatherOrHusName = TextEditingController();
  TextEditingController qualification = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController subCaste = TextEditingController();
  List searchList = [];
  List allWard = [];
  Uint8List? _staffImagebytes;
  PlatformFile? _staffImage;
  bool isSaved = true;
  bool next = false;
  bool opacity = false;
  late bool isEdit;
  @override
  void initState() {
    mob.text = widget.mob;
    isEdit = widget.isEdit;
    getStaffFormDetails();
    if (!widget.isEdit) {
      getStaffPersonalInfo();
    }

    super.initState();
  }

  //functions
  getStaffProfilePic() async {
    print('staff profile pic');
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getStaffProfilePic/${mob.text}');
    var response = await client.get(url);

    if (response.body == 'false') {
      _staffImagebytes = null;
    } else {
      setState(() {
        _staffImagebytes = response.bodyBytes;
      });
    }
  }

  getStaffPersonalInfo() async {
    getStaffProfilePic();
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getStaffPersonalInfo/${mob.text}');

    var response = await client.get(url);
    print(response.body);
    Map data = jsonDecode(response.body);
    schoolCode = data['schoolCode'].toString();
    joiningDate = data['joiningDate'];
    reportsTo.text = data['reportsTo'];
    department = data['department'] == '' ? null : data['department'];
    role = data['role'] == '' ? null : data['role'];
    designation = data['designation'] == '' ? null : data['designation'];
    gender = data['gender'] == '' ? null : data['gender'];
    dob = data['dob'];
    bloodGroup = data['bloodGroup'] == '' ? null : data['bloodGroup'];
    allWard = data['wardInSchool'] == ""
        ? data['wardInSchool']
        : jsonDecode(data['wardInSchool']);
    firstName.text = data['firstName'];
    lastName.text = data['lastName'];
    email.text = data['email'];
    rfid.text = data['rfid'];
    mob.text = data['mob'];
    fatherOrHusName.text = data['fatherOrHusName'];
    qualification.text = data['qualification'];
    experience.text = data['experience'];
    password.text = data['password'];
    religion = data['religion'] == '' ? null : data['religion'];
    caste = data['caste'] == '' ? null : data['caste'];
    subCaste.text = data['subCaste'];
    setState(() {});
  }

  getStaffFormDetails() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getStaffFormDetails');

    var response = await client.get(url);
    print(response.body);
    Map details = jsonDecode(response.body);
    print(details);
    if (widget.isDriver) {
      roleDropdownList = ['driver'];
      // role = 'driver';
    } else {
      roleDropdownList = details['userType'];
    }
    schoolCode = details['schoolCode'];
    getStaffForms();
  }

  getStaffForms() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/staffForms');
    var response = await client.get(url);
    print(response.body);
    Map details = jsonDecode(response.body);
    designationDropdownList = details['forms']['designations'];
    departmentDropDownList = details['forms']['departments'];
    setState(() {});
  }

  savePersonalInfoStaff() async {
    // print(_staffImagebytes);
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaved = false;
      });
      var url = Uri.http(ipv4,
          widget.isEdit ? '/addPersonalInfoStaff' : 'updatePersonalInfoStaff');
      var req = http.MultipartRequest(
        'POST',
        url,
      );

      if (_staffImagebytes == null) {
        req.fields['staffProfilePic'] = '';
      } else if (_staffImage != null) {
        var httpImage = http.MultipartFile.fromBytes(
          'staffProfilePic',
          _staffImagebytes!,
          filename: '${mob.text}-staff-Profile-Pic.${_staffImage!.extension}',
        );
        req.files.add(httpImage);
      }

      req.fields.addAll({
        'schoolCode': schoolCode.toString(),
        'joiningDate': joiningDate == null ? '' : joiningDate.toString(),
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'gender': gender ?? '',
        'dob': dob == null ? '' : dob.toString(),
        'bloodGroup': bloodGroup ?? '',
        'religion': religion ?? '',
        'caste': caste ?? '',
        'subCaste': subCaste.text.trim(),
        'mob': mob.text.trim(),
        'reportsTo': reportsTo.text.trim(),
        'department': department ?? '',
        'role': role ?? '',
        'rfid': rfid.text.trim(),
        'designation': designation ?? '',
        'wardInSchool': jsonEncode(allWard),
        'email': email.text.trim(),
        'fatherOrHusName': fatherOrHusName.text.trim(),
        'qualification': qualification.text.trim(),
        'experience': experience.text.trim(),
        'password': password.text.trim(),
      });

      var res = await req.send();
      var responded = await http.Response.fromStream(res);

      if (responded.body == 'true') {
        setState(() {
          isSaved = true;
          if (widget.isEdit) {
            next = true;
          }
          if (!widget.isEdit) {
            isEdit = false;
          }
        });
      }
    }
  }

  searchFunction(value) async {
    if (value != '') {
      // setState(() {
      //   searching = true;
      // });

      var client = BrowserClient()..withCredentials = true;
      var url = Uri.http(ipv4, '/searchStudent/$value');
      var res = await client.get(url);

      setState(() {
        // searching = false;
        searchList = jsonDecode(res.body);
      });
    } else {
      setState(() {
        searchList = [];
      });
    }
  }

  //end of functions

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            if (!isEdit)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: CircleBorder(), padding: EdgeInsets.all(15)),
                  onPressed: () {
                    setState(() {
                      isEdit = true;
                    });
                  },
                  child: Icon(Icons.edit_outlined),
                ),
              ),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 250,
                  height: 100,
                  // color: Colors.cyan,
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
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            _staffImage = result!.files.first;
                            setState(() {
                              _staffImagebytes = _staffImage!.bytes;
                            });
                          },
                    child: Stack(
                      children: [
                        _staffImagebytes == null
                            ? Icon(
                                color: Colors.grey,
                                Icons.account_circle_rounded,
                                size: 100,
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: MemoryImage(
                                  _staffImagebytes!,
                                  //  fit: BoxFit.contain,
                                ),
                              ),
                        if (opacity)
                          CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.black.withOpacity(.60)),
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
                Stack(
                  children: [
                    IgnorePointer(
                      ignoring: !isEdit,
                      child: Container(
                        margin: EdgeInsets.only(top: 3),
                        alignment: AlignmentDirectional.center,
                        width: 250,
                        height: 43,
                        // margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton(
                          padding: EdgeInsets.fromLTRB(10, 4, 40, 4),
                          disabledHint: designation != null
                              ? Text(
                                  designation.toString(),
                                  style: TextStyle(color: Colors.black),
                                )
                              : Text(
                                  'Designation',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                          value: designation,
                          isExpanded: true,
                          underline: Text(''),
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text('Designation'),
                          ),
                          items: designationDropdownList
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              designation = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    if (designation != null)
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        color: Colors.blue[50],
                        child: Text(
                          'Designation',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: SizedBox(
                        width: 35,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0, padding: EdgeInsets.all(2)),
                            onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => AddDesignation(
                                      designationDropdownList:
                                          designationDropdownList,
                                      schoolCode: schoolCode,
                                      refresh: () => getStaffForms(),
                                    )),
                            child: Icon(Icons.add)),
                      ),
                    )
                  ],
                ),
                Stack(
                  children: [
                    IgnorePointer(
                      ignoring: !isEdit,
                      child: Container(
                        margin: EdgeInsets.only(top: 3),
                        alignment: AlignmentDirectional.center,
                        width: 250,
                        height: 43,
                        // margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton(
                          padding: EdgeInsets.fromLTRB(10, 4, 40, 4),
                          disabledHint: role != null
                              ? Text(
                                  role.toString(),
                                  style: TextStyle(color: Colors.black),
                                )
                              : Text(
                                  'Role',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                          value: role,
                          isExpanded: true,
                          underline: Text(''),
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text('Role'),
                          ),
                          items: roleDropdownList
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              role = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    if (role != null)
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        color: Colors.blue[50],
                        child: Text(
                          'Role',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: SizedBox(
                        width: 35,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0, padding: EdgeInsets.all(2)),
                            onPressed: () =>
                                context.go('/accessControl', extra: true),
                            child: Icon(Icons.add)),
                      ),
                    )
                  ],
                ),
                Stack(
                  children: [
                    IgnorePointer(
                      ignoring: !isEdit,
                      child: Container(
                        margin: EdgeInsets.only(top: 3),
                        alignment: AlignmentDirectional.center,
                        width: 250,
                        height: 43,
                        // margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton(
                          padding: EdgeInsets.fromLTRB(10, 4, 40, 4),
                          disabledHint: department != null
                              ? Text(
                                  department.toString(),
                                  style: TextStyle(color: Colors.black),
                                )
                              : Text(
                                  'Department',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                          value: department,
                          isExpanded: true,
                          underline: Text(''),
                          hint: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text('Department'),
                          ),
                          items: departmentDropDownList
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              department = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                    if (department != null)
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        color: Colors.blue[50],
                        child: Text(
                          'Department',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                      ),
                    Positioned(
                      top: 10,
                      right: 5,
                      child: SizedBox(
                        width: 35,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0, padding: EdgeInsets.all(2)),
                            onPressed: () => showModalBottomSheet(
                                context: context,
                                builder: (context) => AddDepartment(
                                      departmentDropDownList:
                                          departmentDropDownList,
                                      schoolCode: schoolCode,
                                      refresh: () => getStaffForms(),
                                    )),
                            child: Icon(Icons.add)),
                      ),
                    )
                  ],
                ),
                SearchBarWidget(
                    isEdit: isEdit,
                    controller: reportsTo,
                    label: 'Reports To (Staff)',
                    isMob: true),
                DateSelectWidget(
                  isEdit: isEdit,
                  title: 'Joining Date',
                  selectedDate: joiningDate,
                  callBack: (p0) {
                    setState(() {
                      joiningDate = p0;
                    });
                  },
                ),
                TextFieldWidget(
                  isEdit: isEdit,
                  isValidted: true,
                  label: 'First Name + Middle Name',
                  controller: firstName,
                ),
                TextFieldWidget(
                  isEdit: isEdit,
                  isValidted: true,
                  label: 'Last Name',
                  controller: lastName,
                ),
                DropDownWidget(
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
                DateSelectWidget(
                  isEdit: isEdit,
                  title: 'Date of Birth',
                  selectedDate: dob,
                  callBack: (p0) {
                    setState(() {
                      dob = p0;
                    });
                  },
                ),
                DropDownWidget(
                  isEdit: isEdit,
                  items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                  title: 'Blood Group',
                  callBack: (p0) {
                    setState(() {
                      bloodGroup = p0;
                    });
                  },
                  selected: bloodGroup,
                ),
                DropDownWidget(
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
                DropDownWidget(
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
                TextFieldWidget(
                  isEdit: isEdit,
                  label: 'Sub-Caste',
                  controller: subCaste,
                ),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    readOnly: !isEdit,
                    controller: password,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.indigo),
                          //   splashRadius: 25,
                          child: Icon(Icons.refresh_rounded),
                          onPressed: () {
                            const chars =
                                'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@#%!*';

                            setState(() {
                              password.text = String.fromCharCodes(
                                Iterable.generate(
                                  6,
                                  (_) => chars.codeUnitAt(
                                    Random().nextInt(chars.length),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                      ),
                      isDense: true,
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                TextFieldWidget(
                  isEdit: isEdit,
                  label: 'Email',
                  controller: email,
                ),
                TextFieldWidget(
                  isEdit: isEdit,
                  label: 'RFId',
                  controller: rfid,
                ),
                TextFieldWidget(
                  isEdit: isEdit,
                  isValidted: true,
                  label: 'Mobile Number',
                  controller: mob,
                ),
                TextFieldWidget(
                  isEdit: isEdit,
                  label: 'Qualification',
                  controller: qualification,
                ),
                TextFieldWidget(
                  isEdit: isEdit,
                  label: 'Work Experience',
                  controller: experience,
                ),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    TextFieldWidget(
                      isEdit: isEdit,
                      label: 'Father/Husband Name',
                      controller: fatherOrHusName,
                    ),
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          width: 850,
                          // color: Colors.red,
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 250,
                                child: TextFormField(
                                  onChanged: (value) => searchFunction(value),
                                  readOnly: !isEdit,
                                  controller: wardInSchool,
                                  decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.search),
                                    isDense: true,
                                    label: Text('Ward in School'),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 80,
                                width: 250,
                                child: Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: [
                                    for (int i = 0; i < allWard.length; i++)
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(allWard[i]),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            SizedBox(
                                              height: 15,
                                              width: 15,
                                              child: IconButton(
                                                  splashRadius: 10,
                                                  padding: EdgeInsets.zero,
                                                  iconSize: 15,
                                                  onPressed: () {
                                                    setState(() {
                                                      allWard
                                                          .remove(allWard[i]);
                                                    });
                                                  },
                                                  icon: Icon(
                                                      Icons.close_rounded)),
                                            )
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 45,
                          child: Card(
                            elevation: 5,
                            child: Container(
                              constraints: BoxConstraints(maxHeight: 75),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (var result in searchList)
                                      InkWell(
                                        onTap: () {
                                          // setState(() {
                                          String sib =
                                              '${result['fullName']} - ${result['admNo']}';
                                          allWard.add(sib);
                                          wardInSchool.clear();
                                          setState(() {
                                            searchList = [];
                                          });
                                          // });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 8),
                                          width: 240,
                                          child: Text(
                                              '${result['fullName']} - ${result['admNo']}'),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (isEdit && isSaved)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        onPressed: widget.isEdit
                            ? () {
                                Navigator.of(context).pop();
                              }
                            : () {
                                setState(() {
                                  isEdit = false;
                                });
                              },
                        child: Text('Cancel')),
                    SizedBox(
                      width: 10,
                    ),
                    next
                        ? ElevatedButton(
                            onPressed: () {
                              widget.callback(mob.text);
                            },
                            child: Text('Next'),
                          )
                        : ElevatedButton(
                            onPressed: savePersonalInfoStaff,
                            child: Text('Save'),
                          ),
                  ],
                ),
              ),
            if (!isSaved)
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    // color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AddDesignation extends StatefulWidget {
  const AddDesignation(
      {super.key,
      required this.designationDropdownList,
      required this.schoolCode,
      required this.refresh});
  final List designationDropdownList;
  final String schoolCode;
  final VoidCallback refresh;

  @override
  State<AddDesignation> createState() => _AddDesignationState();
}

class _AddDesignationState extends State<AddDesignation> {
  TextEditingController newDesignation = TextEditingController();
  List designationDropdownList = [];
  @override
  void initState() {
    designationDropdownList = widget.designationDropdownList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Add Designation',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 250,
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: designationDropdownList
                .map((e) => Tooltip(
                      message: 'Remove',
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          var client = BrowserClient()..withCredentials = true;
                          var url = Uri.http(ipv4, '/removeDesignation');
                          var res = await client.delete(url, body: {
                            'schoolCode': widget.schoolCode.toString(),
                            'designation': e
                          });

                          if (res.body == 'true') {
                            print('department removed');
                            setState(() {
                              designationDropdownList.remove(e);
                              newDesignation.clear();
                              widget.refresh();
                            });
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.close,
                              // color: Colors.grey,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextFieldWidget(
          label: 'New Designation',
          controller: newDesignation,
          isEdit: true,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            var client = BrowserClient()..withCredentials = true;
            var url = Uri.http(ipv4, '/addDesignation');
            var res = await client.post(url, body: {
              'schoolCode': widget.schoolCode.toString(),
              'designation': newDesignation.text.trim()
            });

            if (res.body == 'true') {
              print('designation added');

              setState(() {
                designationDropdownList.add(newDesignation.text.trim());
                newDesignation.clear();
                widget.refresh();
              });
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class AddDepartment extends StatefulWidget {
  const AddDepartment(
      {super.key,
      required this.departmentDropDownList,
      required this.schoolCode,
      required this.refresh});
  final List departmentDropDownList;
  final String schoolCode;
  final VoidCallback refresh;

  @override
  State<AddDepartment> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  TextEditingController newDepartment = TextEditingController();
  List departmentDropDownList = [];
  @override
  void initState() {
    departmentDropDownList = widget.departmentDropDownList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          'Add Department',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 250,
          child: Wrap(
            runSpacing: 10,
            spacing: 10,
            children: departmentDropDownList
                .map((e) => Tooltip(
                      message: 'Remove',
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          var client = BrowserClient()..withCredentials = true;
                          var url = Uri.http(ipv4, '/removeDepartment');
                          var res = await client.delete(url, body: {
                            'schoolCode': widget.schoolCode.toString(),
                            'department': e
                          });

                          if (res.body == 'true') {
                            print('department removed');
                            setState(() {
                              departmentDropDownList.remove(e);
                              newDepartment.clear();
                              widget.refresh();
                            });
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.close,
                              // color: Colors.grey,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextFieldWidget(
          label: 'New Department',
          controller: newDepartment,
          isEdit: true,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            var client = BrowserClient()..withCredentials = true;
            var url = Uri.http(ipv4, '/addDepartment');
            var res = await client.post(url, body: {
              'schoolCode': widget.schoolCode.toString(),
              'department': newDepartment.text.trim()
            });

            if (res.body == 'true') {
              print('department added');
              setState(() {
                departmentDropDownList.add(newDepartment.text.trim());
                newDepartment.clear();
                widget.refresh();
              });
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
