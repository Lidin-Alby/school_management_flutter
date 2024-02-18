import 'package:flutter/material.dart';

class SubmitDialog extends StatelessWidget {
  const SubmitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 400,
          width: 400,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.indigo, width: 5),
              borderRadius: BorderRadius.circular(10)),
          child: Column(children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 300,
              child: Text(
                'Your for has been Successfully Submitted',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
