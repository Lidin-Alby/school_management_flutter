import 'package:flutter/material.dart';

class IdCard extends StatefulWidget {
  const IdCard({super.key});

  @override
  State<IdCard> createState() => _IdCardState();
}

class _IdCardState extends State<IdCard> {
  Map cards = {
    1: {'Name': 'Lidin', 'CardStatus': 0},
    2: {'Name': 'Gupta', 'CardStatus': -1},
    3: {'Name': 'Rahul', 'CardStatus': 1}
  };
  int? cardStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5),
              alignment: AlignmentDirectional.centerStart,
              decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5))),
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
              decoration: BoxDecoration(
                  color: Colors.indigo[100],
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(5))),
              width: 200,
              height: 40,
              child: Text(
                'Status',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ],
        ),
        for (var i in cards.keys)
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: i == cards.keys.last
                        ? BorderRadius.only(bottomLeft: Radius.circular(5))
                        : null),
                width: 75,
                height: 75,
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
                height: 75,
                child: Text(
                  cards[i]['Name'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: cards[i]['CardStatus'] == 0
                      ? Colors.red
                      : cards[i]['CardStatus'] == 1
                          ? Colors.green
                          : Colors.orange,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 120,
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.only(left: 8),
                child: DropdownButton(
                  dropdownColor: Colors.grey,
                  isDense: true,
                  iconEnabledColor: Colors.white,
                  style: TextStyle(color: Colors.white),

                  //   selectedItemBuilder: (context) => ,
                  underline: Text(''),
                  value: cards[i]['CardStatus'],
                  items: [
                    DropdownMenuItem(
                      child: Text('Issued'),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text('Not Issued'),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text('Lost'),
                      value: -1,
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      cards[i]['CardStatus'] = value;
                    });
                  },
                ),
              )
            ],
          ),
      ]),
    );
  }
}
