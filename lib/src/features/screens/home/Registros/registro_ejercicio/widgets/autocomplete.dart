import 'package:flutter/material.dart';

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({super.key, required this.onSelected});

  final ValueChanged<String> onSelected; // Callback para enviar la selección

  static const List<String> _kOptions = <String>[
    'Fútbol',
    'Caminata',
    'Correr',
    'Patinaje',
    'Gym',
    'Baloncesto',
    'Béisbol',
    'Tenis',
    'Natación',
    'Ciclismo',
    'Atletismo',
    'Golf',
    'Boxeo',
    'Hockey',
    'Rugby',
    'Voleibol',
    'Esquí',
    'Surf',
    'Artes Marciales',
    'Judo',
    'Taekwondo',
    'Karate',
    'Handbol',
    'Patinaje',
    'Remo',
    'Triatlón',
    'Ski acuático',
    'Escalada',
    'Esgrima',
    'Badminton',
    'Halterofilia',
    'Motociclismo',
    'Fórmula 1',
    'Lucha Libre',
    'Kitesurf',
    'Polo',
    'Softbol',
    'Lacrosse',
    'Críquet',
    'Dardos',
    'Curling',
    'Squash',
    'Ajedrez',
  ];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return _kOptions.where((String option) {
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        onSelected(selection); // Notifica al ActivityLogScreen
      },
    );
  }
}
