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
  int? selected;

  getDesigns() async {
    final url = Uri.parse('$ipv4/getDesigns');
    final res = await http.get(url);
    List data = jsonDecode(res.body);

    return data;
  }

  deleteDesign(String designName) async {
    final url = Uri.parse('$ipv4/deleteDesign');
    final res = await http.delete(url, body: {'designName': designName});
    if (res.body == 'true') {
      setState(() {
        _getDesigns = getDesigns();
      });
    }
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
                          savedDesigns: designs,
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
                              for (int i = 0; i < designs.length; i++)
                                Card.filled(
                                  child: InkWell(
                                    onLongPress: () {
                                      setState(() {
                                        selected = i;
                                      });
                                    },
                                    onTap: () {
                                      if (selected != null) {
                                        setState(() {
                                          selected = null;
                                        });
                                      } else {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => FetchDesign(
                                              designName: designs[i],
                                              savedDesigns: designs,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: SizedBox(
                                      width: 150,
                                      height: 100,
                                      child: Column(
                                        mainAxisAlignment: i == selected
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.center,
                                        children: [
                                          if (i == selected)
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: IconButton(
                                                color: Colors.red,
                                                iconSize: 15,
                                                onPressed: () =>
                                                    deleteDesign(designs[i]),
                                                icon: Icon(Icons.delete),
                                              ),
                                            ),
                                          Text(designs[i]),
                                        ],
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
