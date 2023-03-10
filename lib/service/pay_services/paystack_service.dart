import 'package:flutter/material.dart';
import 'package:tochyodikwa/service/donate_service.dart';
import 'package:tochyodikwa/service/event_book_pay_service.dart';
import 'package:tochyodikwa/service/profile_service.dart';
import 'package:tochyodikwa/view/payments_pages/paystack_payment_page.dart';
import 'package:provider/provider.dart';

class PaystackService {
  payByPaystack(BuildContext context, {required isFromEventBook}) {
    //========>
    Provider.of<DonateService>(context, listen: false).setLoadingFalse();
    Provider.of<EventBookPayService>(context, listen: false).setLoadingFalse();

    var phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .phone ??
        '';
    var amount;
    var name;
    var email;

    String orderId;

    if (isFromEventBook == false) {
      orderId = Provider.of<DonateService>(context, listen: false)
              .orderId
              .toString() +
          'fundorexDonate';
      amount = Provider.of<DonateService>(context, listen: false)
          .donationAmountWithTips;
      amount = amount.toStringAsFixed(2);
      name = Provider.of<DonateService>(context, listen: false)
          .userEnteredNameWhileDonating;
      email = Provider.of<DonateService>(context, listen: false)
          .userEnteredEmailWhileDonating;
    } else {
      orderId = Provider.of<EventBookPayService>(context, listen: false)
              .eventAfterSuccessId
              .toString() +
          'fundorexEvent';

      amount =
          Provider.of<EventBookPayService>(context, listen: false).eventPrice;

      amount = amount.toString();
      name = Provider.of<ProfileService>(context, listen: false)
              .profileDetails
              .name ??
          '';

      email = Provider.of<ProfileService>(context, listen: false)
              .profileDetails
              .email ??
          '';
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaystackPaymentPage(
          amount: amount,
          name: name,
          phone: phone,
          email: email,
          isFromEventBook: isFromEventBook,
          orderId: orderId,
        ),
      ),
    );
  }
}
