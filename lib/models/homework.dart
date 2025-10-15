class Homework {
  final String id;
  final String subject;
  final String title;
  final DateTime dueDate;
  final bool isCompleted;

  Homework({
    required this.id,
    required this.subject,
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });

  Homework copyWith({
    String? id,
    String? subject,
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Homework(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
