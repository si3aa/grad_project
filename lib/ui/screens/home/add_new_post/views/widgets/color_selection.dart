import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/states/new_post_state.dart';
import 'package:flutter/material.dart';


/// A widget for selecting product colors.
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
        const SizedBox(height: 8),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: colorOptions.length,
            itemBuilder: (context, index) {
              final color = colorOptions[index];
              final isSelected = state.selectedColors.contains(color);

              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () => onColorToggled(color, colorNames[color]!),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, color: Colors.white, size: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}