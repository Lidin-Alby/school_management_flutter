import 'dart:convert';

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/widgets/textfield_widget.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';

class StudentDocumet extends StatefulWidget {
  const StudentDocumet(
      {super.key,
      required this.isEdit,
      required this.callback,
      required this.admNo});
  final bool isEdit;
  final VoidCallback callback;
  final String admNo;
  @override
  State<StudentDocumet> createState() => _StudentDocumetState();
}

class _StudentDocumetState extends State<StudentDocumet> {
  TextEditingController studentWeight = TextEditingController();
  TextEditingController studentHeight = TextEditingController();
  TextEditingController studentEyeSight = TextEditingController();
  TextEditingController medicalIssue = TextEditingController();
  TextEditingController operated = TextEditingController();
  TextEditingController allergies = TextEditingController();
  TextEditingController govIdNo = TextEditingController();
  TextEditingController tcNo = TextEditingController();
  TextEditingController bloodReport = TextEditingController();
  TextEditingController vaccine = TextEditingController();
  TextEditingController birthCertificate = TextEditingController();
  List other = [TextEditingController()];
  late bool isEdit;
  bool isSaved = true;
  // bool next = false;
  late int schoolCode;

  String? polio;
  String? dpt;
  String? dt;
  String? measles;
  String? mmr;
  String? tetanus;
  String? typhoid;
  String? hepatitisA;
  String? hepatitisB;
  String? chickenPox;
  int addNew = 1;

  PlatformFile? govDoc;
  Uint8List? govDocBytes;
  PlatformFile? tcDoc;
  Uint8List? tcBytes;
  PlatformFile? bloodReportDoc;
  Uint8List? bloodReportBytes;
  PlatformFile? vaccineDoc;
  Uint8List? vaccineBytes;
  PlatformFile? birthCertificateDoc;
  Uint8List? birthCertificateDocBytes;
  Map docs = {};
  Map otherDocuments = {0: {}};
  Map savedDocs = {};
  List savedControllers = [];
  bool _loading = true;
  getStudentDocuments() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getStudentContactInfo/${widget.admNo}');

    var response = await client.get(url);

    Map data = jsonDecode(response.body);
    print(data);
    schoolCode = data['schoolCode'];
    print(schoolCode);
    studentWeight.text = data['studentWeight'] ?? '';
    studentHeight.text = data['studentHeight'] ?? '';
    studentEyeSight.text = data['studentEyeSight'] ?? '';
    medicalIssue.text = data['medicalIssue'] ?? '';
    operated.text = data['operated'] ?? '';
    allergies.text = data['allergies'] ?? '';
    govIdNo.text = data['govIdNo'] ?? '';
    tcNo.text = data['tcNo'] ?? '';
    bloodReport.text = data['bloodReport'] ?? '';
    vaccine.text = data['vaccine'] ?? '';
    birthCertificate.text = data['birthCertificate'] ?? '';
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
    int count = 0;
    if (data.containsKey('documents')) {
      docs = {};
      otherDocuments = {0: {}};
      savedDocs = {};
      savedControllers = [];
      docs = data['documents'];
      other = [TextEditingController()];

      for (var i in docs.keys) {
        if (i != 'govDoc' &&
            i != 'tcDoc' &&
            i != 'bloodDoc' &&
            i != 'vaccineDoc' &&
            i != 'birthDoc') {
          savedDocs.addAll({i: docs[i]});
          savedControllers.add(i);
          // print(count);
          if (count == 0) {
            other[count].text = i;
          } else {
            // otherDocuments.addAll({count: docs[i]});
            other.add(TextEditingController(text: i));
          }
          count++;
        }
      }
      addNew = count;
      otherDocuments = savedDocs;
    }

