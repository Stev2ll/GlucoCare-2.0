import 'package:flutter/material.dart';

class IntroductionToDiabetesScreen extends StatelessWidget {
  const IntroductionToDiabetesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introducción a la Diabetes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Causas de la Diabetes Tipo 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/educacion/diabetestipo1.png'), // Agrega una imagen
            const Text(
              'La diabetes tipo 1 es una enfermedad autoinmune en la que el sistema '
                  'inmunológico ataca y destruye las células productoras de insulina en el páncreas. '
                  'Las causas exactas de este proceso autoinmune no se conocen completamente, pero se cree '
                  'que factores genéticos y ambientales, como infecciones virales, pueden desempeñar un papel.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Tratamiento de la Diabetes Tipo 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/images/educacion/descarga.jpeg'), // Agrega una imagen
            const SizedBox(height: 10),
            const Text(
              'El tratamiento principal para la diabetes tipo 1 es la administración de insulina. '
                  'Los pacientes deben monitorear sus niveles de glucosa en sangre regularmente y ajustar '
                  'su dosis de insulina en consecuencia. También es importante seguir una dieta saludable y '
                  'realizar ejercicio regularmente para ayudar a controlar los niveles de azúcar en la sangre.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Aspectos Importantes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/images/educacion/control-diabetes-1.png'), // Agrega una imagen
            const SizedBox(height: 10),
            const Text(
              '1. Monitoreo constante: Es crucial para los pacientes con diabetes tipo 1 controlar sus niveles '
                  'de glucosa en sangre varias veces al día.\n'
                  '2. Educación: Los pacientes y sus familias deben estar bien informados sobre cómo manejar la enfermedad.\n'
                  '3. Apoyo: Contar con un buen sistema de apoyo, incluyendo médicos, nutricionistas y grupos de apoyo, '
                  'puede hacer una gran diferencia en la vida de un paciente.\n'
                  '4. Alimentacion: Es importante aprender a contar la cantidad de carbohidratos en los alimentos para ajustar la dosis de insulina y permitir que el cuerpo utilice los carbohidratos de manera adecuada.\n'
                  '5. Actividad Fisica: La actividad física es esencial en la prevención y tratamiento de la diabetes mellitus (DM). Estudios prospectivos en pacientes de alto riesgo han concluido que la actividad física regular se asocia a menor riesgo de progresión ',
            ),
          ],
        ),
      ),
    );
  }
}
