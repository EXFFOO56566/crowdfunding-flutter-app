import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fundorex/view/utils/constant_colors.dart';

class SingleMenuItem extends StatelessWidget {
  const SingleMenuItem({
    Key? key,
    required this.cc,
    required this.iconSvg,
    required this.title,
  }) : super(key: key);

  final ConstantColors cc;
  final iconSvg;
  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 19),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Row(
          children: [
            SvgPicture.asset(iconSvg),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
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
        ));
  }
}
