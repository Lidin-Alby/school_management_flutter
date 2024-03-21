import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Draggable(
          data: 'hello',
          feedback: Container(
            width: 100,
            height: 100,
            color: Colors.blue,
            child: Text('data'),
          ),
          child: Container(
              width: 100, height: 100, color: Colors.red, child: Text('data')),
        ),
        DragTarget(
          builder: (context, candidateData, rejectedData) => Container(
            width: 200,
            height: 200,
            color: Colors.orange,
          ),
        )
      ],
    );
  }
}
