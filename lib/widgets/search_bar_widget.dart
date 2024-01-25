import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/browser_client.dart';

import '../ip_address.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget(
      {super.key,
      required this.controller,
      required this.label,
      required this.isMob,
      this.isEdit = true
      // required this.searchFunction
      });
  final TextEditingController controller;
  final String label;
  final bool isMob;
  final bool isEdit;

  // final Function(String) searchFunction;

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController driverName = TextEditingController();

  final layerLink = LayerLink();
  List searchList = [];
  OverlayEntry? entry;

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    super.initState();
  }

  void showOverlay(List searchList) {
    final overlay = Overlay.of(context);
    if (entry != null) {
      entry!.remove();
    }
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    entry = OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                  link: layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      // height: 200,
                      width: 250,
                      constraints: BoxConstraints(maxHeight: 75),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var result in searchList)
                              InkWell(
                                onTap: () {
                                  // setState(() {
                                  widget.controller.text = result['fullName'];
                                  entry!.remove();
                                  // });
                                },
                                child: Container(
                                  // height: 30,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  width: 240,
                                  child: Text(
                                      '${result['fullName']}${widget.isMob ? ' - ${result['mob']}' : ''} '),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ));
    overlay.insert(entry!);
  }

  // buildOverlay(List search) {
  //   return
  // }

  searchFunction(value) async {
    if (value != '') {
      var client = BrowserClient()..withCredentials = true;
      var url = Uri.parse('$ipv4/searchStaff/$value');
      var res = await client.get(url);

      searchList = jsonDecode(res.body);
      showOverlay(searchList);
    } else {
      // if (entry != null) {
      entry!.remove();
      entry = null;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: SizedBox(
        width: 250,
        child: TextField(
          readOnly: !widget.isEdit,
          onChanged: (value) => searchFunction(value),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            label: Text(widget.label),
            isDense: true,
            border: OutlineInputBorder(),
          ),
          controller: widget.controller,
        ),
      ),
    );
  }
}
