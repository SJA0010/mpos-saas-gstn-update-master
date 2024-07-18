import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../../currency.dart';
import '../../model/home_report_model.dart';
import 'Constant Data/constant.dart';

class TopCustomerTable extends StatelessWidget {
  const TopCustomerTable({
    Key? key,
    required this.report,
  }) : super(key: key);

  final List<TopCustomer> report;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(FontAwesomeIcons.users, size: 18.0, color: kGreyTextColor),
              title: Text(
                lang.S.of(context).customerOfTheMonth,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
              ),
              contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
              horizontalTitleGap: 5,
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
              itemCount: report.length < 5 ? report.length : 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                return (ListTile(
                  leading: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      image: DecorationImage(image: NetworkImage(report[i].image ?? ''), fit: BoxFit.cover),
                    ),
                  ),
                  title: Text(
                    "#${report[i].code ?? ''}",
                    style: kTextStyle.copyWith(color: kBlueTextColor),
                  ),
                  subtitle: Text(
                    report[i].name ?? '',
                    style: kTextStyle.copyWith(color: kTitleColor),
                  ),
                  trailing: Text(
                    "$currency${report[i].amount ?? ''}",
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  horizontalTitleGap: 10,
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
