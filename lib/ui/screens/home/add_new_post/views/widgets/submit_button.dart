import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/states/new_post_state.dart';

class SubmitButton extends StatelessWidget {
  final NewPostState state;
  final Future<bool> Function() onSubmit;
  final GlobalKey<FormState> formKey;

  const SubmitButton({
    Key? key,
    required this.state,
    required this.onSubmit,
    required this.formKey, required bool isFormValid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: !state.isLoading ? kPrimaryColor : Colors.grey[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: state.isLoading ? null : () async {
          await onSubmit();
        },
        child: state.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Create Product',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
