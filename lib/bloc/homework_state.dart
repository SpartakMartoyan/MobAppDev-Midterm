import '../models/homework.dart';

abstract class HomeworkState {}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoadSuccess extends HomeworkState {
  final List<Homework> items;
  HomeworkLoadSuccess(this.items);
}
