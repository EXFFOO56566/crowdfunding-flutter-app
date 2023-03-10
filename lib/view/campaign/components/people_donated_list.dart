// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/view/campaign/components/all_people_who_donated.dart';
import 'package:fundorex/view/home/components/section_title.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';

class PeopleDonatedList extends StatelessWidget {
  const PeopleDonatedList({
    Key? key,
    required this.cc,
    required this.width,
    required this.marginRight,
    required this.provider,
    this.campaignId,
  }) : super(key: key);
  final ConstantColors cc;

  final double width;
  final double marginRight;
  final provider;
  final campaignId;

  @override
  Widget build(BuildContext context) {
    return provider.peopleWhoDonated != null
        ? provider.peopleWhoDonated.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    cc: cc,
                    title: 'People who donated',
                    pressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const AllPeopleWhoDonated(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    height: 58,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      children: [
                        for (int i = 0;
                            i < provider.peopleWhoDonated.length;
                            i++)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) =>
                              //         const ServiceDetailsPage(),
                              //   ),
                              // );
                            },
                            child: DonatorCard(
                                width: width,
                                marginRight: marginRight,
                                cc: cc,
                                provider: provider,
                                i: i),
                          )
                      ],
                    ),
                  ),
                ],
              )
            : Container()
        : Container();
  }
}

class DonatorCard extends StatelessWidget {
  const DonatorCard({
    Key? key,
    required this.width,
    required this.marginRight,
    required this.cc,
    required this.provider,
    required this.i,
  }) : super(key: key);

  final double width;
  final double marginRight;
  final ConstantColors cc;
  final provider;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(
        right: marginRight,
      ),
      decoration: BoxDecoration(
          border: Border.all(color: cc.borderColor),
          borderRadius: BorderRadius.circular(9)),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 13,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/svg/donation-circle.svg',
              height: 35,
            ),

            const SizedBox(
              width: 10,
            ),
            //Title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.peopleWhoDonated[i].name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: cc.greyParagraph,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                sizedBoxCustom(5),
                Text(
                  '\$${provider.peopleWhoDonated[i].amount} · ${CampaignDetailsService().formatDate(provider.peopleWhoDonated[i].createdAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cc.greyParagraph,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
