import 'dart:convert';
import 'dart:js_interop';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/widgets/textfield_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

import '../ip_address.dart';

class OwnerPage extends StatefulWidget {
  const OwnerPage({super.key});

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  late Future _schools;

  @override
  void initState() {
    _schools = getSchools();
    super.initState();
  }

  getSchools() async {
    var url = Uri.http(ipv4, '/getSchools');
    var res = await http.get(url);
    if (res.body.isEmpty) {
      return;
    } else {
      var data = jsonDecode(res.body);
      print(data);
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('School Management')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => AddSchoolDialog(
                              refresh: () => setState(() {
                                _schools = getSchools();
                              }),
                            )),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add School'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => BulkUplaodDialog()),
                      child: Text('Bulk Upload'))
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FutureBuilder(
                future: _schools,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    if (data.isEmpty) {
                      return const Center(child: Text('No Schools added'));
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 150,
                                child: Text(
                                  'School Code',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: 250,
                                child: Text(
                                  'School Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                'Password',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        data[index]['schoolCode'].toString(),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                        width: 250,
                                        child: Text(data[index]['schoolName'])),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                        width: 200,
                                        child: Text(
                                            data[index]['schoolPassword'])),
                                    OutlinedButton(
                                        onPressed: () {
                                          // launchUrl(Uri.parse(
                                          //     '/onlineApplication/${data[index]['onlineCode']}'));

                                          context.go(
                                              '/onlineApplication/${data[index]['onlineCode']}');
                                        },
                                        child: Text('data'))
                                  ],
                                ),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: data.length),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulkUplaodDialog extends StatefulWidget {
  const BulkUplaodDialog({super.key});

  @override
  State<BulkUplaodDialog> createState() => _BulkUplaodDialogState();
}

class _BulkUplaodDialogState extends State<BulkUplaodDialog> {
  final _formKey = GlobalKey<FormState>();
  List<PlatformFile?>? files;
  bool isSaved = true;
  TextEditingController schoolCode = TextEditingController();

  savePersonalInfo() async {
    String? messagge;
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaved = false;
      });
      //   var url = Uri.http(ipv4, '/addPersonalInfo');

      var url = Uri.http(ipv4, '/bulkUpload');

      var req = http.MultipartRequest(
        'POST',
        url,
      );

      for (int i = 0; i < files!.length; i++) {
        var httpFile = http.MultipartFile.fromBytes(
            'profilePic', files![i]!.bytes!,
            filename: files![i]!.name);
        req.files.add(httpFile);
      }
      req.fields.addAll({'schoolCode': schoolCode.text.trim()});

      var res = await req.send();
      var responded = await http.Response.fromStream(res);

      // var response = await http.post(url, body: {

      //   //  'vehicleNo': vehicleNo,
      // });
      // print(response.statusCode);
      if (responded.body == 'true') {
        setState(() {
          isSaved = true;

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: 800,
            height: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                        width: 150,
                        // height: 30,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: schoolCode,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'School Code',
                                isDense: true,
                                border: OutlineInputBorder()),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    OutlinedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  type: FileType.image,
                                  allowMultiple: true,
                                  dialogTitle: 'hello');
                          if (result != null) {
                            files = result.files;

                            setState(() {
                              // _imagebytes = _image!.bytes;
                            });
                          }
                        },
                        child: Text('Select Photos')),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Container(
                    height: 500,
                    width: 800,
                    child: !files.isNull
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Wrap(
                                runSpacing: 20,
                                spacing: 5,
                                direction: Axis.vertical,
                                children: [
                                  for (int i = 0; i < files!.length; i++)
                                    Text(files![i]!.name)
                                ],
                              ),
                            ),
                          )
                        : Center(child: Text('No items selected')),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: ElevatedButton(
                      onPressed: savePersonalInfo, child: Text('upload')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddSchoolDialog extends StatefulWidget {
  const AddSchoolDialog({super.key, required this.refresh});
  final VoidCallback refresh;

  @override
  State<AddSchoolDialog> createState() => _AddSchoolDialogState();
}

class _AddSchoolDialogState extends State<AddSchoolDialog> {
  final _formKey = GlobalKey<FormState>();
  bool isSaved = true;
  TextEditingController schoolCode = TextEditingController();
  TextEditingController schoolName = TextEditingController();
  TextEditingController schoolPassword = TextEditingController();
  addNewSchool() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSaved = false;
      });
      var url = Uri.http(ipv4, '/addNewSchool');
      var res = await http.post(url, body: {
        'schoolCode': schoolCode.text.trim(),
        'schoolName': schoolName.text.trim(),
        'schoolPassword': schoolPassword.text.trim()
      });
      if (res.body == 'true') {
        setState(() {
          isSaved = true;
          Navigator.of(context).pop();
        });
        widget.refresh();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFieldWidget(
                  isEdit: true,
                  label: 'School Code',
                  controller: schoolCode,
                  isValidted: true),
              TextFieldWidget(
                isEdit: true,
                label: 'School Name',
                controller: schoolName,
                isValidted: true,
              ),
              TextFieldWidget(
                isEdit: true,
                label: 'School Password',
                controller: schoolPassword,
                isValidted: true,
              ),
              isSaved
                  ? ElevatedButton(
                      onPressed: addNewSchool,
                      child: const Text('Add'),
                    )
                  : const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
