import 'package:flutter/material.dart';
import '../data/models/profile_order_model.dart';

class OrderCard extends StatefulWidget {
  final ProfileOrderModel order;
  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    Color statusColor;
    switch (order.status.toUpperCase()) {
      case 'PAID':
        statusColor = Colors.green;
        break;
      case 'PENDING':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.1),
              child: Icon(Icons.receipt_long, color: statusColor),
            ),
            title: Text('Order #${order.id}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${order.orderDate}'),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${order.status}',
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${order.totalPrice.toStringAsFixed(2)} EGP',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            onTap: () => setState(() => expanded = !expanded),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...order.orderDetails.map((detail) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            detail.product.media,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                                const Icon(Icons.image_not_supported),
                          ),
                        ),
                        title: Text(detail.product.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                            'x${detail.quantity} • ${detail.unitPrice.toStringAsFixed(2)} EGP'),
                        trailing: detail.coupon != null
                            ? Chip(
                                label: Text('Coupon: ${detail.coupon!.code}'))
                            : null,
                      )),
                  if (order.paidAt != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Paid at: ${order.paidAt}',
                          style: const TextStyle(color: Colors.green)),
                    ),
                  if (order.appliedOffers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Offers: ${order.appliedOffers.join(", ")}',
                          style: const TextStyle(color: Colors.blue)),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
