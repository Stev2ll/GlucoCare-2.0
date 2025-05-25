import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gluco_care/src/features/screens/home/Registros/registro_ejercicio/widgets/autocomplete.dart';
import 'package:gluco_care/src/features/screens/home/Registros/registro_ejercicio/widgets/met_activities.dart';
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
  final User? user = FirebaseAuth.instance.currentUser;
  late double _caloriesBurned = 0.0;
  String? _selectedActivity;
  String interpretacion = '';

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  // Función para calcular edad en años a partir de fecha de nacimiento
  int calcularEdad(DateTime fechaNacimiento) {
    final now = DateTime.now();
    int edad = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // Interpretación clínica con rango etario
  String interpretarActividad(double met, int duracion, double calorias, int edad) {
    String nivelActividad;
    if (met < 3 && duracion < 30 && calorias < 100) {
      nivelActividad = 'Actividad ligera';
    } else if ((met >= 3 && met < 6) || (duracion >= 30 && duracion < 60) || (calorias >= 100 && calorias < 300)) {
      nivelActividad = 'Actividad moderada';
    } else {
      nivelActividad = 'Actividad intensa';
    }

    if (edad < 18) {
      return '$nivelActividad (niños): excelente para desarrollo y salud.';
    } else if (edad >= 18 && edad <= 60) {
      return '$nivelActividad (adultos): contribuye a mantener buena salud cardiovascular.';
    } else {
      return '$nivelActividad (adultos mayores): importante para movilidad y bienestar.';
    }
  }

  Future<void> _saveActivity() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una actividad')),
      );
      return;
    }

    final userDoc = await FirebaseFirestore.instance.collection('usuarios').doc(user!.uid).get();
    final userData = userDoc.data();

    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se encontraron datos del usuario')),
      );
      return;
    }

    final peso = userData['peso'] is String ? double.tryParse(userData['peso']) : userData['peso'];
    if (peso == null || peso <= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peso del usuario inválido para cálculo')),
      );
      return;
    }

    // Leer y calcular edad
    DateTime? fechaNacimiento;
    if (userData['fechaNacimiento'] != null) {
      try {
        fechaNacimiento = DateFormat('yyyy-MM-dd').parse(userData['fechaNacimiento']);
      } catch (e) {
        // Si falla el parseo, se ignora y edad será 30 por defecto
      }
    }
    final edad = fechaNacimiento != null ? calcularEdad(fechaNacimiento) : 30; // Edad por defecto si no está

    final duration = int.tryParse(_durationController.text) ?? 0;
    if (duration <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Duración debe ser mayor que 0')),
      );
      return;
    }

    final met = metValues[_selectedActivity!] ?? 1.0;

    // Factor de ajuste según edad
    double factorEdad = 1.0;
    if (edad < 18) {
      factorEdad = 0.9;
    } else if (edad > 60) {
      factorEdad = 0.85;
    }

    _caloriesBurned = double.parse(((met * peso * duration / 60) * factorEdad).toStringAsFixed(2));

    interpretacion = interpretarActividad(met, duration, _caloriesBurned, edad);

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    await FirebaseFirestore.instance.collection('regActividadFisica').add({
      'idUsuario': user!.uid,
      'actividad': _selectedActivity,
      'duracion': duration,
      'caloriasQuemadas': _caloriesBurned,
      'fechaRegistro': formattedDate,
      'interpretacion': interpretacion,
      'edad': edad,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Actividad física guardada')),
    );

    // Limpieza y actualización UI en un solo setState
    setState(() {
      _durationController.clear();
      _caloriesBurned = 0.0;
      _selectedActivity = null;
      interpretacion = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Actividad Física'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monitorea tus calorías quemadas.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Actividad física',
                child: AutocompleteBasicExample(
                  onSelected: (activity) {
                    setState(() {
                      _selectedActivity = activity;
                    });
                  },
                  options: metActivitiesList,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                label: 'Duración en minutos',
                child: TextFormField(
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
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveActivity,
                child: const Text('Guardar'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Historial',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('regActividadFisica')
                      .where('idUsuario', isEqualTo: user?.uid)
                      .orderBy('fechaRegistro', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No hay actividades registradas.'),
                      );
                    }
                    final activities = snapshot.data!.docs;
                    return ListView.builder(
  itemCount: activities.length,
  itemBuilder: (context, index) {
    final activity = activities[index];
    final docId = activity.id;
    return ListTile(
      title: Text(activity['actividad']),
      subtitle: Text(
        '${activity['duracion']} min | ${activity['interpretacion']}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${activity['caloriasQuemadas']} cal\n${activity['fechaRegistro']}',
            textAlign: TextAlign.right,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: 'Eliminar registro',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar eliminación'),
                  content: const Text('¿Deseas eliminar este registro?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('regActividadFisica')
                            .doc(docId)
                            .delete();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registro eliminado')),
                        );
                      },
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  },
);

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
