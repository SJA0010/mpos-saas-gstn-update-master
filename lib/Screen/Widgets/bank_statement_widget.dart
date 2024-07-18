import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../../constant.dart';
import '../../currency.dart';
import 'Constant Data/constant.dart';

class CashBank extends StatelessWidget {
  const CashBank({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: kWhiteTextColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                FontAwesomeIcons.fileInvoiceDollar,
                color: kGreyTextColor,
                size: 18.0,
              ),
              const SizedBox(width: 10.0),
              Text(lang.S.of(context).cashandBank, style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 18.0)),
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
          Row(
            children: [
              Text(
                lang.S.of(context).cashInHand,
                style: kTextStyle.copyWith(color: kTitleColor),
              ),
              const Spacer(),
              Text(
                '${currency}4726793.75',
                style: kTextStyle.copyWith(color: kGreenTextColor),
              ),
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
          const SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                lang.S.of(context).bankAccounts,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${currency}4726793.75',
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Text(
                lang.S.of(context).creativeHub,
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              const Spacer(),
              Text(
                '${currency}50974.59',
                style: kTextStyle.copyWith(color: kGreenTextColor),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Text(
                lang.S.of(context).shopName,
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              const Spacer(),
              Text(
                '${currency}2974174.54',
                style: kTextStyle.copyWith(color: kGreenTextColor),
              ),
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
          const SizedBox(height: 20.0),
          Text(
            lang.S.of(context).openCheques,
            style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Text(
                'Received (0)',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              const Spacer(),
              Text(
                '${currency}0.00',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Text(
                'Paid (5)',
                style: kTextStyle.copyWith(color: kGreyTextColor),
              ),
              const Spacer(),
              Text(
                '${currency}29174.29',
                style: kTextStyle.copyWith(color: kRedTextColor),
              ),
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
          const SizedBox(height: 20.0),
          Row(
            children: [
              Text(
                lang.S.of(context).loanAccounts,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${currency}272462.79',
                style: kTextStyle.copyWith(color: kRedTextColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
