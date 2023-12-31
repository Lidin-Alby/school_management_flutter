import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'menu_card_widget.dart';

class TeacherMenuPage extends StatelessWidget {
  const TeacherMenuPage({super.key, required this.classNo});
  final String classNo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classNo,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
