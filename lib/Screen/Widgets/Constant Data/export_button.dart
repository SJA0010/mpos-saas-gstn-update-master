import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import 'constant.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40.0,
          width: 300,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: kGreyTextColor.withOpacity(0.1))),
          child: AppTextField(
            showCursor: true,
            cursorColor: kTitleColor,
            textFieldType: TextFieldType.NAME,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              hintText: ('Search...'),
              hintStyle: kTextStyle.copyWith(color: kGreyTextColor),
              border: InputBorder.none,
              suffixIcon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: kGreyTextColor.withOpacity(0.1),
                    ),
                    child: const Icon(
                      FeatherIcons.search,
                      color: kTitleColor,
                    )),
              ),
            ),
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.content_copy,
          color: kTitleColor,
        ),
        const SizedBox(width: 5.0),
        const Icon(FontAwesomeIcons.fileExcel, color: kTitleColor),
        const SizedBox(width: 5.0),
        const Icon(FontAwesomeIcons.file, color: kTitleColor),
        const SizedBox(width: 5.0),
        const Icon(FontAwesomeIcons.filePdf, color: kTitleColor),
        const SizedBox(width: 5.0),
        const Icon(FeatherIcons.printer, color: kTitleColor),
      ],
    );
  }
}

class ExportButton2 extends StatelessWidget {
  const ExportButton2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.content_copy,
          color: kTitleColor,
        ),
        SizedBox(width: 5.0),
        Icon(FontAwesomeIcons.fileExcel, color: kTitleColor),
        SizedBox(width: 5.0),
        Icon(FontAwesomeIcons.file, color: kTitleColor),
        SizedBox(width: 5.0),
        Icon(FontAwesomeIcons.filePdf, color: kTitleColor),
        SizedBox(width: 5.0),
        Icon(FeatherIcons.printer, color: kTitleColor),
      ],
    );
  }
}
