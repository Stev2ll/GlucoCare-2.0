import 'package:flutter/material.dart';

class IntroductionToDiabetesScreen extends StatelessWidget {
  const IntroductionToDiabetesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Introducción a la Diabetes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            context,
            title: 'Causas de la Diabetes Tipo 1',
            image: 'assets/images/educacion/diabetestipo1.png',
            semanticImageLabel:
                'Ilustración del páncreas afectado por la diabetes tipo 1',
            content:
                'La diabetes tipo 1 es una enfermedad autoinmune crónica que suele desarrollarse en la infancia o adolescencia, '
                'aunque también puede aparecer en adultos. En esta condición, el sistema inmunológico ataca por error a las células '
                'beta del páncreas, responsables de producir insulina. Las causas exactas no se conocen completamente, pero se cree '
                'que una combinación de factores genéticos y desencadenantes ambientales, como ciertas infecciones virales, pueden '
                'provocar su aparición. A diferencia de la diabetes tipo 2, la diabetes tipo 1 no está relacionada con el estilo de vida '
                'ni se puede prevenir. Requiere tratamiento con insulina de por vida para mantener el equilibrio de glucosa en sangre.',
            textScale: textScale,
          ),
          const SizedBox(height: 20),
          _buildSection(
            context,
            title: 'Tratamiento de la Diabetes Tipo 1',
            image: 'assets/images/educacion/descarga.jpeg',
            semanticImageLabel: 'Persona aplicándose insulina',
            content:
                'El tratamiento principal es la administración de insulina. Se debe monitorear la glucosa regularmente '
                'y ajustar la dosis de insulina. Además, una dieta saludable y el ejercicio regular son claves para un buen manejo.',
            textScale: textScale,
          ),
          const SizedBox(height: 20),
          _buildImportantAspectsSection(textScale),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String image,
    required String semanticImageLabel,
    required String content,
    required double textScale,
  }) {
    return Semantics(
      container: true,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  // ignore: deprecated_member_use
                  textScaleFactor: textScale,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Semantics(
                  image: true,
                  label: semanticImageLabel,
                  child: Image.asset(image),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                content,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
                // ignore: deprecated_member_use
                textScaleFactor: textScale,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImportantAspectsSection(double textScale) {
    return Semantics(
      container: true,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aspectos Importantes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/images/educacion/control-diabetes-1.png',
                  semanticLabel: 'Iconos representando hábitos saludables',
                ),
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.justify,
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  children: [
                    TextSpan(
                        text: '1. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Monitoreo constante: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Controlar la glucosa varias veces al día.\n\n'),
                    TextSpan(
                        text: '2. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Educación: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Pacientes y familiares bien informados.\n\n'),
                    TextSpan(
                        text: '3. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Apoyo: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'Equipo de salud y grupos de apoyo son fundamentales.\n\n'),
                    TextSpan(
                        text: '4. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Alimentación: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'Contar carbohidratos para ajustar insulina.\n\n'),
                    TextSpan(
                        text: '5. ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'Actividad Física: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Reduce el riesgo y mejora el control.'),
                  ],
                ),
                textScaler: TextScaler.linear(textScale),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
