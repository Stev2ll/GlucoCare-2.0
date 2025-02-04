import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:gluco_care/src/features/screens/onboarding/widgets/onboarding_navigation.dart';
import 'package:gluco_care/src/features/screens/onboarding/widgets/onboarding_next.dart';
import 'package:gluco_care/src/features/screens/onboarding/widgets/onboarding_page.dart';
import 'package:gluco_care/src/features/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:gluco_care/src/utils/constants/image_strings.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardinPage(
                image: TImages.onBoardingImage1,
                title: TTexts.onBoardingTitle1,
                subtitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardinPage(
                image: TImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subtitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardinPage(
                image: TImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subtitle: TTexts.onBoardingSubTitle3,
              ),
              // Add more pages here if needed
            ],
          ),
          // Skin Button
          const OnBoardingSkip(),
          // Dot Navigation SmoothPageIndicator
          const OnBoardingNavigation(),
          // Circular Button
          const OnBoardingNextButton()
        ],
      ),
    );
  }
}
