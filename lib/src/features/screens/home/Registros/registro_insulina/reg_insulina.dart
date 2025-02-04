import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InsulinAdministrationPage extends StatefulWidget {
  const InsulinAdministrationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InsulinAdministrationPageState createState() => _InsulinAdministrationPageState();
}

class _InsulinAdministrationPageState extends State<InsulinAdministrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _doseController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser; // Obtén el usuario autenticado
  final _focusNode = FocusNode(); // FocusNode para el TextFormField
  final _buttonFocusNode = FocusNode(); // FocusNode para el botón

  Future<void> _addDose() async {
    if (_formKey.currentState!.validate()) {
      final doseValue = int.parse(_doseController.text);
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      if (user != null) {
        await FirebaseFirestore.instance.collection('registro_insulina').add({
          'uid': user!.uid, // Guarda el uid del usuario
          'dose': doseValue,
          'date': formattedDate,
        });

        _doseController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración de Insulina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Administración de Insulina',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ingresa la dosis de insulina y guarda el registro.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _doseController,
                    focusNode: _focusNode, // Asigna el FocusNode
                    decoration: const InputDecoration(
                      labelText: 'Dosis de Insulina (Unidades)',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una dosis';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Focus(
                      focusNode: _buttonFocusNode,
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return ElevatedButton(
                            onPressed: _addDose,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              foregroundColor: Colors.white, backgroundColor: Colors.blue,
                              side: hasFocus ? const BorderSide(color: Colors.yellow, width: 2.0) : null,
                              shadowColor: hasFocus ? Colors.yellow : null,
                            ),
                            child: const Text('Guardar'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Historial',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('registro_insulina')
                    .where('uid', isEqualTo: user?.uid) // Filtra por uid del usuario
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
                      final dose = doses[index];
                      final doseValue = dose['dose'];
                      final dateValue = dose['date'];
                      return ListTile(
                        title: Text('Insulina Administrada: $doseValue unidades'),
                        subtitle: Text(dateValue),
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
 