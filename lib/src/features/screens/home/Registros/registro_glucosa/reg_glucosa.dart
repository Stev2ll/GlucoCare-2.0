import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlucoseLogScreen extends StatefulWidget {
  const GlucoseLogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GlucoseLogScreenState createState() => _GlucoseLogScreenState();
}

class _GlucoseLogScreenState extends State<GlucoseLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _glucoseController = TextEditingController();
  final User? user =
      FirebaseAuth.instance.currentUser; // Obtén el usuario autenticado

  Future<void> _saveGlucoseLevel() async {
    if (_formKey.currentState!.validate()) {
      final glucoseLevel = int.parse(_glucoseController.text);
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      if (user != null) {
        await FirebaseFirestore.instance.collection('regGlucosa').add({
          'idUsuario': user!.uid, // Guarda el uid del usuario
          'nivelGlucosa': glucoseLevel,
          'fechaRegistro': formattedDate,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nivel de glucosa guardado')));
        _glucoseController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Glucosa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingresa tu nivel de glucosa.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _glucoseController,
                    decoration: const InputDecoration(
                      labelText: 'Nivel de Glucosa mg/dL',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.monitor),
                      hintText: 'Ej: 120',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa un nivel de glucosa';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.all(16.0))),
                    onPressed: _saveGlucoseLevel,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Historial',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('regGlucosa')
                    .where('idUsuario',
                        isEqualTo: user?.uid) // Filtra por uid del usuario
                    .orderBy('fechaRegistro', descending: true) // Ordenar por fecha
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No hay dosis registradas.'));
                  }
                  final glucoseLevels = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: glucoseLevels.length,
                    itemBuilder: (context, index) {
                      final glucose = glucoseLevels[index];
                      final glucoseLevel = glucose['nivelGlucosa'];
                      final dateValue = glucose['fechaRegistro'];
                      
                      return ListTile(
                        title: Text('Nivel de Glucosa: $glucoseLevel mg/dL'),
                        subtitle: Text(dateValue),
                        trailing: const Icon(Icons.show_chart),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String value;
  final String date;

  const HistoryItem({super.key, required this.value, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(value),
      subtitle: Text(date),
      trailing: const Icon(Icons.show_chart),
    );
  }
}
