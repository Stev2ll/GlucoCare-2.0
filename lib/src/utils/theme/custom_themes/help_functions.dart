import 'package:flutter/material.dart'; // Importa el paquete principal de Flutter para usar widgets y otras utilidades.
import 'package:get/get.dart'; // Importa el paquete Get para usar funcionalidades como navegación y manejo del estado.

class THelperFuctions {
  // Método estático para navegar a otra pantalla.
  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      // Utiliza el Navigator para empujar una nueva ruta (pantalla) en la pila de navegación.
      context,
      MaterialPageRoute(
          builder: (_) =>
              screen), // Crea una nueva ruta MaterialPageRoute con la pantalla destino.
    );
  }

  // Método estático para verificar si el tema actual es oscuro.
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness ==
        Brightness.dark; // Retorna verdadero si el brillo del tema es oscuro.
  }

  // Método estático para obtener el tamaño de la pantalla.
  static Size screenSize() {
    return MediaQuery.of(Get.context!)
        .size; // Usa MediaQuery para obtener el tamaño de la pantalla a través del contexto de Get.
  }

  // Método estático para obtener la altura de la pantalla.
  static double screenHeight() {
    return MediaQuery.of(Get.context!)
        .size
        .height; // Usa MediaQuery para obtener la altura de la pantalla a través del contexto de Get.
  }

  // Método estático para obtener el ancho de la pantalla.
  static double screenWidth() {
    return MediaQuery.of(Get.context!)
        .size
        .width; // Usa MediaQuery para obtener el ancho de la pantalla a través del contexto de Get.
  }
}
