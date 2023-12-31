import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import 'ip_address.dart';

class ProfileNav extends StatefulWidget {
  const ProfileNav({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileNav> createState() => _ProfileNavState();
}

class _ProfileNavState extends State<ProfileNav> {
  String firstName = '';
  String lastName = '';
  String classTitle = '';
  String admNo = '';
  String dob = '';
  String fatherName = '';
  String motherName = '';
  String curAddressLine1 = '';
  String curAddressLine2 = '';
  String curAddressLine3 = '';
  String curPincode = '';
  String fatherMobNo = '';
  String motherMobNo = '';
  String gaurdianMobNo = '';
  String email = '';
  late Future _myProfile;

  @override
  void initState() {
    _myProfile = getMyProfile();
    super.initState();
  }

  getMyProfile() async {
    var client = BrowserClient()..withCredentials = true;
    var url = Uri.http(ipv4, '/getMyProfile');
    var res = await client.get(url);
    // print(res.body);
    var data = jsonDecode(res.body);
    print(data);
    admNo = data['admNo'];
    firstName = data['firstName'];
    lastName = data['lastName'];
    fatherName = data['fatherName'];
    motherName = data['motherName'];
    fatherMobNo = data['fatherMobNo'];
    motherMobNo = data['motherMobNo'];
    classTitle = data['classTitle'];
    //  curAddressLine1 = data['curAddressLine1'];
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: FutureBuilder(
          future: _myProfile,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (width > 900) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 400,
                                decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.only(right: 30),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        color: Colors.white,
                                        size: 100,
                                        Icons.account_circle,
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$firstName $lastName',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Text(
                                                  classTitle,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  thickness: 1,
                                                  color: Colors.black,
                                                ),
                                                Text(
                                                  'Roll No.- 20',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    //  fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Adm No.',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(admNo,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Date of Birth',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            dob,
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.indigo, width: 3),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    //VerticalDivider(),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SelectableText(
                                          'Father\'s Name',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ProfileContainer(
                                          text: fatherName,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Mother\'s Name',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ProfileContainer(
                                          text: motherName,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.home),
                                            Text(
                                              ' Address',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        ProfileContainer(
                                          text:
                                              '$curAddressLine1,\n$curAddressLine2,\n$curAddressLine3,\n$curPincode',
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.phone_rounded),
                                            Text(
                                              ' Contacts',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        ProfileContainer(
                                          text: '$fatherMobNo, $motherMobNo',
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.mail_rounded),
                                            Text(
                                              ' Mail',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        ProfileContainer(
                                          text: email,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              editButton(context),
                            ],
                          );
                        } else
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ProfileCard(),
                                  editButton(context),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // MoreDetailsCard(),
                            ],
                          );
                      }),
                    ),
                  ),
                ),
              );
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }

  OutlinedButton editButton(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.black38),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: Size(20, 10),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          //      padding: EdgeInsets.symmetric(vertical: 5),
          // padding:
          //     EdgeInsets.symmetric(vertical: 15, horizontal: -5),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text('Edit Request'),
                        IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close)),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 500,
                                child: TextField(
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: 'Enter what to be edited',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('Submit Request'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          },
        );
      },
      child: Icon(
        Icons.edit_outlined,
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.indigo[100], borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        softWrap: true,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
