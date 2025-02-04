import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/features/screens/login/password_config/reset_password.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          /// Headings
          Text(TTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(TTexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.0), textAlign: TextAlign.justify,),
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Text field
          TextFormField(
            decoration: const InputDecoration(
                labelText: TTexts.email,
                prefixIcon: Icon(Iconsax.direct_right)),
          ), // TextFormField
          const SizedBox(height: TSizes.spaceBtwSections),

          /// Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => Get.off(() => const ResetPassword()),
                child: const Text(TTexts.submit)),
          ) // SizedBox
        ]), // Column
      ), // Padding
    );
  }
}
