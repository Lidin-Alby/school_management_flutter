import 'package:flutter/material.dart';

import 'edit_widget.dart';

class AddMarks extends StatefulWidget {
  const AddMarks({super.key});

  @override
  State<AddMarks> createState() => _AddMarksState();
}

class _AddMarksState extends State<AddMarks> {
  List exams = ['Test 1', 'Test 2', 'Test 3'];
  late String _selectedDropDown;
  bool enableEdit = false;
  Map attendance = {
    1: {
      'Name': 'Lidin',
      'subjects': {
        'English': 40,
        'Maths': 35,
      }
    },
    2: {
      'Name': 'Gupta',
      'subjects': {
        'English': 40,
        'Maths': 35,
      }
    },
    3: {
      'Name': 'Rahul',
      'subjects': {
        'English': 40,
        'Maths': 35,
      }
    }
  };
  @override
  void initState() {
    _selectedDropDown = exams.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                  color: Colors.deepPurple[200],
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton(
                underline: Text(''),
                value: _selectedDropDown,
                items: List.generate(
                    exams.length,
                    (index) => DropdownMenuItem(
                          child: Text(exams[index]),
                          value: exams[index],
                        )),
                onChanged: (value) {
                  setState(() {
                    _selectedDropDown = value as String;
                  });
                },
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(5))),
                width: 75,
                height: 40,
                child: Text(
                  'Roll No.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 5),
                alignment: AlignmentDirectional.centerStart,
                color: Colors.indigo[100],
                width: 300,
                height: 40,
                child: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                alignment: AlignmentDirectional.centerStart,
                color: Colors.indigo[100],
                width: 110,
                height: 40,
                child: Text(
                  'Maths',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(5))),
                width: 110,
                height: 40,
                child: Text(
                  'English',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
              // if (enableEdit)
              //   TextButton.icon(
              //     onPressed: () async {
              //       final selectedDate = await showDatePicker(
              //           context: context,
              //           initialDate: DateTime.now(),
              //           firstDate: DateTime(DateTime.now().year - 1),
              //           lastDate: DateTime.now()) as DateTime;
              //       setState(() {
              //         _date = selectedDate;
              //       });
              //     },
              //     icon: Icon(Icons.edit_calendar_rounded),
              //     label: Text('Select Date'),
              //   ),
              SizedBox(
                width: 20,
              ),
              OutlinedButton(
                onPressed: !enableEdit
                    ? () {
                        setState(() {
                          enableEdit = true;
                        });
                      }
                    : null,
                child: Icon(Icons.edit_outlined),
              ),
            ],
          ),
          for (var i in attendance.keys)
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5),
                  alignment: AlignmentDirectional.centerStart,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: i == attendance.keys.last
                          ? BorderRadius.only(bottomLeft: Radius.circular(5))
                          : null),
                  width: 75,
                  height: 43,
                  child: Text(
                    i.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  alignment: AlignmentDirectional.centerStart,
                  color: Colors.indigo,
                  width: 300,
                  height: 43,
                  child: Text(
                    attendance[i]['Name'],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                for (int j = 0; j < attendance[i]['subjects'].length; j++)
                  SizedBox(
                    width: 110,
                    //  height: 50,
                    child: TextField(
                      enabled: enableEdit,
                      textAlign: TextAlign.center,
                      maxLength: 3,
                      decoration: InputDecoration(
                          counterText: '',
                          //  enabled: false,
                          border: OutlineInputBorder(
                              borderRadius: j == attendance.keys.last
                                  ? BorderRadius.only(
                                      bottomRight: Radius.circular(5))
                                  : BorderRadius.all(Radius.zero)),
                          isDense: true),
                    ),
                  ),
              ],
            ),
          if (enableEdit)
            EditWidget(
              cancel: () {
                setState(() {
                  enableEdit = false;
                });
              },
              done: () {},
            ),
        ],
      ),
    );
  }
}
