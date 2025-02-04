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
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Text(
                'Menú de Registros',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50), // Espacio entre el título y la cuadrícula
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2, // Número de columnas
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: [
                    MenuButton(
                      icon: Icons.bloodtype,
                      label: 'Registrar Glucosa',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GlucoseLogScreen(),
                          ),
                        );
                      },
                    ),
                    MenuButton(
                      icon: Icons.food_bank,
                      label: 'Registrar Alimentos',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FoodLogScreen(),
                          ),
                        );
                      },
                    ),
                    MenuButton(
                      icon: Icons.fitness_center,
                      label: 'Registrar Ejercicio',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ActivityLogScreen(),
                          ),
                        );
                      },
                    ),
                    MenuButton(
                      icon: Icons.medication,
                      label: 'Administrar Insulina',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InsulinAdministrationPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 40),
      label: Text(label, textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        foregroundColor: isDarkTheme ? Colors.white : Colors.black,
        backgroundColor: isDarkTheme ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        textStyle: const TextStyle(fontSize: 18),
      ),
    );
  }
}
