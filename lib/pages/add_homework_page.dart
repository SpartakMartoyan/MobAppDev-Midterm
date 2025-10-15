import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../bloc/homework_bloc.dart';
import '../bloc/homework_event.dart';
import '../models/homework.dart';

class AddHomeworkPage extends StatefulWidget {
  final VoidCallback onSaveComplete;
  const AddHomeworkPage({Key? key, required this.onSaveComplete}) : super(key: key);

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  DateTime? _dueDate;

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
    );
    if (selected != null) setState(() => _dueDate = selected);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please pick a due date')));
      return;
    }

    final hw = Homework(
      id: const Uuid().v4(),
      subject: _subjectCtrl.text.trim(),
      title: _titleCtrl.text.trim(),
      dueDate: _dueDate!,
    );

    context.read<HomeworkBloc>().add(AddHomework(hw));
    widget.onSaveComplete();
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _dueDate == null
        ? 'Pick due date'
        : '${_dueDate!.year}-${_dueDate!.month}-${_dueDate!.day}';
    return Scaffold(
      appBar: AppBar(title: const Text('Add Homework')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _subjectCtrl,
                decoration: const InputDecoration(labelText: 'Subject'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Please enter subject' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration:
                const InputDecoration(labelText: 'Homework Title / Description'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Please enter title' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(dateText)),
                  TextButton(onPressed: _pickDate, child: const Text('Choose')),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
