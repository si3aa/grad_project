import 'package:Herfa/ui/provider/cubit/content_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentScreen extends StatelessWidget {
  final ContentFilter initialFilter;

  const ContentScreen({super.key, required this.initialFilter});

  @override
  Widget build(BuildContext context) {
    context.read<ContentCubit>().filterContent(initialFilter);
    return Scaffold(
      appBar: AppBar(
        title: Text(initialFilter.toString().split('.').last.toUpperCase()),
      ),
      body: BlocBuilder<ContentCubit, ContentState>(
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: state.content.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(state.content[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
