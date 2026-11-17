import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/adaptive_modal.dart';
import '../../../domain/services/calculator_engine.dart';
import '../../../l10n/app_localizations.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, this.embedInSheet = false});

  /// When true, shows a "Use result" action and pops with the result string.
  final bool embedInSheet;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _display = '0';
  String? _error;
  final List<String> _history = [];
  late CalculatorEngine _engine;
  late String _decimalSep;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context).toString();
    final symbols = NumberFormat.decimalPattern(locale).symbols;
    _decimalSep = symbols.DECIMAL_SEP;
    _engine = CalculatorEngine(decimalSeparator: _decimalSep);
    _ready = true;
  }

  void _append(String value) {
    setState(() {
      _error = null;
      if (_expression.isEmpty &&
          value != _decimalSep &&
          value != '%' &&
          !RegExp(r'[+\-×÷*/()]').hasMatch(value)) {
        _expression = value;
      } else {
        _expression += value;
      }
      _display = _expression.isEmpty ? '0' : _expression;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _display = '0';
      _error = null;
    });
  }

  void _backspace() {
    if (_expression.isEmpty) return;
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
      _display = _expression.isEmpty ? '0' : _expression;
      _error = null;
    });
  }

  CalcResult _evaluateCurrent() {
    return _engine.evaluate(_expression.isEmpty ? '0' : _expression);
  }

  void _equals() {
    final l10n = AppLocalizations.of(context);
    final result = _evaluateCurrent();
    setState(() {
      switch (result) {
        case CalcSuccess(:final value):
          final formatted = _engine.formatResult(value);
          _history.insert(0, '$_expression = $formatted');
          if (_history.length > 20) {
            _history.removeLast();
          }
          _expression = formatted;
          _display = formatted;
          _error = null;
        case CalcError(:final code):
          _error = switch (code) {
            CalcErrorCode.divisionByZero => l10n.calcDivisionByZero,
            CalcErrorCode.empty => l10n.calcEmpty,
            CalcErrorCode.invalid => l10n.calcInvalidExpression,
          };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (!_ready) return const SizedBox.shrink();

    final body = Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_history.isNotEmpty) ...[
                  Row(
                    children: [
                      Text(l10n.calcHistory, style: theme.textTheme.labelLarge),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setState(_history.clear),
                        child: Text(l10n.calcClearHistory),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 72,
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, i) => Text(
                        _history[i],
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  _display,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_error != null)
                  Text(
                    _error!,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
        _Keypad(
          decimalSeparator: _decimalSep,
          onKey: (k) {
            switch (k) {
              case 'C':
                _clear();
              case '⌫':
                _backspace();
              case '=':
                _equals();
              default:
                _append(k);
            }
          },
        ),
        if (widget.embedInSheet)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: FilledButton(
              onPressed: () {
                final result = _evaluateCurrent();
                if (result is CalcError) {
                  _equals();
                  return;
                }
                final value = (result as CalcSuccess).value;
                Navigator.pop(context, _engine.formatResult(value));
              },
              child: Text(l10n.useResult),
            ),
          ),
      ],
    );

    if (widget.embedInSheet) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.85,
        child: body,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.calculator)),
      body: body,
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onKey, required this.decimalSeparator});

  final ValueChanged<String> onKey;
  final String decimalSeparator;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['C', '(', ')', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['%', '0', decimalSeparator, '='],
      ['⌫'],
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        children: [
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  for (final key in row)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _CalcKey(
                          label: key,
                          onTap: () => onKey(key),
                          emphasize: key == '=',
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CalcKey extends StatelessWidget {
  const _CalcKey({
    required this.label,
    required this.onTap,
    this.emphasize = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = emphasize
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHighest;
    final fg =
        emphasize ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return SizedBox(
      height: 52,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> showAmountCalculatorSheet(BuildContext context) {
  return showAdaptiveModal<String>(
    context: context,
    dialogMaxWidth: 420,
    builder: (ctx) => const CalculatorPage(embedInSheet: true),
  );
}
