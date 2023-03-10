// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class MidtransPayment extends StatelessWidget {
  MidtransPayment(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Midtrans'),
      ),
      body: FutureBuilder(
          future: waitForIt(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
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
              onPageFinished: (value) async {
                if (value.contains('success')) {
                  if (isFromEventBook == true) {
                    Provider.of<EventBookPayService>(context, listen: false)
                        .makePaymentSuccess(context);
                  } else {
                    Provider.of<DonateService>(context, listen: false)
                        .makePaymentSuccess(context);
                  }
                }
              },
            );
          }),
    );
  }

  waitForIt(BuildContext context) async {
    final url =
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');

    const serverKey = 'SB-Mid-server-9z5jztsHyYxEdSs7DgkNg2on';
    const clientKey = 'SB-Mid-client-iDuy-jKdZHkLjL_I';

    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$serverKey:$clientKey'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "transaction_details": {
            "order_id": DateTime.now().toString(),
            "gross_amount": 100
          },
          "credit_card": {"secure": true},
          "customer_details": {
            "first_name": name,
            "email": email,
            "phone": phone,
          }
        }));
    print(response.statusCode);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['redirect_url'];
      return;
    }

    return true;
  }
}
