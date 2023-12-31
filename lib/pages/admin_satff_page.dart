import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/browser_client.dart';
import 'package:school_management/ip_address.dart';
import 'package:school_management/widgets/documents_staff.dart';

import '../widgets/account_info_staff.dart';
import '../widgets/contact_info_staff.dart';
import '../widgets/personal_info_staff.dart';

class AdminStaff extends StatefulWidget {
  const AdminStaff({super.key});

  @override
  State<AdminStaff> createState() => _AdminStaffState();
}

class _AdminStaffState extends State<AdminStaff> {
  late Future _staffUsers;
  List selectedStaffs = [];
  String searchText = '';
  List staffs = [];
  getStaffUsers() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getStaffUsers');
    var res = await client.get(url);

    List staffs = json.decode(res.body);
    print(staffs);
    return staffs;
  }

  deleteStudent() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/deleteStaff');
    var res =
        await client.delete(url, body: {'staffs': jsonEncode(selectedStaffs)});

    if (res.body == 'true') {
      setState(() {
        _staffUsers = getStaffUsers();
        selectedStaffs = [];
      });
    }
  }

  Future getStaffProfilePic(fileName) async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getStaffPic/$fileName');
    var response = await client.get(url);

    return response.bodyBytes;
  }

  @override
  void initState() {
    _staffUsers = getStaffUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
            backgroundColor: Colors.indigo[900],
            title: Text('Staff'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton.icon(
                  onPressed: () => showModalBottomSheet(
                    enableDrag: false,
                    isScrollControlled: true,
                    isDismissible: true,
                    context: context,
                    builder: (context) => AddStaffDialog(
                      refresh: () => setState(() {
                        _staffUsers = getStaffUsers();
                      }),
                    ),
                  ),
                  icon: Icon(Icons.add_rounded),
                  label: Text('New Staff'),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 400,
                        child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                hintText: 'Search Staff',
                                isDense: true,
                                prefixIcon: Icon(Icons.search)),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            }
                            // searchFunction(value),
                            ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    if (selectedStaffs.isNotEmpty)
                      ElevatedButton.icon(
                          label: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: deleteStudent,
                          icon: Icon(
                            Icons.delete,
                          )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: _staffUsers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      staffs = snapshot.data;
                      if (searchText != '') {
                        staffs = staffs
                            .where((element) =>
                                element['fullName']
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()) ||
                                element['mob'].contains(searchText))
                            .toList();
                      }
                      if (staffs.isEmpty) {
                        return const Text('No enteries made');
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DataTable(
                                // dataRowMinHeight: 60,
                                dataRowMaxHeight: 100,
                                headingRowColor: MaterialStateColor.resolveWith(
                                    (states) => Colors.orange.shade50),
                                headingTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                showCheckboxColumn: true,
                                columns: [
                                  DataColumn(label: Text(' ')),
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Role')),
                                  DataColumn(label: Text('Mob No.')),
                                  DataColumn(label: Text(' ')),
                                ],
                                rows: staffs
                                    .map(
                                      (staff) => DataRow(
                                        selected: selectedStaffs
                                            .contains(staff['mob']),
                                        onSelectChanged: (value) {
                                          setState(() {
                                            if (selectedStaffs
                                                .contains(staff['mob'])) {
                                              selectedStaffs
                                                  .remove(staff['mob']);
                                            } else {
                                              selectedStaffs.add(staff['mob']);
                                            }
                                          });
                                        },
                                        cells: [
                                          DataCell(
                                            staff['staffProfilePic'] == ''
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Icon(
                                                      Icons
                                                          .account_circle_rounded,
                                                      size: 85,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                : FutureBuilder(
                                                    future: getStaffProfilePic(
                                                        staff[
                                                            'staffProfilePic']),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 15),
                                                          child: CircleAvatar(
                                                            radius: 50,
                                                            backgroundImage:
                                                                MemoryImage(
                                                                    snapshot
                                                                        .data),
                                                          ),
                                                        );
                                                      } else if (snapshot
                                                          .hasError) {
                                                        return Text(
                                                            'Error loading image');
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  ),
                                          ),
                                          DataCell(Text(staff['fullName'])),
                                          DataCell(
                                              Text(staff['role'].toString())),
                                          DataCell(Text(staff['mob'])),
                                          DataCell(
                                            IconButton(
                                              constraints: BoxConstraints(),
                                              padding: EdgeInsets.zero,
                                              splashRadius: 20,
                                              style: IconButton.styleFrom(
                                                  padding: EdgeInsets.zero),
                                              onPressed: () => context
                                                  .go('/staff/${staff['mob']}'),
                                              icon: Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class AddStaffDialog extends StatefulWidget {
  const AddStaffDialog(
      {super.key, required this.refresh, this.isDriver = false});
  final VoidCallback refresh;
  final bool isDriver;

  @override
  State<AddStaffDialog> createState() => _AddStaffDialogState();
}

class _AddStaffDialogState extends State<AddStaffDialog> {
  String selectedTab = 'personal';
  String mob = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(
        alignment: AlignmentDirectional.topEnd,
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.refresh();
          },
          icon: Icon(Icons.close_rounded),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  style: selectedTab == 'personal'
                      ? OutlinedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white)
                      : null,
                  onPressed: () {},
                  child: Text('Personal Info')),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                  style: selectedTab == 'account'
                      ? OutlinedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white)
                      : null,
                  onPressed: () {},
                  child: Text('Account Info')),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                  style: selectedTab == 'contact'
                      ? OutlinedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white)
                      : null,
                  onPressed: () {},
                  child: Text('Contact Info')),
              SizedBox(
                width: 10,
              ),
              OutlinedButton(
                style: selectedTab == 'document'
                    ? OutlinedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white)
                    : null,
                onPressed: () {},
                child: Text('Documents'),
              ),
            ],
          ),
        ),
      ),
      Divider(),
      if (selectedTab == 'personal')
        SingleChildScrollView(
          child: PersonalInfoStaff(
            isDriver: widget.isDriver,
            mob: '',
            isEdit: true,
            callback: (p0) {
              setState(() {
                mob = p0;
                selectedTab = 'account';
              });
            },
          ),
        ),
      if (selectedTab == 'account')
        SingleChildScrollView(
          child: AccountInfoStaff(
            isEdit: true,
            mob: mob,
            callback: () => setState(() {
              selectedTab = 'contact';
            }),
          ),
        ),
      if (selectedTab == 'contact')
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: SingleChildScrollView(
            child: ContactInfoStaff(
              isEdit: true,
              mob: mob,
              callback: () => setState(() {
                selectedTab = 'document';
              }),
            ),
          ),
        ),
      if (selectedTab == 'document')
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: StaffDocument(
              mob: mob,
              isEdit: true,
              refresh: () {
                widget.refresh();
              },
            ),
          ),
        )
    ]);
  }
}
