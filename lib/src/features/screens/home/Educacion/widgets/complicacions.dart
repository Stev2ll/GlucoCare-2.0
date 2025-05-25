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
            _buildSection(
              context,
              title: 'Complicaciones de la Diabetes Tipo 1',
              imagePath: 'assets/images/educacion/complicaciones.jpg',
              imageLabel: 'Diagrama ilustrativo de complicaciones de la diabetes tipo 1',
              content: [
                const TextSpan(
                  text:
                      'La diabetes tipo 1 puede generar complicaciones tanto a corto como a largo plazo si no se mantiene un buen control glucémico. '
                      'Estas complicaciones afectan diversos órganos y sistemas. El monitoreo constante, el uso adecuado de insulina, la alimentación equilibrada y la actividad física regular son fundamentales para prevenirlas.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Complicaciones Crónicas',
              imagePath: '',
              imageLabel: '',
              content: [
                _boldSpan('1. Retinopatía diabética:'),
                const TextSpan(
                  text:
                      ' Daño progresivo en los vasos sanguíneos de la retina. Puede causar visión borrosa, hemorragias vítreas e incluso ceguera si no se detecta y trata a tiempo.\n\n',
                ),
                _boldSpan('2. Nefropatía diabética:'),
                const TextSpan(
                  text:
                      ' Afecta a los riñones, reduciendo su capacidad de filtrar desechos. El control de la presión arterial y los niveles de glucosa es esencial para prevenirla.\n\n',
                ),
                _boldSpan('3. Neuropatía diabética:'),
                const TextSpan(
                  text:
                      ' El daño a los nervios periféricos puede provocar dolor, hormigueo, debilidad o pérdida de sensibilidad, especialmente en pies y manos. Aumenta el riesgo de úlceras y amputaciones.\n\n',
                ),
                _boldSpan('4. Complicaciones cardiovasculares:'),
                const TextSpan(
                  text:
                      ' Las personas con diabetes tipo 1 tienen un mayor riesgo de hipertensión, enfermedad coronaria, infarto y accidente cerebrovascular. Mantener el colesterol y la presión arterial bajo control es clave.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Complicaciones Agudas',
              imagePath: '',
              imageLabel: '',
              content: [
                _boldSpan('1. Hipoglucemia:'),
                const TextSpan(
                  text:
                      ' Ocurre cuando la glucosa en sangre cae por debajo de 70 mg/dL. Puede manifestarse con sudoración, palpitaciones, temblores, confusión o pérdida de conciencia. Es crucial actuar de inmediato con azúcar de absorción rápida.\n\n',
                ),
                _boldSpan('2. Cetoacidosis diabética (CAD):'),
                const TextSpan(
                  text:
                      ' Se produce por la falta de insulina y acumulación de cuerpos cetónicos. Es una emergencia médica que requiere atención inmediata. Los síntomas incluyen sed intensa, náuseas, aliento afrutado y respiración rápida.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Prevención y Detección Temprana',
              imagePath: '',
              imageLabel: '',
              content: [
                const TextSpan(
                  text:
                      'La clave para evitar complicaciones está en la prevención. Realizar controles regulares con el equipo médico, exámenes oftalmológicos anuales, pruebas de función renal y evaluación neurológica son esenciales. '
                      'La educación en el autocuidado y el seguimiento personalizado ayudan a identificar señales tempranas de complicaciones, facilitando un tratamiento oportuno y efectivo.',
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String imagePath,
    required String imageLabel,
    required List<InlineSpan> content,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ignore: deprecated_member_use
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
          ),
          const SizedBox(height: 10),
          if (imagePath.isNotEmpty)
            Center(
              child: Image.asset(
                imagePath,
                semanticLabel: imageLabel,
              ),
            ),
          const SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: content,
            // ignore: deprecated_member_use
            ), textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor),
          ),
        ],
      ),
    );
  }

  TextSpan _boldSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
