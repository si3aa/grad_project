import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/refund_request_cubit.dart';
import '../data/repository/profile_repository.dart';
import '../data/data_source/profile_remote_data_source.dart';

class MyRefundRequestsScreen extends StatelessWidget {
  final String token;
  const MyRefundRequestsScreen({Key? key, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          RefundRequestCubit(ProfileRepository(ProfileRemoteDataSource()))
            ..fetchMyRefundRequests(token),
      child: Scaffold(
        appBar:  AppBar(
        title: const Text(
          'My Refund Requests',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black, size: 24),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
        body: BlocBuilder<RefundRequestCubit, RefundRequestState>(
          builder: (context, state) {
            if (state is MyRefundRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyRefundRequestsLoaded) {
              if (state.refunds.isEmpty) {
                return const Center(child: Text('No refund requests found.'));
              }
              return ListView.builder(
                itemCount: state.refunds.length,
                itemBuilder: (context, i) {
                  final refund = state.refunds[i];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: refund.status == 'PENDING'
                                ? Colors.orange.shade100
                                : refund.status == 'APPROVED'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                            child: Icon(
                              refund.status == 'PENDING'
                                  ? Icons.hourglass_top
                                  : refund.status == 'APPROVED'
                                      ? Icons.check_circle
                                      : Icons.cancel,
                              color: refund.status == 'PENDING'
                                  ? Colors.orange
                                  : refund.status == 'APPROVED'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Refund #${refund.id}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      refund.status,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: refund.status == 'PENDING'
                                            ? Colors.orange
                                            : refund.status == 'APPROVED'
                                                ? Colors.green
                                                : Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        refund.createdAt.split("T").first,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${refund.order.totalPrice.toStringAsFixed(2)} EGP',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is MyRefundRequestsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
