import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../ip_address.dart';
import 'design_class.dart';
import 'design_editor.dart';
import 'fetch_design.dart';

class DesignHomePage extends StatefulWidget {
  const DesignHomePage({super.key});

  @override
  State<DesignHomePage> createState() => _DesignHomePageState();
}

class _DesignHomePageState extends State<DesignHomePage> {
  late Future _getDesigns;

  getDesigns() async {
    final url = Uri.parse('$ipv4/getDesigns');
    final res = await http.get(url);
    List data = jsonDecode(res.body);

    return data;
  }

  @override
  void initState() {
    _getDesigns = getDesigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _getDesigns,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List designs = snapshot.data;
              // [];
              //     List.generate(
              //   15,
              //   (index) => '$index',
              // );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: FilledButton.icon(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DesignEditor(
                          design: Design(
                              designName: '',
                              frontImageName: null,
                              frontBackgroundImage: null,
                              backImageName: '',
                              frontElements: [],
                              backElements: [],
                              backgroundImageHeight: 0),
                        ),
                      )),
                      label: Text('Create'),
                      icon: Icon(Icons.add_rounded),
                    ),
                  ),
                  designs.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height - 50,
                          child: Center(
                            child: Text('No Designs Created'),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Wrap(
                            children: [
                              for (String name in designs)
                                Card.filled(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            FetchDesign(designName: name),
                                      ));
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Center(
                                        child: Text(name),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
