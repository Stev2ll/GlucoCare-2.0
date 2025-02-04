import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/device/device_utility.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';
import 'package:iconsax/iconsax.dart';


class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
  final dark = THelperFuctions.isDarkMode(context);
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: ()=>
          OnBoardingController.instance.nextPage(), 
        style: ElevatedButton.styleFrom(
          shape:const CircleBorder(),
          backgroundColor: dark ? TColors.primary : Colors.black
          ),
        child: const Icon(Iconsax.arrow_right_3)
        ),
    );
  }
}
