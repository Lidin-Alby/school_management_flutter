import 'package:flutter/material.dart';

class HomeworkNav extends StatelessWidget {
  const HomeworkNav({super.key});

  @override
  Widget build(BuildContext context) {
    final Map homework = {
      'English': {
        'topic': 'Fill the sentences',
        'givenDate': '20-03-22',
        'dueDate': '21-03-22'
      },
      'Maths': {
        'topic': 'Solve the problems',
        'givenDate': '15-01-22',
        'dueDate': '16-01-22'
      },
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            children: [
              for (var i in homework.keys)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: EdgeInsets.all(20),
                  //  padding: EdgeInsets.all(20),
                  color: Colors.indigo[50],
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Submit Pending on ${homework[i]['dueDate']}',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          homework[i]['topic'],
                          style:
                              TextStyle(fontSize: 17, color: Colors.grey[700]),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Download'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fixedSize: Size(120, 40),
                                elevation: 0,
                                // backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Submit'),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                fixedSize: Size(120, 40),
                                // backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
