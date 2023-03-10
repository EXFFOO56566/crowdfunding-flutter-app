// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PayfastPayment extends StatelessWidget {
  PayfastPayment(
      {Key? key,
      required this.amount,
      required this.name,
      required this.phone,
      required this.email,
      required this.isFromEventBook})
      : super(key: key);

  final amount;
  final name;
  final phone;
  final email;
  final isFromEventBook;

  String? url;
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payfast'),
      ),
      body: FutureBuilder(
          future: waitForIt(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              return const Center(
                child: Text('Loding failed.'),
              );
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Text('Loding failed.'),
              );
            }
            return WebView(
              onWebResourceError: (error) {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return const AlertDialog(
                        title: Text('Loading failed!'),
                        content: Text('Failed to load payment page.'),
                      );
                    });

                Navigator.pop(context);
              },
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (value) async {
                if (value.contains('finish')) {
                  bool paySuccess = await verifyPayment(value);
                  if (paySuccess) {
                    if (isFromEventBook == true) {
                      await Provider.of<EventBookPayService>(context,
                              listen: false)
                          .makePaymentSuccess(context);
                    } else {
                      await Provider.of<DonateService>(context, listen: false)
                          .makePaymentSuccess(context);
                    }
                    return;
                  }
                }
              },
            );
          }),
    );
  }

  waitForIt(BuildContext context) {
    final merchantId =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey;

    final merchantKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey;

    // final merchantId = '10024000';

    // final merchantKey = '77jcu5v4ufdod';

    this.url =
        'https://sandbox.payfast.co.za/eng/process?merchant_id=$merchantId&merchant_key=$merchantKey&amount=$amount&item_name=GrenmartGroceries';
    //   return;
    // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}
