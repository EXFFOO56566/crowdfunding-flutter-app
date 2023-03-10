import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/related_campaign_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_helper.dart';
import 'package:fundorex/view/campaign/components/people_donated_list.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/home/components/section_title.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class DescTab extends StatefulWidget {
  const DescTab({Key? key}) : super(key: key);

  @override
  State<DescTab> createState() => _DescTabState();
}

class _DescTabState extends State<DescTab> {
  final CustomTimerController _timerController = CustomTimerController();

  @override
  void initState() {
    super.initState();
    _timerController.start();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<CampaignDetailsService>(
      builder: (context, provider, child) {
        final todayDate = DateTime.now();
        final remaining = provider.campaignDetails.remainingTime;
        final timeLeft = remaining.difference(todayDate).inDays;

        return Container(
          padding: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(.3),
              width: 1.0,
            ),
          )),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              provider.campaignDetails.description,
              style: TextStyle(color: cc.greyParagraph, height: 1.4),
            ),
            sizedBoxCustom(18),
            //timer cards
            CustomTimer(
                controller: _timerController,
                begin: Duration(days: timeLeft),
                end: const Duration(),
                builder: (time) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0;
                          i < CampaignHelper().timeCardTitle.length;
                          i++)
                        Container(
                          height: screenWidth / 4 - 31,
                          width: screenWidth / 4 - 27,
                          margin: EdgeInsets.only(right: i == 3 ? 0 : 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: cc.primaryColor),
                          child: TimerCard(
                            i: i,
                            time: time,
                          ),
                        )
                    ],
                  );
                }),

            sizedBoxCustom(22),
            //Progress bar
            CampaignHelper().progressBar(provider.campaignDetails.raisedAmount,
                provider.campaignDetails.goalAmount),

            sizedBoxCustom(15),
            //Raised and Goal ======+>
            Row(
              children: [
                //raised
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Raised",
                        style: TextStyle(
                          color: cc.greyParagraph,
                          fontSize: 12,
                        ),
                      ),
                      sizedBoxCustom(5),
                      AutoSizeText(
                        "\$${provider.campaignDetails.raisedAmount ?? 0}",
                        maxLines: 1,
                        style: TextStyle(
                            color: cc.greyParagraph,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                //Goal
                Expanded(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Goal",
                          style: TextStyle(
                            color: cc.greyParagraph,
                            fontSize: 12,
                          ),
                        ),
                        sizedBoxCustom(5),
                        AutoSizeText(
                          "\$${provider.campaignDetails.goalAmount}",
                          maxLines: 1,
                          style: TextStyle(
                              color: cc.greyParagraph,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            sizedBoxCustom(25),
            PeopleDonatedList(
              cc: cc,
              width: 200,
              marginRight: 20,
              provider: provider,
            ),

            sizedBoxCustom(25),

            //Related Campaign
            //================>

            Consumer<RelatedCampaignService>(
              builder: (context, rProvider, child) =>
                  rProvider.relatedCampaignList.isNotEmpty
                      ? Column(
                          children: [
                            SectionTitle(
                              cc: cc,
                              title: 'Related campaigns',
                              hasSeeAllBtn: false,
                              pressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute<void>(
                                //     builder: (BuildContext context) => const TopAllServicePage(),
                                //   ),
                                // );
                              },
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              height: 275,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                clipBehavior: Clip.none,
                                children: [
                                  for (int i = 0;
                                      i < rProvider.relatedCampaignList.length;
                                      i++)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                CampaignDetailsPage(
                                              campaignId: rProvider
                                                  .relatedCampaignList[i].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CampaignCard(
                                          imageLink: rProvider
                                              .relatedCampaignList[i].image,
                                          title: rProvider
                                              .relatedCampaignList[i].title,
                                          width: 190,
                                          marginRight: 20,
                                          pressed: () {},
                                          camapaignId: rProvider
                                              .relatedCampaignList[i].id,
                                          raisedAmount: rProvider
                                              .relatedCampaignList[i].raised,
                                          goalAmount: rProvider
                                              .relatedCampaignList[i].amount),
                                    )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
            ),
          ]),
        );
      },
    );
  }
}

class TimerCard extends StatelessWidget {
  const TimerCard({
    Key? key,
    required this.i,
    required this.time,
  }) : super(key: key);

  final int i;
  final time;

  @override
  Widget build(BuildContext context) {
    getTime(index) {
      if (index == 0) {
        return time.days;
      } else if (index == 1) {
        return time.hours;
      } else if (index == 2) {
        return time.minutes;
      } else if (index == 3) {
        return time.seconds;
      }
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AutoSizeText(
        getTime(i),
        maxLines: 1,
        style: const TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      ),
      sizedBoxCustom(3),
      AutoSizeText(
        CampaignHelper().timeCardTitle[i],
        maxLines: 1,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ]);
  }
}
