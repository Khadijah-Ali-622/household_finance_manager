import '../../l10n/app_localizations.dart';
import '../../domain/models/category.dart';

/// Translates default category names; custom categories keep stored text.
String localizedCategoryName(AppLocalizations l10n, Category category) {
  if (!category.isDefault) return category.name;
  return switch (category.id) {
    'cat-rashan' => l10n.cat_rashan,
    'cat-sabzi' => l10n.cat_sabzi,
    'cat-bijli' => l10n.cat_bijli,
    'cat-gas' => l10n.cat_gas,
    'cat-kiraya' => l10n.cat_kiraya,
    'cat-school' => l10n.cat_school,
    'cat-dawai' => l10n.cat_dawai,
    'cat-petrol' => l10n.cat_petrol,
    'cat-internet' => l10n.cat_internet,
    'cat-mobile' => l10n.cat_mobile,
    'cat-eid' => l10n.cat_eid,
    'cat-transport' => l10n.cat_transport,
    'cat-eating' => l10n.cat_eating,
    'cat-other-expense' => l10n.cat_other_expense,
    'cat-salary' => l10n.cat_salary,
    'cat-bonus' => l10n.cat_bonus,
    'cat-business' => l10n.cat_business,
    'cat-other-income' => l10n.cat_other_income,
    _ => category.name,
  };
}
