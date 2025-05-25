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
            _buildSection(
              context,
              title: 'Estilo de Vida Saludable para la Diabetes Tipo 1',
              imagePath: 'assets/images/educacion/642ea9fd7efc7.png',
              imageLabel: 'Ilustración sobre hábitos saludables en diabetes tipo 1',
              content: [
                const TextSpan(
                  text:
                      'Adoptar un estilo de vida saludable es fundamental para las personas con diabetes tipo 1. '
                      'Esto incluye mantener una alimentación balanceada, actividad física regular, monitoreo continuo de la glucosa y seguir las indicaciones médicas personalizadas.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Alimentación Saludable',
              imagePath: '',
              imageLabel: '',
              content: [
                _boldSpan('1. Consumir alimentos variados y nutritivos: '),
                const TextSpan(
                  text: 'frutas, vegetales, proteínas magras y granos integrales.\n\n',
                ),
                _boldSpan('2. Evitar azúcares y carbohidratos refinados: '),
                const TextSpan(
                  text: 'reducir productos ultraprocesados y bebidas azucaradas.\n\n',
                ),
                _boldSpan('3. Controlar las porciones: '),
                const TextSpan(
                  text: 'esto ayuda a mantener un peso saludable y niveles estables de glucosa en sangre.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Actividad Física',
              imagePath: '',
              imageLabel: '',
              content: [
                _boldSpan('1. Al menos 150 minutos semanales de actividad física moderada: '),
                const TextSpan(
                  text: 'como caminar, nadar o andar en bicicleta.\n\n',
                ),
                _boldSpan('2. Incluir ejercicios de resistencia: '),
                const TextSpan(
                  text: 'para fortalecer los músculos y mejorar la sensibilidad a la insulina.\n\n',
                ),
                _boldSpan('3. Monitorear glucosa antes y después del ejercicio: '),
                const TextSpan(
                  text: 'especialmente si se utiliza insulina o medicamentos hipoglucemiantes.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Monitoreo y Control',
              imagePath: '',
              imageLabel: '',
              content: [
                _boldSpan('1. Control regular de la glucosa: '),
                const TextSpan(
                  text: 'y ajustes de insulina o alimentación según resultados.\n\n',
                ),
                _boldSpan('2. Consultas médicas periódicas: '),
                const TextSpan(
                  text: 'para evaluar el tratamiento y detectar complicaciones tempranas.\n\n',
                ),
                _boldSpan('3. Llevar registros diarios: '),
                const TextSpan(
                  text: 'de glucosa, comidas y ejercicio para identificar patrones y facilitar decisiones clínicas.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Infórmese Sobre Sus Niveles',
              imagePath: '',
              imageLabel: '',
              content: [
                _boldSpan('1. Consulte con su médico: '),
                const TextSpan(
                  text:
                      'para saber qué rangos de glucosa son seguros antes de ejercitarse.\n\n',
                ),
                _boldSpan('2. Mida la glucosa antes, durante y después del ejercicio: '),
                const TextSpan(
                  text:
                      'especialmente si usa insulina u otros medicamentos.\n\n',
                ),
                _boldSpan('3. Ajuste su dosis de insulina si es necesario: '),
                const TextSpan(
                  text:
                      'en caso de actividad intensa, puede requerirse una reducción preventiva.',
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
