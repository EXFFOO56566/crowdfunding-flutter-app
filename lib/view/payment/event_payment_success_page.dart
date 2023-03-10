import 'package:flutter/material.dart';
import 'package:fundorex/service/bottom_nav_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/view/events/events_bookings_page.dart';
import 'package:fundorex/view/home/landing_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class EventPaymentSuccessPage extends StatelessWidget {
  const EventPaymentSuccessPage({Key? key}) : super(key: key);

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
      body: Consumer<EventBookPayService>(
        builder: (context, provider, child) => Container(
          padding: EdgeInsets.symmetric(horizontal: screenPadding),
          // height: screenHeight - 200,
          alignment: Alignment.center,
          child: Column(
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
                  'Booking Successfull',
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
                        'Your booking for the event is successful, ID is #${provider.eventAfterSuccessId}',
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
              ]),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: Row(children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: 20, bottom: 20),
            child: CommonHelper().buttonPrimary('See booked events', () {
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
                  builder: (BuildContext context) => const EventsBookingsPage(),
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
