import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  const MenuCard(
      {Key? key,
      required this.icon,
      required this.title,
      required this.tapFunction})
      : super(key: key);
  final IconData icon;
  final String title;
  final VoidCallback tapFunction;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        // splashColor: Colors.indigo,
        onDoubleTap: tapFunction,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.indigo),
              borderRadius: BorderRadius.circular(5)),
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.blue,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
