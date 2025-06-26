import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/get_inter_event_repository.dart';
import 'viewmodels/get_inter_event_cubit.dart';

class GetInterEventProvider extends StatelessWidget {
  final Widget child;
  const GetInterEventProvider({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = GetInterEventCubit(GetInterEventRepository());
        cubit.fetchInterestedEvents();
        return cubit;
      },
      child: child,
    );
  }
}
