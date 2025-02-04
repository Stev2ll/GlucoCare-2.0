import 'package:flutter/material.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/introduccionDiabtes.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/manejoGlucosa.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/vidaSaludable.dart';
import 'package:gluco_care/src/features/screens/home/Educacion/widgets/videoyarticulos.dart';
import 'widgets/complicacions.dart';

class DiabetesEducationPage extends StatelessWidget {
  const DiabetesEducationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Educación sobre Diabetes',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ignore: deprecated_member_use
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
              const SizedBox(height: 8),
              Text(
                'Explora nuestros módulos educativos y recursos.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                // ignore: deprecated_member_use
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
              const SizedBox(height: 24),
              Text(
                'Módulos Educativos',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ignore: deprecated_member_use
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
              const SizedBox(height: 16),
              _buildModuleItem('Introducción a la Diabetes', context),
              _buildModuleItem('Manejo de Glucosa', context),
              _buildModuleItem('Complicaciones de la Diabetes', context),
              _buildModuleItem('Estilo de Vida Saludable', context),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VideosPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Ver Videos',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArticlesPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Leer Artículos',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
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

  Widget _buildModuleItem(String title, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
        // ignore: deprecated_member_use
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
      ),
      trailing: TextButton(
        onPressed: () {
          // Acción para abrir el módulo
          if (title == 'Introducción a la Diabetes') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IntroductionToDiabetesScreen(),
              ),
            );
          } else if (title == 'Manejo de Glucosa') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GlucoseManagementScreen(),
              ),
            );
          } else if (title == 'Complicaciones de la Diabetes') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DiabetesComplicationsScreen(),
              ),
            );
          } else if (title == 'Estilo de Vida Saludable') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HealthyLifestyleScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleDetailPage(title: title),
              ),
            );
          }
        },
        child: const Text(
          'Ver',
          style: TextStyle(fontSize: 16, color: Colors.green),
        ),
      ),
    );
  }
}

class ModuleDetailPage extends StatelessWidget {
  final String title;

  const ModuleDetailPage({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Contenido del módulo: $title',
          // ignore: deprecated_member_use
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }
}
