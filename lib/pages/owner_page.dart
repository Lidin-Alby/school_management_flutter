import 'package:flutter/material.dart';
import 'package:school_management/pages/idCardEditor/design_main.dart';
import 'package:school_management/pages/midCard/mid_home.dart';
import 'package:school_management/pages/school_management.dart';

class OwnerPage extends StatefulWidget {
  const OwnerPage({super.key});

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('School Management')),
        body: Center(
          child: Wrap(
            children: [
              Card(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Schoolmanagement(),
                  )),
                  child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      child: Text('School Management')),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MidHome(),
                  )),
                  child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      child: Text('Mid Card')),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DesignMain(),
                  )),
                  child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      child: Text('Card Designer')),
                ),
              )
            ],
          ),
        ));
  }
}
