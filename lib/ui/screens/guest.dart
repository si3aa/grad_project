import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/widgets/header_container.dart';
import 'package:Herfa/ui/widgets/header_text.dart';
import 'package:Herfa/ui/widgets/label_text_field.dart';
import 'package:Herfa/ui/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class GuestScreen extends StatefulWidget {
  const GuestScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _GuestScreenState createState() => _GuestScreenState();
}

// ignore: unused_element
class _GuestScreenState extends State<GuestScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: backgroundImage,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    HeaderTitle(
                      title: 'LOGIN',
                    ),
                    const SizedBox(height: 80),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Color(0x0fffffff).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              HeaderButton(
                                text: 'Sign up',
                                textColor: kPrimaryColor,
                              ),
                              HeaderButton(
                                text: 'Guest',
                                buttonColor: kPrimaryColor,
                                textColor: Colors.white,
                              ),
                              HeaderButton(
                                text: 'Sign in',
                                textColor: kPrimaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'You can browse as a Guest to explore our handmade and craft products, but some features may require an account.',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),
                          LabelText(labelText: "Name", state: 'Optional'),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: "Enter a temporary name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: 'continue',
                            controller:_nameController,
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
