import 'package:flutter/material.dart';

import '../../constant.dart';
import '../../currency.dart';
import '../../model/home_report_model.dart';
import 'Constant Data/constant.dart';

class ReportTableWidget extends StatelessWidget {
  const ReportTableWidget({Key? key, required this.report, required this.color, required this.title, required this.icon}) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;
  final List<HomeReport> report;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: kGreyTextColor),
                const SizedBox(width: 10.0),
                Text(
                  title,
                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                ),
                // const Spacer(),
                // Text(
                //   '${currency}82,500.00',
                //   style: kTextStyle.copyWith(color: kTitleColor),
                // ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: List.generate(
                  800 ~/ 10,
                  (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                          height: 1,
                        ),
                      )),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: report.length < 5 ? report.length : 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, i) {
                  return Row(
                    children: [
                      Text(
                        report[i].name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle.copyWith(color: kTitleColor),
                      ),
                      const Spacer(),
                      Text(
                        '$currency${report[i].amount ?? ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle.copyWith(color: color),
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
