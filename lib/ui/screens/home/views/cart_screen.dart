import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/core/utils/responsive.dart';
import 'package:Herfa/features/orders/viewmodels/order_cubit.dart';
import 'package:Herfa/features/orders/data/repository/order_repository.dart';
import 'package:Herfa/features/orders/data/models/order_model.dart';
import 'package:dio/dio.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/orders/data/data_source/order_remote_data_source.dart';
import 'package:url_launcher/url_launcher.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
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
                              Navigator.pushReplacementNamed(context, '/home');
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
                          SizedBox(height: 80),
                        ],
                      );
                    }
                    // Modern cart UI
                    final items = state.items;
                    double total = 0;
                    for (var item in items) {
                      total += item.price * item.quantity;
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: Colors.grey.shade200),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: item.imageUrl.startsWith('http')
                                      ? Image.network(item.imageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover)
                                      : Image.asset(item.imageUrl,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover),
                                ),
                                title: Text(item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Price: ${item.price.toStringAsFixed(2)} EGP'),
                                    if (item.couponCode != null)
                                      Text('Coupon: ${item.couponCode}',
                                          style: const TextStyle(
                                              color: Colors.green)),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline),
                                          onPressed: item.quantity > 1
                                              ? () => context
                                                  .read<CartCubit>()
                                                  .updateQuantity(item.id,
                                                      item.quantity - 1,
                                                      couponCode:
                                                          item.couponCode)
                                              : null,
                                        ),
                                        Text('${item.quantity}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline),
                                          onPressed: () => context
                                              .read<CartCubit>()
                                              .updateQuantity(
                                                  item.id, item.quantity + 1,
                                                  couponCode: item.couponCode),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => context
                                      .read<CartCubit>()
                                      .removeItem(item.id,
                                          couponCode: item.couponCode),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 10,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Total',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      '${total.toStringAsFixed(2)} EGP',
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.payment),
                                  label: const Text('Checkout'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                  onPressed: () async {
                                    final cartCubit = context.read<CartCubit>();
                                    final items = cartCubit.state.items;
                                    if (items.isEmpty) return;
                                    final token =
                                        await AuthSharedPrefLocalDataSource()
                                            .getToken();
                                    if (token == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'You must be logged in to checkout.')),
                                      );
                                      return;
                                    }
                                    final orderItems = items
                                        .map((item) => OrderItemModel(
                                              productId: item.id,
                                              quantity: item.quantity,
                                              couponCode: item.couponCode,
                                            ))
                                        .toList();
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return BlocProvider(
                                          create: (_) => OrderCubit(
                                            repository: OrderRepositoryImpl(
                                              remoteDataSource:
                                                  OrderRemoteDataSourceImpl(
                                                dio: Dio(BaseOptions(
                                                    baseUrl:
                                                        'https://zygotic-marys-herfa-c2dd67a8.koyeb.app')),
                                              ),
                                            ),
                                          ),
                                          child: _OrderDialog(
                                              orderItems: orderItems,
                                              token: token,
                                              onOrderSuccess: () {
                                                cartCubit.clearCart();
                                              }),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Order dialog widget for checkout
class _OrderDialog extends StatelessWidget {
  final List<OrderItemModel> orderItems;
  final String token;
  final VoidCallback onOrderSuccess;
  const _OrderDialog(
      {required this.orderItems,
      required this.token,
      required this.onOrderSuccess});

  void _showAmountDialog(
      BuildContext context, void Function(double) onAmountEntered) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Enter Recharge Amount'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'Amount'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value == null || value <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid amount.')),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                onAmountEntered(value);
              },
              child: const Text('Recharge'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccess) {
          onOrderSuccess();
        }
        if (state is OrderRechargeUrl) {
          // Open Stripe URL in browser BEFORE closing the dialog
          final uri = Uri.parse(state.url);
          launchUrl(uri, mode: LaunchMode.externalApplication).then((_) {
            Navigator.of(context).pop();
          }).catchError((e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open payment page.')),
            );
          });
        }
      },
      builder: (context, state) {
        if (state is OrderInitial) {
          context.read<OrderCubit>().makeOrder(items: orderItems, token: token);
        }
        if (state is OrderLoading || state is OrderInitial) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Placing your order...'),
              ],
            ),
          );
        } else if (state is OrderSuccess) {
          final order = state.order;
          return AlertDialog(
            title: const Text('Order Confirmed!',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 12),
                  Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
                  const Divider(),
                  const Text('Items:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...order.orderDetails.map((detail) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(detail.product.name),
                        subtitle: Text(
                            'x${detail.quantity}  |   ${detail.unitPrice.toStringAsFixed(2)} EGP'),
                        trailing: detail.couponCode != null
                            ? Text('Coupon: ${detail.couponCode}',
                                style: const TextStyle(color: Colors.green))
                            : null,
                      )),
                  if (order.appliedOffers.isNotEmpty) ...[
                    const Divider(),
                    const Text('Applied Offers:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...order.appliedOffers.map((offer) => Text(
                        offer['name'] ?? '',
                        style: const TextStyle(color: Colors.blue))),
                  ],
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text('Pay'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        context.read<OrderCubit>().checkBalanceAndPay(
                              orderId: order.id,
                              total: order.totalPrice,
                              token: token,
                            );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        } else if (state is OrderPaying || state is OrderCheckingBalance) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing payment...'),
              ],
            ),
          );
        } else if (state is OrderPaid) {
          return AlertDialog(
            title: const Text('Payment Successful!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
            content: const Icon(Icons.verified, color: Colors.green, size: 64),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        } else if (state is OrderInsufficientBalance) {
          return AlertDialog(
            title: const Text('Insufficient Balance',
                style: TextStyle(color: Colors.red)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet,
                    color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(
                    'Your balance is only \$${state.balance.toStringAsFixed(2)}.'),
                const SizedBox(height: 8),
                const Text('Please recharge your wallet to continue.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.account_balance_wallet),
                  label: const Text('Recharge Wallet'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _showAmountDialog(context, (amount) {
                      context
                          .read<OrderCubit>()
                          .rechargeWallet(amount: amount, token: token);
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        } else if (state is OrderRechargingWallet) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Preparing wallet recharge...'),
              ],
            ),
          );
        } else if (state is OrderRechargeUrl) {
          // In a real app, use url_launcher to open the URL
          return AlertDialog(
            title: const Text('Recharge Wallet'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.open_in_browser, color: kPrimaryColor, size: 48),
                const SizedBox(height: 12),
                const Text('Click below to recharge your wallet:'),
                const SizedBox(height: 8),
                SelectableText(state.url,
                    style: const TextStyle(color: Colors.blue)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Payment Page'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final uri = Uri.parse(state.url);
                    try {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Could not open payment page.')),
                      );
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        } else if (state is OrderError) {
          return AlertDialog(
            title:
                const Text('Order Failed', style: TextStyle(color: Colors.red)),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
