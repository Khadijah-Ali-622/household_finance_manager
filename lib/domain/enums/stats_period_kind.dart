enum StatsPeriodKind {
  weekly,
  monthly,
  annually,
  custom;

  String get label => switch (this) {
        StatsPeriodKind.weekly => 'Weekly',
        StatsPeriodKind.monthly => 'Monthly',
        StatsPeriodKind.annually => 'Annually',
        StatsPeriodKind.custom => 'Period',
      };
}

enum StatsChartType {
  pie,
  bar;
}

enum StatsFlow {
  income,
  expense;
}
