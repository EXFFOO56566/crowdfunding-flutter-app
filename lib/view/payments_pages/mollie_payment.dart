// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class MolliePayment extends StatelessWidget {
  MolliePayment(
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
  String? statusURl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mollie'),
      ),
      body: FutureBuilder(
          future: waitForIt(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: (value) async {
                //=======>
                String redirectUrl;

                if (isFromEventBook == false) {
                  redirectUrl =
                      Provider.of<DonateService>(context, listen: false)
                          .successUrl;
                } else {
                  redirectUrl =
                      Provider.of<EventBookPayService>(context, listen: false)
                          .successUrl;
                }

                if (value.contains(redirectUrl)) {
                  String status = await verifyPayment(context);
                  if (status == 'paid') {
                    if (isFromEventBook == true) {
                      await Provider.of<EventBookPayService>(context,
                              listen: false)
                          .makePaymentSuccess(context);
                    } else {
                      await Provider.of<DonateService>(context, listen: false)
                          .makePaymentSuccess(context);
                    }
                  }
                  if (status == 'open') {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AlertDialog(
                            title: Text('Payment cancelled!'),
                            content: Text('Payment has been cancelled.'),
                          );
                        });
                    Navigator.pop(context);
                  }
                  if (status == 'failed') {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AlertDialog(
                            title: Text('Payment failed!'),
                          );
                        });
                    Navigator.pop(context);
                  }
                  if (status == 'expired') {
                    await showDialog(
                        context: context,
                        builder: (ctx) {
                          return const AlertDialog(
                            title: Text('Payment failed!'),
                            content: Text('Payment has been expired.'),
                          );
                        });
                    Navigator.pop(context);
                  }
                }
              },
            );
          }),
    );
  }

  waitForIt(BuildContext context) async {
    final publicKey =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey;

    String orderId;
    String successUrl;

    if (isFromEventBook == false) {
      orderId = Provider.of<DonateService>(context, listen: false)
              .orderId
              .toString() +
          'fundorexDonate';

      successUrl =
          Provider.of<DonateService>(context, listen: false).successUrl;
    } else {
      orderId = Provider.of<EventBookPayService>(context, listen: false)
              .eventAfterSuccessId
              .toString() +
          'fundorexEvent';
      successUrl =
          Provider.of<EventBookPayService>(context, listen: false).successUrl;
    }

    final url = Uri.parse('https://api.mollie.com/v2/payments');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };

    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "amount": {"value": amount, "currency": "USD"},
          "description": "Qixer payment",
          "redirectUrl": successUrl,
          "webhookUrl": successUrl,
          "metadata": orderId,
          // "method": "creditcard",
        }));
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['_links']['checkout']['href'];
      this.statusURl = jsonDecode(response.body)['_links']['self']['href'];
      print(statusURl);
      return;
    }

    return true;
  }

  verifyPayment(BuildContext context) async {
    final publicKey =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey;

    final url = Uri.parse(statusURl as String);
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $publicKey",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.get(url, headers: header);
    print(jsonDecode(response.body)['status']);
    return jsonDecode(response.body)['status'];
  }
}
