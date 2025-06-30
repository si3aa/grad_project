import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/deal_cubit.dart';

class AllSellerDealsScreen extends StatelessWidget {
  final String token;
  const AllSellerDealsScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SellerDealsCubit>(context)
        ..fetchAllSellerDeals(token),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Deals',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        body: BlocBuilder<SellerDealsCubit, SellerDealsState>(
          builder: (context, state) {
            if (state is SellerDealsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SellerDealsError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            } else if (state is SellerDealsLoaded) {
              final deals = state.deals;
              if (deals.isEmpty) {
                return const Center(child: Text('No deals found.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<SellerDealsCubit>()
                      .fetchAllSellerDeals(token);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: deals.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final deal = deals[index];
                    final product = deal.product;
                    Color statusColor;
                    switch (deal.status) {
                      case 'ACCEPTED':
                        statusColor = Colors.green;
                        break;
                      case 'REJECTED':
                        statusColor = Colors.red;
                        break;
                      default:
                        statusColor = Colors.orange;
                    }
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    product.media,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image,
                                          size: 40, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(product.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text(product.shortDescription,
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13)),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text('Buyer: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text(deal.buyerUsername,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text('Status: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text(deal.status,
                                              style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7C5CFC)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: const Color(0xFF7C5CFC),
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Buyer\'s Offer:',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Color(0xFF7C5CFC))),
                                            Text(
                                              'Price: ${deal.proposedPrice} EGP',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF7C5CFC)),
                                            ),
                                            Text(
                                              'Quantity: ${deal.requestedQuantity}',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF7C5CFC)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (deal.counterPrice != null ||
                                          deal.counterQuantity != null) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF7C5CFC)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: const Color(0xFF7C5CFC),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Counter Offer:',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color:
                                                          Color(0xFF7C5CFC))),
                                              if (deal.counterPrice != null)
                                                Text(
                                                    'Counter Price: ${deal.counterPrice} EGP',
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF7C5CFC))),
                                              if (deal.counterQuantity != null)
                                                Text(
                                                    'Counter Quantity: ${deal.counterQuantity}',
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF7C5CFC))),
                                            ],
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                          'Created: ${deal.createdAt.split("T")[0]}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Tooltip(
                                    message: deal.status == 'PENDING'
                                        ? 'Accept this deal'
                                        : 'Only pending deals can be accepted',
                                    child: ElevatedButton(
                                      onPressed: deal.status == 'PENDING'
                                          ? () {
                                              context
                                                  .read<SellerDealsCubit>()
                                                  .acceptDeal(token, deal.id);
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        minimumSize: const Size(48, 28),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      child: const Text('Accept',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Tooltip(
                                    message: deal.status == 'PENDING'
                                        ? 'Reject this deal'
                                        : 'Only pending deals can be rejected',
                                    child: ElevatedButton(
                                      onPressed: deal.status == 'PENDING'
                                          ? () {
                                              context
                                                  .read<SellerDealsCubit>()
                                                  .rejectDeal(token, deal.id);
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        minimumSize: const Size(48, 28),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      child: const Text('Reject',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Tooltip(
                                    message: deal.status == 'PENDING'
                                        ? 'Propose a counter offer'
                                        : 'Only pending deals can be countered',
                                    child: ElevatedButton(
                                      onPressed: deal.status == 'PENDING'
                                          ? () async {
                                              double? counterPrice;
                                              int? counterQuantity;
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  final _formKey =
                                                      GlobalKey<FormState>();
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Counter Offer',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                    content: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Counter Price',
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                            validator: (v) =>
                                                                v == null ||
                                                                        v.isEmpty
                                                                    ? 'Required'
                                                                    : null,
                                                            onSaved: (v) =>
                                                                counterPrice =
                                                                    double.tryParse(
                                                                        v ??
                                                                            ''),
                                                          ),
                                                          const SizedBox(
                                                              height: 12),
                                                          TextFormField(
                                                            decoration:
                                                                const InputDecoration(
                                                              labelText:
                                                                  'Counter Quantity',
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator: (v) =>
                                                                v == null ||
                                                                        v.isEmpty
                                                                    ? 'Required'
                                                                    : null,
                                                            onSaved: (v) =>
                                                                counterQuantity =
                                                                    int.tryParse(
                                                                        v ??
                                                                            ''),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          if (_formKey
                                                                  .currentState
                                                                  ?.validate() ??
                                                              false) {
                                                            _formKey
                                                                .currentState
                                                                ?.save();
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                        child:
                                                            const Text('Send'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (counterPrice != null &&
                                                  counterQuantity != null) {
                                                context
                                                    .read<SellerDealsCubit>()
                                                    .counterOffer(
                                                        token,
                                                        deal.id,
                                                        counterPrice!,
                                                        counterQuantity!);
                                              }
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        minimumSize: const Size(48, 28),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        textStyle: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      child: const Text('Counter Offer',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
