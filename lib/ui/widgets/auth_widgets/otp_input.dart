import 'package:flutter/material.dart';
import 'package:Herfa/ui/provider/controller.dart';

class OtpTextField extends StatelessWidget {
  final VerifyCodeController controller;

  const OtpTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.otpLength,
        (index) => Container(
          width: 45,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          child: TextField(
            controller: controller.otpControllers[index],
            focusNode: controller.focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(color: Colors.purple),
              ),
            ),
            onChanged: (value) => controller.onOtpChanged(value, index),
            onSubmitted: (_) => controller.submitOtp(),
            onEditingComplete: () => controller.focusNodes[index].unfocus(),
            onTap: () => controller.otpControllers[index].selection =
                TextSelection.fromPosition(
              TextPosition(
                  offset: controller.otpControllers[index].text.length),
            ),
          ),
        ),
      ),
    );
  }
}
