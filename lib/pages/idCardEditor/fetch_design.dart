import 'package:flutter/material.dart';

import 'design_editor.dart';
import 'functions.dart';

class FetchDesign extends StatefulWidget {
  const FetchDesign(
      {super.key, required this.designName, required this.savedDesigns});
  final String designName;
  final List savedDesigns;

  @override
  State<FetchDesign> createState() => _FetchDesignState();
}

class _FetchDesignState extends State<FetchDesign> {
  late Future _getDesignData;

  @override
  void initState() {
    _getDesignData = getDesignData(widget.designName);
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
            savedDesigns: widget.savedDesigns,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
