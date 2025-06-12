import 'package:flutter/material.dart';

class DeleteProfileRequest extends StatefulWidget {
  const DeleteProfileRequest({super.key});

  @override
  State<DeleteProfileRequest> createState() => _DeleteProfileRequestState();
}

class _DeleteProfileRequestState extends State<DeleteProfileRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Removal'),
      ),
      body: Center(
          child: SelectableText.rich(
        textAlign: TextAlign.center,
        TextSpan(children: [
          TextSpan(
            text: 'To remove your data from our system.\nContact:',
            style: TextStyle(color: Colors.black54),
          ),
          TextSpan(
              text: ' +91 86879 28687',
              style: TextStyle(fontWeight: FontWeight.bold))
        ]),
        style: TextStyle(
          fontSize: 25,
          height: 1.4,
        ),
      )),
    );
  }
}
