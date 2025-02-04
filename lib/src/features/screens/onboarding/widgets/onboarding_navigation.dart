import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/device/device_utility.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingNavigation extends StatelessWidget {
  const OnBoardingNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuctions.isDarkMode(context);
    final controller = OnBoardingController.instance;


    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight()+25,
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect:  ExpandingDotsEffect(
          activeDotColor: dark ? TColors.light: TColors.black,
          dotHeight: 8,
        ),
      ),
    );
  }
}

