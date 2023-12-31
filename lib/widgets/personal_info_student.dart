import 'dart:convert';
import 'dart:js_interop';

import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import 'package:school_management/ip_address.dart';
// import 'package:http_parser/http_parser.dart';

import 'date_select_widget.dart';
import 'dropdown_widget.dart';
import 'textfield_widget.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo(
      {super.key,
      required this.admNo,
      required this.callback,
      required this.isEdit});

  final String admNo;
  final Function(String) callback;
  final bool isEdit;

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  bool isSaved = true;
  bool next = false;

  Uint8List? _imagebytes;
  PlatformFile? _image;
  late String schoolCode;

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
  String? vehicleNo;
  String? pickAndDrop;
  String? schoolTransportRoute;
  String? schoolHouse;
  String? boardingType;
  String? academicYear;
  String? classNo;
  String? section;

  String? admDate;
  TextEditingController session = TextEditingController();
  TextEditingController admNo = TextEditingController();
  TextEditingController rfid = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  String? gender;
  String? dob;
  TextEditingController sibling = TextEditingController();
  TextEditingController subCaste = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fatherMobNo = TextEditingController();
  TextEditingController perAddressLine1 = TextEditingController();

  String? bloodGroup;
  TextEditingController newFieldController = TextEditingController();
  TextEditingController studentPassword = TextEditingController();
  TextEditingController parentPassword = TextEditingController();
  TextEditingController fatherName = TextEditingController();
  TextEditingController motherName = TextEditingController();

  List schoolHouseDropdownList = [];

  List schoolTransportList = [];

  List pickAndDropList = [];

  List vehicleNoList = [];
  bool opacity = false;
  late bool isEdit;
  bool profileStatus = false;
  List searchList = [];
  List allSibilings = [];

  @override
  void initState() {
    isEdit = widget.isEdit;
    admNo.text = widget.admNo;
    getFormDetails();
    if (widget.isEdit == false) {
      getStudentDetails();
    }
    super.initState();
  }

