import 'package:flutter/material.dart';
import 'package:gluco_care/src/utils/constants/image_strings.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';


class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        Center(
          child: Image(
            height: 160.0,
            image: AssetImage(
              dark ? TImages.lightAppLogo : TImages.darkAppLogo,
            ),
          ),
        ),
        const SizedBox(height: TSizes.sm),
        // Título y subtítulo
    
        Text(
          TTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 24,
              ),
        ),
        const SizedBox(height: TSizes.sm),
        Text(
          TTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize:
                    16, // Ajusta el tamaño del subtítulo según sea necesario
              ),
        ),
      ],
    );
  }
}