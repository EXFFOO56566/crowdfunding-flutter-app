// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/others_helper.dart';

import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class BillplzPayment extends StatelessWidget {
  BillplzPayment(
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
        title: const Text('BillPlz'),
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
              // onWebViewCreated: ((controller) {
              //   _controller = controller;
              // }),
              onWebResourceError: (error) => showDialog(
                  context: context,
                  builder: (ctx) {
                    return const AlertDialog(
                      title: Text('Loading failed!'),
                      content: Text('Failed to load payment page.'),
                    );
                  }),
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (value) async {
                verifyPayment(value, context, isFromEventBook);
              },
            );
          }),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        print('page body: $pageBody');
      },
    );
  }

  waitForIt(BuildContext context) async {
    // String orderId =
    //     Provider.of<PlaceOrderService>(context, listen: false).orderId;

    final url = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
    final username =
        Provider.of<PaymentChooseService>(context, listen: false).publicKey ??
            '';

    final collectionName =
        Provider.of<PaymentChooseService>(context, listen: false)
                .billPlzCollectionName ??
            '';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$username'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "collection_id": collectionName,
          "description": "Qixer payment",
          "email": email,
          "name": name,
          "amount": "${double.parse(amount) * 100}",
          "reference_1_label": "Bank Code",
          "reference_1": "BP-FKR01",
          "callback_url": "http://www.xgenious.com"
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)["url"];
      return;
    }

    return true;
  }
}

Future verifyPayment(String url, BuildContext context, isFromEventBook) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.body.contains('paid')) {
    if (isFromEventBook == true) {
      Provider.of<EventBookPayService>(context, listen: false)
          .makePaymentSuccess(context);
    } else {
      Provider.of<DonateService>(context, listen: false)
          .makePaymentSuccess(context);
    }

    return;
  }
  if (response.body.contains('your payment was not')) {
    OthersHelper().showSnackBar(context, 'Payment failed', Colors.red);
    Navigator.pop(context);
    return;
  }
}
