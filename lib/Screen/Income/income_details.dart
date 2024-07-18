import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:salespro_admin/model/income_modle.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../Widgets/Constant Data/constant.dart';

class IncomeDetails extends StatelessWidget {
  const IncomeDetails({Key? key, required this.income, required this.manuContext}) : super(key: key);

  final IncomeModel income;
  final BuildContext manuContext;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    lang.S.of(context).incomeDetails,
                    style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                  ),
                  const Spacer(),
                  const Icon(FeatherIcons.x, color: kTitleColor, size: 30.0).onTap(() {
                    Navigator.pop(context);
                    Navigator.pop(manuContext);
                  })
                ],
              ),
              const SizedBox(height: 5.0),
              Divider(
                thickness: 1.0,
                color: kGreyTextColor.withOpacity(0.2),
              ),
              const SizedBox(height: 20.0),

              ///__________Date_________________________________________________
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      lang.S.of(context).date,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      income.incomeDate,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              ///__________Expense For_________________________________________________
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      lang.S.of(context).name,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      income.incomeFor,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              ///__________Category_________________________________________________
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      lang.S.of(context).category,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      income.category,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              ///__________reference No_________________________________________________
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      lang.S.of(context).referenceNumber,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      income.referenceNo,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              ///__________Payment Type________________________________________________
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      lang.S.of(context).paymentType,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      income.paymentType,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              ///__________Amount_________________________________________________
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      lang.S.of(context).amount,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      income.amount,
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              ///__________Expense For_________________________________________________
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      lang.S.of(context).note,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      income.note,
                      style: const TextStyle(fontSize: 18),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
