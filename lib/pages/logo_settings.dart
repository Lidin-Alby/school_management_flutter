import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';

class LogoSettings extends StatefulWidget {
  const LogoSettings({super.key, required this.schoolCode});
  final String schoolCode;

  @override
  State<LogoSettings> createState() => _LogoSettingsState();
}

class _LogoSettingsState extends State<LogoSettings> {
  Uint8List? _printLogoBytes;
  PlatformFile? _printLogo;
  Uint8List? _adminLogoBytes;
  PlatformFile? _adminLogo;
  Uint8List? _adminLogoSmallBytes;
  PlatformFile? _adminLogoSmall;
  Uint8List? _appLogoBytes;
  PlatformFile? _appLogo;
  late String schoolCode;

  getAllLogos() async {
    var client = BrowserClient()..withCredentials = true;
    var url1 = Uri.parse('$ipv4/getPrintLogo');
    var response1 = await client.get(url1);

    _printLogoBytes = response1.bodyBytes;

    var url2 = Uri.parse('$ipv4/getAdminLogo');
    var response2 = await client.get(url2);

    _adminLogoBytes = response2.bodyBytes;

    var url3 = Uri.parse('$ipv4/getAdminSmallLogo');
    var response3 = await client.get(url3);

    _adminLogoSmallBytes = response3.bodyBytes;

    var url4 = Uri.parse('$ipv4/getAppLogo');
    var response4 = await client.get(url4);

    _appLogoBytes = response4.bodyBytes;

    // var url2 = Uri.parse('$ipv4/getMotherPic/${widget.admNo}');
    // var response2 = await client.get(url2);

    // if (response2.body == 'false') {
    //   _adminLogoBytes = null;
    // } else {
    //   _adminLogoBytes = response2.bodyBytes;
    // }
    // var url3 = Uri.parse('$ipv4/getGaurdianPic/${widget.admNo}');
    // var response3 = await client.get(url3);

    // if (response3.body == 'false') {
    //   _adminLogoSmallBytes = null;
    // } else {
    //   setState(() {
    //     _adminLogoSmallBytes = response3.bodyBytes;
    //   });
    // }
    // var url4 = Uri.parse('$ipv4/getGaurdianPic/${widget.admNo}');
    // var response4 = await client.get(url4);

    // if (response4.body == 'false') {
    //   _appLogoBytes = null;
    // } else {
    //   setState(() {
    //     _appLogoBytes = response4.bodyBytes;
    //   });
    // }
    setState(() {});
  }

  saveLogos() async {
    var url = Uri.parse('$ipv4/addLogos');

    var req = http.MultipartRequest(
      'POST',
      url,
    );
    if (_printLogoBytes == null) {
      req.fields['printLogo'] = '';
    } else if (_printLogo != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'printLogo',
        _printLogoBytes!,
        filename: '${schoolCode}_printLogo.${_printLogo!.extension}',
      );
      req.files.add(httpImage);
    }
    if (_adminLogoBytes == null) {
      req.fields['adminLogo'] = '';
    } else if (_adminLogo != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'adminLogo',
        _adminLogoBytes!,
        filename: '${schoolCode}_adminLogo.${_adminLogo!.extension}',
      );
      req.files.add(httpImage);
    }
    if (_adminLogoSmallBytes == null) {
      req.fields['adminLogoSmall'] = '';
    } else if (_adminLogoSmall != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'adminLogoSmall',
        _adminLogoSmallBytes!,
        filename: '${schoolCode}_adminLogoSmall.${_adminLogoSmall!.extension}',
      );
      req.files.add(httpImage);
    }
    if (_appLogoBytes == null) {
      req.fields['appLogo'] = '';
    } else if (_appLogo != null) {
      var httpImage = http.MultipartFile.fromBytes(
        'appLogo',
        _appLogoBytes!,
        filename: '${schoolCode}_appLogo.${_appLogo!.extension}',
      );
      req.files.add(httpImage);
    }
    req.fields.addAll({'schoolCode': schoolCode.toString()});
    var res = await req.send();
    var responded = await http.Response.fromStream(res);

    if (responded.body == 'true') {
      print(true);
    }
  }

  @override
  void initState() {
    schoolCode = widget.schoolCode;

    getAllLogos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Logo Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                ElevatedButton(onPressed: saveLogos, child: Text('Save'))
              ],
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Print Logo',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 1,
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            _printLogo = result.files.first;

                            setState(() {
                              _printLogoBytes = _printLogo!.bytes;
                            });
                          }
                        },
                        child: _printLogoBytes == null
                            ? SizedBox(
                                width: 200,
                                height: 160,
                                // color: Colors.red,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_upload_outlined,
                                      size: 50,
                                      color: Colors.indigo,
                                    ),
                                    Text('170px x 184px'),
                                  ],
                                ))
                            : SizedBox(
                                height: 140,
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircleAvatar(
                                    // radius: 50,
                                    backgroundImage:
                                        MemoryImage(_printLogoBytes!),
                                  ),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Admin Logo',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 1),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            _adminLogo = result.files.first;

                            setState(() {
                              _adminLogoBytes = _adminLogo!.bytes;
                            });
                          }
                        },
                        child: _adminLogoBytes == null
                            ? SizedBox(
                                height: 160,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_upload_outlined,
                                      size: 50,
                                      color: Colors.indigo,
                                    ),
                                    Text('290px x 51px')
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 140,
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircleAvatar(
                                    // radius: 50,
                                    backgroundImage:
                                        MemoryImage(_adminLogoBytes!),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Admin Small Logo',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(height: 1),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            _adminLogoSmall = result.files.first;

                            setState(() {
                              _adminLogoSmallBytes = _adminLogoSmall!.bytes;
                            });
                          }
                        },
                        child: _adminLogoSmallBytes == null
                            ? SizedBox(
                                height: 160,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_upload_outlined,
                                      size: 50,
                                      color: Colors.indigo,
                                    ),
                                    Text('32px x 32px')
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 140,
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircleAvatar(
                                    // radius: 50,
                                    backgroundImage:
                                        MemoryImage(_adminLogoSmallBytes!),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'App Logo',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 1,
                      ),
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.image);
                          if (result != null) {
                            _appLogo = result.files.first;

                            setState(() {
                              _appLogoBytes = _appLogo!.bytes;
                            });
                          }
                        },
                        child: _appLogoBytes == null
                            ? SizedBox(
                                height: 160,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_upload_outlined,
                                      size: 50,
                                      color: Colors.indigo,
                                    ),
                                    Text('290px x 51px')
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 140,
                                width: 200,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircleAvatar(
                                    // radius: 50,
                                    backgroundImage:
                                        MemoryImage(_appLogoBytes!),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
