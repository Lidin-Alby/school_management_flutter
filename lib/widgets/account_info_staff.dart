import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';
import 'textfield_widget.dart';

class AccountInfoStaff extends StatefulWidget {
  const AccountInfoStaff(
      {super.key,
      required this.callback,
      required this.mob,
      required this.isEdit});
  final VoidCallback callback;
  final String mob;
  final bool isEdit;

  @override
  State<AccountInfoStaff> createState() => _AccountInfoStaffState();
}

class _AccountInfoStaffState extends State<AccountInfoStaff> {
  TextEditingController aadhaar = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController uan = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountNo = TextEditingController();
  TextEditingController ifscCode = TextEditingController();
  TextEditingController nameOnRecord = TextEditingController();
  TextEditingController dlNo = TextEditingController();
  TextEditingController dlValidity = TextEditingController();
  TextEditingController basicSalary = TextEditingController();
  String? salaryType;
  String? contractType;
  List salaryTypeList = [];
  List contractTypeList = [];
  bool isSaved = true;
  bool next = false;
  late bool isEdit;
  late String schoolCode;

  @override
  void initState() {
    isEdit = widget.isEdit;
    // if (!widget.isEdit) {
    getAccountInfoStaff();
    // }
    super.initState();
  }

  getAccountInfoStaff() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/getStaffAccountInfo/${widget.mob}');

    var response = await client.get(url);

    print(response.body);
    if (response.body.isNotEmpty) {
      Map data = jsonDecode(response.body);
      print(data['schoolCode']);
      schoolCode = data['schoolCode'].toString();
      aadhaar.text = data['aadhaar'] ?? '';
      pan.text = data['pan'] ?? '';
      uan.text = data['uan'] ?? '';
      bankName.text = data['bankName'] ?? '';
      accountNo.text = data['accountNo'] ?? '';
      ifscCode.text = data['ifscCode'] ?? '';
      nameOnRecord.text = data['nameOnRecord'] ?? '';
      dlNo.text = data['dlNo'] ?? '';
      dlValidity.text = data['dlValidity'] ?? '';
      basicSalary.text = data['basicSalary'] ?? '';
      salaryType = data['salaryType'] == '' ? null : data['salaryType'];
      contractType = data['contractType'] == '' ? null : data['contractType'];
    }
    getStaffForms();
  }

  getStaffForms() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.parse('$ipv4/staffForms');
    var response = await client.get(url);
    print(response.body);
    Map details = jsonDecode(response.body);
    salaryTypeList = details['forms']['salaryTypes'];
    contractTypeList = details['forms']['contractTypes'];
    setState(() {});
  }

  saveAccountInfoStaff() async {
    setState(() {
      isSaved = false;
    });
    var url = Uri.parse('$ipv4/addStaffAccountInfo');
    print('mobile');
    print(widget.mob);
    var response = await http.post(url, body: {
      'schoolCode': schoolCode.toString(),
      'mob': widget.mob,
      'aadhaar': aadhaar.text.trim(),
      'pan': pan.text.trim(),
      'uan': uan.text.trim(),
      'bankName': bankName.text.trim(),
      'accountNo': accountNo.text.trim(),
      'ifscCode': ifscCode.text.trim(),
      'nameOnRecord': nameOnRecord.text.trim(),
      'dlNo': dlNo.text.trim(),
      'dlValidity': dlValidity.text.trim(),
      'basicSalary': basicSalary.text.trim(),
      'salaryType': salaryType ?? '',
      'contractType': contractType ?? '',
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
          SizedBox(
            height: 30,
          ),
          firstColumn(),
          SizedBox(
            height: 50,
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
                          onPressed: widget.callback,
                          child: Text('Next'),
                        )
                      : ElevatedButton(
                          onPressed: saveAccountInfoStaff,
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
      runSpacing: 20, spacing: 20,
      // direction: Axis.vertical,
      children: [
        TextFieldWidget(
          isEdit: isEdit,
          label: 'Aadhaar Card No.',
          controller: aadhaar,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'Pan No.',
          controller: pan,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'Uan No.',
          controller: uan,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'Bank Name',
          controller: bankName,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'Account No.',
          controller: accountNo,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'IFSC Code',
          controller: ifscCode,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'Name as Bank Record',
          controller: nameOnRecord,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'DL No.',
          controller: dlNo,
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'DL Validity',
          controller: dlValidity,
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
                  disabledHint: salaryType != null
                      ? Text(
                          salaryType.toString(),
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          'Salary Type',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                  value: salaryType,
                  isExpanded: true,
                  underline: Text(''),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Salary Type'),
                  ),
                  items: salaryTypeList
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      salaryType = value.toString();
                    });
                  },
                ),
              ),
            ),
            if (salaryType != null)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 3),
                color: Colors.blue[50],
                child: Text(
                  'Salary Type',
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
                        builder: (context) => AddSalaryType(
                              salaryTypeList: salaryTypeList,
                              schoolCode: schoolCode,
                              refresh: () => getStaffForms(),
                            )),
                    child: Icon(Icons.add)),
              ),
            )
          ],
        ),
        TextFieldWidget(
          isEdit: isEdit,
          label: 'Basic Salary',
          controller: basicSalary,
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
                  disabledHint: contractType != null
                      ? Text(
                          contractType.toString(),
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          'Contract Type',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                  value: contractType,
                  isExpanded: true,
                  underline: Text(''),
                  hint: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Contract Type'),
                  ),
                  items: contractTypeList
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      contractType = value.toString();
                    });
                  },
                ),
              ),
            ),
            if (contractType != null)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 3),
                color: Colors.blue[50],
                child: Text(
                  'Contract Type',
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
                        builder: (context) => AddContractType(
                              contractTypeList: contractTypeList,
                              schoolCode: schoolCode,
                              refresh: () => getStaffForms(),
                            )),
                    child: Icon(Icons.add)),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class AddSalaryType extends StatefulWidget {
  const AddSalaryType(
      {super.key,
      required this.salaryTypeList,
      required this.schoolCode,
      required this.refresh});
  final List salaryTypeList;
  final String schoolCode;
  final VoidCallback refresh;

  @override
  State<AddSalaryType> createState() => _AddSalaryTypeState();
}

