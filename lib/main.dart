import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gluco_care/app.dart';
import 'package:gluco_care/firebase_options.dart';
import 'package:gluco_care/src/autentication/authentication.dart';

Future<void> main() async {
   //Widget Vinculante
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  //Get almacenamiento local
  await GetStorage.init();

  //Esperar el splash nativo
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //Inicia FireBase y Autenticación
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((FirebaseApp value) => Get.put(AuthenticationRepository())); 

  //iniciacion de aplicacion
  runApp(const MyApp());
}
