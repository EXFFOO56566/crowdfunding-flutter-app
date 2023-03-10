// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:tochyodikwa/service/donate_service.dart';
import 'package:tochyodikwa/service/event_book_pay_service.dart';
import 'package:tochyodikwa/service/pay_services/payment_choose_service.dart';
import 'package:tochyodikwa/service/profile_service.dart';
import 'package:tochyodikwa/view/utils/others_helper.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CashfreeService {
  getTokenAndPay(BuildContext context, {required isFromEventBook}) async {
    // var header = {
    //   //if header type is application/json then the data should be in jsonEncode method
    //   // "Accept": "application/json",
    //   'x-client-id': '94527832f47d6e74fa6ca5e3c72549',
    //   'x-client-secret': 'ec6a3222018c676e95436b2e26e89c1ec6be2830',
    //   "Content-Type": "application/json"
    // };

    //========>
    Provider.of<DonateService>(context, listen: false).setLoadingFalse();
    Provider.of<EventBookPayService>(context, listen: false).setLoadingFalse();

    var amount;

    var name;
    var phone = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .phone ??
        '';
    var email;

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      // "Accept": "application/json",
      'x-client-id': Provider.of<PaymentChooseService>(context, listen: false)
          .publicKey
          .toString(),
      'x-client-secret':
          Provider.of<PaymentChooseService>(context, listen: false)
              .secretKey
              .toString(),
      "Content-Type": "application/json"
    };

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

    print('order id in cashfree $orderId');

    String orderCurrency = "INR";
    var data = jsonEncode({
      'orderId': orderId,
      'orderAmount': amount,
      'orderCurrency': orderCurrency
    });

    var response = await http.post(
      Uri.parse(
          'https://test.cashfree.com/api/v2/cftoken/order'), // change url to https://api.cashfree.com/api/v2/cftoken/order when in production
      body: data,
      headers: header,
    );
    print(response.body);

    if (jsonDecode(response.body)['status'] == "OK") {
      cashFreePay(jsonDecode(response.body)['cftoken'], orderId, orderCurrency,
          context, amount, name, phone, email, isFromEventBook);
    } else {
      OthersHelper().showToast('Something went wrong', Colors.black);
    }
    // if()
  }

  cashFreePay(token, orderId, orderCurrency, BuildContext context, amount, name,
      phone, email, isFromEventBook) {
    //Replace with actual values
    //has to be unique every time
    String stage = "TEST"; // PROD when in production mode// TEST when in test

    String tokenData = token; //generate token data from server

    String appId = "94527832f47d6e74fa6ca5e3c72549";

    String notifyUrl = "";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": amount,
      "customerName": name,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": phone,
      "customerEmail": email,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    // CashfreePGSDK.doPayment(inputParams)
    //     .then((value) => value?.forEach((key, value) {
    //           print("$key : $value");
    //           print('it worked');
    //           //Do something with the result
    //         }));
    CashfreePGSDK.doPayment(
      inputParams,
    ).then((value) {
      print('cashfree payment result $value');
      if (value != null) {
        if (value['txStatus'] == "SUCCESS") {
          print('Cashfree Payment successfull. Do something here');
          if (isFromEventBook == true) {
            Provider.of<EventBookPayService>(context, listen: false)
                .makePaymentSuccess(context);
          } else {
            Provider.of<DonateService>(context, listen: false)
                .makePaymentSuccess(context);
          }
        }
      }
    });
  }
}
