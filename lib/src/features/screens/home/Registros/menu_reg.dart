import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/home/Registros/registro_ejercicio/reg_ejercicio.dart';
import 'package:gluco_care/src/features/screens/home/Registros/registro_insulina/reg_insulina.dart';
import 'package:gluco_care/src/features/screens/home/registros/registro_alimentos/reg_alimentos.dart';
import 'package:gluco_care/src/features/screens/home/registros/registro_glucosa/reg_glucosa.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
  body: Padding(
    padding: const EdgeInsets.all(25.0),
    child: Center(
      child: GridView.count(
        shrinkWrap: true,            // Ajusta el GridView al tamaño del contenido
        physics: const NeverScrollableScrollPhysics(), // Desactiva scroll para evitar conflicto
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildMenuButton(
            context,
            icon: Icons.bloodtype,
            label: 'Registrar Glucosa',
            semanticLabel: 'Botón para registrar glucosa',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GlucoseLogScreen())),
          ),
          _buildMenuButton(
            context,
            icon: Icons.food_bank,
            label: 'Registrar Alimentos',
            semanticLabel: 'Botón para registrar alimentos',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodLogScreen())),
          ),
          _buildMenuButton(
            context,
            icon: Icons.fitness_center,
            label: 'Registrar Ejercicio',
            semanticLabel: 'Botón para registrar ejercicio',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityLogScreen())),
          ),
          _buildMenuButton(
            context,
            icon: Icons.medication,
            label: 'Administrar Insulina',
            semanticLabel: 'Botón para administrar insulina',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsulinAdministrationPage())),
          ),
        ],
      ),
    ),
  ),
);

  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String semanticLabel,
    required VoidCallback onPressed,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = isDarkTheme ? Colors.white : Colors.black;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 40, color: textColor),
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: textColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 60), // Tamaño mínimo táctil
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          shadowColor: Colors.black45,
        ),
      ),
    );
  }
}
