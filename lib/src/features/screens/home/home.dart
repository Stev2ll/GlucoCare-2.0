import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluco_care/src/utils/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:gluco_care/src/utils/constants/text_strings.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Esto quita la flecha de regreso
        backgroundColor:  isDarkTheme ? TColors.black : Theme.of(context).primaryColor,
        title: const Text(
          TTexts.appName,
          style: TextStyle(
            fontSize: 34.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildGlucoseModule(),
            const SizedBox(height: 16),
            _buildActivityModule(),
            const SizedBox(height: 16),
            _buildInsulinModule(user),
            const SizedBox(height: 16),
            _buildFoodLogModule(user),
          ],
        ),
      ),
    );
  }

  Widget _buildGlucoseModule() {
    return const Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Glucosa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text('0 mg/dL Semanal'),
          ),
          ListTile(
            title: Text('Última lectura'),
            subtitle: Text('0 mg/dL'),
          ),
          ListTile(
            title: Text('Hipoglucemias'),
            subtitle: Text('0'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityModule() {
    return const Card(
      child: Column(
        children: [
          ListTile(
            title: Text('Actividad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text('Objetivo diario: 10,000 pasos'),
          ),
          ListTile(
            title: Text('0 Kilómetros'),
            subtitle: Text('0 Pasos'),
          ),
          ListTile(
            title: Text('- Calorías'),
          ),
        ],
      ),
    );
  }

  Widget _buildInsulinModule(User? user) {
    if (user == null) {
      return const Center(child: Text('Usuario no autenticado.'));
    }

    // Debugging output
    print('Current user UID: ${user.uid}');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('registro_insulina')
          .where('uid', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Debugging output
          print('No doses found for UID: ${user.uid}');
          return const Center(child: Text('No hay dosis registradas.'));
        }

        final doses = snapshot.data!.docs;

        // Debugging output
        print('Doses: $doses');

        return Card(
          child: Column(
            children: [
              const ListTile(
                title: Text('Registro Insulina', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Unidades de Insulina Administradas'),
                subtitle: Text('${doses.last['dose']} unidades administradas'),
              ),
              ListTile(
                title: const Text('Última dosis'),
                subtitle: Text(_formatDate(doses.last['date'])),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFoodLogModule(User? user) {
    if (user == null) {
      return const Center(child: Text('Usuario no autenticado.'));
    }

    // Debugging output
    print('Current user UID: ${user.uid}');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('food_log')
          .where('user_id', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Debugging output
          print('No food logs found for UID: ${user.uid}');
          return const Center(child: Text('No hay registros de alimentos.'));
        }

        final foodLogs = snapshot.data!.docs;

        // Calculate total calories and carbohydrates
        int totalCalories = 0;
        int totalCarbs = 0;

        for (var doc in foodLogs) {
          // Convert string values to int, with error handling
          final caloriesStr = doc['calories'] as String?;
          final carbsStr = doc['carbs'] as String?;

          // Convert strings to integers, handle possible conversion errors
          final calories = int.tryParse(caloriesStr ?? '') ?? 0;
          final carbs = int.tryParse(carbsStr ?? '') ?? 0;

          totalCalories += calories;
          totalCarbs += carbs;
        }

        // Debugging output
        print('Food logs: $foodLogs');
        print('Total calories: $totalCalories');
        print('Total carbohydrates: $totalCarbs');

        return Card(
          child: Column(
            children: [
              const ListTile(
                title: Text('Registro de Alimentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Calorías Totales'),
                subtitle: Text('$totalCalories kcal'),
              ),
              ListTile(
                title: const Text('Carbohidratos Totales'),
                subtitle: Text('$totalCarbs g'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(date);
      return DateFormat('dd MMM yyyy, HH:mm').format(parsedDate);
    } catch (e) {
      print('Error al formatear la fecha: $e');
      return date; // Return the original date string if parsing fails
    }
  }
}
 