class _AddSalaryTypeState extends State<AddSalaryType> {
  TextEditingController newSalaryType = TextEditingController();
  List salaryTypeList = [];
  @override
  void initState() {
    salaryTypeList = widget.salaryTypeList;
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
          'Add Salary Type',
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
            children: salaryTypeList
                .map((e) => Tooltip(
                      message: 'Remove',
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          var client = BrowserClient()..withCredentials = true;
                          var url = Uri.parse('$ipv4/removeSalaryType');
                          var res = await client.delete(url, body: {
                            'schoolCode': widget.schoolCode.toString(),
                            'salaryType': e
                          });

                          if (res.body == 'true') {
                            print('salary type removed');
                            setState(() {
                              salaryTypeList.remove(e);
                              newSalaryType.clear();
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
          label: 'New Salary Type',
          controller: newSalaryType,
          isEdit: true,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            var client = BrowserClient()..withCredentials = true;
            var url = Uri.parse('$ipv4/addSalaryType');
            var res = await client.post(url, body: {
              'schoolCode': widget.schoolCode.toString(),
              'salaryType': newSalaryType.text.trim()
            });

            if (res.body == 'true') {
              print('salary added');

              setState(() {
                salaryTypeList.add(newSalaryType.text.trim());
                newSalaryType.clear();
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

class AddContractType extends StatefulWidget {
  const AddContractType(
      {super.key,
      required this.contractTypeList,
      required this.schoolCode,
      required this.refresh});
  final List contractTypeList;
  final String schoolCode;
  final VoidCallback refresh;
  @override
  State<AddContractType> createState() => _AddContractTypeState();
}

class _AddContractTypeState extends State<AddContractType> {
  TextEditingController newContractType = TextEditingController();
  List contractTypeList = [];
  @override
  void initState() {
    contractTypeList = widget.contractTypeList;
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
          'Add Contract Type',
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
            children: contractTypeList
                .map((e) => Tooltip(
                      message: 'Remove',
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () async {
                          var client = BrowserClient()..withCredentials = true;
                          var url = Uri.parse('$ipv4/removeContractType');
                          var res = await client.delete(url, body: {
                            'schoolCode': widget.schoolCode.toString(),
                            'contractType': e
                          });

                          if (res.body == 'true') {
                            print('contract type removed');
                            setState(() {
                              contractTypeList.remove(e);
                              newContractType.clear();
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
          label: 'New Contract Type',
          controller: newContractType,
          isEdit: true,
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            var client = BrowserClient()..withCredentials = true;
            var url = Uri.parse('$ipv4/addContractType');
            var res = await client.post(url, body: {
              'schoolCode': widget.schoolCode.toString(),
              'contractType': newContractType.text.trim()
            });

            if (res.body == 'true') {
              print('contract type added');

              setState(() {
                contractTypeList.add(newContractType.text.trim());
                newContractType.clear();
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
