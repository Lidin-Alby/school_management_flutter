import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';
import 'textfield_widget.dart';

class ParentInfo extends StatefulWidget {
  const ParentInfo(
      {super.key,
      required this.admNo,
      required this.callback,
      required this.isEdit});

  final String admNo;
  final VoidCallback callback;
  final bool isEdit;

  @override
  State<ParentInfo> createState() => _ParentInfoState();
}

class _ParentInfoState extends State<ParentInfo> {
  bool isSaved = true;
  bool next = false;

  TextEditingController fatherName = TextEditingController();
  TextEditingController fatherOccupation = TextEditingController();
  TextEditingController fatherMobNo = TextEditingController();
  TextEditingController fatherWhatsApp = TextEditingController();
  TextEditingController fatherAadhaar = TextEditingController();
  TextEditingController motherName = TextEditingController();
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
  late int schoolCode;
  Uint8List? _fatherImagebytes;
  PlatformFile? _fatherImage;
  PlatformFile? _motherImage;
  Uint8List? _motherImagebytes;
  PlatformFile? _gaurdianImage;
  Uint8List? _gaurdianImagebytes;
  bool _fatherOpacity = false;
  bool _motherOpacity = false;
  bool _gaurdianOpacity = false;
  late bool isEdit;
  bool getAll = false;
  Map form = {};

  @override
  void initState() {
    isEdit = widget.isEdit;
    getStudentParentInfo();
    super.initState();
  }

  getFormAccessStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getFormAccessStudent');
    var res = await client.get(url);

    Map data = jsonDecode(res.body);
    // Map form = data['studentForm'];
    print(data);
    form = data['studentForm'];

