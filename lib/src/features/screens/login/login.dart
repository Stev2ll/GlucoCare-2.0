import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/common/styles/spacing_style.dart';
import 'package:gluco_care/src/features/screens/login/widgets/login_form.dart';
import 'package:gluco_care/src/features/screens/login/widgets/login_header.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/constants/image_strings.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuctions.isDarkMode(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // logo, title y subtitle
              TLoginHeader(dark: dark),
              // Form
              const TLoginForm(),
              // Divider
              TFormDivider(dark: dark),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              // FOOTER
              const TSocialButtons()
            ],
          ),
        ),
      ),
    );
  }
}












class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: TColors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        child: IconButton(
          onPressed: () {},
          icon: const Image(
            width: TSizes.iconMd,
            height: TSizes.iconMd,
            image: AssetImage(TImages.google),
          ),
        ),
      ),
    );
  }
}

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? TColors.darkGrey : TColors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5.0,
          ),
        ),
        Text(
          TTexts.orSignInwith.capitalize!,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        Flexible(
          child: Divider(
            color: dark ? TColors.darkGrey : TColors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        )
      ],
    );
  }
}
