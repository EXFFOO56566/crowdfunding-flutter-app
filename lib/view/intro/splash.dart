import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/splash_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      screenSizeAndPlatform(context);
    });
    SplashService().loginOrGoHome(context);

    //run when app starts
    runAtStart(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
          // color: ConstantColors().primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 70,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.png'),
                        fit: BoxFit.fitHeight)),
              ),
              const SizedBox(
                height: 15,
              ),
              OthersHelper().showLoading(ConstantColors().primaryColor)
            ],
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ));
  }
}
