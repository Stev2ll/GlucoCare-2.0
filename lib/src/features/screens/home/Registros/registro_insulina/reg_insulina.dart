import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InsulinAdministrationPage extends StatefulWidget {
  const InsulinAdministrationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InsulinAdministrationPageState createState() => _InsulinAdministrationPageState();
}

class _InsulinAdministrationPageState extends State<InsulinAdministrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _doseController = TextEditingController();
  final _focusNode = FocusNode();
  final _buttonFocusNode = FocusNode();
  final User? user = FirebaseAuth.instance.currentUser;

  String _selectedType = 'Rápida';
  String interpretacion = '';

  String interpretarInsulina(int dosis, String tipo) {
    if (tipo == 'Rápida') {
      if (dosis < 4) return 'Dosis baja de insulina rápida: revisar si es suficiente según la glucosa.';
      if (dosis > 10) return 'Dosis alta de insulina rápida: asegúrate de haber calculado bien los carbohidratos.';
    } else {
      if (dosis < 6) return 'Dosis baja de insulina basal: confirmar con el equipo médico.';
      if (dosis > 20) return 'Dosis alta de insulina basal: monitorea posibles hipoglucemias nocturnas.';
    }
    return 'Dosis adecuada según el tipo de insulina.';
  }

  Future<void> _addDose() async {
    if (_formKey.currentState!.validate() && user != null) {
      final doseValue = int.parse(_doseController.text);
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      interpretacion = interpretarInsulina(doseValue, _selectedType);

      await FirebaseFirestore.instance.collection('registro_insulina').add({
        'uid': user!.uid,
        'dose': doseValue,
        'tipo': _selectedType,
        'interpretacion': interpretacion,
        'date': formattedDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dosis de insulina guardada')),
      );

      setState(() {
        _doseController.clear();
        _selectedType = 'Rápida';
      });
    }
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar registro?'),
        content: const Text('Esta acción no se puede deshacer. ¿Deseas continuar?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(context).pop();
              await FirebaseFirestore.instance.collection('registro_insulina').doc(docId).delete();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Registro eliminado')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Insulina'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: 'Registro de Insulina',
                applicationVersion: '1.0.0',
                children: [
                  const Text('Esta aplicación permite registrar y administrar dosis de insulina.'),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Administración de Insulina', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Semantics(
                    label: 'Dosis de insulina en unidades',
                    child: TextFormField(
                      controller: _doseController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Dosis (Unidades)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => (value == null || value.isEmpty) ? 'Por favor ingrese una dosis' : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    label: 'Tipo de insulina',
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      items: const [
                        DropdownMenuItem(value: 'Rápida', child: Text('Rápida')),
                        DropdownMenuItem(value: 'Lenta', child: Text('Lenta')),
                      ],
                      onChanged: (value) => setState(() => _selectedType = value ?? 'Rápida'),
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Insulina',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Focus(
                      focusNode: _buttonFocusNode,
                      child: Builder(builder: (context) {
                        final hasFocus = Focus.of(context).hasFocus;
                        return ElevatedButton(
                          onPressed: _addDose,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            side: hasFocus ? const BorderSide(color: Colors.yellow, width: 2.0) : null,
                          ),
                          child: const Text('Guardar'),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Historial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('registro_insulina')
                    .where('uid', isEqualTo: user?.uid)
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No hay dosis registradas.'));
                  }

                  final doses = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: doses.length,
                    itemBuilder: (context, index) {
                      final doc = doses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          tileColor: Colors.blue.shade50,
                          title: Text('Dosis: ${doc['dose']} u | Tipo: ${doc['tipo']}'),
                          subtitle: Text('${doc['date']}\n${doc['interpretacion']}'),
                          isThreeLine: true,
                          trailing: Semantics(
                            button: true,
                            label: 'Eliminar registro',
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Eliminar',
                              onPressed: () => _confirmDelete(context, doc.id),
                            ),
                          ),
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
    );
  }
}
