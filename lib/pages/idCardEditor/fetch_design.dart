import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ip_address.dart';
import 'design_class.dart';
import 'design_editor.dart';

class FetchDesign extends StatefulWidget {
  const FetchDesign({super.key, required this.designName});
  final String designName;

  @override
  State<FetchDesign> createState() => _FetchDesignState();
}

class _FetchDesignState extends State<FetchDesign> {
  late Future _getDesignData;

  getDesignData() async {
    final designName = Uri.encodeQueryComponent(widget.designName);
    final frontImageurl =
        Uri.parse('$ipv4/getFrontImage/?designName=$designName');
    final backImageurl =
        Uri.parse('$ipv4/getBackImage/?designName=$designName');
    final designDetailsUrl =
        Uri.parse('$ipv4/getDesignDetails/?designName=$designName');
    final frontImageRes = await http.get(frontImageurl);
    final backImageRes = await http.get(backImageurl);
    final designDetailsRes = await http.get(designDetailsUrl);
    Map designDetails = jsonDecode(designDetailsRes.body);
    final design = Design.fromMap(
      designDetails,
      frontImageRes.bodyBytes,
      backImageRes.bodyBytes,
    );
    // List data = jsonDecode(res.body);

    // print(jsonDecode(designDetails['frontElements']));

    return design;
  }

  @override
  void initState() {
    _getDesignData = getDesignData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDesignData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DesignEditor(
            design: snapshot.data,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
