import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_management/ip_address.dart';

class AddClassDialog extends StatefulWidget {
  const AddClassDialog(
      {super.key, required this.schoolCode, required this.callback});
  final int schoolCode;
  final VoidCallback callback;

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  TextEditingController className = TextEditingController();
  TextEditingController section = TextEditingController();
  bool validate = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 400,
              child: TextField(
                controller: className,
                decoration: InputDecoration(
                  hintText: 'Class / Departmrnt',
                  errorText: validate ? 'This Field is required' : null,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: section,
                decoration: InputDecoration(
                  hintText: 'Section',
                  errorText: validate ? 'This Field is required' : null,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  section.text.trim().isEmpty || className.text.trim().isEmpty
                      ? validate = true
                      : validate = false;
                });
                if (!validate) {
                  var url = Uri.parse('$ipv4/addClassOrBranch');
                  var res = await http.post(url, body: {
                    'schoolCode': widget.schoolCode.toString(),
                    'title': '${className.text.trim()}-${section.text.trim()}',
                    'className': className.text.trim(),
                    'sec': section.text.trim()
                  });
                  if (res.body == 'true') {
                    print('done');
                    className.clear();
                    section.clear();
                    widget.callback();
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
