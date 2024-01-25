import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';
import 'textfield_widget.dart';

class StaffDocument extends StatefulWidget {
  const StaffDocument(
      {super.key,
      required this.mob,
      required this.isEdit,
      required this.refresh});
  final String mob;
  final bool isEdit;
  final VoidCallback refresh;

  @override
  State<StaffDocument> createState() => _StaffDocumentState();
}

class _StaffDocumentState extends State<StaffDocument> {
  late bool isEdit;
  TextEditingController aadhaarNo = TextEditingController();
  TextEditingController panNo = TextEditingController();
  TextEditingController bloodReport = TextEditingController();
  TextEditingController joiningLetter = TextEditingController();
  TextEditingController drivingLicence = TextEditingController();
  List other = [TextEditingController()];

  PlatformFile? aadhaarDoc;
  Uint8List? aadhaarDocBytes;
  PlatformFile? panDoc;
  Uint8List? panDocBytes;
  PlatformFile? bloodReportDoc;
  Uint8List? bloodReportDocBytes;
  PlatformFile? joiningLetterDoc;
  Uint8List? joiningLetterDocBytes;
  PlatformFile? drivingLicenceDoc;
  Uint8List? drivingLicenceDocBytes;
  int addNew = 1;

  late int schoolCode;
  bool _loading = true;
  bool isSaved = true;

  Map docs = {};
  Map otherDocuments = {0: {}};
  Map savedDocs = {};
  List savedControllers = [];

  getStaffDocuments() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getStaffContactInfo/${widget.mob}');

    var response = await client.get(url);

    Map data = jsonDecode(response.body);
    print(data);
    schoolCode = data['schoolCode'];
    print(schoolCode);

    aadhaarNo.text = data['aadhaarNo'] ?? '';
    panNo.text = data['panNo'] ?? '';
    bloodReport.text = data['bloodReport'] ?? '';
    joiningLetter.text = data['joiningLetter'] ?? '';
    drivingLicence.text = data['drivingLicence'] ?? '';

