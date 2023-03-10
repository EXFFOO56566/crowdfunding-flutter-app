// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tochyodikwa/service/donate_service.dart';
import 'package:tochyodikwa/service/event_book_pay_service.dart';
import 'package:tochyodikwa/service/profile_service.dart';
import 'package:tochyodikwa/view/payments_pages/billplz_payment.dart';
import 'package:provider/provider.dart';

class BillPlzService {
  payByBillPlz(BuildContext context, {required isFromEventBook}) {
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

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => BillplzPayment(
          amount: amount,
          name: name,
          phone: phone,
          email: email,
          isFromEventBook: isFromEventBook,
        ),
      ),
    );
  }
}
