import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:flutterwave_standard/view/flutterwave_style.dart';
import 'package:tochyodikwa/service/donate_service.dart';
import 'package:tochyodikwa/service/event_book_pay_service.dart';
import 'package:tochyodikwa/service/pay_services/payment_choose_service.dart';
import 'package:tochyodikwa/service/profile_service.dart';

import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';

class FlutterwaveService {
  String currency = 'USD';

  payByFlutterwave(BuildContext context, {required isFromEventBook}) {
    _handlePaymentInitialization(context, isFromEventBook: isFromEventBook);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => const FlutterwavePaymentPage(),
    //   ),
    // );
  }

  _handlePaymentInitialization(BuildContext context,
      {required isFromEventBook}) async {
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

    if (isFromEventBook == false) {
      amount = Provider.of<DonateService>(context, listen: false)
          .donationAmountWithTips;

      amount = amount.toStringAsFixed(2);
      name = Provider.of<DonateService>(context, listen: false)
          .userEnteredNameWhileDonating;
      email = Provider.of<DonateService>(context, listen: false)
          .userEnteredEmailWhileDonating;
    } else {
      amount =
          Provider.of<EventBookPayService>(context, listen: false).eventPrice;
      amount = double.parse(amount).toStringAsFixed(2);
      name = Provider.of<ProfileService>(context, listen: false)
              .profileDetails
              .name ??
          '';

      email = Provider.of<ProfileService>(context, listen: false)
              .profileDetails
              .email ??
          '';
    }

    // String publicKey = 'FLWPUBK_TEST-86cce2ec43c63e09a517290a8347fcab-X';
    String publicKey =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey ??
            '';

    final style = FlutterwaveStyle(
      appBarText: "Flutterwave payment",
      buttonColor: Colors.blue,
      buttonTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      appBarColor: Colors.blue,
      dialogCancelTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 17,
      ),
      dialogContinueTextStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 17,
      ),
      mainBackgroundColor: Colors.white,
      mainTextStyle:
          const TextStyle(color: Colors.black, fontSize: 17, letterSpacing: 2),
      dialogBackgroundColor: Colors.white,
      appBarIcon: const Icon(Icons.arrow_back, color: Colors.white),
      buttonText: "Pay \$ $amount",
      appBarTitleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );

    final Customer customer =
        Customer(name: "FLW Developer", phoneNumber: phone, email: email);

    final subAccounts = [
      SubAccount(
          id: "RS_1A3278129B808CB588B53A14608169AD",
          transactionChargeType: "flat",
          transactionPercentage: 25),
      SubAccount(
          id: "RS_C7C265B8E4B16C2D472475D7F9F4426A",
          transactionChargeType: "flat",
          transactionPercentage: 50)
    ];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        style: style,
        publicKey: publicKey,
        currency: currency,
        txRef: const Uuid().v1(),
        amount: amount,
        customer: customer,
        subAccounts: subAccounts,
        paymentOptions: "card, payattitude",
        customization: Customization(title: "Test Payment"),
        redirectUrl: "https://www.google.com",
        isTestMode: false);
    var response = await flutterwave.charge();
    if (response != null) {
      showLoading(response.status!, context);

      print('flutterwave payment successfull');
      if (isFromEventBook == true) {
        Provider.of<EventBookPayService>(context, listen: false)
            .makePaymentSuccess(context);
      } else {
        Provider.of<DonateService>(context, listen: false)
            .makePaymentSuccess(context);
      }

      // print("${response.toJson()}");
    } else {
      //User cancelled the payment
      // showLoading("No Response!");
    }
  }

  Future<void> showLoading(String message, context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
