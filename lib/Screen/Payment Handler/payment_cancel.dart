import 'package:flutter/material.dart';
import 'package:salespro_admin/generated/l10n.dart' as lang;
import '../Widgets/Constant Data/constant.dart';

class PaymentCancel extends StatefulWidget {
  const PaymentCancel({Key? key}) : super(key: key);

  static const String route = '/pricing/cancel';

  @override
  // ignore: library_private_types_in_public_api
  _PaymentCancelState createState() => _PaymentCancelState();
}

class _PaymentCancelState extends State<PaymentCancel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkWhite,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/mpos.png'),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          color: kGreyTextColor.withOpacity(0.1),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          lang.S.of(context).yourPaymentisCancelled,
                          style: kTextStyle.copyWith(color: kGreyTextColor, fontWeight: FontWeight.bold, fontSize: 21.0),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
