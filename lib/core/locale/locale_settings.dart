import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../currency/iso_currencies.dart';

const kPrefLocale = 'app_locale';
const kPrefBaseCurrency = 'base_currency';
const kPrefNativeDigits = 'native_digits';
const kPrefOnboardingDone = 'onboarding_done';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override sharedPreferencesProvider in main()');
});

/// null = follow device language.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString(kPrefLocale);
    if (code == null || code.isEmpty || code == 'system') return null;
    return Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.setString(kPrefLocale, 'system');
      state = null;
    } else {
      await prefs.setString(kPrefLocale, locale.languageCode);
      state = locale;
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);

class BaseCurrencyNotifier extends Notifier<String> {
  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(kPrefBaseCurrency) ?? 'PKR';
  }

  Future<void> setCurrency(String code) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final normalized = code.toUpperCase();
    await prefs.setString(kPrefBaseCurrency, normalized);
    state = normalized;
  }
}

final baseCurrencyProvider = NotifierProvider<BaseCurrencyNotifier, String>(
  BaseCurrencyNotifier.new,
);

class NativeDigitsNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(kPrefNativeDigits) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(kPrefNativeDigits, enabled);
    state = enabled;
  }
}

final nativeDigitsProvider = NotifierProvider<NativeDigitsNotifier, bool>(
  NativeDigitsNotifier.new,
);

class OnboardingDoneNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(kPrefOnboardingDone) ?? false;
  }

  Future<void> complete() => setDone(true);

  Future<void> setDone(bool done) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(kPrefOnboardingDone, done);
    state = done;
  }
}

final onboardingDoneProvider =
    NotifierProvider<OnboardingDoneNotifier, bool>(OnboardingDoneNotifier.new);

/// Suggests a base currency from the device locale.
String defaultCurrencyForDeviceLocale(Locale locale) {
  final country = locale.countryCode?.toUpperCase();
  final lang = locale.languageCode.toLowerCase();
  const byCountry = {
    'PK': 'PKR',
    'US': 'USD',
    'GB': 'GBP',
    'IN': 'INR',
    'AE': 'AED',
    'SA': 'SAR',
    'BD': 'BDT',
    'TR': 'TRY',
    'ID': 'IDR',
    'CN': 'CNY',
    'RU': 'RUB',
    'BR': 'BRL',
    'MX': 'MXN',
    'JP': 'JPY',
    'KR': 'KRW',
    'EU': 'EUR',
    'DE': 'EUR',
    'FR': 'EUR',
    'ES': 'EUR',
    'PT': 'EUR',
    'AU': 'AUD',
    'CA': 'CAD',
    'NZ': 'NZD',
    'SG': 'SGD',
    'MY': 'MYR',
    'TH': 'THB',
    'PH': 'PHP',
    'EG': 'EGP',
    'KW': 'KWD',
    'QA': 'QAR',
    'OM': 'OMR',
    'CH': 'CHF',
    'ZA': 'ZAR',
    'HK': 'HKD',
  };
  if (country != null && byCountry.containsKey(country)) {
    return byCountry[country]!;
  }
  return switch (lang) {
    'ur' => 'PKR',
    'ar' => 'AED',
    'hi' => 'INR',
    'bn' => 'BDT',
    'tr' => 'TRY',
    'id' => 'IDR',
    'zh' => 'CNY',
    'ru' => 'RUB',
    'pt' => 'BRL',
    'es' => 'EUR',
    'fr' => 'EUR',
    'de' => 'EUR',
    _ => 'USD',
  };
}

bool isSupportedLanguageCode(String code) {
  const supported = {
    'en',
    'ur',
    'ar',
    'hi',
    'bn',
    'es',
    'fr',
    'de',
    'tr',
    'id',
    'zh',
    'ru',
    'pt',
  };
  return supported.contains(code);
}

String languageDisplayName(String code) {
  return switch (code) {
    'en' => 'English',
    'ur' => 'اردو',
    'ar' => 'العربية',
    'hi' => 'हिन्दी',
    'bn' => 'বাংলা',
    'es' => 'Español',
    'fr' => 'Français',
    'de' => 'Deutsch',
    'tr' => 'Türkçe',
    'id' => 'Bahasa Indonesia',
    'zh' => '中文',
    'ru' => 'Русский',
    'pt' => 'Português',
    _ => code,
  };
}

List<Locale> get appSupportedLocales => const [
      Locale('en'),
      Locale('ur'),
      Locale('ar'),
      Locale('hi'),
      Locale('bn'),
      Locale('es'),
      Locale('fr'),
      Locale('de'),
      Locale('tr'),
      Locale('id'),
      Locale('zh'),
      Locale('ru'),
      Locale('pt'),
    ];

/// Effective locale used for formatting (never null).
Locale effectiveLocale(Locale? override, Locale device) {
  if (override != null) return override;
  if (isSupportedLanguageCode(device.languageCode)) {
    return Locale(device.languageCode);
  }
  return const Locale('en');
}

String currencyLabel(String code) {
  final info = IsoCurrencies.byCode(code);
  if (info == null) return code;
  return '${info.code} — ${info.name}';
}
