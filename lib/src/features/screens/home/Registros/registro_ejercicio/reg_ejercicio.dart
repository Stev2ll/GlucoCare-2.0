import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gluco_care/src/features/screens/home/Registros/registro_ejercicio/widgets/autocomplete.dart';
import 'package:intl/intl.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityLogScreenState createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _intensityController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  late double _caloriesBurned = 0.0;
  String? _selectedActivity;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _durationController.dispose();
    _intensityController.dispose();
    super.dispose();
  }

  // Función para imprimir datos de depuración
  void _debugPrintUserData(Map<String, dynamic>? userData) {
    if (userData == null) {
      debugPrint('User data is null');
    } else {
      debugPrint('User data: $userData');
    }
  }

  Future<void> _saveActivity() async {
    if (_formKey.currentState!.validate()) {
      final duration = int.parse(_durationController.text);
      final intensity = int.parse(_intensityController.text);

      // Obtener altura, peso y género del usuario desde Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user!.uid)
          .get();
      final userData = userDoc.data();

      // Imprimir datos de usuario para depuración
      _debugPrintUserData(userData);
      if (userData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron datos del usuario')),
        );
        return;
      }

      final peso = userData['peso'] is String
          ? double.tryParse(userData['peso'])
          : userData['peso'];
      final genero = userData['genero'];

      // Calcular las calorías quemadas usando fórmula de Harris-Benedict
      double bmr;
      if (genero == 'Masculino') {
        bmr = (66 + (6.3 * peso) + (12.9 * 170) - (6.8 * 30)); // Asume una edad promedio
      } else {
        bmr = (655 + (4.3 * peso) + (4.7 * 170) - (4.7 * 30)); // Asume una edad promedio
      }
      _caloriesBurned = double.parse(
          (bmr / 24 * duration * intensity * 0.0175).toStringAsFixed(3));

      setState(() {});
    }
    if (_formKey.currentState!.validate()) {
      if (_selectedActivity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona una actividad')),
        );
        return;
      }

      final duration = int.parse(_durationController.text);
      final intensity = int.parse(_intensityController.text);
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      await FirebaseFirestore.instance.collection('regActividadFisica').add({
        'idUsuario': user!.uid,
        'actividad': _selectedActivity,
        'duracion': duration,
        'intensidad': intensity,
        'caloriasQuemadas': _caloriesBurned,
        'fechaRegistro': formattedDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actividad física guardada')),
      );

      _durationController.clear();
      _intensityController.clear();
      _caloriesBurned = 0.0;
      _selectedActivity = null;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Actividad Física'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monitorea tus calorías quemadas.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registra el deporte realizado.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    AutocompleteBasicExample(
                      onSelected: (activity) {
                        setState(() {
                          _selectedActivity = activity;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Registra el tiempo realizado.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duración (minutos)',
                        border: OutlineInputBorder(),
                        hintText: 'Ej: 60',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la duración';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Registra la intensidad realizada (1 min - 3 max).',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _intensityController,
                      decoration: const InputDecoration(
                        labelText: 'Intensidad (nivel)',
                        border: OutlineInputBorder(),
                        hintText: 'Ej: 1 al 3',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa la intensidad';
                        }
                        final int? intensity = int.tryParse(value);
                        if (intensity == null) {
                          return 'Ingresa un número válido';
                        }
                        if (intensity < 1 || intensity > 3) {
                          return 'La intensidad debe estar entre 1 y 3';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.all(16.0))),
                      onPressed: () {
                        _saveActivity();
                      },
                      child: const Text('Guardar'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Historial',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: 300, // Ajusta la altura según sea necesario
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('regActividadFisica')
                            .where('idUsuario', isEqualTo: user?.uid)
                            .orderBy('fechaRegistro', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No hay actividades registradas.'),
                            );
                          }
                          final activities = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: activities.length,
                            itemBuilder: (context, index) {
                              final activity = activities[index];
                              final activityType = activity['actividad'];
                              final duration = activity['duracion'];
                              final intensity = activity['intensidad'];
                              final calories = activity['caloriasQuemadas'];
                              final date = activity['fechaRegistro'];
                              return ListTile(
                                title: Text('$activityType'),
                                subtitle: Text(
                                    '$duration min, Intensidad $intensity'),
                                trailing: Text('$calories cal\n$date'),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
