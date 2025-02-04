import 'package:flutter/material.dart';

class GlucoseManagementScreen extends StatelessWidget {
  const GlucoseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manejo de Glucosa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Monitoreo de Glucosa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/images/educacion/descarga (1).jpeg'), // Agrega una imagen
            const SizedBox(height: 10),
            const Text(
              'El monitoreo de glucosa en sangre es fundamental para las personas con diabetes. '
                  'Es importante medir los niveles de glucosa regularmente para asegurarse de que estén '
                  'dentro del rango objetivo. Los dispositivos de monitoreo continuo de glucosa pueden ser '
                  'útiles para algunas personas.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Control de la Dieta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Seguir una dieta equilibrada y saludable es esencial para el manejo de la glucosa. '
                  'Es recomendable comer alimentos ricos en fibra y bajos en carbohidratos refinados. '
                  'Trabajar con un nutricionista puede ayudar a crear un plan de comidas adecuado.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Actividad Física',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'El ejercicio regular ayuda a controlar los niveles de glucosa en sangre. '
                  'Es importante encontrar una rutina de ejercicios que sea segura y efectiva. '
                  'Consultar con un médico antes de comenzar un nuevo programa de ejercicios es recomendable.',
            ),
          ],
        ),
      ),
    );
  }
}
