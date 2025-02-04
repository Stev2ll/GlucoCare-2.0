import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/signup/widgets/form_create.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(children: [
            //Title
            Text(
              TTexts.signupTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
            FormCreate(dark: dark),
            const SizedBox(
              height: TSizes.spaceBtwSections,
            ),
          ]),
        ),
      ),
    );
  }
}
