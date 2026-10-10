import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/task.dart';
import '../../services/auth_service.dart';
import '../../services/task_repository.dart';

/// Opens the add-task form, or the edit form when [task] is passed.
Future<void> showTaskForm(BuildContext context, {Task? task}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _TaskForm(task: task),
  );
}

class _TaskForm extends StatefulWidget {
  const _TaskForm({this.task});

  final Task? task;

  @override
  State<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<_TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.task?.title ?? '');
  late final _note = TextEditingController(text: widget.task?.note ?? '');
  late DateTime? _dueDate = widget.task?.dueDate;
  XFile? _picked; // newly picked image
  Uint8List? _pickedBytes; // for the preview
  bool _saving = false;

  bool get _isEdit => widget.task != null;

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 75, // compress before upload to save space
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (mounted) {
      setState(() {
        _picked = file;
        _pickedBytes = bytes;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final uid = authService.uid;
    if (uid == null) return;

    setState(() => _saving = true);
    try {
      if (_isEdit) {
        await taskRepository.updateTask(
          uid,
          widget.task!,
          title: _title.text,
          note: _note.text,
          dueDate: _dueDate,
          newAttachment: _picked,
        );
      } else {
        await taskRepository.addTask(
          uid,
          title: _title.text,
          note: _note.text,
          dueDate: _dueDate,
          attachment: _picked,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        showMessage(context, 'Could not save the task, please try again');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final existingUrl = widget.task?.attachmentUrl;

    return Padding(
      // Lift the form above the keyboard
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isEdit ? 'Edit task' : 'New task',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _title,
                label: 'Title',
                icon: Icons.title,
                maxLength: 120,
                validator: (v) => Validators.required(v, 'Title'),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                controller: _note,
                label: 'Notes (optional)',
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saving ? null : _pickDate,
                      icon: const Icon(Icons.event_outlined),
                      label: Text(_dueDate == null ? 'Set due date' : formatDate(_dueDate!)),
                    ),
                  ),
                  if (_dueDate != null)
                    IconButton(
                      tooltip: 'Clear due date',
                      onPressed: _saving ? null : () => setState(() => _dueDate = null),
                      icon: const Icon(Icons.close),
                    ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saving ? null : _pickImage,
                      icon: const Icon(Icons.attach_file),
                      label: Text(
                        _picked != null || existingUrl != null ? 'Change photo' : 'Attach image',
                      ),
                    ),
                  ),
                ],
              ),
              if (_pickedBytes != null || existingUrl != null) ...[
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    height: 160,
                    child: _pickedBytes != null
                        ? Image.memory(_pickedBytes!, fit: BoxFit.cover)
                        : Image.network(
                            existingUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Center(child: Icon(Icons.broken_image_outlined)),
                          ),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: _isEdit ? 'Save changes' : 'Add',
                loading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
