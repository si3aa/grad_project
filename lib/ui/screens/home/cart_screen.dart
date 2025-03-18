import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/core/utils/responsive.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.pushReplacementNamed(context,'/home'),
                        color: kPrimaryColor,
                      ),
                      const Spacer(),
                      const Text(
                        "Your Cart",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          return Text(
                            "${state.itemCount} items",
                            style: const TextStyle(fontSize: 16),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: BlocBuilder<CartCubit, CartState>(
                      builder: (context, state) {
                        if (state.itemCount == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/cart.png',
                                width: Responsive.screenWidth(context) * 0.5,
                                height: Responsive.screenHeight(context) * 0.3,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Your cart is empty !",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/home');
                                },
                                child: Text(
                                  "add to cart",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: kPrimaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const Center(child: Text("Cart has items!"));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
