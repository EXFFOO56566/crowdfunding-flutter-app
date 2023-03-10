// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:webview_flutter/webview_flutter.dart';

class MercadopagoPaymentPage extends StatefulWidget {
  MercadopagoPaymentPage(
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

  @override
  State<MercadopagoPaymentPage> createState() => _MercadopagoPaymentPageState();
}

class _MercadopagoPaymentPageState extends State<MercadopagoPaymentPage> {
  @override
  void initState() {
    super.initState();
  }

  late String url;

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();
    return Scaffold(
      appBar: AppBar(title: const Text('Mercado pago')),
      body: FutureBuilder(
          future: getPaymentUrl(context),
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
              onWebResourceError: (error) => showDialog(
                  context: context,
                  builder: (ctx) {
                    return const AlertDialog(
                      title: Text('Loading failed!'),
                      content: Text('Failed to load payment page.'),
                      actions: [
                        Spacer(),
                      ],
                    );
                  }),
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.contains('https://www.google.com/')) {
                  print('payment success');

                  if (widget.isFromEventBook == true) {
                    Provider.of<EventBookPayService>(context, listen: false)
                        .makePaymentSuccess(context);
                  } else {
                    Provider.of<DonateService>(context, listen: false)
                        .makePaymentSuccess(context);
                  }

                  return NavigationDecision.prevent;
                }
                if (request.url.contains('https://www.facebook.com/')) {
                  print('payment failed');
                  OthersHelper()
                      .showSnackBar(context, 'Payment failed', Colors.red);
                  Navigator.pop(context);

                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            );
          }),
    );
  }

  Future<dynamic> getPaymentUrl(BuildContext context) async {
    String mercadoKey =
        Provider.of<PaymentChooseService>(context, listen: false).secretKey ??
            '';

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({
      "items": [
        {
          "title": "Qixer",
          "description": "Qixer payment",
          "quantity": 1,
          "currency_id": "ARS",
          "unit_price": double.parse(widget.amount).toInt()
        }
      ],
      'back_urls': {
        "success": 'https://www.google.com/',
        "failure": 'https://www.facebook.com',
        "pending": 'https://www.facebook.com'
      },
      'auto_return': 'approved',
      "payer": {"email": widget.email}
    });

    var response = await http.post(
        Uri.parse(
            'https://api.mercadopago.com/checkout/preferences?access_token=$mercadoKey'),
        headers: header,
        body: data);

    print(response.body);

    // print(response.body);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['init_point'];

      return;
    }
    return '';
  }
}
