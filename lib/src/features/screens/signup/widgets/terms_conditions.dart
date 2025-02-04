import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/signup_controller.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';

class TTermsConditions extends StatelessWidget {
  const TTermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = THelperFuctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Checkbox(
                value: controller.privaPolitic.value,
                onChanged: (value) => controller.privaPolitic.value = !controller.privaPolitic.value
              )),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Text.rich(TextSpan(children: [
          TextSpan(
            text: '${TTexts.iAgreeTo} ',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextSpan(
            text: '${TTexts.privacyPolicy} ',
            style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark ? TColors.white : TColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark ? TColors.white : TColors.primary,
                ),
          ),
          TextSpan(
              text: '${TTexts.and} ',
              style: Theme.of(context).textTheme.bodySmall),
          TextSpan(
              text: TTexts.termsofUse,
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: dark ? TColors.white : TColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? TColors.white : TColors.primary,
                  ))
        ]))
      ],
    );
  }
}
