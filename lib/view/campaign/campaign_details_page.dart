import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/follow_user_service.dart';
import 'package:fundorex/view/campaign/components/comments_tab.dart';
import 'package:fundorex/view/campaign/components/desc_tab.dart';
import 'package:fundorex/view/campaign/components/faq_tab.dart';
import 'package:fundorex/view/campaign/components/updates_tab.dart';
import 'package:fundorex/view/campaign/write_comment_page.dart';
import 'package:fundorex/view/payment/donation_payment_choose_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/constant_styles.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class CampaignDetailsPage extends StatefulWidget {
  const CampaignDetailsPage({
    Key? key,
    required this.campaignId,
  }) : super(key: key);

  final campaignId;

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage>
    with SingleTickerProviderStateMixin {
  int currentTab = 0;
  late TabController _tabController;
  int _tabIndex = 0;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: cc.greyPrimary),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: cc.greyFour,
            size: 18,
          ),
        ),
        actions: [
          //Follow button
          Row(
            children: [
              SizedBox(
                height: 41,
                width: 90,
                child: Consumer<CampaignDetailsService>(
                  builder: (context, provider, child) =>
                      Consumer<FollowUserService>(
                    builder: (context, fProvider, child) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: CommonHelper().buttonPrimary(
                          fProvider.isFollowingUser ? 'Following' : 'Follow',
                          () {
                        if (fProvider.isLoading == true) return;

                        fProvider.followUser(
                            context: context,
                            userType: provider.campaignDetails.createdBy,
                            campaignOwnerId:
                                provider.campaignDetails.campaignOwnerId);
                      },
                          paddingVertical: 5,
                          fontsize: 13,
                          borderRadius: 7,
                          isloading:
                              fProvider.isLoading == false ? false : true),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<CampaignDetailsService>(
          builder: (context, provider, child) {
            return provider.isloading == false
                ? provider.hasError == false
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenPadding),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sizedBoxCustom(14),
                              Text(
                                provider.campaignDetails.title ?? '',
                                style: TextStyle(
                                    color: cc.greyFour,
                                    fontSize: 18,
                                    height: 1.4,
                                    fontWeight: FontWeight.bold),
                              ),
                              sizedBoxCustom(22),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: 180,
                                  width: double.infinity,
                                  imageUrl: provider.campaignDetails.image ??
                                      placeHolderUrl,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              sizedBoxCustom(22),
                              //Name, profile image etc
                              Row(
                                children: [
                                  CommonHelper().profileImage(
                                      provider.campaignDetails.userImage ??
                                          placeHolderUrl,
                                      55,
                                      55,
                                      radius: 50),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //name
                                        CommonHelper().titleCommon(
                                            provider.campaignDetails.userName ??
                                                '-',
                                            fontsize: 17),
                                        sizedBoxCustom(7),
                                        //time and category
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/calendar.svg',
                                              height: 17,
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              provider.campaignDetails
                                                      .createdAt ??
                                                  '-',
                                              style: TextStyle(
                                                color: cc.greyParagraph,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            SvgPicture.asset(
                                              'assets/svg/category.svg',
                                              height: 17,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              provider.campaignDetails
                                                      .category ??
                                                  '-',
                                              style: TextStyle(
                                                color: cc.greyParagraph,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              //Tabs
                              Container(
                                color: Colors.white,
                                margin:
                                    const EdgeInsets.only(top: 13, bottom: 20),
                                child: Column(
                                  children: <Widget>[
                                    TabBar(
                                      onTap: (value) {
                                        setState(() {
                                          currentTab = value;
                                        });
                                      },
                                      labelColor: cc.primaryColor,
                                      unselectedLabelColor: cc.greyFour,
                                      isScrollable: true,
                                      indicatorColor: cc.primaryColor,
                                      unselectedLabelStyle: TextStyle(
                                          color: cc.greyParagraph,
                                          fontWeight: FontWeight.normal),
                                      controller: _tabController,
                                      tabs: const [
                                        Tab(text: 'Description'),
                                        Tab(text: 'FAQ'),
                                        Tab(text: 'Updates'),
                                        Tab(text: 'Comments'),
                                      ],
                                    ),
                                    Container(
                                      child: [
                                        const DescTab(),
                                        const FaqTab(),
                                        const UpdatesTab(),
                                        const CommentsTab()
                                      ][_tabIndex],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      )
                    : Container(
                        height: screenHeight - 250,
                        alignment: Alignment.center,
                        child: const Text("Something went wrong"))
                : Center(
                    child: SizedBox(
                        height: screenHeight - 250,
                        child: OthersHelper().showLoading(cc.primaryColor)),
                  );
          },
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenPadding,
          ),
          height: currentTab == 3 ? 160 : 90,
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border(
            //   top: BorderSide(
            //     color: Colors.grey.withOpacity(.3),
            //     width: 1.0,
            //   ),
            // ),
            boxShadow: [
              BoxShadow(
                blurRadius: 15.0,
                color: Colors.grey.withOpacity(.2),
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentTab == 3
                  ? Column(
                      children: [
                        CommonHelper().borderButtonPrimary("Write a Comment",
                            () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    WriteCommentPage(
                                      campaignId: widget.campaignId,
                                    )),
                          );
                        }, paddingVertical: 16),
                        const SizedBox(
                          height: 14,
                        ),
                      ],
                    )
                  : Container(),
              CommonHelper().buttonPrimary("Donate", () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        DonationPaymentChoosePage(
                            campaignId: widget.campaignId),
                  ),
                );
              }),
            ],
          )),
    );
  }
}