    setState(() {
      _loading = false;
    });
  }

  saveDocumentStudent() async {
    setState(() {
      // isSaved = false;
      _loading = true;
    });
    var url = Uri.parse('$ipv4/uploadStudentDocument');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (govDocBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes('govDoc', govDocBytes!,
          filename: '${widget.admNo}_govDoc.${govDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (tcBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes('tcDoc', tcBytes!,
          filename: '${widget.admNo}_tcDoc.${tcDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (bloodReportBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes('bloodDoc', bloodReportBytes!,
          filename: '${widget.admNo}_bloodDoc.${bloodReportDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (vaccineBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes('vaccineDoc', vaccineBytes!,
          filename: '${widget.admNo}_vaccineDoc.${vaccineDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (birthCertificateDocBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes(
          'birthDoc', birthCertificateDocBytes!,
          filename:
              '${widget.admNo}_birthDoc.${birthCertificateDoc!.extension}');
      req.files.add(httpDoc);
    }
    // Map tempDocs = otherDocuments;
    otherDocuments.removeWhere((key, value) => key is String);

    for (int i in otherDocuments.keys) {
      if (otherDocuments[i].isNotEmpty) {
        var httpDoc = http.MultipartFile.fromBytes(
            otherDocuments[i]['field'], otherDocuments[i]['bytes'],
            filename:
                '${widget.admNo}_${otherDocuments[i]['field']}.${otherDocuments[i]['ext']}');
        req.files.add(httpDoc);
      }
    }

    req.fields.addAll({
      'schoolCode': schoolCode.toString(),
      'admNo': widget.admNo,
      'studentWeight': studentWeight.text.trim(),
      'studentHeight': studentHeight.text.trim(),
      'studentEyeSight': studentEyeSight.text.trim(),
      'medicalIssue': medicalIssue.text.trim(),
      'operated': operated.text.trim(),
      'allergies': allergies.text.trim(),
      'govIdNo': govIdNo.text.trim(),
      'tcNo': tcNo.text.trim(),
      'bloodReport': bloodReport.text.trim(),
      'vaccine': vaccine.text.trim(),
      'birthCertificate': birthCertificate.text.trim(),
      'polio': polio ?? '',
      'dpt': dpt ?? '',
      'dt': dt ?? '',
      'measles': measles ?? '',
      'mmr': mmr ?? '',
      'tetanus': tetanus ?? '',
      'typhoid': typhoid ?? '',
      'hepatitisA': hepatitisA ?? '',
      'hepatitisB': hepatitisB ?? '',
      'chickenPox': chickenPox ?? ''
    });
    var res = await req.send();
    var responded = await http.Response.fromStream(res);
    if (responded.body == 'true') {
      getStudentDocuments();
      setState(() {
        isSaved = true;
      });
    }
  }

  downloadFile(String loc, String name) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/downloadDoc');
    var response = await client.post(url, body: {'loc': loc});

    final fileBytes = response.bodyBytes;

    FileSaver.instance.saveFile(
      name: name,
      bytes: fileBytes,
      // ext: 'pdf',
      // mimeType: MimeType.pdf,
    );
  }

  @override
  void initState() {
    isEdit = widget.isEdit;
    if (widget.isEdit) {
      _loading = false;
    }
    getStudentDocuments();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? SizedBox(
            width: 500, height: 500, child: Center(child: Text('Loading..')))
        : Column(
            children: [
              // Text('${savedDocs.keys.elementAt(0) is String}'),
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
                runSpacing: 15,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Wrap(
                      runSpacing: 15,
                      children: [
                        TextFieldWidget(
                          label: 'Student Weight',
                          controller: studentWeight,
                          isEdit: isEdit,
                        ),
                        TextFieldWidget(
                          label: 'Student Height',
                          controller: studentHeight,
                          isEdit: isEdit,
                        ),
                        TextFieldWidget(
                          label: 'Eye sight',
                          controller: studentEyeSight,
                          isEdit: isEdit,
                        ),
                        TextFieldWidget(
                          label: 'Any Medical Issue / Disability',
                          controller: medicalIssue,
                          isEdit: isEdit,
                        ),
                        TextFieldWidget(
                          label: 'Has child ever operated upon?',
                          controller: operated,
                          isEdit: isEdit,
                        ),
                        TextFieldWidget(
                          label: 'Allergies',
                          controller: allergies,
                          isEdit: isEdit,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    child: Wrap(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRadioButton(
                          groupValue: polio,
                          label: 'Polio',
                          callback: (p0) {
                            setState(() {
                              polio = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: dpt,
                          label: 'DPT',
                          callback: (p0) {
                            setState(() {
                              dpt = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: dt,
                          label: 'DT',
                          callback: (p0) {
                            setState(() {
                              dt = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: measles,
                          label: 'Measles',
                          callback: (p0) {
                            setState(() {
                              measles = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: mmr,
                          label: 'MMR',
                          callback: (p0) {
                            setState(() {
                              mmr = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: tetanus,
                          label: 'Tetanus',
                          callback: (p0) {
                            setState(() {
                              tetanus = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: typhoid,
                          label: 'Typhoid or cholera',
                          callback: (p0) {
                            setState(() {
                              typhoid = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: hepatitisA,
                          label: 'Hepatitis A',
                          callback: (p0) {
                            setState(() {
                              hepatitisA = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: hepatitisB,
                          label: 'Hepatitis B',
                          callback: (p0) {
                            setState(() {
                              hepatitisB = p0;
                            });
                          },
                        ),
                        CustomRadioButton(
                          groupValue: chickenPox,
                          label: 'Chicken Pox',
                          callback: (p0) {
                            setState(() {
                              chickenPox = p0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    child: Wrap(
                      // direction: Axis.vertical,
                      runSpacing: 15,
                      children: [
                        TextFieldWidget(
                            label: 'Government Id No.',
                            controller: govIdNo,
                            isEdit: isEdit),
                        SizedBox(
                          width: 10,
                        ),
                        docs.containsKey('govDoc')
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side:
                                              BorderSide(color: Colors.black)),
                                      onPressed: () => downloadFile(
                                          docs['govDoc']['loc'],
                                          docs['govDoc']['name']),
                                      child: Text(
                                        docs['govDoc']['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  if (isEdit)
                                    IconButton(
                                        splashRadius: 20,
                                        onPressed: () async {
                                          var url =
                                              Uri.parse('$ipv4/deleteDoc');

                                          await http.post(url, body: {
                                            'schoolCode': schoolCode.toString(),
                                            'admNo': widget.admNo,
                                            'field': 'govDoc',
                                            'path': docs['govDoc']['loc']
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                ],
                              )
                            : govDocBytes == null
                                ? OutlinedButton(
                                    onPressed: !isEdit
                                        ? () {}
                                        : () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        type: FileType.any);
                                            if (result != null) {
                                              govDoc = result.files.first;

                                              govDocBytes = govDoc!.bytes;

                                              setState(() {});
                                            }
                                          },
                                    child: Text('Upload file'))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(govDoc!.name),
                                      IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          setState(() {
                                            govDocBytes = null;
                                          });
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                        TextFieldWidget(
                            label: 'TC No.', controller: tcNo, isEdit: isEdit),
                        SizedBox(
                          width: 10,
                        ),
                        docs.containsKey('tcDoc')
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side:
                                              BorderSide(color: Colors.black)),
                                      onPressed: () => downloadFile(
                                          docs['tcDoc']['loc'],
                                          docs['tcDoc']['name']),
                                      child: Text(
                                        docs['tcDoc']['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  if (isEdit)
                                    IconButton(
                                        splashRadius: 20,
                                        onPressed: () async {
                                          var url =
                                              Uri.parse('$ipv4/deleteDoc');

                                          await http.post(url, body: {
                                            'schoolCode': schoolCode.toString(),
                                            'admNo': widget.admNo,
                                            'field': 'tcDoc',
                                            'path': docs['tcDoc']['loc']
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                ],
                              )
                            : tcBytes == null
                                ? OutlinedButton(
                                    onPressed: !isEdit
                                        ? () {}
                                        : () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        type: FileType.any);
                                            if (result != null) {
                                              tcDoc = result.files.first;

                                              setState(() {
                                                tcBytes = tcDoc!.bytes;
                                              });
                                            }
                                          },
                                    child: Text('Upload file'))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(tcDoc!.name),
                                      IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          setState(() {
                                            tcBytes = null;
                                          });
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                        TextFieldWidget(
                            label: 'Blood Report',
                            controller: bloodReport,
                            isEdit: isEdit),
                        SizedBox(
                          width: 10,
                        ),
                        docs.containsKey('bloodDoc')
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side:
                                              BorderSide(color: Colors.black)),
                                      onPressed: () => downloadFile(
                                          docs['bloodDoc']['loc'],
                                          docs['bloodDoc']['name']),
                                      child: Text(
                                        docs['bloodDoc']['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  if (isEdit)
                                    IconButton(
                                        splashRadius: 20,
                                        onPressed: () async {
                                          var url =
                                              Uri.parse('$ipv4/deleteDoc');

                                          await http.post(url, body: {
                                            'schoolCode': schoolCode.toString(),
                                            'admNo': widget.admNo,
                                            'field': 'bloodDoc',
                                            'path': docs['bloodDoc']['loc']
                                          });
                                          setState(() {
                                            getStudentDocuments();
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                ],
                              )
                            : bloodReportBytes == null
                                ? OutlinedButton(
                                    onPressed: !isEdit
                                        ? () {}
                                        : () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        type: FileType.any);
                                            if (result != null) {
                                              bloodReportDoc =
                                                  result.files.first;

                                              setState(() {
                                                bloodReportBytes =
                                                    bloodReportDoc!.bytes;
                                              });
                                            }
                                          },
                                    child: Text('Upload file'))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(bloodReportDoc!.name),
                                      IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          setState(() {
                                            bloodReportBytes = null;
                                          });
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                        TextFieldWidget(
                            label: 'Vaccination Report',
                            controller: vaccine,
                            isEdit: isEdit),
                        SizedBox(
                          width: 10,
                        ),
                        docs.containsKey('vaccineDoc')
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side:
                                              BorderSide(color: Colors.black)),
                                      onPressed: () => downloadFile(
                                          docs['vaccineDoc']['loc'],
                                          docs['vaccineDoc']['name']),
                                      child: Text(
                                        docs['vaccineDoc']['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  if (isEdit)
                                    IconButton(
                                        splashRadius: 20,
                                        onPressed: () async {
                                          var url =
                                              Uri.parse('$ipv4/deleteDoc');

                                          await http.post(url, body: {
                                            'schoolCode': schoolCode.toString(),
                                            'admNo': widget.admNo,
                                            'field': 'vaccineDoc',
                                            'path': docs['vaccineDoc']['loc']
                                          });
                                          setState(() {
                                            getStudentDocuments();
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                ],
                              )
                            : vaccineBytes == null
                                ? OutlinedButton(
                                    onPressed: !isEdit
                                        ? () {}
                                        : () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        type: FileType.any);
                                            if (result != null) {
                                              vaccineDoc = result.files.first;

                                              setState(() {
                                                vaccineBytes =
                                                    vaccineDoc!.bytes;
                                              });
                                            }
                                          },
                                    child: Text('Upload file'))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(vaccineDoc!.name),
                                      IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          setState(() {
                                            vaccineBytes = null;
                                          });
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                        TextFieldWidget(
                            label: 'Birth Certificate No.',
                            controller: birthCertificate,
                            isEdit: isEdit),
                        SizedBox(
                          width: 10,
                        ),
                        docs.containsKey('birthDoc')
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side:
                                              BorderSide(color: Colors.black)),
                                      onPressed: () => downloadFile(
                                          docs['birthDoc']['loc'],
                                          docs['birthDoc']['name']),
                                      child: Text(
                                        docs['birthDoc']['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  if (isEdit)
                                    IconButton(
                                        splashRadius: 20,
                                        onPressed: () async {
                                          var url =
                                              Uri.parse('$ipv4/deleteDoc');

                                          await http.post(url, body: {
                                            'schoolCode': schoolCode.toString(),
                                            'admNo': widget.admNo,
                                            'field': 'birthDoc',
                                            'path': docs['birthDoc']['loc']
                                          });
                                          setState(() {
                                            getStudentDocuments();
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                ],
                              )
                            : birthCertificateDocBytes == null
                                ? OutlinedButton(
                                    onPressed: !isEdit
                                        ? () {}
                                        : () async {
                                            FilePickerResult? result =
                                                await FilePicker.platform
                                                    .pickFiles(
                                                        type: FileType.any);
                                            if (result != null) {
                                              birthCertificateDoc =
                                                  result.files.first;

                                              setState(() {
                                                birthCertificateDocBytes =
                                                    birthCertificateDoc!.bytes;
                                              });
                                            }
                                          },
                                    child: Text('Upload file'))
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(birthCertificateDoc!.name),
                                      IconButton(
                                        splashRadius: 20,
                                        onPressed: () {
                                          setState(() {
                                            birthCertificateDocBytes = null;
                                          });
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                        for (int i = 0; i < addNew; i++)
                          Wrap(
                            children: [
                              SizedBox(
                                width: 250,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  readOnly: !isEdit,
                                  controller: other[i],
                                  decoration: InputDecoration(
                                    isDense: true,
                                    label: Text('Other (Type Name)'),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              savedDocs.isNotEmpty &&
                                      savedDocs.keys.elementAt(i) is String
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                    color: Colors.black)),
                                            onPressed: () => downloadFile(
                                                savedDocs[savedControllers[i]]
                                                    ['loc'],
                                                savedDocs[savedControllers[i]]
                                                    ['name']),
                                            child: Text(
                                              savedDocs[savedControllers[i]]
                                                  ['name'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        if (isEdit)
                                          IconButton(
                                              splashRadius: 20,
                                              onPressed: () async {
                                                var url = Uri.https(
                                                    ipv4, '/deleteDoc');

                                                await http.post(url, body: {
                                                  'schoolCode':
                                                      schoolCode.toString(),
                                                  'admNo': widget.admNo,
                                                  'field': other[i].text,
                                                  'path': docs[other[i].text]
                                                      ['loc']
                                                });
                                                setState(() {
                                                  getStudentDocuments();
                                                });
                                              },
                                              icon: Icon(Icons.delete))
                                      ],
                                    )
                                  : otherDocuments[i].isEmpty
                                      ? OutlinedButton(
                                          onPressed: other[i].text.trim() == ""
                                              ? null
                                              : !isEdit
                                                  ? () {}
                                                  : () async {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles(
                                                                  type: FileType
                                                                      .any);
                                                      if (result != null) {
                                                        PlatformFile?
                                                            otherDocs =
                                                            result.files.first;

                                                        setState(() {
                                                          // print(otherDocs.name);

                                                          Uint8List?
                                                              otherDocsBytes =
                                                              otherDocs.bytes;
                                                          otherDocuments.update(
                                                              i,
                                                              (value) => {
                                                                    'field':
                                                                        other[i]
                                                                            .text,
                                                                    'name':
                                                                        otherDocs
                                                                            .name,
                                                                    'ext': otherDocs
                                                                        .extension,
                                                                    'bytes':
                                                                        otherDocsBytes
                                                                  });
                                                        });
                                                      }
                                                    },
                                          child: Text('Upload file'))
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                                width: 100,
                                                child: Text(
                                                    otherDocuments[i]['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            IconButton(
                                              splashRadius: 20,
                                              onPressed: () {
                                                setState(() {
                                                  print(otherDocuments);
                                                  print(i);
                                                  // addNew--;
                                                  otherDocuments.update(
                                                      i, (value) => {});
                                                });
                                              },
                                              icon: Icon(Icons.close),
                                            )
                                          ],
                                        ),
                            ],
                          ),
                        if (isEdit)
                          ElevatedButton(
                            onPressed: () {
                              other.add(TextEditingController());
                              otherDocuments.addAll({addNew: {}});

                              setState(() {
                                addNew++;
                              });
                            },
                            child: Icon(Icons.add),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              if (isEdit && isSaved)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isEdit = false;
                            });
                          },
                          child: Text('Cancel')),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveDocumentStudent();
                        },
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
}

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton(
      {super.key,
      required this.groupValue,
      required this.label,
      required this.callback});
  final String? groupValue;
  final String label;
  final Function(String?) callback;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(width: 125, child: Text(label)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 125,
              child: RadioListTile(
                dense: true,
                title: Text('Yes'),
                value: 'yes',
                groupValue: groupValue,
                onChanged: (value) => callback(value),
              ),
            ),
            SizedBox(
              width: 125,
              child: RadioListTile(
                dense: true,
                title: Text('No'),
                value: 'no',
                groupValue: groupValue,
                onChanged: (value) => callback(value),
              ),
            ),
          ],
        )
      ],
    );
  }
}
