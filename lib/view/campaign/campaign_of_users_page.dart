// import 'package:flutter/material.dart';
// import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
// import 'package:fundorex/view/home/components/campaign_card.dart';
// import 'package:fundorex/view/utils/common_helper.dart';
// import 'package:fundorex/view/utils/constant_colors.dart';
// import 'package:fundorex/view/utils/constant_styles.dart';

// class CampaignOfUsersPage extends StatelessWidget {
//   const CampaignOfUsersPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ConstantColors cc = ConstantColors();
//     return Scaffold(
//       appBar: CommonHelper().appbarCommon('Robert Fox', context, () {
//         Navigator.pop(context);
//       }, bgColor: Colors.white),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: screenPadding,
//             ),
//             child: Column(
//               children: [
//                 sizedBoxCustom(5),
//                 GridView.builder(
//                   gridDelegate: const FlutterzillaFixedGridView(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 15,
//                       crossAxisSpacing: 15,
//                       height: 278),
//                   itemCount: 6,
//                   shrinkWrap: true,
//                   clipBehavior: Clip.none,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     return CampaignCard(
//                         imageLink:
//                             'https://images.unsplash.com/photo-1613375920388-f1f70f341f8a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c29saWR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
//                         title: 'Donation for flood victims in sylhet',
//                         width: 190,
//                         marginRight: 0,
//                         pressed: () {},
//                         serviceId: 1,
//                         raisedAmount: 200,
//                         goalAmount: 250);
//                   },
//                 ),
//                 sizedBoxCustom(25),
//               ],
//             )),
//       )),
//     );
//   }
// }
