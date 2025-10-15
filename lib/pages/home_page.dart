import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/homework_bloc.dart';
import '../bloc/homework_event.dart';
import '../bloc/homework_state.dart';
import '../models/homework.dart';
import '../widgets/homework_tile.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onAddPressed;
  const HomePage({Key? key, required this.onAddPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Homework Tracker')),
      body: BlocBuilder<HomeworkBloc, HomeworkState>(
        builder: (context, state) {
          if (state is HomeworkLoadSuccess) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No homework yet. Tap + to add one.'));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, idx) {
                final Homework hw = state.items[idx];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: HomeworkTile(
                    item: hw,
                    onToggle: () {
                      context.read<HomeworkBloc>().add(ToggleComplete(hw.id));
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddPressed,
        child: const Icon(Icons.add),
      ),
    );
  }
}
