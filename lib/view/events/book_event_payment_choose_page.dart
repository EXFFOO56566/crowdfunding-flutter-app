import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/pay_services/bank_transfer_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/service/pay_services/payment_constants_event_booking.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class BookEventPagePaymentChoosePage extends StatefulWidget {
  const BookEventPagePaymentChoosePage({Key? key, required this.eventId})
      : super(key: key);

  final eventId;

  @override
  State<BookEventPagePaymentChoosePage> createState() =>
      _BookEventPagePaymentChoosePageState();
}

class _BookEventPagePaymentChoosePageState
    extends State<BookEventPagePaymentChoosePage> {
  @override
  void initState() {
    super.initState();

    nameController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .name ??
        '';
    emailController.text = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .email ??
        '';

    qtyController.text = '1';
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final qtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final cc = ConstantColors();

  int selectedMethod = -1;

  @override
  Widget build(BuildContext context) {
    //fetch payment gateway list
    Provider.of<PaymentChooseService>(context, listen: false)
        .fetchGatewayList();

    return Scaffold(
      appBar: CommonHelper().appbarCommon('', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenPadding),
        child: Consumer<PaymentChooseService>(
          builder: (context, pgProvider, child) => pgProvider
                  .paymentList.isNotEmpty
              ? Consumer<EventBookPayService>(
                  builder: (context, eProvider, child) => Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Name ============>
                          CommonHelper().labelCommon("Username"),
                          CustomInput(
                            controller: nameController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            hintText: "Name",
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          //Email ============>
                          CommonHelper().labelCommon("Email"),
                          CustomInput(
                            controller: emailController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Email';
                              }
                              return null;
                            },
                            hintText: "Email",
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 8,
                          ),

                          //Quantity ============>
                          CommonHelper().labelCommon("Quantity"),
                          CustomInput(
                            controller: qtyController,
                            paddingHorizontal: 18,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter how many tickets you want to buy';
                              }
                              return null;
                            },
                            hintText: "Quantity",
                            textInputAction: TextInputAction.next,
                            isNumberField: true,
                          ),

                          // Button =====>

                          sizedBoxCustom(20),
                          CommonHelper().titleCommon('Choose payment method'),

                          //payment method card
                          GridView.builder(
                            gridDelegate: const FlutterzillaFixedGridView(
                                crossAxisCount: 3,
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                height: 60),
                            padding: const EdgeInsets.only(top: 30),
                            itemCount: pgProvider.paymentList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            clipBehavior: Clip.none,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedMethod = index;
                                  });

                                  //set key
                                  pgProvider.setKey(
                                      pgProvider.paymentList[selectedMethod]
                                          ['name'],
                                      index);

                                  //save selected payment method name
                                  // Provider.of<BookService>(context,
                                  //         listen: false)
                                  //     .setSelectedPayment(pgProvider
                                  //             .paymentList[selectedMethod]
                                  //         ['name']);
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 60,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: selectedMethod == index
                                                ? cc.primaryColor
                                                : cc.borderColor),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: pgProvider.paymentList[index]
                                            ['logo_link'],
                                        placeholder: (context, url) {
                                          return Image.asset(
                                              'assets/images/placeholder.png');
                                        },
                                        // fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    selectedMethod == index
                                        ? Positioned(
                                            right: -7,
                                            top: -9,
                                            child: CommonHelper().checkCircle())
                                        : Container()
                                  ],
                                ),
                              );
                            },
                          ),

                          selectedMethod != -1
                              ? pgProvider.paymentList[selectedMethod]
                                          ['name'] ==
                                      'manual_payment'
                                  ?
                                  //pick image ==========>
                                  Consumer<BankTransferService>(
                                      builder:
                                          (context, btProvider, child) =>
                                              Column(
                                                children: [
                                                  //pick image button =====>
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 30,
                                                      ),
                                                      CommonHelper()
                                                          .buttonPrimary(
                                                              'Choose images',
                                                              () {
                                                        btProvider
                                                            .pickImage(context);
                                                      }),
                                                    ],
                                                  ),
                                                  btProvider.pickedImage != null
                                                      ? Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            SizedBox(
                                                              height: 80,
                                                              child: ListView(
                                                                clipBehavior:
                                                                    Clip.none,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                shrinkWrap:
                                                                    true,
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () {},
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          margin:
                                                                              const EdgeInsets.only(right: 10),
                                                                          child:
                                                                              Image.file(
                                                                            // File(provider.images[i].path),
                                                                            File(btProvider.pickedImage.path),
                                                                            height:
                                                                                80,
                                                                            width:
                                                                                80,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      : Container(),
                                                ],
                                              ))
                                  : Container()
                              : Container(),

                          sizedBoxCustom(30),

                          CommonHelper().buttonPrimary("Confirm", () {
                            if (int.tryParse(qtyController.text.trim()) ==
                                null) {
                              //if user entered other than int value
                              OthersHelper().showSnackBar(
                                  context,
                                  'Quantity must be integer value',
                                  cc.warningColor);
                              return;
                            }

                            if (selectedMethod == -1) {
                              OthersHelper().showSnackBar(context,
                                  'Please select a payment method', Colors.red);

                              return;
                            }

                            if (eProvider.isloading == true) return;

                            if (_formKey.currentState!.validate()) {
                              payActionForEventBook(
                                  pgProvider.paymentList[selectedMethod]
                                      ['name'],
                                  context, //if user selected bank transfer
                                  pgProvider.paymentList[selectedMethod]
                                              ['name'] ==
                                          'manual_payment'
                                      ? Provider.of<BankTransferService>(
                                              context,
                                              listen: false)
                                          .pickedImage
                                      : null,
                                  name: nameController.text,
                                  email: emailController.text,
                                  eventId: widget.eventId,
                                  qty: qtyController.text.trim());
                            }
                          },
                              isloading:
                                  eProvider.isloading == false ? false : true),

                          sizedBoxCustom(30),
                        ],
                      )),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: OthersHelper().showLoading(cc.primaryColor),
                ),
        ),
      )),
    );
  }
}
