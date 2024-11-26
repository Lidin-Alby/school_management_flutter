import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';

class FaceDetection extends StatefulWidget {
  const FaceDetection({super.key});

  @override
  State<FaceDetection> createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  PlatformFile? plFile;
  Uint8List? img;
  FaceDetector faceDetector = FaceDetector(options: FaceDetectorOptions());
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        child: Text('Pick'),
        onPressed: () async {
          FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.image);
          plFile = result!.files.first;

          setState(() {
            img = result.files.first.bytes;
          });
        },
      ),
      if (img != null) SizedBox(height: 400, child: Image.memory(img!)),
      ElevatedButton(
          onPressed: () async {
            final tempDir = await getTemporaryDirectory();
            File file = await File('${tempDir.path}/img').writeAsBytes(img!);

            final finalImg = InputImage.fromFile(file);
            List faces = await faceDetector.processImage(finalImg);
            print(faces);
          },
          child: Text('Process'))
    ]);
  }
}
