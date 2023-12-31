import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key, required this.subjectName});
  final String subjectName;

  @override
  Widget build(BuildContext context) {
    Map chapters = {
      'Chapter 1 Grammer': {
        'Topic Name 1': ' google.com',
        'Topic Name 2': ' youtube.com',
        'Topic Name 3': 'facebook.com'
      },
      'Chapter 2 Grammer': {
        'Topic Name 1': 'google.com',
        'Topic Name 2': 'youtube.com',
        'Topic Name 3': 'facebook.com'
      }
    };
    print(chapters);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              for (var content in chapters.keys)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onDoubleTap: () =>
                            context.go('/study-material/$subjectName/chapter'),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 200,
                          height: 50,
                          child: Center(child: Text(content)),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
