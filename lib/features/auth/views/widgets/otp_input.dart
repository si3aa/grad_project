import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  final TextEditingController controller;
  final int otpLength;

  const OtpTextField({
    super.key,
    required this.controller,
    this.otpLength = 6,
  });

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.otpLength,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.otpLength,
      (index) => FocusNode(),
    );

    
    widget.controller.addListener(_syncControllers);
  }

  void _syncControllers() {
    final otp = widget.controller.text;
    for (int i = 0; i < widget.otpLength; i++) {
      if (i < otp.length) {
        _controllers[i].text = otp[i];
      } else {
        _controllers[i].text = '';
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1) {
     
      final otp = StringBuffer();
      for (var controller in _controllers) {
        otp.write(controller.text);
      }
      widget.controller.text = otp.toString();

    
      if (index < widget.otpLength - 1) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty) {
     
      final otp = StringBuffer();
      for (var controller in _controllers) {
        otp.write(controller.text);
      }
      widget.controller.text = otp.toString();

      
      if (index > 0) {
        _focusNodes[index].unfocus();
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.otpLength,
        (index) => Container(
          width: 45,
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
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
            onChanged: (value) => _onOtpChanged(value, index),
            onTap: () => _controllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers[index].text.length),
            ),
          ),
        ),
      ),
    );
  }
}