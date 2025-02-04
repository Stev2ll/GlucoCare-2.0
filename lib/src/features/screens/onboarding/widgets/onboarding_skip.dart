import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(
        onPressed: ()=> 
        OnBoardingController.instance.skipPage(),
        child: const Text(
          'Siguiente',
          style: TextStyle(
            fontSize: TSizes.fontSizeMd,
            fontWeight: FontWeight.bold
          ),
        ),
      )
    );
  }
}