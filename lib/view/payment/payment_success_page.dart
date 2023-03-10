import 'package:flutter/material.dart';
import 'package:fundorex/service/bottom_nav_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/donations/donations_list_page.dart';
import 'package:fundorex/view/home/landing_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var donationId = Provider.of<DonateService>(context, listen: false).orderId;
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('', context, () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LandingPage(),
          ),
        );
      }),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        // height: screenHeight - 200,
        alignment: Alignment.center,
        child: Consumer<DonateService>(
          builder: (context, provider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.celebration_outlined,
                  color: cc.successColor,
                  size: 65,
                ),
                sizedBoxCustom(15),
                Text(
                  'Donated successfully!',
                  style: TextStyle(
                      color: cc.greyPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
                sizedBoxCustom(10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text:
                        'Your donation has been successful!, Order ID is #${provider.orderId}',
                    style: TextStyle(
                        color: cc.greyParagraph, fontSize: 15, height: 1.4),
                    children: const <TextSpan>[
                      // TextSpan(
                      //     text: '#$donationId',
                      //     style: TextStyle(
                      //         color: cc.primaryColor,
                      //         fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                sizedBoxCustom(90)
              ]),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: Row(children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: 20, bottom: 20),
            child: CommonHelper().buttonPrimary('See all donations', () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const LandingPage(),
                ),
              );

              Provider.of<BottomNavService>(context, listen: false)
                  .setCurrentIndex(2);

              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const DonationsListPage(),
                ),
              );
            }),
          )),
          const SizedBox(
            width: 18,
          ),
        ]),
      ),
    );
  }
}