    int count = 0;
    if (data.containsKey('documents')) {
      docs = {};
      otherDocuments = {0: {}};
      savedDocs = {};
      savedControllers = [];
      docs = data['documents'];
      other = [TextEditingController()];

      for (var i in docs.keys) {
        if (i != 'aadhaarDoc' &&
            i != 'panDoc' &&
            i != 'bloodDoc' &&
            i != 'joiningLetterDoc' &&
            i != 'drivingLicenceDoc') {
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

  saveDocumentStaff() async {
    setState(() {
      // isSaved = false;
      _loading = true;
    });
    var url = Uri.parse('$ipv4/uploadStaffDocument');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (aadhaarDocBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes('aadhaarDoc', aadhaarDocBytes!,
          filename: '${widget.mob}_aadhaarDoc.${aadhaarDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (panDocBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes('panDoc', panDocBytes!,
          filename: '${widget.mob}_panDoc.${panDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (bloodReportDocBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes(
          'bloodDoc', bloodReportDocBytes!,
          filename: '${widget.mob}_bloodDoc.${bloodReportDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (joiningLetterDocBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes(
          'joiningLetterDoc', joiningLetterDocBytes!,
          filename:
              '${widget.mob}_joiningLetterDoc.${joiningLetterDoc!.extension}');
      req.files.add(httpDoc);
    }
    if (drivingLicenceDocBytes != null) {
      var httpDoc = http.MultipartFile.fromBytes(
          'drivingLicenceDoc', drivingLicenceDocBytes!,
          filename:
              '${widget.mob}_drivingLicenceDoc.${drivingLicenceDoc!.extension}');
      req.files.add(httpDoc);
    }
    // Map tempDocs = otherDocuments;
    otherDocuments.removeWhere((key, value) => key is String);

    for (int i in otherDocuments.keys) {
      if (otherDocuments[i].isNotEmpty) {
        var httpDoc = http.MultipartFile.fromBytes(
            otherDocuments[i]['field'], otherDocuments[i]['bytes'],
            filename:
                '${widget.mob}_${otherDocuments[i]['field']}.${otherDocuments[i]['ext']}');
        req.files.add(httpDoc);
      }
    }

    req.fields.addAll({
      'schoolCode': schoolCode.toString(),
      'mob': widget.mob,
      'aadhaarNo': aadhaarNo.text.trim(),
      'panNo': panNo.text.trim(),
      'bloodReport': bloodReport.text.trim(),
      'joiningLetter': joiningLetter.text.trim(),
      'drivingLicence': drivingLicence.text.trim()
    });
    var res = await req.send();
    var responded = await http.Response.fromStream(res);
    if (responded.body == 'true') {
      getStaffDocuments();
      setState(() {
        isSaved = true;
        if (!widget.isEdit) {
          isEdit = false;
        }
        if (widget.isEdit) {
          widget.refresh();
          Navigator.of(context).pop();
        }
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
    getStaffDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? SizedBox(
            width: 500, height: 500, child: Center(child: Text('Loading..')))
        : Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                if (!isEdit)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          runSpacing: 5,
                          children: [
                            TextFieldWidget(
                                label: 'Aadhaar No.',
                                controller: aadhaarNo,
                                isEdit: isEdit),
                            SizedBox(
                              width: 10,
                            ),
                            docs.containsKey('aadhaarDoc')
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
                                              docs['aadhaarDoc']['loc'],
                                              docs['aadhaarDoc']['name']),
                                          child: Text(
                                            docs['aadhaarDoc']['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                                'schoolCode':
                                                    schoolCode.toString(),
                                                'mob': widget.mob,
                                                'field': 'aadhaarDoc',
                                                'path': docs['aadhaarDoc']
                                                    ['loc']
                                              });
                                              setState(() {
                                                getStaffDocuments();
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                    ],
                                  )
                                : aadhaarDocBytes.isNull
                                    ? OutlinedButton(
                                        onPressed: !isEdit
                                            ? () {}
                                            : () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                            type: FileType.any);
                                                if (result != null) {
                                                  aadhaarDoc =
                                                      result.files.first;

                                                  setState(() {
                                                    aadhaarDocBytes =
                                                        aadhaarDoc!.bytes;
                                                  });
                                                }
                                              },
                                        child: Text('Upload file'))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(aadhaarDoc!.name),
                                          IconButton(
                                            splashRadius: 20,
                                            onPressed: () {
                                              setState(() {
                                                aadhaarDocBytes = null;
                                              });
                                            },
                                            icon: Icon(Icons.close),
                                          )
                                        ],
                                      ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          runSpacing: 5,
                          children: [
                            TextFieldWidget(
                              label: 'Pan No.',
                              controller: panNo,
                              isEdit: isEdit,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            docs.containsKey('panDoc')
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
                                              docs['panDoc']['loc'],
                                              docs['panDoc']['name']),
                                          child: Text(
                                            docs['panDoc']['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                                'schoolCode':
                                                    schoolCode.toString(),
                                                'mob': widget.mob,
                                                'field': 'panDoc',
                                                'path': docs['panDoc']['loc']
                                              });
                                              setState(() {
                                                getStaffDocuments();
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                    ],
                                  )
                                : panDocBytes.isNull
                                    ? OutlinedButton(
                                        onPressed: !isEdit
                                            ? () {}
                                            : () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                            type: FileType.any);
                                                if (result != null) {
                                                  panDoc = result.files.first;

                                                  setState(() {
                                                    panDocBytes = panDoc!.bytes;
                                                  });
                                                }
                                              },
                                        child: Text('Upload file'))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(panDoc!.name),
                                          IconButton(
                                            splashRadius: 20,
                                            onPressed: () {
                                              setState(() {
                                                panDocBytes = null;
                                              });
                                            },
                                            icon: Icon(Icons.close),
                                          )
                                        ],
                                      ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          runSpacing: 5,
                          children: [
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
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          onPressed: () => downloadFile(
                                              docs['bloodDoc']['loc'],
                                              docs['bloodDoc']['name']),
                                          child: Text(
                                            docs['bloodDoc']['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                                'schoolCode':
                                                    schoolCode.toString(),
                                                'mob': widget.mob,
                                                'field': 'bloodDoc',
                                                'path': docs['bloodDoc']['loc']
                                              });
                                              setState(() {
                                                getStaffDocuments();
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                    ],
                                  )
                                : bloodReportDocBytes.isNull
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
                                                    bloodReportDocBytes =
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
                                                bloodReportDocBytes = null;
                                              });
                                            },
                                            icon: Icon(Icons.close),
                                          )
                                        ],
                                      ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          runSpacing: 5,
                          children: [
                            TextFieldWidget(
                                label: 'Joining Letter',
                                controller: joiningLetter,
                                isEdit: isEdit),
                            SizedBox(
                              width: 10,
                            ),
                            docs.containsKey('joiningLetterDoc')
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
                                              docs['joiningLetterDoc']['loc'],
                                              docs['joiningLetterDoc']['name']),
                                          child: Text(
                                            docs['joiningLetterDoc']['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                                'schoolCode':
                                                    schoolCode.toString(),
                                                'mob': widget.mob,
                                                'field': 'joiningLetterDoc',
                                                'path': docs['joiningLetterDoc']
                                                    ['loc']
                                              });
                                              setState(() {
                                                getStaffDocuments();
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                    ],
                                  )
                                : joiningLetterDocBytes.isNull
                                    ? OutlinedButton(
                                        onPressed: !isEdit
                                            ? () {}
                                            : () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                            type: FileType.any);
                                                if (result != null) {
                                                  joiningLetterDoc =
                                                      result.files.first;

                                                  setState(() {
                                                    joiningLetterDocBytes =
                                                        joiningLetterDoc!.bytes;
                                                  });
                                                }
                                              },
                                        child: Text('Upload file'))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(joiningLetterDoc!.name),
                                          IconButton(
                                            splashRadius: 20,
                                            onPressed: () {
                                              setState(() {
                                                joiningLetterDocBytes = null;
                                              });
                                            },
                                            icon: Icon(Icons.close),
                                          )
                                        ],
                                      ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Wrap(
                          runSpacing: 5,
                          children: [
                            TextFieldWidget(
                                label: 'Driving License',
                                controller: drivingLicence,
                                isEdit: isEdit),
                            SizedBox(
                              width: 10,
                            ),
                            docs.containsKey('drivingLicenceDoc')
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
                                              docs['drivingLicenceDoc']['loc'],
                                              docs['drivingLicenceDoc']
                                                  ['name']),
                                          child: Text(
                                            docs['drivingLicenceDoc']['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                TextStyle(color: Colors.black),
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
                                                'schoolCode':
                                                    schoolCode.toString(),
                                                'mob': widget.mob,
                                                'field': 'drivingLicenceDoc',
                                                'path':
                                                    docs['drivingLicenceDoc']
                                                        ['loc']
                                              });
                                              setState(() {
                                                getStaffDocuments();
                                              });
                                            },
                                            icon: Icon(Icons.delete))
                                    ],
                                  )
                                : drivingLicenceDocBytes.isNull
                                    ? OutlinedButton(
                                        onPressed: !isEdit
                                            ? () {}
                                            : () async {
                                                FilePickerResult? result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                            type: FileType.any);
                                                if (result != null) {
                                                  drivingLicenceDoc =
                                                      result.files.first;

                                                  setState(() {
                                                    drivingLicenceDocBytes =
                                                        drivingLicenceDoc!
                                                            .bytes;
                                                  });
                                                }
                                              },
                                        child: Text('Upload file'))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(drivingLicenceDoc!.name),
                                          IconButton(
                                            splashRadius: 20,
                                            onPressed: () {
                                              setState(() {
                                                drivingLicenceDocBytes = null;
                                              });
                                            },
                                            icon: Icon(Icons.close),
                                          )
                                        ],
                                      ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        for (int i = 0; i < addNew; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Wrap(
                              runSpacing: 5,
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
                                                    'mob': widget.mob,
                                                    'field': other[i].text,
                                                    'path': docs[other[i].text]
                                                        ['loc']
                                                  });
                                                  setState(() {
                                                    getStaffDocuments();
                                                  });
                                                },
                                                icon: Icon(Icons.delete))
                                        ],
                                      )
                                    : otherDocuments[i].isEmpty
                                        ? OutlinedButton(
                                            onPressed: other[i].text.trim() ==
                                                    ""
                                                ? null
                                                : !isEdit
                                                    ? () {}
                                                    : () async {
                                                        FilePickerResult?
                                                            result =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                                    type: FileType
                                                                        .any);
                                                        if (result != null) {
                                                          PlatformFile?
                                                              otherDocs = result
                                                                  .files.first;

                                                          setState(() {
                                                            // print(otherDocs.name);

                                                            Uint8List?
                                                                otherDocsBytes =
                                                                otherDocs.bytes;
                                                            otherDocuments
                                                                .update(
                                                                    i,
                                                                    (value) => {
                                                                          'field':
                                                                              other[i].text,
                                                                          'name':
                                                                              otherDocs.name,
                                                                          'ext':
                                                                              otherDocs.extension,
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
                                                      overflow: TextOverflow
                                                          .ellipsis)),
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
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
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
                            saveDocumentStaff();
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
            ),
          );
  }
}
