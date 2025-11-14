import 'package:flutter/material.dart';

class OperativeChoiceChip extends StatelessWidget {
  final String label;
  final String selectedChip;
  final VoidCallback onSelected;
  final Color primaryColor;
  final Color secondaryColor;
  final Color subTitleColor;

  const OperativeChoiceChip({
    super.key,
    required this.label,
    required this.selectedChip,
    required this.onSelected,
    required this.primaryColor,
    required this.secondaryColor,
    required this.subTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedChip == label;

    return ChoiceChip(
      checkmarkColor: secondaryColor,
      label: Text(
        label,
        style: TextStyle(
          fontFamily: "OpenSans",
          fontWeight: FontWeight.w600,
          color: isSelected ? secondaryColor : primaryColor,
        ),
      ),
      selected: isSelected,
      selectedColor: primaryColor,
      backgroundColor: subTitleColor.withOpacity(0.1),
      onSelected: (bool value) {
        if (value) onSelected();
      },
    );
  }
}
