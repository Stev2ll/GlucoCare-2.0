import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gluco_care/src/autentication/authentication.dart';
import 'package:gluco_care/src/autentication/user_repository.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/network_manager.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/user_model.dart';
import 'package:gluco_care/src/utils/constants/image_strings.dart';
import 'package:gluco_care/src/utils/popups/full_screen_loader.dart';
import 'package:gluco_care/src/utils/popups/loander.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // Variables
  final contraoculta = true.obs; // Mostrar y ocultar contraseña
  final privaPolitic = true.obs; // Observa las políticas de aceptación
  final email = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final contrasena = TextEditingController();
  final fechanacimiento = TextEditingController();
  final genero = TextEditingController();
  final peso = TextEditingController();
  final altura = TextEditingController();
  final signupFormKey = GlobalKey<FormState>();

  // Registro
  void signup() async {
    try {
      // Inicia carga
      TFullScreenLoader.openLoadingDialog(
        'Estamos procesando tu información...',
        TImages.lightAppLogo,
      );

      // Chequeo de internet
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.warningSnackBar(title: 'Sin Conexión a Internet');
        return;
      }

      // Validación de datos
      if (!signupFormKey.currentState!.validate()) return;

      // Aceptación de términos
      if (!privaPolitic.value) {
        TLoaders.warningSnackBar(
          title: 'Aceptar Políticas de Privacidad',
          message: 'Para crear una cuenta, debes aceptar nuestros Términos de Uso y Políticas de Privacidad',
        );
        return;
      }

      // Registrar usuario en la base de datos y guardar datos
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        contrasena.text.trim(),
      );
 
      // Guardar autenticación del usuario
      final newUser = UserModel(
        id: userCredential.user!.uid,
        nombres: nombre.text.trim(),
        apellidos: apellido.text.trim(),
        email: email.text.trim(),
        contrasena: contrasena.text.trim(),
        fechanacimiento: fechanacimiento.text.trim(),
        genero: genero.text.trim(),
        peso: peso.text.trim(),
        altura: altura.text.trim(),
        fotperfil: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Muestra mensaje de éxito
      TLoaders.successSnackBar(
        title: 'Felicidades',
        message: '¡Tu cuenta se ha creado exitosamente! Verifica tu correo a continuación...',
      );


    } catch (e) {
      // Muestra el error genérico
      TLoaders.errorSnackBar(title: '¡Oh Rayos!', message: e.toString());
    } finally {
      // Remueve el cargando
      TFullScreenLoader.stopLoading();
    }
  }
}
