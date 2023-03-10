import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/menu/menu_names.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
        backgroundColor: cc.bgGrey,
        body: SingleChildScrollView(
          child: Consumer<CreateCampaignService>(
            builder: (context, ccProvider, child) {
              return Column(
                children: [
                  Container(
                      height: 50, width: double.infinity, color: Colors.white),
                  SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenPadding, vertical: 20),
                          child: Consumer<RtlService>(
                            builder: (context, rtlP, child) => Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.01),
                                            spreadRadius: -2,
                                            blurRadius: 13,
                                            offset: const Offset(0, 13)),
                                      ],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListView(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.zero,
                                    children: <Widget>[
                                      for (int i = 0;
                                          i < menuNamesList.length;
                                          i++)
                                        InkWell(
                                          onTap: () {
                                            if (ccProvider
                                                    .hasCampaignCreatePermission ==
                                                true) {
                                              getNavLink(i, context);
                                            } else {
                                              if (menuNamesList[i].name ==
                                                      'Create campaign' ||
                                                  menuNamesList[i].name ==
                                                      'My campaigns') {
                                                OthersHelper().showSnackBar(
                                                    context,
                                                    'You don\'t have permission to create campaign',
                                                    Colors.red);
                                              }
                                            }
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 19),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                bottom: BorderSide(
                                                  color: cc.borderColor,
                                                  width: 1.0,
                                                ),
                                              )),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: rtlP.direction ==
                                                                'ltr'
                                                            ? 20
                                                            : 0,
                                                        left: rtlP.direction ==
                                                                'ltr'
                                                            ? 0
                                                            : 20),
                                                    child: SvgPicture.asset(
                                                        menuNamesList[i].icon),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      menuNamesList[i].name,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          color: cc.greyFour),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 9,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: cc.greyFour,
                                                    size: 14,
                                                  )
                                                ],
                                              )),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ))),
                ],
              );
            },
          ),
        ));
  }
}
