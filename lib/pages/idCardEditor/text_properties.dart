import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'movable_and_extra_class.dart';

class TextProperties extends StatelessWidget {
  const TextProperties(
      {super.key,
      required this.selectedObj,
      required this.isAuto,
      required this.onChange,
      required this.onDelete});
  final MyAutoText selectedObj;
  final bool isAuto;
  final Function(MyAutoText) onChange;
  final Function(MyAutoText) onDelete;

  @override
  Widget build(BuildContext context) {
    List fonts = [
      // 'Bungee Tint',
      'Bungee Spice',
      'Honk',
      'Bungee Shade',
      'Monoton',
      'Vast Shadow',
      'Mogra',
      'Roboto',
      'DM Serif Text',
      'Open Sans',
      'Oswald',
      'Bebas Neue',
      'Noto Serif',
      'Barlow Condensed',
      'Mukta',
      'Archivo',
      'Teko',
      'Hind',
      'Fjalla One',
      'Passion One',
      'Domine',
      'Spicy Rice', 'Staatliches', 'Salsa', 'Akshar', 'Aclonica', 'Boogaloo',
      'Markazi Text', 'Palanquin', 'PT Serif', 'Luckiest Guy', 'Rye',
      'Amarante',
      'Smythe',
      'Zen Tokyo Zoo',
      'Ribeye Marrow',
      'Metamorphous',
      'Modern Antiqua',
      'Skranji',
      'Bungee Inline',
      'Train One',
      'Germania One',
      'DynaPuff',
      'Chewy',
      'Boogaloo',
      'Reggae One', 'Road Rage', 'Margarine', 'Yusei Magic', 'Rozha One',
      'Noto Sans',
      'Eczar',
      'Noto Sans Gurmukhi',
      'Noto Sans Tirhuta',
      'Noto Sans Telugu',
      'Noto Sans Tamil',
      'Noto Sans Gujarati',
      'Noto Sans Arabic', 'Noto Kufi Arabic', 'Noto Nastaliq Urdu',
      'Noto Sans Kannada', 'Noto Sans Oriya', 'Noto Sans Malayalam',
      'Noto Sans Gurmukhi',
      'Noto Sans Bengali',
      'Noto Sans Devanagari',
      'Rethink Sans',
      'Sofia Sans',
      'Baloo Paaji 2',
      'Vazirmatn',
      'Bricolage Grotesque', //
      // 'Afacad Flux',
      'Kode Mono',
      //  'Reddit Sans',
      // 'Ubuntu Sans',
      // 'Platypi',
      'Protest Strike',
      // 'Madimi One',
      // 'Radio Canada Big',
      // 'Edu Australia VIC WA NT Hand',
      // 'New Amsterdam',
      // 'Teachers',
      // 'Playwrite Deutschland Grundschrift',
      // 'Moderustic',
      // 'Kalnia Glaze',
      // 'Parkinsans',
      // 'Matemasie',
      'DM Serif Text',
      'PT Serif Caption', 'Merriweather Sans', 'Volkhov', 'Libre Bodoni',
      'Voces', 'Yanone Kaffeesatz',
      // 'Zain',
      'Barlow Semi Condensed', 'Agdasima',
      // 'Sour Gummy',//
      'Delius',
      'Emilys Candy',
      'Cherry Bomb One',
      'Jua',
      'Akaya Kanadaka',
      'Bagel Fat One',
      'Chicle',
      'Bubblegum Sans',
      'Titan One',
      'Fugaz One',
      'Rubik Moonrocks', 'Grandstander', 'Wendy One', 'Quando', 'Tourney'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Text(selectedObj.name),
            // Spacer(),
            FilledButton(
              onPressed: () {
                onDelete(selectedObj);
              },
              child: Text('Delete'),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          // spacing: 5,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Width: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                ),
                controller: TextEditingController(
                  text: selectedObj.width.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.width = double.parse(value);
                  // });
                  onChange(selectedObj);
                },
              ),
            ),
            Spacer(),
            Text('Height: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(isDense: true),
                controller: TextEditingController(
                  text: selectedObj.height.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.height = double.parse(value);
                  // });
                  onChange(selectedObj);
                },
              ),
            ),
          ],
        ),
        Row(
          // spacing: 5,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('top: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                ),
                controller: TextEditingController(
                  text: selectedObj.top.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.top = double.parse(value);
                  // });
                  onChange(selectedObj);
                },
              ),
            ),
            Spacer(),
            Text('left: '),
            SizedBox(
              width: 45,
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(isDense: true),
                controller: TextEditingController(
                  text: selectedObj.left.toStringAsFixed(2),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.left = double.parse(value);
                  // });
                  onChange(selectedObj);
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Text Align:'),
            ChoiceChip(
              labelPadding: EdgeInsets.zero,
              showCheckmark: false,
              label: Icon(
                Icons.align_horizontal_left_rounded,
                size: 20,
              ),
              selected: selectedObj.textAlign == TextAlign.left,
              onSelected: (value) {
                // setState(() {

                selectedObj.textAlign = TextAlign.left;
                // });
                onChange(selectedObj);
              },
            ),
            ChoiceChip(
              labelPadding: EdgeInsets.zero,
              showCheckmark: false,
              label: Icon(
                Icons.align_horizontal_center,
                size: 20,
              ),
              selected: selectedObj.textAlign == TextAlign.center,
              onSelected: (value) {
                // setState(() {
                selectedObj.textAlign = TextAlign.center;
                // });
                onChange(selectedObj);
              },
            ),
            ChoiceChip(
              labelPadding: EdgeInsets.zero,
              showCheckmark: false,
              label: Icon(
                Icons.align_horizontal_right,
                size: 20,
              ),
              selected: selectedObj.textAlign == TextAlign.right,
              onSelected: (value) {
                // setState(() {
                selectedObj.textAlign = TextAlign.right;
                // });
                onChange(selectedObj);
              },
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Font: '),
            SizedBox(
              width: 150,
              height: 40,
              child: DropdownMenu(
                label: Text(
                  selectedObj.font,
                  style: GoogleFonts.getFont(selectedObj.font),
                ),
                enableFilter: true,
                dropdownMenuEntries: fonts
                    .map(
                      (e) => DropdownMenuEntry(
                        labelWidget: Text(
                          e,
                          style: GoogleFonts.getFont(e),
                        ),
                        label: e,
                        value: e,
                      ),
                    )
                    .toList(),
                onSelected: (value) {
                  selectedObj.font = value.toString();
                  onChange(selectedObj);
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Font Size:'),
            SizedBox(
              width: 40,
              child: TextField(
                decoration: InputDecoration(isDense: true),
                controller: TextEditingController(
                  text: selectedObj.fontSize.toStringAsFixed(1),
                ),
                onSubmitted: (value) {
                  // setState(() {
                  selectedObj.fontSize = double.parse(value);
                  // });
                  onChange(selectedObj);
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Font Style:'),
            ChoiceChip(
              labelPadding: EdgeInsets.zero,
              showCheckmark: false,
              label: Icon(
                Icons.format_bold_rounded,
                size: 20,
              ),
              selected: selectedObj.fontWeight == FontWeight.bold,
              onSelected: (value) {
                // setState(() {
                if (value) {
                  selectedObj.fontWeight = FontWeight.bold;
                } else {
                  selectedObj.fontWeight = FontWeight.normal;
                }
                // });
                onChange(selectedObj);
              },
            ),
            ChoiceChip(
              labelPadding: EdgeInsets.zero,
              showCheckmark: false,
              label: Icon(
                Icons.format_italic_rounded,
                size: 20,
              ),
              selected: selectedObj.fontStyle == FontStyle.italic,
              onSelected: (value) {
                // setState(() {
                if (value) {
                  selectedObj.fontStyle = FontStyle.italic;
                } else {
                  selectedObj.fontStyle = FontStyle.normal;
                }
                onChange(selectedObj);
                // });
              },
            ),
            ChoiceChip(
              labelPadding: EdgeInsets.zero,
              showCheckmark: false,
              label: Icon(
                Icons.format_underline_rounded,
                size: 20,
              ),
              selected: selectedObj.textDecoration == TextDecoration.underline,
              onSelected: (value) {
                // setState(() {
                if (value) {
                  selectedObj.textDecoration = TextDecoration.underline;
                } else {
                  selectedObj.textDecoration = TextDecoration.none;
                }
                onChange(selectedObj);
                // });
              },
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 5,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Text Capital: '),
            ChoiceChip(
              showCheckmark: false,
              label: Text('-'),
              selected: selectedObj.stringCase == '',
              onSelected: (value) {
                selectedObj.stringCase = '';
                onChange(selectedObj);
              },
            ),
            ChoiceChip(
              showCheckmark: false,
              label: Text('A'),
              selected: selectedObj.stringCase == 'U',
              onSelected: (value) {
                selectedObj.stringCase = 'U';
                onChange(selectedObj);
              },
            ),
            ChoiceChip(
              showCheckmark: false,
              label: Text('a'),
              selected: selectedObj.stringCase == 'L',
              onSelected: (value) {
                selectedObj.stringCase = 'L';
                onChange(selectedObj);
              },
            ),
            ChoiceChip(
              showCheckmark: false,
              label: Text('W'),
              selected: selectedObj.stringCase == 'W',
              onSelected: (value) {
                selectedObj.stringCase = 'W';
                onChange(selectedObj);
              },
            ),
          ],
        ),
        // DropdownMenu(
        //   dropdownMenuEntries: fonts
        //       .map(
        //         (font) => DropdownMenuEntry(
        //           label: font,
        //           value: font,
        //         ),
        //       )
        //       .toList(),
        //   enableFilter: true,
        //   onSelected: (value) {},
        // )
        SizedBox(
          height: 15,
        ),
        ColorPicker(
          colorPickerWidth: 200,
          portraitOnly: true,
          pickerColor: selectedObj.textcolor,
          onColorChanged: (value) {
            // setState(() {
            selectedObj.textcolor = value;
            // });
            onChange(selectedObj);
          },
        ),
        if (isAuto)
          Row(
            children: [
              Text('QR'),
              Switch(
                value: selectedObj.isQR,
                onChanged: (value) {
                  selectedObj.isQR = value;
                  onChange(selectedObj);
                },
              ),
            ],
          ),
      ],
    );
  }
}
