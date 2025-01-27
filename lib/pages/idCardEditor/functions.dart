import 'dart:convert';

import '../../ip_address.dart';
import 'design_class.dart';

import 'package:http/http.dart' as http;

Future getDesignData(String d) async {
  final designName = Uri.encodeQueryComponent(d);
  final frontImageurl =
      Uri.parse('$ipv4/getFrontImage/?designName=$designName');
  final backImageurl = Uri.parse('$ipv4/getBackImage/?designName=$designName');
  final designDetailsUrl =
      Uri.parse('$ipv4/getDesignDetails/?designName=$designName');
  final frontImageRes = await http.get(frontImageurl);
  final backImageRes = await http.get(backImageurl);
  final designDetailsRes = await http.get(designDetailsUrl);
  Map designDetails = jsonDecode(designDetailsRes.body);

  final design = Design.fromMap(
    designDetails,
    frontImageRes.bodyBytes,
    backImageRes.bodyBytes,
  );
  // List data = jsonDecode(res.body);

  // print(jsonDecode(designDetails['frontElements']));

  return design;
}



//  Future getImage(String image, index, j) async {
//     final xhr = html.HttpRequest();
//     // var url = Uri.parse("$ipv4/saveDesign");

//     xhr.open('GET', '$ipv4/getPic/108/$image');

//     double progress = 0;
//     final completer = Completer();

//     xhr.onProgress.listen(
//       (event) {
//         if (xhr.status == 404) {
//           setState(() {
//             // studentProgress[index][j]['progress'] = xhr.responseText;
//           });
//         } else {
//           progress = event.loaded! / event.total!;

//           setState(() {
//             // studentProgress[index][j]['progress'] = progress;
//           });
//           if (progress == 1) {
//             setState(() {
//               img = xhr.response;
//             });
//             completer.complete(xhr.response);
//           }
//         }

//         // print(event.total);
//       },
//     );

//     xhr.send();
//     return completer.future;
//   }