import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class EditWidget extends StatelessWidget {
  const EditWidget({super.key, required this.cancel, required this.done});

  final VoidCallback cancel;
  final VoidCallback done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(onPressed: cancel, child: Text('Cancel')),
          SizedBox(
            width: 10,
          ),
          TextButton(
            style: IconButton.styleFrom(
              padding: EdgeInsets.all(15),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            onPressed: done,
            child: Text('Done'),
          ),
        ],
      ),
    );
  }
}
