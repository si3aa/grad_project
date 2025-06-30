import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/deal_cubit.dart';

class AllDealsScreen extends StatelessWidget {
  final String token;
  const AllDealsScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<BuyerDealsCubit>(context)
        ..fetchAllBuyerDeals(token),
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
        body: BlocBuilder<BuyerDealsCubit, BuyerDealsState>(
          builder: (context, state) {
            if (state is BuyerDealsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BuyerDealsError) {
              return Center(
                  child: Text(state.message,
                      style: const TextStyle(color: Colors.red)));
            } else if (state is BuyerDealsLoaded) {
              final deals = state.deals;
              if (deals.isEmpty) {
                return const Center(child: Text('No deals found.'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await context
                      .read<BuyerDealsCubit>()
                      .fetchAllBuyerDeals(token);
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.media,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(product.shortDescription,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13)),
                                const SizedBox(height: 8),
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
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Original Offer:',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Text('Price: ${deal.proposedPrice} EGP',
                                            style:
                                                const TextStyle(fontSize: 13)),
                                        Text(
                                            'Quantity: ${deal.requestedQuantity}',
                                            style:
                                                const TextStyle(fontSize: 13)),
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
                                        borderRadius: BorderRadius.circular(8),
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Color(0xFF7C5CFC))),
                                if (deal.counterPrice != null)
                                            Text(
                                                'Counter Price: \$${deal.counterPrice}',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF7C5CFC))),
                                if (deal.counterQuantity != null)
                                  Text(
                                      'Counter Quantity: ${deal.counterQuantity}',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF7C5CFC))),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Tooltip(
                                                message: deal.status ==
                                                        'COUNTERED'
                                                    ? 'Accept this counter offer'
                                                    : 'Only countered deals can be accepted',
                                                child: ElevatedButton(
                                                  onPressed:
                                                      deal.status == 'COUNTERED'
                                                          ? () {
                                                              context
                                                                  .read<
                                                                      BuyerDealsCubit>()
                                                                  .acceptCounter(
                                                                      token,
                                                                      deal.id);
                                                            }
                                                          : null,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    minimumSize:
                                                        const Size(64, 32),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    textStyle: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  child: const Text('Accept',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Tooltip(
                                                message: deal.status ==
                                                        'COUNTERED'
                                                    ? 'Reject this counter offer'
                                                    : 'Only countered deals can be rejected',
                                                child: ElevatedButton(
                                                  onPressed:
                                                      deal.status == 'COUNTERED'
                                                          ? () {
                                                              context
                                                                  .read<
                                                                      BuyerDealsCubit>()
                                                                  .rejectCounter(
                                                                      token,
                                                                      deal.id);
                                                            }
                                                          : null,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    minimumSize:
                                                        const Size(64, 32),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    textStyle: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  child: const Text('Reject',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                const SizedBox(height: 4),
                                  Text(
                                      'Created: ${deal.createdAt.split("T")[0]}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
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
