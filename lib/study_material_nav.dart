import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudyMaterialNav extends StatelessWidget {
  const StudyMaterialNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map studyMaterial = {
      'English': {
        'Chapter 1 Grammer': ['google.com', 'youtube.com', 'facebook.com'],
        'Chapter 2 Grammer': ['google2.com', 'youtube2.com', 'facebook2.com'],
      },
      'Maths': {
        'Chapter 1 Numbers': {
          'Topic Name 1': 'maths.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
        'Chapter 2 Integers': {
          'Topic Name 1': 'google.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
      },
      'History': {
        'Chapter 1 Last Decade': {
          'Topic Name 1': 'history.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
        'Chapter 2 French Revelution': {
          'Topic Name 1': 'google.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
      },
      'Geography': {
        'Chapter 1 Grammer': {
          'Topic Name 1': 'google.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
        'Chapter 2 Grammer': {
          'Topic Name 1': 'google.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
      },
      'Science': {
        'Chapter 1 Numbers': {
          'Topic Name 1': 'maths.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
        'Chapter 2 Integers': {
          'Topic Name 1': 'google.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
      },
      'Subject 1': {
        'Chapter 1 Last Decade': {
          'Topic Name 1': 'history.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
        'Chapter 2 French Revelution': {
          'Topic Name 1': 'google.com',
          'Topic Name 2': 'youtube.com',
          'Topic Name 3': 'facebook.com'
        },
      },
    };
    //print(studyMaterial.keys.first);
    return Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Container(
                width: MediaQuery.of(context).size.width - 175,
                child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              for (var subject in studyMaterial.keys)
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                      color: Colors.white,
                                      child: InkWell(
                                        onDoubleTap: () => context.go(
                                            '/study-material/$subject',
                                            extra: studyMaterial[subject]),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 50,
                                          width: 150,
                                          child: Center(child: Text(subject)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
