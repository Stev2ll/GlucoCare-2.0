import 'package:flutter/material.dart';

class HealthyLifestyleScreen extends StatelessWidget {
  const HealthyLifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estilo de Vida Saludable'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Estilo de Vida Saludable para la Diabetes Tipo 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/images/educacion/642ea9fd7efc7.png'), // Agrega una imagen
            const SizedBox(height: 10),
            const Text(
              'Adoptar un estilo de vida saludable es crucial para las personas con diabetes tipo 1. '
                  'Esto incluye mantener una dieta equilibrada, realizar actividad física regularmente, '
                  'monitorear los niveles de glucosa en sangre, y seguir las recomendaciones médicas. '
                  'Aquí hay algunos consejos para un estilo de vida saludable:',
            ),
            const SizedBox(height: 20),
            const Text(
              'Alimentación Saludable',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Consumir una variedad de alimentos nutritivos, incluidos vegetales, frutas, proteínas magras y granos integrales.',
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Evitar el consumo excesivo de azúcares y carbohidratos refinados.',
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Controlar las porciones para mantener un peso saludable y evitar fluctuaciones en los niveles de glucosa.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Actividad Física',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Realizar al menos 150 minutos de actividad física moderada a la semana, como caminar, nadar o andar en bicicleta.',
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Incluir ejercicios de resistencia para fortalecer los músculos y mejorar la sensibilidad a la insulina.',
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Monitorear los niveles de glucosa antes y después de la actividad física para evitar hipoglucemias.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Monitoreo y Control',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Monitorear regularmente los niveles de glucosa en sangre y ajustar el tratamiento según sea necesario.',
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Asistir a consultas médicas regulares para evaluar el control de la diabetes y detectar posibles complicaciones tempranas.',
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Mantener un registro de los niveles de glucosa, la dieta y la actividad física para identificar patrones y realizar ajustes.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Informese sobre sus niveles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Hable con su medico sobre qué niveles de azúcar en sangre son adecuados para usted antes comenzar a ejercitarse.',
            ),
            const SizedBox(height: 10),
            const Text(
              '2.  Controle su ivel de azúcar en sangre sntes y despues de hacer ejercicio, y durante ese, en particular, si usas insulina u otros medicamntos.',
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Si usa insulina, esposible que deba reduir las dosis de insulina antes de realizar actividad física.',
            ),
          ],
        ),
      ),
    );
  }
}
