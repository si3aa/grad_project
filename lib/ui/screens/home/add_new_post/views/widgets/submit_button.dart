import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/states/new_post_state.dart';
import 'package:flutter/material.dart';
/// A button for submitting the product creation form.
class SubmitButton extends StatelessWidget {
  final NewPostState state;
  final Future<bool> Function() onSubmit;
  final GlobalKey<FormState> formKey;

  const SubmitButton({
    super.key,
    required this.state,
    required this.onSubmit,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: state.isLoading ? Colors.grey[400] : kPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: state.isLoading
            ? null
            : () async {
                print("Create Product button pressed");
                if (formKey.currentState!.validate()) {
                  print("Form is valid, submitting product");
                  final success = await onSubmit();
                  print("Product submission result: $success");
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product created successfully')),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create product: ${state.error ?? "Unknown error"}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
        child: state.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Create Product',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}