// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/service/pay_services/zitopay_service.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZitopayPaymentPage extends StatefulWidget {
  const ZitopayPaymentPage({
    Key? key,
    required this.amount,
    required this.name,
    required this.phone,
    required this.email,
    required this.isFromEventBook,
  }) : super(key: key);

  final amount;
  final name;
  final phone;
  final email;
  final isFromEventBook;

  @override
  _ZitopayPaymentPageState createState() => _ZitopayPaymentPageState();
}

class _ZitopayPaymentPageState extends State<ZitopayPaymentPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    zitopayReceiverName =
        Provider.of<PaymentChooseService>(context, listen: false)
            .zitopayReceiverName;
  }

  var zitopayReceiverName;

  bool alreadySuccessful = false;

  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text("Zitopay"),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  child: IconButton(
                      onPressed: () async {
                        controller.reload();
                      },
                      icon: const Icon(Icons.refresh)),
                )
              ]),
          body: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl:
                "https://zitopay.africa/sci/?currency=XAF&amount=${widget.amount}&receiver=$zitopayReceiverName&success_url=https%3A%2F%2Fwww.google.com%2F&cancel_url=https%3A%2F%2Fpub.dev",
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            navigationDelegate: (NavigationRequest request) async {
              if (request.url.contains('https://www.google.com/')) {
                //if payment is success, then the page is refreshing twice.
                //which is causing the screen pop twice.
                //So, this alreadySuccess = true trick will prevent that
                if (alreadySuccessful != true) {
                  print('payment success');
                  if (widget.isFromEventBook == true) {
                    Provider.of<EventBookPayService>(context, listen: false)
                        .makePaymentSuccess(context);
                  } else {
                    Provider.of<DonateService>(context, listen: false)
                        .makePaymentSuccess(context);
                  }
                }

                setState(() {
                  alreadySuccessful = true;
                });

                return NavigationDecision.prevent;
              }
              if (request.url.contains('https://pub.dev/')) {
                print('payment failed');
                OthersHelper()
                    .showSnackBar(context, 'Payment failed', Colors.red);
                Navigator.pop(context);

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            // onPageFinished: (url) {
            //   print(url);
            //   if (url == 'https://www.google.com/') {
            //   } else if (url == 'https://pub.dev/') {}
            // },
          ),
        ),
      ),
    );
  }
}
