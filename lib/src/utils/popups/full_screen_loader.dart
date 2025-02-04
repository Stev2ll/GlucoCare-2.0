import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/common/widgets/loaders/animation_loader.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/theme/custom_themes/help_functions.dart';
//import '../../common/widgets/loaders/animation_loader.dart';


/// Una clase de utilidad para gestionar un diálogo de carga a pantalla completa.
class TFullScreenLoader {
  /// Abre un diálogo de carga a pantalla completa con un texto y animación dados.
  /// Este método no retorna nada.
  ///
  /// Parámetros:
  /// - text: El texto que se mostrará en el diálogo de carga.
  /// - animation: La animación Lottie que se mostrará.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!, // Utiliza Get.overlayContext para diálogos superpuestos
      barrierDismissible: false, // El diálogo no se puede cerrar tocando fuera de él
      builder: (_) => PopScope(
        canPop: false, // Desactiva el retroceso con el botón de atrás
        child: Container(
          color: THelperFuctions.isDarkMode(Get.context!)
              ? TColors.dark
              : TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250), // Ajusta el espacio según sea necesario
              TAnimationLoaderWidget(text: text, animation: animation),
            ],
          ), // Column
        ), // Container
      ),
    );
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}
