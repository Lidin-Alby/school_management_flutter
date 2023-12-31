import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';
import 'textfield_widget.dart';

class ContactInfoStaff extends StatefulWidget {
  const ContactInfoStaff(
      {super.key,
      required this.mob,
      required this.callback,
      required this.isEdit});
  final String mob;
  final VoidCallback callback;
  final bool isEdit;

  @override
  State<ContactInfoStaff> createState() => _ContactInfoStaffState();
}

class _ContactInfoStaffState extends State<ContactInfoStaff> {
  TextEditingController curAddressLine1 = TextEditingController();
  TextEditingController curAddressLine2 = TextEditingController();
  TextEditingController curAddressLine3 = TextEditingController();
  TextEditingController curPincode = TextEditingController();
  TextEditingController perAddressLine1 = TextEditingController();
  TextEditingController perAddressLine2 = TextEditingController();
  TextEditingController perAddressLine3 = TextEditingController();
  TextEditingController perPincode = TextEditingController();
  bool isSaved = true;
  bool next = false;
  late bool isEdit;
  late int schoolCode;

  @override
  void initState() {
    isEdit = widget.isEdit;
    // if (!widget.isEdit) {
    getContactInfoStaff();
    // }
    super.initState();
  }

  getContactInfoStaff() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getStaffAccountInfo/${widget.mob}');

    var response = await client.get(url);
    print(response.body);
    Map data = jsonDecode(response.body);
    schoolCode = data['schoolCode'];
    curAddressLine1.text = data['curAddressLine1'] ?? '';
    curAddressLine2.text = data['curAddressLine2'] ?? '';
    curAddressLine3.text = data['curAddressLine3'] ?? '';
    curPincode.text = data['curPincode'] ?? '';
    perAddressLine1.text = data['perAddressLine1'] ?? '';
    perAddressLine2.text = data['perAddressLine2'] ?? '';
    perAddressLine3.text = data['perAddressLine3'] ?? '';
    perPincode.text = data['perPincode'] ?? '';
  }

  saveContactInfoStaff() async {
    setState(() {
      isSaved = false;
    });
    var url = Uri.http(ipv4, '/addStaffContactInfo');
    var response = await http.post(url, body: {
      'schoolCode': schoolCode.toString(),
      'mob': widget.mob,
      'curAddressLine1': curAddressLine1.text.trim(),
      'curAddressLine2': curAddressLine2.text.trim(),
      'curAddressLine3': curAddressLine3.text.trim(),
      'curPincode': curPincode.text.trim(),
      'perAddressLine1': perAddressLine1.text.trim(),
      'perAddressLine2': perAddressLine2.text.trim(),
      'perAddressLine3': perAddressLine3.text.trim(),
      'perPincode': perPincode.text.trim()
    });

    if (response.body == 'true') {
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
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: widget.callback,
                          child: Text('Next'),
                        )
                      : ElevatedButton(
                          onPressed: saveContactInfoStaff,
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

  Wrap firstColumn() {
    return Wrap(
      spacing: 40,
      children: [
        SizedBox(
          width: 275,
          child: Column(
            // spacing: 20,
            // direction: Axis.vertical,
            children: [
              Center(
                child: Text(
                  'Staff Current Address',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.purple),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFieldWidget(
                isEdit: isEdit,
                label: 'Address Line 1',
                controller: curAddressLine1,
              ),
              SizedBox(
                height: 15,
              ),
              TextFieldWidget(
                isEdit: isEdit,
                label: 'Address Line 2',
                controller: curAddressLine2,
              ),
              SizedBox(
                height: 15,
              ),
              TextFieldWidget(
                isEdit: isEdit,
                label: 'Address Line 3',
                controller: curAddressLine3,
              ),
              SizedBox(
                height: 15,
              ),
              TextFieldWidget(
                isEdit: isEdit,
                label: 'Pincode',
                controller: curPincode,
              ),
            ],
          ),
        ),
        Wrap(
          direction: Axis.vertical,
          children: [
            Center(
              child: Text(
                'Staff Permanent Address',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Address Line 1',
              controller: perAddressLine1,
            ),
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Address Line 2',
              controller: perAddressLine2,
            ),
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Address Line 3',
              controller: perAddressLine3,
            ),
            SizedBox(
              height: 15,
            ),
            TextFieldWidget(
              isEdit: isEdit,
              label: 'Pincode',
              controller: perPincode,
            ),
          ],
        ),
      ],
    );
  }
}
