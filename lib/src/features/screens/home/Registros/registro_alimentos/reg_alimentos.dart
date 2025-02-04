import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'FoodApiService.dart';

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FoodLogScreenState createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  final FoodApiService apiService = FoodApiService();
  List<FoodItem> foodItems = [];
  List<FoodItem> addedFoods = [];
  int totalCalories = 0;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  void _searchFood(String query) async {
    if (query.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<FoodItem> results = await apiService.fetchFoodItems(query);
      setState(() {
        foodItems = results;
      });
    } catch (e) {
      print('Error al recuperar alimentos: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addFood(FoodItem food) async {
    try {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      await FirebaseFirestore.instance.collection('regAlimentos').add({
        ...food.toJson(),
        'idUsuario': _userId,
        'fechaRegistro': formattedDate, // Guarda la fecha en formato de cadena
      });

      setState(() {
        addedFoods.add(food);
        totalCalories += int.tryParse(food.calories) ?? 0;
      });
    } catch (e) {
      print('Error al agregar comida a Firestore: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Alimentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Busca y agrega tus alimentos consumidos.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar Alimentos',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchFood(_searchController.text);
                  },
                ),
              ),
              onSubmitted: _searchFood,
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: foodItems.length,
                itemBuilder: (context, index) {
                  return FoodItemCard(
                    foodItem: foodItems[index],
                    onAdd: _addFood,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Conteo de Calorías: $totalCalories kcal',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    .collection('regAlimentos')
                    .where('idUsuario', isEqualTo: _userId)
                    .orderBy('fechaRegistro', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print('Error al recuperar el historial: ${snapshot.error}');
                    return const Center(child: Text('Error al cargar el historial'));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(child: Text('No existe alimentos registrados'));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      // Verifica el tipo del campo 'date' y maneja el caso de formato de cadena
                      final dateValue = data['fechaRegistro'] as String;
                      final dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateValue);
                      final formattedDate = DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);

                      return HistoryItem(
                        value: '${data['name']} - ${data['calories']} kcal',
                        date: formattedDate,
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

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;
  final Function(FoodItem) onAdd;

  const FoodItemCard({super.key, required this.foodItem, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(foodItem.name),
        subtitle: Text('${foodItem.carbs}g de carbohidratos, ${foodItem.calories} kcal'),
        trailing: ElevatedButton(
          style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.all(10.0))),
          onPressed: () {
            onAdd(foodItem);
          },
          child: const Text('Agregar'),
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