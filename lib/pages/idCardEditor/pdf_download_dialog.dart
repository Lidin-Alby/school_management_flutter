import 'dart:convert';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
// import 'package:intl/intl.dart';

import '../../ip_address.dart';
import 'design_class.dart';
import 'functions.dart';
import 'image_capsule.dart';
import 'movable_and_extra_class.dart';

import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

import 'print_settings_class.dart';

class PdfDownloadDialog extends StatefulWidget {
  const PdfDownloadDialog(
      {super.key,
      required this.selectedStudnts,
      required this.wantedDesigns,
      required this.printSetting,
      required this.callback});
  final List selectedStudnts;
  final PrintSetting printSetting;
  final Set wantedDesigns;

  final VoidCallback callback;

  @override
  State<PdfDownloadDialog> createState() => _PdfDownloadDialogState();
}

class _PdfDownloadDialogState extends State<PdfDownloadDialog> {
  late Future _getDataDesign;
  late Set wantedDesigns;
  Map<String, Design> wantedDesignsData = {};
  late Design design;
  List screenshotAdded = [];
  List students = [];
  List studentProgress = [];
  int page = 1;

  getDataDesign() async {
    wantedDesigns = widget.wantedDesigns.toSet();

    for (var i in wantedDesigns) {
      var designData = await getDesignData(i);

      wantedDesignsData.addAll({i: designData});
    }

    return [];
  }

  Future getImage(String schoolCode, String image) async {
    final url = Uri.parse('$ipv4/getPic/$schoolCode/$image');
    final res = await http.get(url);
    if (res.statusCode == 404) {
      return res.body;
    }
    // setState(() {
    //   studentProgress[index][j]['progress'] = 1;
    // });
    return res.bodyBytes;
  }

  sideByside() async {
    List<pw.Image> ims = [];
    ScreenshotController screenshotController = ScreenshotController();
    for (int i = 0; i < students.length; i++) {
      design = wantedDesignsData[students[i]['designName']]!;
      int j = 0;
      for (var ele in design.frontElements) {
        if (ele is MyImage) {
          studentProgress[i].add({'fieldName': ele.name, 'progress': 0.0});

          var res =
              await getImage(students[i]['schoolCode'], students[i][ele.value]);

          if (res is Uint8List) {
            setState(() {
              studentProgress[i][j]['progress'] = 1.0;
            });

            ele.imageBytes = res;
          } else {
            setState(() {
              studentProgress[i][j]['progress'] = res;
            });
            ele.imageBytes = null;
          }
          j++;
        } else {
          switch ((ele as MyAutoText).stringCase) {
            case 'U':
              ele.value = students[i][ele.name].toUpperCase();
              break;
            case 'L':
              ele.value = students[i][ele.name].toLowerCase();
              break;
            default:
              ele.value = students[i][ele.name];
          }
        }
      }
      for (var ele in design.backElements) {
        if (ele is MyImage) {
          studentProgress[i].add({'fieldName': ele.name, 'progress': 0.0});

          var res =
              await getImage(students[i]['schoolCode'], students[i][ele.value]);

          if (res is Uint8List) {
            setState(() {
              studentProgress[i][j]['progress'] = 1.0;
            });

            ele.imageBytes = res;
          } else {
            setState(() {
              studentProgress[i][j]['progress'] = res;
            });
            ele.imageBytes = null;
          }
          j++;
        } else {
          switch ((ele as MyAutoText).stringCase) {
            case 'U':
              ele.value = students[i][ele.name].toUpperCase();
              break;
            case 'L':
              ele.value = students[i][ele.name].toLowerCase();
              break;
            default:
              ele.value = students[i][ele.name];
          }
        }
      }
      Uint8List? front = await screenshotController.captureFromWidget(
          pixelRatio: 2.5,
          ImageCapsule(
            backgroundImage: design.frontBackgroundImage,
            backgroundImageHeight: design.backgroundImageHeight,
            elements: design.frontElements,
            showGuidlines: false,
            selected: null,
            onSelected: (p0) {},
          ));
      Uint8List? back = await screenshotController.captureFromWidget(
          pixelRatio: 2.5,
          ImageCapsule(
            backgroundImage: design.backBackgroundImage,
            backgroundImageHeight: design.backgroundImageHeight,
            elements: design.backElements,
            showGuidlines: false,
            selected: null,
            onSelected: (p0) {},
          ));
      ims.add(
        pw.Image(
          pw.MemoryImage(
            front,
          ),
          height: widget.printSetting.cardHeight! * 72,
          width: widget.printSetting.cardWidth! * 72,
          fit: pw.BoxFit.fill,
        ),
      );

      ims.add(
        pw.Image(
          pw.MemoryImage(
            back,
          ),
          height: widget.printSetting.cardHeight! * 72,
          width: widget.printSetting.cardWidth! * 72,
          fit: pw.BoxFit.fill,
        ),
      );

      setState(() {
        int len = ims.length;
        if (design.backBackgroundImage != null) {
          len = len ~/ 2;
        }
        screenshotAdded[len - 1] = true;
      });
    }
    generatePdfSidebySide(ims);
  }

