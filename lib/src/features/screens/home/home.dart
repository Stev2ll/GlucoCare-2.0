import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: isDarkTheme ? TColors.black : Theme.of(context).primaryColor,
        title: const Text(
          TTexts.appName,
          style: TextStyle(fontSize: 34.0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildGlucoseModule(user),
            const SizedBox(height: 16),
            _buildActivityModule(user),
            const SizedBox(height: 16),
            _buildInsulinModule(user),
            const SizedBox(height: 16),
            _buildFoodLogModule(user),
          ],
        ),
      ),
    );
  }

  Widget _buildGlucoseModule(User? user) {
    return _buildDataCard(
      title: 'Glucosa',
      stream: FirebaseFirestore.instance
          .collection('registro_glucosa')
          .where('uid', isEqualTo: user?.uid)
          .orderBy('fecha', descending: true)
          .limit(1)
          .snapshots(),
      builder: (doc) {
        final value = doc['glucosa'] ?? 0;
        final context = doc['contexto'] ?? '';
        final date = _formatDate(doc['fecha']);
        return Column(
          children: [
            ListTile(title: const Text('Última lectura'), subtitle: Text('$value mg/dL')),
            ListTile(title: const Text('Contexto'), subtitle: Text(context)),
            ListTile(title: const Text('Fecha'), subtitle: Text(date)),
          ],
        );
      },
      emptyMessage: 'No hay lecturas de glucosa registradas.',
    );
  }

  Widget _buildActivityModule(User? user) {
    return _buildDataCard(
      title: 'Actividad Física',
      stream: FirebaseFirestore.instance
          .collection('registro_actividad')
          .where('uid', isEqualTo: user?.uid)
          .orderBy('fecha', descending: true)
          .limit(1)
          .snapshots(),
      builder: (doc) {
        final actividad = doc['actividad'] ?? 'Desconocida';
        final duracion = doc['duracion'] ?? '0';
        final calorias = doc['calorias'] ?? '0';
        return Column(
          children: [
            ListTile(title: const Text('Actividad'), subtitle: Text(actividad)),
            ListTile(title: const Text('Duración'), subtitle: Text('$duracion min')),
            ListTile(title: const Text('Calorías estimadas'), subtitle: Text('$calorias kcal')),
          ],
        );
      },
      emptyMessage: 'No hay actividades registradas.',
    );
  }

  Widget _buildInsulinModule(User? user) {
    return _buildDataCard(
      title: 'Insulina',
      stream: FirebaseFirestore.instance
          .collection('registro_insulina')
          .where('uid', isEqualTo: user?.uid)
          .orderBy('date', descending: true)
          .limit(1)
          .snapshots(),
      builder: (doc) {
        final dose = doc['dose'] ?? '0';
        final date = _formatDate(doc['date']);
        return Column(
          children: [
            ListTile(title: const Text('Dosis'), subtitle: Text('$dose unidades')),
            ListTile(title: const Text('Fecha'), subtitle: Text(date)),
          ],
        );
      },
      emptyMessage: 'No hay dosis registradas.',
    );
  }

  Widget _buildFoodLogModule(User? user) {
    return _buildDataCard(
      title: 'Alimentos',
      stream: FirebaseFirestore.instance
          .collection('food_log')
          .where('user_id', isEqualTo: user?.uid)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (doc) {
        final alimento = doc['nombre'] ?? 'Desconocido';
        final calorias = doc['calories'] ?? '0';
        final carbs = doc['carbs'] ?? '0';
        return Column(
          children: [
            ListTile(title: const Text('Último alimento'), subtitle: Text(alimento)),
            ListTile(title: const Text('Calorías'), subtitle: Text('$calorias kcal')),
            ListTile(title: const Text('Carbohidratos'), subtitle: Text('$carbs g')),
          ],
        );
      },
      emptyMessage: 'No hay alimentos registrados.',
    );
  }

  Widget _buildDataCard({
    required String title,
    required Stream<QuerySnapshot> stream,
    required Widget Function(Map<String, dynamic>) builder,
    required String emptyMessage,
  }) {
    return Card(
      child: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(emptyMessage),
            );
          }

          final doc = snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              builder(doc),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
      return DateFormat('dd MMM yyyy, HH:mm').format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}
