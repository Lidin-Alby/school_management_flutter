import 'package:flutter/material.dart';

class AttendanceNav extends StatelessWidget {
  const AttendanceNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, top: 40),
        child: Row(
          //     mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                AttendanceCard(),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Apply for Leave',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                onPressed: () async {
                                  DateTimeRange? selectedDate =
                                      await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(DateTime.now().year),
                                    lastDate: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                    ),
                                  );
                                  print(selectedDate);
                                },
                                child:
                                    Icon(size: 28, Icons.edit_calendar_rounded),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text('(Select dates of leave)'),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 500,
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Write your reason',
                                      border: OutlineInputBorder()),
                                  maxLines: 5,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    'Apply for Leave',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 100)),
                )
              ],
            ),
            SizedBox(
              width: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leaves Taken',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  //  padding: EdgeInsets.only(left: 20),
                  width: 700,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(
                        width: 2,
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(5)),
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(
                          MediaQuery.of(context).size.width < 800 ? 1 : 4)
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Reason',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Center(
                            child: Text(
                              '20-04-2022',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 10),
                            child: Text(
                                style: TextStyle(fontSize: 16),
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo, width: 3),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)),
      //   margin: EdgeInsets.only(top: 40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          //  mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Attendance\nReport',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              children: [
                Column(
                  children: const [
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: CircularProgressIndicator(
                        strokeWidth: 15,
                        value: 0.8,
                        backgroundColor: Colors.red,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Overall',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '80.09%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: CircularProgressIndicator(
                        strokeWidth: 15,
                        value: 0.9,
                        backgroundColor: Colors.red,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'This Month',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '95.20%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Today',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(5)),
              child: Text(
                'Present',
                style: TextStyle(
                  fontSize: 20,
                  //  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