    setState(() {
      getAll = true;
    });
  }

  getAllProfilePics() async {
    var client = BrowserClient()..withCredentials = true;
    var url1 = Uri.parse('$ipv4/getFatherPic/${widget.admNo}');
    var response1 = await client.get(url1);

    if (response1.body == 'false') {
      _fatherImagebytes = null;
    } else {
      _fatherImagebytes = response1.bodyBytes;
    }
    var url2 = Uri.parse('$ipv4/getMotherPic/${widget.admNo}');
    var response2 = await client.get(url2);

    if (response2.body == 'false') {
      _motherImagebytes = null;
    } else {
      _motherImagebytes = response2.bodyBytes;
    }
    var url3 = Uri.parse('$ipv4/getGaurdianPic/${widget.admNo}');
    var response3 = await client.get(url3);

    if (response3.body == 'false') {
      _gaurdianImagebytes = null;
    } else {
      setState(() {
        _gaurdianImagebytes = response3.bodyBytes;
      });
    }
    setState(() {});
  }

  getStudentParentInfo() async {
    getAllProfilePics();
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getStudentParentInfo/${widget.admNo}');

    var response = await client.get(url);
    print(response.body);
    print('parent');
    Map data = jsonDecode(response.body);
    schoolCode = data['schoolCode'];
    fatherName.text = data['fatherName'] ?? '';
    motherName.text = data['motherName'] ?? '';
    motherOccupation.text = data['motherOccupation'] ?? '';
    fatherOccupation.text = data['fatherOccupation'] ?? '';
    fatherMobNo.text = data['fatherMobNo'] ?? '';
    motherMobNo.text = data['motherMobNo'] ?? '';
    fatherWhatsApp.text = data['fatherWhatsApp'] ?? '';
    motherWhatsApp.text = data['motherWhatsApp'] ?? '';
    fatherAadhaar.text = data['fatherAadhaar'] ?? '';
    motherAadhaar.text = data['motherAadhaar'] ?? '';
    gaurdianRelation.text = data['gaurdianRelation'] ?? '';
    gaurdianName.text = data['gaurdianName'] ?? '';
    gaurdianOccupation.text = data['gaurdianOccupation'] ?? '';
    gaurdianMobNo.text = data['gaurdianOccupation'] ?? '';
    gaurdianWhatsApp.text = data['gaurdianWhatsApp'] ?? '';
    gaurdianAadhaar.text = data['gaurdianAadhaar'] ?? '';
    getFormAccessStudent();
  }

  saveStudentParentInfo() async {
    setState(() {
      isSaved = false;
    });
    var url = Uri.parse('$ipv4/addStudentParentInfo');

    var req = http.MultipartRequest(
      'POST',
      url,
    );

    if (_fatherImagebytes == null) {
      req.fields['fatherProfilePic'] = '';
    } else if (_fatherImage != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'fatherProfilePic',
        _fatherImagebytes!,
        filename:
            '${schoolCode}_${widget.admNo}_father_ProfilePic.${_fatherImage!.extension}',
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
            '${schoolCode}_${widget.admNo}_mother_ProfilePic.${_motherImage!.extension}',
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
            '${schoolCode}_${widget.admNo}_gaurdian_ProfilePic.${_gaurdianImage!.extension}',
      );
      req.files.add(httpImage);
    }
    //   req.fields['admNo'] = admNo.text.trim();
    req.fields.addAll({
      'schoolCode': schoolCode.toString(),
      'admNo': widget.admNo,
      'fatherName': fatherName.text.trim(),
      'fatherOccupation': fatherOccupation.text.trim(),
      'fatherMobNo': fatherMobNo.text.trim(),
      'fatherWhatsApp': fatherWhatsApp.text.trim(),
      'fatherAadhaar': fatherAadhaar.text.trim(),
      'motherName': motherName.text.trim(),
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
        if (widget.isEdit) {
          next = true;
        }
        if (!widget.isEdit) {
          isEdit = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Wrap(
          // mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            firstColumn(),
            SizedBox(
              width: 50,
            ),
            secondColumn(),
            SizedBox(
              width: 50,
            ),
            thirdColumn()
          ],
        ),
        SizedBox(
          height: 30,
        ),
        if (isEdit && isSaved)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
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
                        onPressed: widget.callback,
                        child: Text('Next'),
                      )
                    : ElevatedButton(
                        onPressed: saveStudentParentInfo,
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
                onTap: !isEdit
                    ? () {}
                    : () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.image);
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
              isEdit: isEdit,
              label: 'Relation with Student',
              controller: gaurdianRelation,
            ),
          if (form['gaurdianName'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Gaurdian\'s Name',
              controller: gaurdianName,
            ),
          if (form['gaurdianOccupation'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Occupation',
              controller: gaurdianOccupation,
            ),
          if (form['gaurdianMobNo'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Gaurdian\'s Mobile No.',
              controller: gaurdianMobNo,
            ),
          if (form['gaurdianWhatsApp'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Gaurdian \'s Whatsapp No.',
              controller: gaurdianWhatsApp,
            ),
          if (form['gaurdianAadhaar'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
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
                onTap: !isEdit
                    ? () {}
                    : () async {
                        FilePickerResult? result = await FilePicker.platform
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
              isEdit: isEdit,
              label: 'Mother\'s Name',
              controller: motherName,
            ),
          if (form['motherOccupation'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Occupation',
              controller: motherOccupation,
            ),
          if (form['motherMobNo'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Mother\'s Mobile No.',
              controller: motherMobNo,
            ),
          if (form['motherWhatsapp'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Mother\'s Whatsapp No.',
              controller: motherWhatsApp,
            ),
          if (form['motherAadhaar'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
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
                onTap: !isEdit
                    ? () {}
                    : () async {
                        FilePickerResult? result = await FilePicker.platform
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
              isEdit: isEdit,
              label: 'Father\'s Name',
              controller: fatherName,
            ),
          if (form['fatherOccupation'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Occupation',
              controller: fatherOccupation,
            ),
          if (form['fatherMobNo'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Father\'s Mobile No.',
              controller: fatherMobNo,
            ),
          if (form['fatherWhatsapp'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Father\'s Whatsapp No.',
              controller: fatherWhatsApp,
            ),
          if (form['fatherAadhaar'] == 'true')
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Aadhaar No.',
              controller: fatherAadhaar,
            )
        ],
      ),
    );
  }
}
