import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart'; // Asegúrate de tener el paquete de iconsax importado

/// Clase que proporciona métodos para mostrar SnackBars de éxito y advertencia.
class TLoaders {
  /// Muestra una SnackBar de éxito.
  ///
  /// Parámetros:
  /// - title: El título de la SnackBar.
  /// - message: El mensaje de la SnackBar (opcional).
  /// - duration: La duración de la SnackBar en segundos (opcional, por defecto 3).
  static void successSnackBar(
      {required String title, String message = '', int duration = 3}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: TColors.primary,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10),
      icon: const Icon(Iconsax.check, color: Colors.white),
    );
  }

  /// Muestra una SnackBar de advertencia.
  ///
  /// Parámetros:
  /// - title: El título de la SnackBar.
  /// - message: El mensaje de la SnackBar (opcional).
  static void warningSnackBar({required String title, String message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: Colors.white),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title, 
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: TColors.white,)
      );
  }
}
