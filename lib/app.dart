import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gluco_care/src/features/screens/onboarding/onboarging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:gluco_care/src/utils/theme/theme.dart';
// Asegúrate de que el camino sea correcto

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale(
          'es', 'ES'), // Español de España,
      supportedLocales: const [
        Locale('es', 'ES'), // Agrega otros idiomas si lo necesitas
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'GlucoCare App',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      // Indica un cargando para indicar que se está autenticando
      home:
          const OnBoardingScreen(), // Asegúrate de que el nombre del widget sea correcto
    );
  }
}
