import 'package:flutter/material.dart';

class FeeNav extends StatelessWidget {
  const FeeNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo, width: 3)),
            margin: EdgeInsets.all(50),
            padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 50,
            ),
            //  width: 600,
            child: Column(
              children: [
                Text(
                  'Fee Card',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 200,
                  child: Divider(
                    color: Colors.indigo,
                    thickness: 2,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DataTable(
                    dividerThickness: 2,
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue.shade50),
                    columns: [
                      DataColumn(
                        label: Text(
                          'S. No.',
                        ),
                        onSort: (columnIndex, ascending) {},
                      ),
                      DataColumn(
                          label: Text(
                        'Fee Type',
                      )),
                      DataColumn(label: Text('Due Date')),
                      DataColumn(
                          label: Text(
                        'Amount',
                      )),
                      DataColumn(
                          label: Text(
                        'Staus',
                      ))
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('1')),
                        DataCell(Text('Tution Fee')),
                        DataCell(Text('20-02-23')),
                        DataCell(Text('1000')),
                        DataCell(ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white),
                          child: Text('Pay Now'),
                          onPressed: () {},
                        )),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('2')),
                        DataCell(Text('Photography')),
                        DataCell(Text('15-05-23')),
                        DataCell(Text('150')),
                        DataCell(Text(
                          'Paid',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        )),
                      ]),
                    ])
                // Table(
                //   children: [
                //     TableRow(decoration: BoxDecoration(), children: [
                //       Text('Sr.'),
                //       Text('Fee for the Month'),
                //       Text('Date of Deposit'),
                //       Text('Total Fee'),
                //       Text('Deposit Fee'),
                //       Text('Due Fee')
                //     ]),
                //     TableRow(
                //       children: [
                //         Text('1'),
                //         Text('April'),
                //         Text('02/05/2022'),
                //         Text('500'),
                //         Text('400'),
                //         Text('100')
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
