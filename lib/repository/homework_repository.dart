import '../models/homework.dart';

class HomeworkRepository {
  final List<Homework> _items = [];

  List<Homework> getAll() => List.unmodifiable(_items);

  void add(Homework hw) => _items.add(hw);

  void toggleComplete(String id) {
    final index = _items.indexWhere((h) => h.id == id);
    if (index != -1) {
      final old = _items[index];
      _items[index] = old.copyWith(isCompleted: !old.isCompleted);
    }
  }
}
