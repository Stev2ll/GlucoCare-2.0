import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/firebase_exceptions.dart';
import 'package:gluco_care/src/features/screens/login/login.dart';
import 'package:gluco_care/src/features/screens/onboarding/onboarging.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //variables
  final devicesStorange = GetStorage();
  final _auth = FirebaseAuth.instance;

  //llamado de main.dart en ejecucion de la app
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    //almacenamiento local
    if (kDebugMode) {
      print('=========== GET STORAGE AUTHENTICATION ============');
      print(devicesStorange.read('PrimerTiempo'));
    }
    devicesStorange.writeIfNull('PrimerTiempo', true);
    devicesStorange.read('PrimerTiempo') != true
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(const OnBoardingScreen());
  }

  /* ----------------------EMAIL Y CONTRAEÑA INICIAR SESION ----------------*/

  //EmailAutenticacion - SignIn


  //EmailAutenticacion - Registro
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try{
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch (e){
      throw TFirebaseAuthException(e.code).message;
    }on FirebaseException catch(e){
      throw TFirebaseAuthException(e.code).message;
    }on FormatException catch(_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code);
    }catch(e){
      throw 'Algo salio mal. Porfavor vuelva a intentar';
    }
  }

}
