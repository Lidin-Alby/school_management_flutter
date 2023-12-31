import 'package:flutter/material.dart';

class ResultNav extends StatelessWidget {
  const ResultNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map result = {
      'Test 1': {'Eng': 40.5, 'Maths': 30, 'Science': 35},
      'Test 2': {'Eng': 20, 'Maths': 35, 'Science': 35},
      'Test 3': {'Eng': 20, 'Maths': 30, 'Science': 25},
    };

    getMarks(exam) {
      num totalMarks = 0;
      for (var subject in result[exam].keys) {
        totalMarks += result[exam][subject];
      }
      return totalMarks;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        children: [
          for (var exam in result.keys)
            Container(
              color: Colors.indigo[50],
              width: 500,
              child: Theme(
                data: ThemeData(splashColor: Colors.red),
                child: ExpansionTile(
                    textColor: Colors.indigo,
                    iconColor: Colors.indigo,
                    //   collapsedBackgrosundColor: Colors.indigo[50],
                    // textColor: Color(0xffAE8A68),
                    // iconColor: Color(0xffAE8A68),
                    childrenPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            exam,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${getMarks(exam).toString()} / 150')
                        ],
                      ),
                    ),
                    subtitle: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        color: Colors.green,
                        backgroundColor: Colors.grey[400],
                        minHeight: 15,
                        value: getMarks(exam) / 150,
                      ),
                    ),
                    children: [
                      for (var subject in result[exam].keys)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  //   color: Colors.red,
                                  width: 100,
                                  child: Text(
                                    subject, style: TextStyle(fontSize: 18),
                                    //textAlign: TextAlign.start,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  child: Text(
                                    result[exam][subject].toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ]),
              ),
            ),
        ],
      ),
    );
  }
}
