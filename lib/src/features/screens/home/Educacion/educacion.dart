import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/introduccionDiabtes.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/manejoGlucosa.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/vidaSaludable.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/videoyarticulos.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/complicacions.dart';

class DiabetesEducationPage extends StatelessWidget {
  const DiabetesEducationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false, // Esto quita la flecha de regreso
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                label:
                    'Educación sobre Diabetes. Explora módulos y recursos educativos.',
                child: Text(
                  'Educación sobre Diabetes',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  // ignore: deprecated_member_use
                  textScaleFactor: textScale,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explora nuestros módulos educativos y recursos.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                // ignore: deprecated_member_use
                textScaleFactor: textScale,
              ),
              const SizedBox(height: 24),
              Text(
                'Módulos Educativos',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ignore: deprecated_member_use
                textScaleFactor: textScale,
              ),
              const SizedBox(height: 16),
              _buildModuleItem(
                  'Introducción a la Diabetes', Icons.info, context),
              _buildModuleItem('Manejo de Glucosa', Icons.bloodtype, context),
              _buildModuleItem(
                  'Complicaciones de la Diabetes', Icons.warning, context),
              _buildModuleItem(
                  'Estilo de Vida Saludable', Icons.favorite, context),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    button: true,
                    label: 'Ver videos educativos',
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const VideosPage()));
                      },
                      child: const Text('Ver Videos',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: 'Leer artículos educativos',
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ArticlesPage()));
                      },
                      child: const Text('Leer Artículos',
                          style: TextStyle(fontSize: 16, color: Colors.blue)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleItem(String title, IconData icon, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Semantics(
          button: true,
          label: 'Abrir módulo $title',
          child: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => _navigateToModule(context, title),
          ),
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, String title) {
    Widget screen;
    switch (title) {
      case 'Introducción a la Diabetes':
        screen = const IntroductionToDiabetesScreen();
        break;
      case 'Manejo de Glucosa':
        screen = const GlucoseManagementScreen();
        break;
      case 'Complicaciones de la Diabetes':
        screen = const DiabetesComplicationsScreen();
        break;
      case 'Estilo de Vida Saludable':
        screen = const HealthyLifestyleScreen();
        break;
      default:
        screen = ModuleDetailPage(title: title);
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class ModuleDetailPage extends StatelessWidget {
  final String title;

  const ModuleDetailPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Contenido del módulo: $title',
          // ignore: deprecated_member_use
          textScaleFactor: textScale,
        ),
      ),
    );
  }
}
