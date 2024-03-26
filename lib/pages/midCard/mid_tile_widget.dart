import 'package:flutter/material.dart';

class MidTile extends StatelessWidget {
  const MidTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.color,
      required this.callback});
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
          child: InkWell(
            onTap: callback,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 6, color: color),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Wrap(
                  runSpacing: 15,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        icon,
                        size: 30,
                      ),
                    ),
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