  Future generatePdfSidebySide(List images) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      pageFormat: PdfPageFormat(
        widget.printSetting.pageWidth * 72,
        widget.printSetting.pageHeight * 72,
        marginBottom: widget.printSetting.marginVertical,
        marginTop: widget.printSetting.marginVertical,
        marginLeft: widget.printSetting.marginHorizontal,
        marginRight: widget.printSetting.marginHorizontal,
      ),
      build: (context) => [
        pw.Wrap(
            spacing: widget.printSetting.paddingHorizontal!,
            runSpacing: widget.printSetting.paddingVertical!,
            children: [for (var i in images) i])
      ],
    ));
    final file = await pdf.save();
    // return file;
    FileSaver.instance.saveFile(
        name: 'my_file', bytes: file, mimeType: MimeType.pdf, ext: 'pdf');
  }

  startDataCollection() async {
    double availableHeight = widget.printSetting.pageHeight * 72 -
        widget.printSetting.marginVertical;
    double availableWidth = widget.printSetting.pageWidth * 72 -
        widget.printSetting.marginHorizontal;
    int rowCount =
        (availableWidth / (widget.printSetting.cardWidth! * 72)).floor();
    int colCount =
        (availableHeight / (widget.printSetting.cardHeight! * 72)).floor();
    int cardCount = rowCount * colCount;

    List<pw.Image> frontims = [];
    List<pw.Image> backims = [];

    ScreenshotController screenshotController = ScreenshotController();
    for (int i = 0; i < students.length; i++) {
      design = wantedDesignsData[students[i]['designName']]!;
      int j = 0;
      for (var ele in design.frontElements) {
        if (ele is MyImage) {
          studentProgress[i].add({'fieldName': ele.name, 'progress': 0.0});

          var res =
              await getImage(students[i]['schoolCode'], students[i][ele.value]);

          if (res is Uint8List) {
            setState(() {
              studentProgress[i][j]['progress'] = 1.0;
            });

            ele.imageBytes = res;
          } else {
            setState(() {
              studentProgress[i][j]['progress'] = res;
            });
            ele.imageBytes = null;
          }
          j++;
        } else {
          switch ((ele as MyAutoText).stringCase) {
            case 'U':
              ele.value = students[i][ele.name].toUpperCase();
              break;
            case 'L':
              ele.value = students[i][ele.name].toLowerCase();
              break;
            default:
              ele.value = students[i][ele.name];
          }
        }
      }
      for (var ele in design.backElements) {
        if (ele is MyImage) {
          studentProgress[i].add({'fieldName': ele.name, 'progress': 0.0});

          var res =
              await getImage(students[i]['schoolCode'], students[i][ele.value]);

          if (res is Uint8List) {
            setState(() {
              studentProgress[i][j]['progress'] = 1.0;
            });

            ele.imageBytes = res;
          } else {
            setState(() {
              studentProgress[i][j]['progress'] = res;
            });
            ele.imageBytes = null;
          }
          j++;
        } else {
          switch ((ele as MyAutoText).stringCase) {
            case 'U':
              ele.value = students[i][ele.name].toUpperCase();
              break;
            case 'L':
              ele.value = students[i][ele.name].toLowerCase();
              break;
            default:
              ele.value = students[i][ele.name];
          }
        }
      }

      Uint8List? front = await screenshotController.captureFromWidget(
          pixelRatio: 2.5,
          ImageCapsule(
            backgroundImage: design.frontBackgroundImage,
            backgroundImageHeight: design.backgroundImageHeight,
            elements: design.frontElements,
            showGuidlines: false,
            selected: null,
            onSelected: (p0) {},
          ));
      Uint8List? back = await screenshotController.captureFromWidget(
          pixelRatio: 2.5,
          ImageCapsule(
            backgroundImage: design.backBackgroundImage,
            backgroundImageHeight: design.backgroundImageHeight,
            elements: design.backElements,
            showGuidlines: false,
            selected: null,
            onSelected: (p0) {},
          ));
      frontims.add(
        pw.Image(
          pw.MemoryImage(
            front,
          ),
          height: widget.printSetting.cardHeight! * 72,
          width: widget.printSetting.cardWidth! * 72,
          fit: pw.BoxFit.fill,
        ),
      );

      backims.add(
        pw.Image(
          pw.MemoryImage(
            back,
          ),
          height: widget.printSetting.cardHeight! * 72,
          width: widget.printSetting.cardWidth! * 72,
          fit: pw.BoxFit.fill,
        ),
      );

      setState(() {
        int len = frontims.length;
        if (design.backBackgroundImage != null) {
          len += backims.length;
          len = len ~/ 2;
        }
        screenshotAdded[len - 1] = true;
      });
    }

    generatePdf(frontims, backims, cardCount);
  }

  Future generatePdf(List frontImages, List backImages, int cardCount) async {
    final pdf = pw.Document();

    for (int count = 0; count < (frontImages.length / cardCount); count++) {
      int length = cardCount * (count + 1);

      pdf.addPage(
        pw.MultiPage(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            pageFormat: PdfPageFormat(
              widget.printSetting.pageWidth * 72,
              widget.printSetting.pageHeight * 72,
              marginBottom: widget.printSetting.marginVertical,
              marginTop: widget.printSetting.marginVertical,
              marginLeft: widget.printSetting.marginHorizontal,
              marginRight: widget.printSetting.marginHorizontal,
            ),
            //multiply by 72
            build: (context) {
              return [
                pw.Wrap(
                    spacing: widget.printSetting.paddingHorizontal!,
                    runSpacing: widget.printSetting.paddingVertical!,
                    children: [
                      for (int i = count * cardCount;
                          i <
                              (length > frontImages.length
                                  ? frontImages.length
                                  : length);
                          i++)
                        frontImages[i]
                    ])
              ];
            }),
      );
      pdf.addPage(
        pw.MultiPage(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            textDirection: pw.TextDirection.rtl,
            pageFormat: PdfPageFormat(
              widget.printSetting.pageWidth * 72,
              widget.printSetting.pageHeight * 72,
              marginBottom: widget.printSetting.marginVertical,
              marginTop: widget.printSetting.marginVertical,
              marginLeft: widget.printSetting.marginHorizontal,
              marginRight: widget.printSetting.marginHorizontal,
            ),
            //multiply by 72
            build: (context) {
              return [
                pw.Wrap(
                    spacing: widget.printSetting.paddingHorizontal!,
                    runSpacing: widget.printSetting.paddingVertical!,
                    children: [
                      for (int i = count * cardCount;
                          i <
                              (length > frontImages.length
                                  ? frontImages.length
                                  : length);
                          i++)
                        backImages[i]
                    ])
              ];
            }),
      );
      // cardCount = cardCount * currentCount;
    }

    final file = await pdf.save();

    FileSaver.instance.saveFile(
        name: 'my_file', bytes: file, mimeType: MimeType.pdf, ext: 'pdf');
    printedInfo(students);
  }

  printedInfo(List selectedStudents) async {
    selectedStudents = selectedStudents.map(
      (e) {
        return {
          'schoolCode': e['schoolCode'],
          'admNo': e['admNo'],
          'printed': true,
          'ready': false,
          'printDate': DateFormat('dd-MMM-yy').format(DateTime.now())
        };
      },
    ).toList();

    var url = Uri.parse('$ipv4/printedInfo');

    var res =
        await http.post(url, body: {'data': jsonEncode(selectedStudents)});

    if (res.body == 'true') {
      widget.callback();
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    wantedDesigns = widget.wantedDesigns;
    _getDataDesign = getDataDesign();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: FutureBuilder(
        future: _getDataDesign,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            students = widget.selectedStudnts
                .map(
                  (e) => Map.from(e),
                )
                .toList();

            return Column(
              children: [
                for (Design d in wantedDesignsData.values)
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Image.memory(d.frontBackgroundImage!),
                        Image.memory(d.backBackgroundImage!),
                      ],
                    ),
                  ),
                FilledButton(
                  onPressed: () {
                    screenshotAdded = List.generate(
                      widget.selectedStudnts.length,
                      (index) => false,
                    );
                    studentProgress =
                        List.generate(students.length, (index) => []);

                    setState(() {});
                    startDataCollection();
                  },
                  child: Text('Duplex PDF'),
                ),
                SizedBox(
                  height: 5,
                ),
                FilledButton(
                  onPressed: () {
                    screenshotAdded = List.generate(
                      widget.selectedStudnts.length,
                      (index) => false,
                    );
                    studentProgress =
                        List.generate(students.length, (index) => []);

                    setState(() {});
                    sideByside();
                  },
                  child: Text('One Sided PDF'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: Material(
                        child: ListTile(
                          minVerticalPadding: 30,
                          tileColor: Colors.grey[300],
                          leading: SizedBox(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${students[i]['admNo']} - ${students[i]['firstName']}'
                                      .toString(),
                                ),
                                Text(
                                  students[i]['schoolCode'].toString(),
                                ),
                                Text(
                                  students[i]['designName'].toString(),
                                )
                              ],
                            ),
                          ),
                          title: studentProgress.isNotEmpty
                              ? Column(
                                  children: [
                                    for (Map progressMap in studentProgress[i])
                                      progressMap['progress'] is double
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                LinearProgressIndicator(
                                                  value:
                                                      progressMap['progress'],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      progressMap['fieldName'],
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '${(progressMap['progress'] * 100).toStringAsFixed(1)}%',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )
                                          : Text(progressMap['progress']),
                                  ],
                                )
                              : null,
                          trailing: screenshotAdded.isNotEmpty
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: screenshotAdded[i]
                                      ? Icon(Icons.check_circle_outline)
                                      : CircularProgressIndicator(),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Fetching Design Data')
              ],
            );
          }
        },
      ),
    );
  }
}
