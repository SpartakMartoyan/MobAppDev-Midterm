import '../models/homework.dart';

abstract class HomeworkEvent {}

class LoadHomework extends HomeworkEvent {}

class AddHomework extends HomeworkEvent {
  final Homework homework;
  AddHomework(this.homework);
}

class ToggleComplete extends HomeworkEvent {
  final String id;
  ToggleComplete(this.id);
}
