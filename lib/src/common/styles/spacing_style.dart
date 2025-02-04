import 'package:flutter/material.dart';
import 'package:gluco_care/src/utils/constants/sizes.dart';

// Clase que define estilos de espaciado (padding)
class TSpacingStyle {
  // Define el espaciado con la altura del AppBar
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: TSizes
        .appBarHeight, // Espacio en la parte superior igual a la altura del AppBar
    left: TSizes
        .defaultSpace, // Espacio a la izquierda igual al espacio por defecto
    bottom: TSizes
        .defaultSpace, // Espacio en la parte inferior igual al espacio por defecto
    right: TSizes
        .defaultSpace, // Espacio a la derecha igual al espacio por defecto
  );
}
