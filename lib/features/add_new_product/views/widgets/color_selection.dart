import 'package:Herfa/features/add_new_product/viewmodels/states/new_post_state.dart';
import 'package:flutter/material.dart';

/// A widget for selecting product colors with an improved list style.
class ColorSelection extends StatelessWidget {
  final NewPostState state;
  final void Function(Color, String) onColorToggled;
  final List<Color> colorOptions;
  final Map<Color, String> colorNames;

  const ColorSelection({
    super.key,
    required this.state,
    required this.onColorToggled,
    required this.colorOptions,
    required this.colorNames,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Colors',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        
        // Selected colors display
        if (state.selectedColors.isNotEmpty) ...[
          const Text(
            'Selected Colors:',
            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.selectedColors.map((color) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      colorNames[color] ?? 'Unknown',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => onColorToggled(color, colorNames[color]!),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        // Available colors
        const Text(
          'Available Colors:',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: colorOptions.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[200],
            ),
            itemBuilder: (context, index) {
              final color = colorOptions[index];
              final isSelected = state.selectedColors.contains(color);
              
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                ),
                title: Text(colorNames[color] ?? 'Unknown'),
                trailing: isSelected 
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.add_circle_outline, color: Colors.grey),
                onTap: () => onColorToggled(color, colorNames[color]!),
                selected: isSelected,
                selectedTileColor: Colors.grey[100],
              );
            },
          ),
        ),
      ],
    );
  }
}
