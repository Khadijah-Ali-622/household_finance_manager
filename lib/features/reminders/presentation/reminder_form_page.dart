import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/currency/iso_currencies.dart';
import '../../../core/l10n/category_l10n.dart';
import '../../../core/locale/locale_settings.dart';
import '../../../core/widgets/currency_picker_sheet.dart';
import '../../../core/widgets/form_page_body.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../domain/enums/category_type.dart';
import '../../../domain/enums/reminder_repeat.dart';
import '../../../domain/enums/reminder_type.dart';
import '../../../domain/models/money_amount.dart';
import '../../../domain/services/reminder_scheduler.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers.dart';
import 'reminder_labels.dart';

class ReminderFormPage extends ConsumerStatefulWidget {
  const ReminderFormPage({super.key, this.reminderId});

  final String? reminderId;

  @override
  ConsumerState<ReminderFormPage> createState() => _ReminderFormPageState();
}

class _ReminderFormPageState extends ConsumerState<ReminderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _daysCtrl = TextEditingController(text: '0');

  ReminderType _type = ReminderType.bill;
  ReminderRepeat? _repeat;
  String? _walletId;
  String? _categoryId;
  String _currency = 'PKR';
  DateTime _due = ReminderScheduler.dateOnly(DateTime.now());
  int _minutes = ReminderScheduler.defaultTimeMinutes;
  bool _loading = false;
  bool _ready = false;
  bool _missing = false;

  bool get _isSystemType =>
      _type == ReminderType.recurring || _type == ReminderType.budget;

  bool get _isDaily => _type == ReminderType.dailyExpense;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _daysCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.reminderId == null) {
      final base = ref.read(baseCurrencyProvider);
      if (!mounted) return;
      setState(() {
        _currency = base;
        _ready = true;
      });
      return;
    }

    final reminder = await ref
        .read(reminderRepositoryProvider)
        .getById(widget.reminderId!);
    if (!mounted) return;
    if (reminder == null) {
      setState(() {
        _missing = true;
        _ready = true;
      });
      return;
    }
    setState(() {
      _type = reminder.type;
      _repeat = reminder.repeat;
      _walletId = reminder.walletId;
      _categoryId = reminder.categoryId;
      _currency = reminder.currency;
      _due = ReminderScheduler.dateOnly(reminder.dueDate);
      _minutes = reminder.dailyTimeMinutes ?? _minutes;
      _titleCtrl.text = reminder.title;
      _noteCtrl.text = reminder.note ?? '';
      _daysCtrl.text = reminder.remindDaysBefore.toString();
      final amount = reminder.amount;
      if (amount != null) {
        _amountCtrl.text = _formatMinor(amount.minorUnits, reminder.currency);
      }
      _ready = true;
    });
  }

  String _formatMinor(int minor, String currency) {
    final digits = IsoCurrencies.decimalDigits(currency);
    final factor = MoneyAmount.factor(digits);
    if (minor % factor == 0) return (minor ~/ factor).toString();
    return MoneyAmount(minor).toMajor(digits).toStringAsFixed(digits);
  }

  MoneyAmount? _parseAmount() {
    final raw = _amountCtrl.text.trim();
    if (raw.isEmpty) return null;
    return MoneyAmount.fromMajorString(
      raw,
      fractionDigits: IsoCurrencies.decimalDigits(_currency),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _due,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _due = ReminderScheduler.dateOnly(picked));
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minutes ~/ 60, minute: _minutes % 60),
    );
    if (picked == null) return;
    setState(() => _minutes = picked.hour * 60 + picked.minute);
  }

  String _dateLabel(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _loading = true);
    try {
      await ref
          .read(reminderRepositoryProvider)
          .save(
            id: widget.reminderId,
            title: _titleCtrl.text,
            amount: _parseAmount(),
            currency: _currency,
            note: _noteCtrl.text,
            dueDate: _due,
            repeat: _isDaily ? ReminderRepeat.daily : _repeat,
            remindDaysBefore: int.tryParse(_daysCtrl.text.trim()) ?? 0,
            dailyTimeMinutes: _minutes,
            walletId: _walletId,
            categoryId: _categoryId,
            type: _type,
          );
      await ref.read(syncReminderNotificationsProvider)();
      if (mounted) context.pop();
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_ready) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.reminderId == null ? l10n.addReminder : l10n.editReminder,
          ),
        ),
        body: LoadingState(message: l10n.loading),
      );
    }
    if (_missing) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.editReminder)),
        body: Center(child: Text(l10n.errorGeneric)),
      );
    }

    final wallets = ref.watch(allWalletsProvider).value ?? const [];
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final expenseCategories = categories
        .where((item) => item.type == CategoryType.expense && !item.isDeleted)
        .toList();
    final walletOk = wallets.any((item) => item.id == _walletId);
    final categoryOk = expenseCategories.any((item) => item.id == _categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reminderId == null ? l10n.addReminder : l10n.editReminder,
        ),
      ),
      body: FormPageBody(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isSystemType)
                InputDecorator(
                  decoration: InputDecoration(labelText: l10n.reminderType),
                  child: Text(reminderTypeLabel(l10n, _type)),
                )
              else
                SegmentedButton<ReminderType>(
                  segments: [
                    ButtonSegment(
                      value: ReminderType.bill,
                      label: Text(l10n.reminderTypeBill),
                    ),
                    ButtonSegment(
                      value: ReminderType.dailyExpense,
                      label: Text(l10n.reminderTypeDailyExpense),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (value) {
                    setState(() => _type = value.first);
                  },
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(labelText: l10n.reminderTitle),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountCtrl,
                decoration: InputDecoration(
                  labelText: l10n.amount,
                  hintText: l10n.optional,
                  suffixText: _currency,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  final raw = value?.trim() ?? '';
                  if (raw.isEmpty) return null;
                  final amount = _parseAmount();
                  if (amount == null || amount.minorUnits <= 0) {
                    return l10n.amountMustBePositive;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.currency),
                subtitle: Text(
                  IsoCurrencies.byCode(_currency)?.code ?? _currency,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final code = await showCurrencyPicker(
                    context,
                    selectedCode: _currency,
                  );
                  if (code == null) return;
                  setState(() => _currency = code);
                },
              ),
              if (!_isDaily) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.dueDate),
                  subtitle: Text(_dateLabel(_due)),
                  trailing: const Icon(Icons.event),
                  onTap: _pickDate,
                ),
                DropdownButtonFormField<String>(
                  key: ValueKey('repeat-${_repeat?.name}'),
                  initialValue: _repeat?.storageValue ?? 'none',
                  decoration: InputDecoration(labelText: l10n.repeat),
                  items: [
                    DropdownMenuItem(
                      value: 'none',
                      child: Text(l10n.repeatNone),
                    ),
                    for (final repeat in ReminderRepeat.values)
                      DropdownMenuItem(
                        value: repeat.storageValue,
                        child: Text(reminderRepeatLabel(l10n, repeat)),
                      ),
                  ],
                  onChanged: (value) => setState(() {
                    _repeat = ReminderRepeat.fromStorage(value);
                  }),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _daysCtrl,
                  decoration: InputDecoration(labelText: l10n.remindDaysBefore),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final raw = value?.trim() ?? '';
                    if (raw.isEmpty) return null;
                    final parsed = int.tryParse(raw);
                    if (parsed == null || parsed < 0) {
                      return l10n.fieldRequired;
                    }
                    return null;
                  },
                ),
              ],
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.reminderTime),
                subtitle: Text(reminderClockLabel(context, _minutes)),
                trailing: const Icon(Icons.schedule),
                onTap: _pickTime,
              ),
              DropdownButtonFormField<String>(
                key: ValueKey('wallet-$_walletId'),
                initialValue: walletOk ? _walletId! : '',
                decoration: InputDecoration(labelText: l10n.wallets),
                items: [
                  DropdownMenuItem(value: '', child: Text(l10n.none)),
                  for (final wallet in wallets)
                    DropdownMenuItem(
                      value: wallet.id,
                      child: Text('${wallet.name} (${wallet.currency})'),
                    ),
                ],
                onChanged: (value) {
                  final id = (value == null || value.isEmpty) ? null : value;
                  final wallet = wallets
                      .where((item) => item.id == id)
                      .firstOrNull;
                  setState(() {
                    _walletId = id;
                    if (wallet != null) _currency = wallet.currency;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey('category-$_categoryId'),
                initialValue: categoryOk ? _categoryId! : '',
                decoration: InputDecoration(labelText: l10n.category),
                items: [
                  DropdownMenuItem(value: '', child: Text(l10n.none)),
                  for (final category in expenseCategories)
                    DropdownMenuItem(
                      value: category.id,
                      child: Text(localizedCategoryName(l10n, category)),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _categoryId = (value == null || value.isEmpty)
                        ? null
                        : value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteCtrl,
                decoration: InputDecoration(labelText: l10n.note),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _save,
                child: Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
