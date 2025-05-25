import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlucoseLogScreen extends StatefulWidget {
  const GlucoseLogScreen({super.key});

  @override
  State<GlucoseLogScreen> createState() => _GlucoseLogScreenState();
}

class _GlucoseLogScreenState extends State<GlucoseLogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _glucoseController = TextEditingController();
  String _selectedContext = 'Ayunas';
  final User? user = FirebaseAuth.instance.currentUser;

  final List<String> _contexts = [
    'Ayunas',
    'Antes de comer',
    'Después de comer',
    'Antes de dormir',
    'Después de ejercicio',
    'Otros',
  ];

  Future<int> _getUserAge() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user!.uid)
        .get();

    final birthDateField = userDoc['fechaNacimiento'];
    DateTime birthDate = birthDateField is Timestamp
        ? birthDateField.toDate()
        : DateTime.parse(birthDateField);

    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Map<String, int> _getRecommendedRange(int age) {
    if (age <= 6) return {'min': 100, 'max': 180};
    if (age <= 13) return {'min': 90, 'max': 180};
    if (age <= 18) return {'min': 80, 'max': 180};
    return {'min': 80, 'max': 130};
  }

  Future<void> _saveGlucoseLevel() async {
    if (_formKey.currentState!.validate()) {
      final glucoseLevel = int.parse(_glucoseController.text);
      if (glucoseLevel < 20 || glucoseLevel > 600) {
        _showAlertDialog('Valor inválido', 'Ingresa un valor entre 20 y 600 mg/dL.');
        return;
      }

      final now = DateTime.now();

      if (user != null) {
        final age = await _getUserAge();
        final range = _getRecommendedRange(age);

        String status;
        if (glucoseLevel < range['min']!) {
          status = 'Por debajo del rango para tu edad';
        } else if (glucoseLevel > range['max']!) {
          status = 'Por encima del rango recomendado ⚠️';
        } else {
          status = 'Dentro del rango recomendado 🎯';
        }

        await FirebaseFirestore.instance.collection('regGlucosa').add({
          'idUsuario': user!.uid,
          'nivelGlucosa': glucoseLevel,
          'fechaRegistro': Timestamp.fromDate(now),
          'contexto': _selectedContext,
          'estado': status,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nivel de glucosa guardado. $status')),
        );
        _glucoseController.clear();
      }
    }
  }

  void _showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  Future<void> _confirmDelete(DocumentSnapshot doc) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Estás seguro de que deseas eliminar este registro de glucosa?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      await FirebaseFirestore.instance.collection('regGlucosa').doc(doc.id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro eliminado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Glucosa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ingresa tu nivel de glucosa', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _glucoseController,
                    decoration: const InputDecoration(
                      labelText: 'Nivel de Glucosa (mg/dL)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.monitor_heart),
                      hintText: 'Ej: 120',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingresa un nivel de glucosa';
                      final n = int.tryParse(value);
                      if (n == null || n < 20 || n > 600) return 'Valor inválido (20 - 600)';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedContext,
                    decoration: const InputDecoration(
                      labelText: 'Contexto de la medición',
                      border: OutlineInputBorder(),
                    ),
                    items: _contexts.map((ctx) => DropdownMenuItem(value: ctx, child: Text(ctx))).toList(),
                    onChanged: (val) => setState(() => _selectedContext = val ?? _selectedContext),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveGlucoseLevel,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Historial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('regGlucosa')
                  .where('idUsuario', isEqualTo: user?.uid)
                  .orderBy('fechaRegistro', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Text('No hay registros aún.');

                final glucoseRecords = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: glucoseRecords.length,
                  itemBuilder: (context, index) {
                    final doc = glucoseRecords[index];
                    final nivel = doc['nivelGlucosa'];
                    final fecha = (doc['fechaRegistro'] as Timestamp).toDate();
                    final contexto = doc['contexto'] ?? 'Sin contexto';
                    final estado = doc['estado'] ?? 'Sin estado';
                    final icon = nivel < 70
                        ? Icons.warning
                        : nivel > 180
                            ? Icons.error
                            : Icons.check_circle;
                    final color = nivel < 70
                        ? Colors.orange
                        : nivel > 180
                            ? Colors.red
                            : Colors.green;

                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Icon(icon, color: color),
                        title: Text('Nivel: $nivel mg/dL'),
                        subtitle: Text('${DateFormat('dd/MM/yyyy HH:mm').format(fecha)} - $contexto\n$estado'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar registro',
                          onPressed: () => _confirmDelete(doc),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
