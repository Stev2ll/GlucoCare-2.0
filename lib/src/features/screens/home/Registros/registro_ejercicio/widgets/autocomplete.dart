import 'package:flutter/material.dart';

class AutocompleteBasicExample extends StatelessWidget {
  const AutocompleteBasicExample({
    super.key,
    required this.onSelected,
    required this.options,
  });

  final ValueChanged<String> onSelected;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((option) => 
          option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (selection) {
        onSelected(selection);
      },
    );
  }
}
