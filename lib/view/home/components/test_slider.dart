import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:provider/provider.dart';

import '../../utils/constant_colors.dart';

class TestSlider extends StatelessWidget {
  const TestSlider({
    Key? key,
    required this.cc,
  }) : super(key: key);

  final ConstantColors cc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: 3,
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: false,
          viewportFraction: 0.9,
          aspectRatio: 2.0,
          initialPage: 1,
        ),
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://images.unsplash.com/photo-1610505466122-b1d9482901ef?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjQxfHxzb2xpZHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Consumer<RtlService>(
              builder: (context, rtlP, child) => Positioned(
                  left: rtlP.direction == 'ltr' ? 25 : 0,
                  right: rtlP.direction == 'ltr' ? 0 : 25,
                  top: 20,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        // Text(
                        //   "Raise Money",
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: TextStyle(
                        //       color: cc.greyFour,
                        //       fontSize: 21,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        // const SizedBox(
                        //   height: 7,
                        // ),
                        // Text(
                        //   'Add campaign to raise money for special cause',
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: TextStyle(
                        //     color: cc.greyFour,
                        //     fontSize: 14,
                        //   ),
                        // ),
                        SizedBox(
                          height: 7,
                        ),
                        // ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //         primary: cc.greyFour, elevation: 0),
                        //     onPressed: () {},
                        //     child: const Text('Get now'))
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
