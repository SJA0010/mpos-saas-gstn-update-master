import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../../currency.dart';
import 'Constant Data/constant.dart';

class TotalCountWidget extends StatelessWidget {
  const TotalCountWidget({Key? key, required this.icon, required this.title, required this.count, required this.changes, required this.iconColor}) : super(key: key);

  final String title;
  final String count;
  final IconData icon;
  final int changes;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: kWhiteTextColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
          subtitle: Row(
            children: [
              Text(
                '$currency$count',
                maxLines: 2,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: context.width() < 1000 ? 14 : context.width() * 0.018),
                overflow: TextOverflow.fade,
              ),
              // const SizedBox(width: 10.0),
              // Container(
              //   padding: const EdgeInsets.only(left: 4.0, right: 4.0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30.0),
              //     color: changes <0 ? kRedTextColor.withOpacity(0.2) : kGreenTextColor.withOpacity(0.2) ,
              //   ),
              //   child: Text(
              //     '${changes.toString()}%',
              //     style: kTextStyle.copyWith(color: changes <0 ?kRedTextColor : kGreenTextColor, fontSize: 14.0),
              //   ),
              // ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomerCountWidget extends StatelessWidget {
  const CustomerCountWidget({Key? key, required this.icon, required this.title, required this.count, required this.changes, required this.iconColor}) : super(key: key);

  final String title;
  final String count;
  final IconData icon;
  final int changes;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        // width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: kWhiteTextColor,
        ),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kGreyTextColor),
          ),
          subtitle: Row(
            children: [
              Text(
                count,
                style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: context.width() < 1000 ? 14 : context.width() * 0.018),
              ),
              const SizedBox(width: 10.0),
              Container(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: changes < 0 ? kRedTextColor.withOpacity(0.2) : kGreenTextColor.withOpacity(0.2),
                ),
                child: Text(
                  '${changes.toString()}%',
                  style: kTextStyle.copyWith(color: changes < 0 ? kRedTextColor : kGreenTextColor, fontSize: 14.0),
                ),
              ).visible(false),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
