import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/states/new_post_state.dart';
import 'package:flutter/material.dart';


/// A widget for selecting the product category.
class CategorySelection extends StatelessWidget {
  final NewPostState state;
  final ValueChanged<int> onCategorySelected;
  final List<Map<String, dynamic>> categories;

  const CategorySelection({
    super.key,
    required this.state,
    required this.onCategorySelected,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = state.categoryId == category['id'];

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(category['name']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      onCategorySelected(category['id']!);
                    }
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: kPrimaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
        if (state.error != null && state.categoryId == 0)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Please select a category',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}