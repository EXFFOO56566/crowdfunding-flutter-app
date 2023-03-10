import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tochyodikwa/service/all_donations_service.dart';
import 'package:tochyodikwa/service/all_events_service.dart';
import 'package:tochyodikwa/service/auth_services/change_pass_service.dart';
import 'package:tochyodikwa/service/auth_services/email_verify_service.dart';
import 'package:tochyodikwa/service/auth_services/facebook_login_service.dart';
import 'package:tochyodikwa/service/auth_services/google_sign_service.dart';
import 'package:tochyodikwa/service/auth_services/login_service.dart';
import 'package:tochyodikwa/service/auth_services/logout_service.dart';
import 'package:tochyodikwa/service/auth_services/reset_password_service.dart';
import 'package:tochyodikwa/service/auth_services/signup_service.dart';
import 'package:tochyodikwa/service/bottom_nav_service.dart';
import 'package:tochyodikwa/service/campaign_by_category_service.dart';
import 'package:tochyodikwa/service/campaign_details_service.dart';
import 'package:tochyodikwa/service/category_service.dart';
import 'package:tochyodikwa/service/country_states_service.dart';
import 'package:tochyodikwa/service/create_campaign_service.dart';
import 'package:tochyodikwa/service/dashboard_service.dart';
import 'package:tochyodikwa/service/donate_service.dart';
import 'package:tochyodikwa/service/edit_campaign_service.dart';
import 'package:tochyodikwa/service/event_book_pay_service.dart';
import 'package:tochyodikwa/service/events_booking_service.dart';
import 'package:tochyodikwa/service/featured_campaing_service.dart';
import 'package:tochyodikwa/service/follow_user_service.dart';
import 'package:tochyodikwa/service/followed_user_campaign_service.dart';
import 'package:tochyodikwa/service/followed_user_list_service.dart';
import 'package:tochyodikwa/service/my_campaign_list_service.dart';
import 'package:tochyodikwa/service/pay_services/bank_transfer_service.dart';
import 'package:tochyodikwa/service/pay_services/payment_choose_service.dart';
import 'package:tochyodikwa/service/pay_services/stripe_service.dart';
import 'package:tochyodikwa/service/profile_edit_service.dart';
import 'package:tochyodikwa/service/profile_service.dart';
import 'package:tochyodikwa/service/quick_donation_dropdown_service.dart';
import 'package:tochyodikwa/service/recent_campaing_service.dart';
import 'package:tochyodikwa/service/reward_list_service.dart';
import 'package:tochyodikwa/service/reedem_reward_service.dart';
import 'package:tochyodikwa/service/related_campaign_service.dart';
import 'package:tochyodikwa/service/reward_points_service.dart';
import 'package:tochyodikwa/service/rtl_service.dart';
import 'package:tochyodikwa/service/slider_service.dart';
import 'package:tochyodikwa/service/support_ticket/create_ticket_service.dart';
import 'package:tochyodikwa/service/support_ticket/support_messages_service.dart';
import 'package:tochyodikwa/service/support_ticket/support_ticket_service.dart';
import 'package:tochyodikwa/service/write_comment_service.dart';
import 'package:tochyodikwa/view/intro/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var publishableKey = await StripeService().getStripeKey();
  Stripe.publishableKey = publishableKey;
  await Stripe.instance.applySettings();

  await Firebase.initializeApp();
  runApp(const MyApp());

  //get user id, so that we can clear everything cached by provider when user logs out and logs in again
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getInt('userId');
}

int? userId;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      key: ObjectKey(userId),
      providers: [
        ChangeNotifierProvider(create: (_) => LoginService()),
        ChangeNotifierProvider(create: (_) => SignupService()),
        ChangeNotifierProvider(create: (_) => CountryStatesService()),
        ChangeNotifierProvider(create: (_) => ProfileService()),
        ChangeNotifierProvider(create: (_) => ChangePassService()),
        ChangeNotifierProvider(create: (_) => EmailVerifyService()),
        ChangeNotifierProvider(create: (_) => LogoutService()),
        ChangeNotifierProvider(create: (_) => ResetPasswordService()),
        ChangeNotifierProvider(create: (_) => RtlService()),
        ChangeNotifierProvider(create: (_) => GoogleSignInService()),
        ChangeNotifierProvider(create: (_) => FacebookLoginService()),
        ChangeNotifierProvider(create: (_) => SliderService()),
        ChangeNotifierProvider(create: (_) => QuickDonationDropdownService()),
        ChangeNotifierProvider(create: (_) => DonateService()),
        ChangeNotifierProvider(create: (_) => PaymentChooseService()),
        ChangeNotifierProvider(create: (_) => ProfileEditService()),
        ChangeNotifierProvider(create: (_) => RewardListService()),
        ChangeNotifierProvider(create: (_) => CreateTicketService()),
        ChangeNotifierProvider(create: (_) => SupportMessagesService()),
        ChangeNotifierProvider(create: (_) => SupportTicketService()),
        ChangeNotifierProvider(create: (_) => BottomNavService()),
        ChangeNotifierProvider(create: (_) => FeaturedCampaignService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => RecentCampaignService()),
        ChangeNotifierProvider(create: (_) => CampaignDetailsService()),
        ChangeNotifierProvider(create: (_) => DashboardService()),
        ChangeNotifierProvider(create: (_) => AllDonationsService()),
        ChangeNotifierProvider(create: (_) => RelatedCampaignService()),
        ChangeNotifierProvider(create: (_) => FollowUserService()),
        ChangeNotifierProvider(create: (_) => FollowedUserListService()),
        ChangeNotifierProvider(create: (_) => AllEventsService()),
        ChangeNotifierProvider(create: (_) => EventsBookingService()),
        ChangeNotifierProvider(create: (_) => CampaignByCategoryService()),
        ChangeNotifierProvider(create: (_) => FollowedUserCampaignService()),
        ChangeNotifierProvider(create: (_) => RewardPointsService()),
        ChangeNotifierProvider(create: (_) => RedeemRewardService()),
        ChangeNotifierProvider(create: (_) => BankTransferService()),
        ChangeNotifierProvider(create: (_) => WriteCommentService()),
        ChangeNotifierProvider(create: (_) => EventBookPayService()),
        ChangeNotifierProvider(create: (_) => CreateCampaignService()),
        ChangeNotifierProvider(create: (_) => MyCampaignListService()),
        ChangeNotifierProvider(create: (_) => EditCampaignService()),
      ],
      child: MaterialApp(
        title: 'Fundorex',
        debugShowCheckedModeBanner: false,
        builder: (context, rtlchild) {
          return Consumer<RtlService>(
            builder: (context, rtlP, child) => Directionality(
              textDirection: rtlP.direction == 'ltr'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: rtlchild!,
            ),
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
