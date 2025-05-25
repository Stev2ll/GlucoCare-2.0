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

  // Controlador para la cantidad en gramos para cada alimento en la lista
  // Usamos un Map para asociar cada alimento con su cantidad de gramos
  final Map<String, TextEditingController> _gramosControllers = {};

  String get _userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  /// Busca el IG del alimento por nombre (en minúsculas)
  double? obtenerIG(String nombre) {
    return igMap[nombre.toLowerCase()];
  }

  /// Obtiene la edad del usuario a partir de la fecha de nacimiento almacenada en Firestore
  Future<int> _getUserAge() async {
    if (_userId.isEmpty) return 0;

    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_userId)
        .get();
    if (!doc.exists) return 0;

    final fechaNacimientoStr = doc.data()?['fechaNacimiento'] as String?;
    if (fechaNacimientoStr == null) return 0;

    final fechaNacimiento = DateTime.parse(fechaNacimientoStr);
    final now = DateTime.now();
    int age = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      age--;
    }
    return age;
  }

  /// Realiza la búsqueda de alimentos desde la API
  void _searchFood(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      foodItems = [];
      _gramosControllers.clear(); // Limpia los controladores previos
    });

    try {
      List<FoodItem> results = await apiService.fetchFoodItems(query);

      setState(() {
        foodItems = results;

        // Crea un TextEditingController para cada alimento con valor inicial 100 gramos
        for (var item in results) {
          _gramosControllers[item.name] = TextEditingController(text: '100');
        }
      });
    } catch (e) {
      print('Error al recuperar alimentos: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Agrega el alimento ajustando por gramos y con interpretación clínica
  void _addFood(FoodItem food) async {
    try {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      // Obtiene la cantidad consumida en gramos desde el controlador
      final gramosStr = _gramosControllers[food.name]?.text ?? '100';
      final gramos = double.tryParse(gramosStr) ?? 100;

      // Factor para ajustar valores por gramos consumidos
      final factor = gramos / 100;

      final adjustedCarbs = (double.tryParse(food.carbs) ?? 0) * factor;
      final adjustedCalories = (double.tryParse(food.calories) ?? 0) * factor;

      final age = await _getUserAge();

      // Obtiene índice glucémico si está disponible
      final ig = obtenerIG(food.name);

      // Construye interpretación clínica básica
      String interpretacion = '';

      if (age < 18) {
        interpretacion = 'Niño: Ajusta insulina según carbohidratos.';
      } else if (age <= 60) {
        interpretacion =
            'Adulto: Controla porciones para mantener glucemia estable.';
      } else {
        interpretacion = 'Adulto mayor: Precaución con hipoglucemias.';
      }

      if (adjustedCarbs > 30) {
        interpretacion +=
            ' Alto en carbohidratos, puede elevar glucosa rápidamente.';
      } else if (adjustedCarbs < 5) {
        interpretacion += ' Bajo en carbohidratos, buen snack.';
      }

      if (ig != null) {
        if (ig > 70) {
          interpretacion += ' Índice glucémico alto ($ig).';
        } else if (ig < 40) {
          interpretacion += ' Índice glucémico bajo ($ig).';
        } else {
          interpretacion += ' Índice glucémico moderado ($ig).';
        }
      } else {
        interpretacion += ' Índice glucémico no disponible.';
      }

      // Guarda en Firestore con valores ajustados y la interpretación
      await FirebaseFirestore.instance.collection('regAlimentos').add({
        'name': food.name,
        'carbs': adjustedCarbs.toStringAsFixed(1),
        'calories': adjustedCalories.toStringAsFixed(1),
        'idUsuario': _userId,
        'fechaRegistro': formattedDate,
        'gramosConsumidos': gramos,
        'interpretacion': interpretacion,
      });

      setState(() {
        // Guarda localmente el alimento ajustado para mostrar en la lista y suma calorías
        addedFoods.add(FoodItem(
          name: food.name,
          carbs: adjustedCarbs.toStringAsFixed(1),
          calories: adjustedCalories.toStringAsFixed(1),
        ));
        totalCalories += adjustedCalories.round();
      });
    } catch (e) {
      print('Error al agregar comida a Firestore: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Dispose de todos los controladores de gramos
    for (var controller in _gramosControllers.values) {
      controller.dispose();
    }
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
                        final food = foodItems[index];
                        final gramosController = _gramosControllers[food.name]!;

                        return FoodItemCard(
                          foodItem: food,
                          gramosController: gramosController,
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
                    return const Center(
                        child: Text('Error al cargar el historial'));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(
                        child: Text('No existen alimentos registrados'));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      // Convierte fecha de cadena a DateTime para mejor formato
                      final dateValue = data['fechaRegistro'] as String;
                      final dateTime =
                          DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateValue);
                      final formattedDate =
                          DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);

                      return HistoryItem(
                        value: '${data['name']} - ${data['calories']} kcal',
                        date: formattedDate,
                        interpretation: data['interpretacion'] ?? '',
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

/// Widget para mostrar cada alimento en la lista de búsqueda
/// Ahora incluye un TextField para que el usuario indique gramos consumidos
class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;
  final TextEditingController gramosController;
  final Function(FoodItem) onAdd;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    required this.gramosController,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final igMap = {
      'pan blanco': 70,
      'arroz blanco': 72,
      'manzana': 38,
      'zanahoria': 35,
    };

    final ig = igMap[foodItem.name.toLowerCase()];

    return Card(
      child: Semantics(
        container: true,
        label:
            'Alimento: ${foodItem.name}, ${foodItem.carbs} gramos de carbohidratos, ${foodItem.calories} calorías',
        hint: 'Presiona el botón para agregar este alimento al registro',
        child: ListTile(
          title: Text(foodItem.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${foodItem.carbs}g CHO • ${foodItem.calories} kcal por 100g'),
              const SizedBox(height: 8),
              TextField(
                controller: gramosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad consumida (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              if (ig != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Índice Glucémico estimado: $ig'),
                ),
            ],
          ),
          trailing: Semantics(
            button: true,
            label: 'Agregar ${foodItem.name}',
            child: ElevatedButton(
              onPressed: () {
                onAdd(foodItem);
              },
              child: const Text('Agregar'),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget para mostrar cada elemento del historial con interpretación clínica
class HistoryItem extends StatelessWidget {
  final String value;
  final String date;
  final String interpretation;

  const HistoryItem({
    super.key,
    required this.value,
    required this.date,
    this.interpretation = '',
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(value),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date),
          if (interpretation.isNotEmpty)
            Text(interpretation, style: const TextStyle(color: Colors.blue)),
        ],
      ),
      trailing: const Icon(Icons.delete, color: Colors.red),
      onTap: () async {
        // Mostrar un diálogo de confirmación antes de eliminar
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
        title: const Text('Eliminar registro'),
        content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
          ),
        );

        if (confirm == true) {
          // Elimina el documento de Firestore
          // Necesitamos el ID del documento, así que debes pasar el DocumentSnapshot o el ID al HistoryItem
          // Aquí asumimos que tienes acceso al ID, si no, deberás modificar el widget para recibirlo
          // Ejemplo:
          // await FirebaseFirestore.instance.collection('regAlimentos').doc(documentId).delete();
          if (ModalRoute.of(context)?.settings.arguments is String) {
            final documentId = ModalRoute.of(context)!.settings.arguments as String;
            await FirebaseFirestore.instance.collection('regAlimentos').doc(documentId).delete();
          } else {
            // Si no tienes el documentId, muestra un error o haz nada
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo eliminar el registro.')),
            );
          }
        }
      },
    );
  }
}

/// Mapa simple para índice glucémico (IG) para algunos alimentos comunes
/// En una app real deberías tener una base de datos más completa
final Map<String, double> igMap = {
  'pan blanco': 70,
  'arroz blanco': 72,
  'manzana': 38,
  'zanahoria': 35,
  'plátano maduro': 62,
  'plátano verde': 30,
  'papas cocidas': 78,
  'papas fritas': 75,
  'batata': 44,
  'sandía': 76,
  'melón': 65,
  'piña': 59,
  'mango': 51,
  'uvas': 59,
  'fresas': 41,
  'arándanos': 53,
  'naranja': 43,
  'pera': 38,
  'ciruela': 39,
  'kiwi': 50,
  'durazno': 42,
  'cereza': 22,
  'higos': 61,
  'pasas': 64,
  'dátil': 62,
  'pan integral': 65,
  'pan de centeno': 58,
  'pasta blanca cocida': 49,
  'pasta integral cocida': 42,
  'espagueti cocido al dente': 44,
  'maíz cocido': 52,
  'palomitas de maíz': 72,
  'harina de avena': 55,
  'avena instantánea': 79,
  'cereal de maíz': 81,
  'cereal de salvado': 51,
  'granola': 62,
  'leche entera': 31,
  'leche descremada': 32,
  'leche de soya': 34,
  'leche de almendras': 25,
  'yogur natural': 35,
  'yogur con azúcar': 50,
  'helado': 61,
  'queso': 0,
  'huevo': 0,
  'pollo': 0,
  'carne de res': 0,
  'pescado': 0,
  'tofu': 15,
  'hummus': 6,
  'garbanzos cocidos': 28,
  'lentejas cocidas': 32,
  'frijoles negros cocidos': 30,
  'soja cocida': 18,
  'panqueques': 67,
  'gofres': 76,
  'tortilla de trigo': 30,
  'tortilla de maíz': 52,
  'pizza': 80,
  'croissant': 67,
  'galletas saladas': 74,
  'galletas dulces': 77,
  'muffins': 62,
  'pastel de chocolate': 38,
  'brownies': 40,
  'azúcar blanca': 65,
  'miel': 58,
  'jarabe de maíz': 90,
  'jarabe de arce': 54,
  'chocolate negro (70%)': 23,
  'chocolate con leche': 42,
  'refresco (con azúcar)': 63,
  'jugo de naranja': 50,
  'jugo de manzana': 41,
  'bebida energética': 70,
  'té sin azúcar': 0,
  'café sin azúcar': 0,
  'cerveza': 66,
  'vino tinto': 30,
  'zanahoria cocida': 39,
  'espinaca': 15,
  'brócoli': 10,
  'lechuga': 15,
  'pepino': 15,
  'coliflor': 15,
  'berenjena': 15,
  'calabacín': 15,
  'pimiento': 15,
  'cebolla': 10,
  'ajo': 10,
  'champiñones': 10,
  'nueces': 15,
  'almendras': 10,
  'cacahuates': 14,
  'semillas de girasol': 35,
  'semillas de chía': 1,
  'aceite de oliva': 0,
  'aceite vegetal': 0,
};