//functions
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

  getProfilePic() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getProfilePic/${admNo.text}');
    var response = await client.get(url);

    if (response.body == 'false') {
      _imagebytes = null;
    } else {
      setState(() {
        _imagebytes = response.bodyBytes;
      });
    }
  }

  Future getStudentDetails() async {
    var client = BrowserClient()..withCredentials = true;
    getProfilePic();
    Map data = {};
    var url = Uri.http(ipv4, '/getStudentUsers/${admNo.text}');

    var response = await client.get(url);
    print('dqw${response.body}');
    // Map data = jsonDecode(response.body);
    if (response.body.isEmpty) {
      return;
    } else {
      data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        firstName.text = data['firstName'];
        lastName.text = data['lastName'];
        fatherName.text = data['fatherName'];
        motherName.text = data['motherName'];
        classNo = data['classTitle'] == '' ? null : data['classTitle'];
        gender = data['gender'] == '' ? null : data['gender'];
        dob = data['dob'];
        admDate = data['admDate'];
        bloodGroup = data['bloodGroup'] == '' ? null : data['bloodGroup'];

        religion = data['religion'] == '' ? null : data['religion'];
        caste = data['caste'] == '' ? null : data['caste'];
        subCaste.text = data['subCaste'];
        email.text = data['email'];
        fatherMobNo.text = data['fatherMobNo'].toString();
        perAddressLine1.text = data['perAddressLine1'];
        boardingType = data['boardingType'] == '' ? null : data['boardingType'];
        schoolHouse = data['schoolHouse'] == '' ? null : data['schoolHouse'];
        schoolTransportRoute = data['schoolTransportRoute'] == ''
            ? null
            : data['schoolTransportRoute'];
        pickAndDrop = data['pickAndDrop'] == '' ? null : data['pickAndDrop'];
        vehicleNo = data['vehicleNo'] == '' ? null : data['vehicleNo'];
        studentPassword.text =
            data['studentPassword'] == '' ? null : data['studentPassword'];
        parentPassword.text =
            data['parentPassword'] == '' ? null : data['parentPassword'];
        rfid.text = data['rfid'] == '' ? null : data['rfid'];
        session.text = data['session'] == '' ? null : data['session'];
        allSibilings = data['sibling'] == ""
            ? data['sibling']
            : jsonDecode(data['sibling']);
      }
    }
    // return response.body;
  }

  Future getFormDetails() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getFormDetails');
    var res = await client.get(url);
    print('fooooooorms');
    print(res.body);
    Map data = jsonDecode(res.body);
    schoolCode = data['schoolCode'];

    classDropdownList = data['title'];
    schoolTransportList = data['route'];
    vehicleNoList = data['vehicle'];
    pickAndDropList = data['pickup'];
    setState(() {});
    print(classDropdownList);
  }

  savePersonalInfo() async {
    String? messagge;
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaved = false;
      });
      //   var url = Uri.http(ipv4, '/addPersonalInfo');

      var url = Uri.http(ipv4,
          widget.isEdit ? '/addPersonalInfo' : '/updateStudentPersonalInfo');

      var req = http.MultipartRequest(
        'POST',
        url,
      );

      if (_imagebytes == null) {
        req.fields['profilePic'] = '';
        // } else if (!profileStatus) {
        //   req.fields['profilePic'] = 'no change';
      } else if (!profileStatus) {
        req.fields['profilePic'] = 'null';
      } else {
        var httpImage = http.MultipartFile.fromBytes(
          'profilePic',
          _imagebytes!,
          filename:
              '${schoolCode}_${admNo.text.trim()}_${firstName.text.trim()}_${lastName.text.trim()}.${_image!.extension}',
        );
        req.files.add(httpImage);
      }

      req.fields.addAll({
        'schoolCode': schoolCode.toString(),
        'classTitle': classNo ?? '',
        'admNo': admNo.text.trim(),
        'admDate': admDate ?? '',
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'fatherName': fatherName.text.trim(),
        'motherName': motherName.text.trim(),
        'gender': gender ?? '',
        'dob': dob ?? '',
        'bloodGroup': bloodGroup ?? '',
        'sibling': jsonEncode(allSibilings),
        'religion': religion ?? '',
        'caste': caste ?? '',
        'subCaste': subCaste.text.trim(),
        'email': email.text.trim(),
        'fatherMobNo': fatherMobNo.text.trim(),
        'perAddressLine1': perAddressLine1.text.trim(),
        'studentPassword': studentPassword.text.trim(),
        'parentPassword': parentPassword.text.trim(),
        'boardingType': boardingType ?? '',
        'schoolHouse': schoolHouse ?? '',
        'schoolTransportRoute': schoolTransportRoute ?? '',
        'session': session.text.trim(),
        'rfid': rfid.text.trim(),
        'pickAndDrop': pickAndDrop ?? '',
        'vehicleNo': vehicleNo ?? '',
      });

      var res = await req.send();
      var responded = await http.Response.fromStream(res);

      // var response = await http.post(url, body: {

      //   //  'vehicleNo': vehicleNo,
      // });
      // print(response.statusCode);
      if (responded.body == 'true') {
        setState(() {
          isSaved = true;
          if (widget.isEdit) {
            next = true;
          }
          if (!widget.isEdit) {
            isEdit = false;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  Text(
                    'Updated Successfully ',
                  ),
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          );
        });
      } else {
        messagge = responded.body.toString();
        if (context.mounted) {
          if (!messagge.isNull) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[700],
                behavior: SnackBarBehavior.floating,
                content: Text(
                  messagge.toString(),
                ),
              ),
            );
          }
        }
        setState(() {
          isSaved = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          if (!isEdit)
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: CircleBorder(), padding: EdgeInsets.all(20)),
                onPressed: () {
                  setState(() {
                    isEdit = true;
                  });
                },
                child: Icon(Icons.edit_outlined),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          firstColumn(),
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
                            widget.callback(admNo.text);
                          },
                          child: Text('Next'),
                        )
                      : ElevatedButton(
                          onPressed: savePersonalInfo,
                          child: Text('Save'),
                        ),
                ],
              ),
            ),
          if (!isSaved)
            Container(
              height: 100,
              padding: EdgeInsets.only(top: 40, right: 15),
              constraints: BoxConstraints(maxWidth: 800, minWidth: 100),
              child: Align(
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
            ),
        ],
      ),
    );
  }

  Wrap firstColumn() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
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
            onTap: !isEdit
                ? () {}
                : () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      _image = result.files.first;
                      profileStatus = true;

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
        Wrap(
          runSpacing: 20,
          spacing: 20,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropDownWidget(
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
            TextFieldWidget(
              isEdit: isEdit,
              isValidted: true,
              label: 'Admission No.',
              controller: admNo,
            ),
            DateSelectWidget(
              isEdit: isEdit,
              title: 'Admission Date',
              selectedDate: admDate,
              callBack: (p0) {
                setState(() {
                  admDate = p0;
                });
              },
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Session',
              controller: session,
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
                selected: bloodGroup),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Father\'s Name',
              controller: fatherName,
              isValidted: true,
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Mother\'s Name',
              controller: motherName,
              isValidted: true,
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
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Email',
              controller: email,
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Mobile Number(Home)',
              controller: fatherMobNo,
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Address Line 1',
              controller: perAddressLine1,
            ),
            DropDownWidget(
                isEdit: isEdit,
                items: boardingDropdownList,
                title: 'Boarding Type',
                callBack: (p0) {
                  setState(() {
                    boardingType = p0;
                  });
                },
                selected: boardingType),
            DropDownWidget(
                isEdit: isEdit,
                items: schoolHouseDropdownList,
                title: 'School House',
                callBack: (p0) {
                  setState(() {
                    schoolHouse = p0;
                  });
                },
                selected: schoolHouse),
            DropDownWidget(
                isEdit: isEdit,
                items: schoolTransportList,
                title: 'School Transport Route',
                callBack: (p0) {
                  setState(() {
                    schoolTransportRoute = p0;
                  });
                },
                selected: schoolTransportRoute),
            DropDownWidget(
                isEdit: isEdit,
                items: pickAndDropList,
                title: 'Pick And Drop Location',
                callBack: (p0) {
                  setState(() {
                    pickAndDrop = p0;
                  });
                },
                selected: pickAndDrop),
            DropDownWidget(
                isEdit: isEdit,
                items: vehicleNoList,
                title: 'Vehicle No.',
                callBack: (p0) {
                  setState(() {
                    vehicleNo = p0;
                  });
                },
                selected: vehicleNo),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'RFId',
              controller: rfid,
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
                controller: studentPassword,
                decoration: InputDecoration(
                  // suffixIconColor: Colors.red,
                  suffixIcon: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo),
                        //   splashRadius: 25,
                        child: Icon(Icons.refresh_rounded),
                        onPressed: () {
                          const chars =
                              'abcdefghijklmnopqrstuvwxyz1234567890@#%!*';

                          setState(() {
                            studentPassword.text = String.fromCharCodes(
                              Iterable.generate(
                                6,
                                (_) => chars.codeUnitAt(
                                  Random().nextInt(chars.length),
                                ),
                              ),
                            );
                          });
                        }),
                  ),
                  isDense: true,
                  label: Text('Student Password'),
                  border: OutlineInputBorder(),
                ),
              ),
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
                controller: parentPassword,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
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
                          parentPassword.text = String.fromCharCodes(
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
                  label: Text('Parent Password'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        onChanged: (value) => searchFunction(value),
                        readOnly: !isEdit,
                        controller: sibling,
                        decoration: InputDecoration(
                          isDense: true,
                          label: Text('Siblings in School'),
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
                          for (int i = 0; i < allSibilings.length; i++)
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(allSibilings[i]),
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
                                            allSibilings
                                                .remove(allSibilings[i]);
                                          });
                                        },
                                        icon: Icon(Icons.close_rounded)),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
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
                                  allSibilings.add(sib);
                                  sibling.clear();
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
    );
  }
}
