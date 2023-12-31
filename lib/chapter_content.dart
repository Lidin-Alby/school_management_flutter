import 'package:flutter/material.dart';

class ChapterContent extends StatelessWidget {
  const ChapterContent({super.key});

  @override
  Widget build(BuildContext context) {
    List content = ['google.com', 'youtube.com', 'facebook.com'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                for (var i in content)
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo[50],
                            borderRadius: BorderRadius.circular(10)),
                        width: 150,
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 110,
                                width: 135,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.link_rounded,
                                  size: 35,
                                ),
                              ),
                              Spacer(),
                              Text(
                                i,
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        )),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
