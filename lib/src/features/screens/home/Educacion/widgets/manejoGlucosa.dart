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
            _buildSection(
              context,
              title: 'Monitoreo de Glucosa',
              imagePath: 'assets/images/educacion/glucosa.png',
              imageLabel: 'Persona usando medidor de glucosa',
              content:
                  'El monitoreo de glucosa en sangre es fundamental para las personas con diabetes tipo 1. '
                  'Se recomienda revisar los niveles varias veces al día, especialmente antes y después de las comidas y al acostarse. '
                  'El rango objetivo habitual en ayunas está entre 80 y 130 mg/dL, aunque puede variar según indicaciones médicas. '
                  'Detectar a tiempo hipoglucemias (glucosa baja) o hiperglucemias (glucosa alta) previene complicaciones. '
                  'Dispositivos como los glucómetros o monitores continuos de glucosa (MCG) permiten un control más preciso. '
                  'El uso de MCG permite observar tendencias y configurar alertas para mayor seguridad, especialmente durante la noche. '
                  'Registrar estos valores permite al equipo médico ajustar el tratamiento con mayor precisión.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Control de la Dieta',
              imagePath: 'assets/images/educacion/dieta.jpg', // Espacio reservado para futura imagen
              imageLabel: '',
              content:
                  'Seguir una alimentación saludable es esencial. El conteo de carbohidratos permite ajustar la insulina según la comida. '
                  'Prefiere alimentos con bajo índice glucémico, ricos en fibra (verduras, legumbres, cereales integrales) y evita azúcares simples. '
                  'Comer a horarios regulares ayuda a mantener niveles estables de glucosa. '
                  'Consultar a un nutricionista especializado es clave para un plan alimenticio individualizado. '
                  'También es importante aprender la relación insulina-carbohidrato (IC) y el uso del factor de corrección, para calcular dosis precisas de insulina.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Actividad Física',
              imagePath: 'assets/images/educacion/ejercicio.jpg', // Espacio reservado para futura imagen
              imageLabel: '',
              content:
                  'El ejercicio mejora la sensibilidad a la insulina y regula la glucosa. '
                  'Se recomienda realizar al menos 30 minutos de actividad física moderada casi todos los días. '
                  'Antes del ejercicio, mide la glucosa y ten a mano una colación si está baja. '
                  'El ejercicio no solo regula el azúcar, también reduce el estrés y mejora el ánimo. '
                  'El tipo de ejercicio también influye: el aeróbico tiende a bajar la glucosa, mientras que el anaeróbico puede elevarla brevemente. '
                  'La planificación individualizada es clave para evitar descompensaciones durante o después del esfuerzo físico.',
            ),
            const SizedBox(height: 20),

            _buildSection(
              context,
              title: 'Educación y Apoyo',
              imagePath: '', // Espacio reservado para futura imagen
              imageLabel: '',
              content:
                  'Contar con información actualizada y apoyo emocional es clave para un buen manejo de la diabetes tipo 1. '
                  'La educación continua empodera al paciente a tomar decisiones acertadas. '
                  'Participar en talleres, consultar a profesionales capacitados y apoyarse en familiares o grupos de apoyo puede marcar una gran diferencia.',
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
    required String content,
    required String imagePath,
    required String imageLabel,
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
          Text(
            content,
            textAlign: TextAlign.justify,
            // ignore: deprecated_member_use
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
