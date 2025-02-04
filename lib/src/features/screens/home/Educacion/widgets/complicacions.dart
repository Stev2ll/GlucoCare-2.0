import 'package:flutter/material.dart';

class DiabetesComplicationsScreen extends StatelessWidget {
  const DiabetesComplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complicaciones de la Diabetes Tipo 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Complicaciones de la Diabetes Tipo 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/images/educacion/complicaciones.jpg'), // Agrega una imagen
            const SizedBox(height: 10),
            const Text(
              'Las complicaciones de la diabetes tipo 1 pueden afectar a muchas partes del cuerpo. '
                  'Es importante controlar los niveles de glucosa en sangre y seguir las recomendaciones '
                  'médicas para minimizar el riesgo de complicaciones. Aquí hay algunas complicaciones comunes:',
            ),
            const SizedBox(height: 20),
            const Text(
              'Complicaciones a Largo Plazo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Problemas oculares: La diabetes puede causar daño a los vasos sanguíneos de la retina, '
                  'lo que lleva a la retinopatía diabética. También puede aumentar el riesgo de otras afecciones oculares '
                  'como cataratas y glaucoma.',
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Nefropatía diabética: El daño a los riñones puede resultar en insuficiencia renal o enfermedad renal crónica.',
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Neuropatía diabética: El daño a los nervios periféricos puede causar dolor, entumecimiento o debilidad en las extremidades.',
            ),
            const SizedBox(height: 10),
            const Text(
              '4. Enfermedades cardiovasculares: Las personas con diabetes tienen un mayor riesgo de enfermedades del corazón, '
                  'incluidos ataques cardíacos y accidentes cerebrovasculares.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Complicaciones Agudas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Hipoglucemia: Niveles de glucosa en sangre extremadamente bajos que pueden causar pérdida de conciencia si no se tratan rápidamente.',
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Cetoacidosis diabética: Una condición grave causada por la falta de insulina, que puede llevar a un estado de coma o incluso la muerte si no se trata.',
            ),
          ],
        ),
      ),
    );
  }
}
