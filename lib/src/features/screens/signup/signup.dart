import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/signup/widgets/form_create.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuctions.isDarkMode(context);
    final FocusNode mainFormFocus = FocusNode();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('es', 'ES'), // 📌 Define el idioma
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // 📌 Permite cerrar el teclado al desplazar
          child: Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Botón oculto para "Saltar al contenido principal"
                const SizedBox(height: TSizes.spaceBtwSections),

                // 📌 Título con etiqueta de encabezado accesible
                Semantics(
                  header: true,
                  child: Text(
                    TTexts.signupTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                // 📌 Formulario con Semantics para mejor accesibilidad
                Semantics(
                  label: 'Formulario de Registro',
                  explicitChildNodes: true,
                  child: FormCreate(dark: dark, focusNode: mainFormFocus),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
