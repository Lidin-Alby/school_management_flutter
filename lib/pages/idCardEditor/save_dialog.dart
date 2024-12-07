import 'package:flutter/material.dart';

import '../../ip_address.dart';
import 'design_class.dart';
import 'package:http/http.dart' as http;

class SaveDialog extends StatefulWidget {
  const SaveDialog({super.key, required this.design});
  final Design design;

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  bool uploaded = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController designNameController = TextEditingController();

  saveDesign() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        uploaded = false;
      });
      var url = Uri.parse("$ipv4/saveDesign");
      var request = http.MultipartRequest('POST', url);

      final stream = http.ByteStream(
          Stream.fromIterable(widget.design.frontBackgroundImage.map(
        (e) => [e],
      )));
      // print(await stream.length);
      int length = await stream.length;

      var httpImage = http.MultipartFile('image', stream, length,
          filename: widget.design.frontImageName);

      request.files.add(httpImage);
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      print(responded.body);
      if (responded.body == 'done') {
        Navigator.pop(context);
        setState(() {
          uploaded = true;
        });
      }
      // response. stream. transform(utf8.decoder).listen((event) {
      //   print(event);
      //   if (event == 'done') {
      //     Navigator.pop(context);
      //     setState(() {
      //       uploaded = true;
      //     });
      //   }
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Save Design'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          validator: (value) {
            if (value!.trim() == '') {
              return 'This field is required';
            }
            return null;
          },
          controller: designNameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Design Name',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        uploaded
            ? FilledButton(
                onPressed: saveDesign,
                child: Text('Save'),
              )
            : CircularProgressIndicator(),
      ],
    );
  }
}
