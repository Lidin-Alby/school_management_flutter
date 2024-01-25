import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

import '../ip_address.dart';
import 'textfield_widget.dart';

class ContactInfo extends StatefulWidget {
  const ContactInfo(
      {super.key,
      required this.admNo,
      required this.callback,
      required this.isEdit});

  final String admNo;
  final VoidCallback callback;
  final bool isEdit;

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  TextEditingController curAddressLine1 = TextEditingController();
  TextEditingController curAddressLine2 = TextEditingController();
  TextEditingController curAddressLine3 = TextEditingController();
  TextEditingController curPincode = TextEditingController();
  TextEditingController perAddressLine1 = TextEditingController();
  TextEditingController perAddressLine2 = TextEditingController();
  TextEditingController perAddressLine3 = TextEditingController();
  TextEditingController perPincode = TextEditingController();
  late int schoolCode;
  bool isSaved = true;
  bool next = false;
  late bool isEdit;

  @override
  void initState() {
    isEdit = widget.isEdit;
    print('contact');
    getStudentContactInfo();
    super.initState();
  }

  getStudentContactInfo() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getStudentContactInfo/${widget.admNo}');

    var response = await client.get(url);

    var data = jsonDecode(response.body);
    print(data);
    schoolCode = data['schoolCode'];
    print(schoolCode);
    curAddressLine1.text = data['curAddressLine1'] ?? '';
    curAddressLine2.text = data['curAddressLine2'] ?? '';
    curAddressLine3.text = data['curAddressLine3'] ?? '';
    curPincode.text = data['curPincode'] ?? '';
    perAddressLine1.text = data['perAddressLine1'] ?? '';
    perAddressLine2.text = data['perAddressLine2'] ?? '';
    perAddressLine3.text = data['perAddressLine3'] ?? '';
    perPincode.text = data['perPincode'] ?? '';
  }

  saveStudentContactInfo() async {
    setState(() {
      isSaved = false;
    });
    var url = Uri.parse('$ipv4/addStudentContactInfo');

    var response = await http.post(url, body: {
      'schoolCode': schoolCode.toString(),
      'admNo': widget.admNo,
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
        SizedBox(
          height: 70,
        ),
        Wrap(
          runSpacing: 20,
          children: [
            firstColumn(),
            SizedBox(
              width: 50,
            ),
            secondColumn()
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height - 600,
        ),
        if (isEdit && isSaved)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                        onPressed: saveStudentContactInfo,
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

  SizedBox secondColumn() {
    return SizedBox(
      width: 250,
      child: Wrap(
        runSpacing: 15,
        children: [
          Text(
            'Student Permanent Address',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.purple),
          ),
          SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Address Line 1',
            controller: perAddressLine1,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Address Line 2',
            controller: perAddressLine2,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Address Line 3',
            controller: perAddressLine3,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Pincode',
            controller: perPincode,
          ),
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
          Text(
            'Student Current Address',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.purple),
          ),
          SizedBox(
            height: 15,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Address Line 1',
            controller: curAddressLine1,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Address Line 2',
            controller: curAddressLine2,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Address Line 3',
            controller: curAddressLine3,
          ),
          TextFieldWidget(
            isEdit: isEdit,
            label: 'Pincode',
            controller: curPincode,
          ),
        ],
      ),
    );
  }
}
