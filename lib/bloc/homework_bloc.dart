import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/homework_repository.dart';
import '../models/homework.dart';
import 'homework_event.dart';
import 'homework_state.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkRepository repository;

  HomeworkBloc({required this.repository}) : super(HomeworkInitial()) {
    on<LoadHomework>((event, emit) {
      emit(HomeworkLoadSuccess(repository.getAll()));
    });

    on<AddHomework>((event, emit) {
      repository.add(event.homework);
      emit(HomeworkLoadSuccess(repository.getAll()));
    });

    on<ToggleComplete>((event, emit) {
      repository.toggleComplete(event.id);
      emit(HomeworkLoadSuccess(repository.getAll()));
    });

    add(LoadHomework());
  }
}
