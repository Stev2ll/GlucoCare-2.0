import 'package:flutter/material.dart';

class OnBoardinPage extends StatelessWidget {
  const OnBoardinPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          height: 400.0,
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        const SizedBox(
            height: 20), // Add some space between the image and the text
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10), // Add some space between the texts
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}