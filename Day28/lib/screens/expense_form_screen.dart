import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../theme/app_theme.dart';
import '../utils/category_style.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';
import '../widgets/loading_button.dart';
import '../widgets/responsive_center.dart';

/// Used for both adding a new expense and editing an existing one.
class ExpenseFormScreen extends StatefulWidget {
  final Expense? expense;

  const ExpenseFormScreen({super.key, this.expense});

  bool get isEditing => expense != null;

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  static final DateTime _firstDate = DateTime(2000);

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final String _initialTitle;
  late final String _initialAmount;
  late final String _initialCategory;
  late final DateTime _initialDate;

  late String _category;
  late DateTime _date;
  bool _submitted = false;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    final e = widget.expense;
    _initialTitle = e?.title ?? '';
    _initialAmount = e == null ? '' : e.amount.toStringAsFixed(2);
    _initialCategory = e?.category ?? Expense.categories.first;
    _initialDate = DateUtils.dateOnly(e?.date ?? DateTime.now());

    _titleController = TextEditingController(text: _initialTitle)
      ..addListener(_updateDirty);
    _amountController = TextEditingController(text: _initialAmount)
      ..addListener(_updateDirty);
    _category = _initialCategory;
    _date = _initialDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _updateDirty() {
    final dirty = _titleController.text.trim() != _initialTitle ||
        _amountController.text.trim() != _initialAmount ||
        _category != _initialCategory ||
        _date != _initialDate;
    if (dirty != _isDirty) setState(() => _isDirty = dirty);
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    // The picker crashes if the initial date is outside its range,
    // e.g. an old expense saved from a device in another time zone.
    var initial = _date;
    if (initial.isAfter(today)) initial = today;
    if (initial.isBefore(_firstDate)) initial = _firstDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: _firstDate,
      lastDate: today,
      helpText: 'Expense date',
    );
    if (picked == null || !mounted) return;
    setState(() => _date = DateUtils.dateOnly(picked));
    _updateDirty();
  }

  Future<void> _save() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final provider = context.read<ExpenseProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final expense = Expense(
      id: widget.expense?.id ?? '',
      title: _titleController.text.trim(),
      amount: Validators.parseAmount(_amountController.text)!,
      category: _category,
      date: _date,
    );

    if (widget.isEditing && expense.hasSameContentAs(widget.expense!)) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('No changes to save')));
      navigator.pop();
      return;
    }

    final ok = widget.isEditing
        ? await provider.updateExpense(expense)
        : await provider.addExpense(expense);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? (widget.isEditing ? 'Expense updated' : 'Expense added')
                : provider.actionError ?? 'Could not save the expense.',
          ),
        ),
      );
    if (ok && mounted) navigator.pop();
  }

  Future<void> _confirmDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('Your changes to this expense will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.select<ExpenseProvider, bool>((p) => p.isSaving);
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: !_isDirty || isSaving,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit Expense' : 'Add Expense'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ResponsiveCenter(
              maxWidth: AppSpacing.maxFormWidth,
              child: Form(
                key: _formKey,
                autovalidateMode: _submitted
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      enabled: !isSaving,
                      maxLength: Validators.titleMaxLength,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g. Lunch with team',
                        prefixIcon: Icon(Icons.edit_note_outlined),
                      ),
                      validator: Validators.title,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _amountController,
                      enabled: !isSaving,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                        LengthLimitingTextInputFormatter(13),
                      ],
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _save(),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$ ',
                        prefixIcon: Icon(Icons.payments_outlined),
                      ),
                      validator: Validators.amount,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Category', style: textTheme.labelLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final category in Expense.categories)
                          ChoiceChip(
                            avatar: Icon(
                              CategoryStyle.of(category).icon,
                              size: 18,
                              color: CategoryStyle.of(category).color,
                            ),
                            label: Text(category),
                            selected: _category == category,
                            showCheckmark: false,
                            onSelected: isSaving
                                ? null
                                : (_) {
                                    setState(() => _category = category);
                                    _updateDirty();
                                  },
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text('Date', style: textTheme.labelLarge),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: isSaving ? null : _pickDate,
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: Text(
                        '${formatFriendlyDate(_date)} · ${formatDate(_date)}',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    LoadingButton(
                      label: widget.isEditing ? 'Save Changes' : 'Add Expense',
                      isLoading: isSaving,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
