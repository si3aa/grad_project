import 'package:Herfa/constants.dart';
import 'package:Herfa/features/add_new_product/viewmodels/states/new_post_state.dart';
import 'package:flutter/material.dart';

/// A button for submitting the product creation form.
class SubmitButton extends StatelessWidget {
  final NewPostState state;
  final Future<bool> Function() onSubmit;
  final GlobalKey<FormState> formKey;
  final bool isEditMode;

  const SubmitButton({
    Key? key,
    required this.state,
    required this.onSubmit,
    required this.formKey,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: state.isLoading
            ? null
            : () async {
                print(
                    "${isEditMode ? 'Update' : 'Create'} Product button pressed");
                if (formKey.currentState!.validate()) {
                  print("Form is valid, submitting product");

                  // Show loading overlay
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );

                  final success = await onSubmit();

                  // Close loading overlay
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }

                  print("Product submission result: $success");
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditMode
                            ? 'Product updated successfully'
                            : 'Product created successfully'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );

                    if (isEditMode) {
                      // Return to previous screen with success result
                      Navigator.of(context).pop(true);
                    } else {
                      // Navigate to home for new products
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Failed to ${isEditMode ? 'update' : 'create'} product: ${state.error ?? "Unknown error"}'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
        child: Text(isEditMode ? 'UPDATE PRODUCT' : 'CREATE PRODUCT'),
      ),
    );
  }
}
