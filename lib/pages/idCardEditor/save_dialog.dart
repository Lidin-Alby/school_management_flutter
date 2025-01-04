import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_management/ip_address.dart';

import 'design_class.dart';
// import 'package:http/http.dart' as http;
import 'dart:html' as html;

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
  double progress = 0;

  saveDesign() async {
    if (_formKey.currentState!.validate()) {
      final xhr = html.HttpRequest();
      // var url = Uri.parse("$ipv4/saveDesign");
      xhr.open('POST', '$ipv4/saveDesign');

      // var request = http.MultipartRequest('POST', url);
      xhr.upload.onProgress.listen(
        (event) {
          if (event.lengthComputable) {
            setState(() {
              progress = event.loaded! / event.total!;
            });
            if (progress == 1) {
              Navigator.pop(context);
            }
          }
        },
      );
      xhr.onLoad.listen(
        (event) {
          if (xhr.status == 200) {
            print('done');
          }
        },
      );
      String designName = designNameController.text.trim();
      widget.design.designName = designName;
      final formData = html.FormData();
      String frontext = widget.design.frontImageName!.split('.').last;
      String backext = widget.design.frontImageName!.split('.').last;
      widget.design.frontImageName = '$designName-frontImage.$frontext';

      formData.appendBlob(
          'image',
          html.Blob([widget.design.frontBackgroundImage]),
          '$designName-frontImage.$frontext');
      if (widget.design.backBackgroundImage != null) {
        widget.design.backImageName = '$designName-backImage.$backext';
        formData.appendBlob(
            'image',
            html.Blob([widget.design.backBackgroundImage]),
            '$designName-backImage.$backext');
      }
      formData.append('data', jsonEncode(widget.design.toMap()));
      xhr.send(formData);

      // var httpImage = http.MultipartFile.fromBytes(
      //     'image', widget.design.frontBackgroundImage,
      //     filename: widget.design.frontImageName);

      // request.files.add(httpImage);

      // // request.fields.addAll(widget.design.toMap());
      // var streamedResponse = await request.send();
      // var totalBytes = streamedResponse.contentLength;
      // var bytesUploaded = 0;
      // streamedResponse.stream.listen(
      //   (value) {
      //     bytesUploaded += value.length;
      //     print(bytesUploaded);
      //   },
      //   onDone: () async {
      //     var response = await http.Response.fromStream(streamedResponse);
      //     if (response.statusCode == 200) {
      //       print('done');
      //     }
      //   },
      // );
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
        progress == 0
            ? FilledButton(
                onPressed: saveDesign,
                child: Text('Save'),
              )
            : Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                  ),
                  Text(
                    '${progress.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
      ],
    );
  }
}
