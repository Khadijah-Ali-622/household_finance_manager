import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('ur'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Household Finance'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navWallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get navWallets;

  /// No description provided for @navAssetsLiabilities.
  ///
  /// In en, this message translates to:
  /// **'Assets & Debts'**
  String get navAssetsLiabilities;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @thisMonthIncome.
  ///
  /// In en, this message translates to:
  /// **'This Month Income'**
  String get thisMonthIncome;

  /// No description provided for @thisMonthExpense.
  ///
  /// In en, this message translates to:
  /// **'This Month Expense'**
  String get thisMonthExpense;

  /// No description provided for @netWorth.
  ///
  /// In en, this message translates to:
  /// **'Net Worth'**
  String get netWorth;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWallet;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit Wallet'**
  String get editWallet;

  /// No description provided for @archiveWallet.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveWallet;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening Balance'**
  String get openingBalance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @fromWallet.
  ///
  /// In en, this message translates to:
  /// **'From Wallet'**
  String get fromWallet;

  /// No description provided for @toWallet.
  ///
  /// In en, this message translates to:
  /// **'To Wallet'**
  String get toWallet;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @emptyWallets.
  ///
  /// In en, this message translates to:
  /// **'No wallets yet. Create your first wallet.'**
  String get emptyWallets;

  /// No description provided for @emptyTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get emptyTransactions;

  /// No description provided for @emptyAssets.
  ///
  /// In en, this message translates to:
  /// **'No assets yet.'**
  String get emptyAssets;

  /// No description provided for @emptyLiabilities.
  ///
  /// In en, this message translates to:
  /// **'No liabilities yet.'**
  String get emptyLiabilities;

  /// No description provided for @emptyGroups.
  ///
  /// In en, this message translates to:
  /// **'No wallet groups yet.'**
  String get emptyGroups;

  /// No description provided for @walletGroups.
  ///
  /// In en, this message translates to:
  /// **'Wallet Groups'**
  String get walletGroups;

  /// No description provided for @combinedView.
  ///
  /// In en, this message translates to:
  /// **'Combined View'**
  String get combinedView;

  /// No description provided for @quickSelect.
  ///
  /// In en, this message translates to:
  /// **'Quick Select'**
  String get quickSelect;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @liabilities.
  ///
  /// In en, this message translates to:
  /// **'Liabilities'**
  String get liabilities;

  /// No description provided for @currentValue.
  ///
  /// In en, this message translates to:
  /// **'Current Value'**
  String get currentValue;

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining Amount'**
  String get remainingAmount;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Spending Categories'**
  String get topCategories;

  /// No description provided for @incomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get incomeVsExpense;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @walletBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Wallet Breakdown'**
  String get walletBreakdown;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @selectWallets.
  ///
  /// In en, this message translates to:
  /// **'Select Wallets'**
  String get selectWallets;

  /// No description provided for @perWalletBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Per-wallet breakdown'**
  String get perWalletBreakdown;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @phase2Coming.
  ///
  /// In en, this message translates to:
  /// **'Coming in Phase 2'**
  String get phase2Coming;

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add Asset'**
  String get addAsset;

  /// No description provided for @addLiability.
  ///
  /// In en, this message translates to:
  /// **'Add Liability'**
  String get addLiability;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit Asset'**
  String get editAsset;

  /// No description provided for @editLiability.
  ///
  /// In en, this message translates to:
  /// **'Edit Liability'**
  String get editLiability;

  /// No description provided for @pieChart.
  ///
  /// In en, this message translates to:
  /// **'Pie'**
  String get pieChart;

  /// No description provided for @barChart.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get barChart;

  /// No description provided for @emptyStats.
  ///
  /// In en, this message translates to:
  /// **'No income or expenses in this period.'**
  String get emptyStats;

  /// No description provided for @walletFilter.
  ///
  /// In en, this message translates to:
  /// **'Wallet filter'**
  String get walletFilter;

  /// No description provided for @allWallets.
  ///
  /// In en, this message translates to:
  /// **'All wallets'**
  String get allWallets;

  /// No description provided for @selectedWallets.
  ///
  /// In en, this message translates to:
  /// **'Choose wallets…'**
  String get selectedWallets;

  /// No description provided for @weekStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Week starts on'**
  String get weekStartsOn;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @periodWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get periodMonthly;

  /// No description provided for @periodAnnually.
  ///
  /// In en, this message translates to:
  /// **'Annually'**
  String get periodAnnually;

  /// No description provided for @periodCustom.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get periodCustom;

  /// No description provided for @sectionTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get sectionTools;

  /// No description provided for @sectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get sectionPreferences;

  /// No description provided for @sectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sectionSecurity;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get sectionData;

  /// No description provided for @sectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get sectionAbout;

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// No description provided for @currencyExchange.
  ///
  /// In en, this message translates to:
  /// **'Currency & exchange rates'**
  String get currencyExchange;

  /// No description provided for @currencyExchangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon — manage rates and conversions.'**
  String get currencyExchangeSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @securitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'PIN and app lock'**
  String get securitySubtitle;

  /// No description provided for @statsSettings.
  ///
  /// In en, this message translates to:
  /// **'Stats settings'**
  String get statsSettings;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save a copy on this device or in your Google Drive.'**
  String get backupSubtitle;

  /// No description provided for @useResult.
  ///
  /// In en, this message translates to:
  /// **'Use result'**
  String get useResult;

  /// No description provided for @calcHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get calcHistory;

  /// No description provided for @calcClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get calcClearHistory;

  /// No description provided for @calcDivisionByZero.
  ///
  /// In en, this message translates to:
  /// **'Cannot divide by zero'**
  String get calcDivisionByZero;

  /// No description provided for @calcInvalidExpression.
  ///
  /// In en, this message translates to:
  /// **'Invalid expression'**
  String get calcInvalidExpression;

  /// No description provided for @calcEmpty.
  ///
  /// In en, this message translates to:
  /// **'Enter an expression'**
  String get calcEmpty;

  /// No description provided for @pinLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get pinLock;

  /// No description provided for @pinEnabled.
  ///
  /// In en, this message translates to:
  /// **'PIN enabled'**
  String get pinEnabled;

  /// No description provided for @pinDisabled.
  ///
  /// In en, this message translates to:
  /// **'PIN not set'**
  String get pinDisabled;

  /// No description provided for @setPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @removePin.
  ///
  /// In en, this message translates to:
  /// **'Remove PIN'**
  String get removePin;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// No description provided for @enterCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get enterCurrentPin;

  /// No description provided for @enterNewPin.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN'**
  String get enterNewPin;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsDoNotMatch;

  /// No description provided for @invalidPinLength.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 4 or 6 digits'**
  String get invalidPinLength;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get wrongPin;

  /// No description provided for @pinSetSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN saved'**
  String get pinSetSuccess;

  /// No description provided for @pinRemoved.
  ///
  /// In en, this message translates to:
  /// **'PIN removed'**
  String get pinRemoved;

  /// No description provided for @autoLock.
  ///
  /// In en, this message translates to:
  /// **'Lock after'**
  String get autoLock;

  /// No description provided for @autoLockImmediate.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get autoLockImmediate;

  /// No description provided for @autoLock1Min.
  ///
  /// In en, this message translates to:
  /// **'1 minute'**
  String get autoLock1Min;

  /// No description provided for @autoLock5Min.
  ///
  /// In en, this message translates to:
  /// **'5 minutes'**
  String get autoLock5Min;

  /// No description provided for @biometricUnlock.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock'**
  String get biometricUnlock;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Household Finance'**
  String get biometricReason;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get forgotPin;

  /// No description provided for @forgotPinWarning.
  ///
  /// In en, this message translates to:
  /// **'Resetting the PIN erases all local data on this device. A Google Drive backup is not restored automatically. If you have a backup, restore it from Backup after you set a new PIN.'**
  String get forgotPinWarning;

  /// No description provided for @forgotPinConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase all local data?'**
  String get forgotPinConfirmTitle;

  /// No description provided for @forgotPinConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will delete wallets, transactions, and settings on this device, then remove the PIN. This cannot be undone.'**
  String get forgotPinConfirmBody;

  /// No description provided for @forgotPinConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Erase data & reset PIN'**
  String get forgotPinConfirmAction;

  /// No description provided for @typeEraseToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Type ERASE to confirm'**
  String get typeEraseToConfirm;

  /// No description provided for @lockoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds} seconds.'**
  String lockoutMessage(int seconds);

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get unlockTitle;

  /// No description provided for @unlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to continue'**
  String get unlockSubtitle;

  /// No description provided for @attemptsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} attempts remaining'**
  String attemptsRemaining(int count);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @useDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get useDeviceLanguage;

  /// No description provided for @baseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get baseCurrency;

  /// No description provided for @exchangeRates.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get exchangeRates;

  /// No description provided for @refreshRates.
  ///
  /// In en, this message translates to:
  /// **'Refresh rates'**
  String get refreshRates;

  /// No description provided for @ratesLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Rates last updated: {date}'**
  String ratesLastUpdated(String date);

  /// No description provided for @ratesRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh exchange rates.'**
  String get ratesRefreshFailed;

  /// No description provided for @ratesRefreshSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates updated.'**
  String get ratesRefreshSuccess;

  /// No description provided for @amountSent.
  ///
  /// In en, this message translates to:
  /// **'Amount sent'**
  String get amountSent;

  /// No description provided for @amountReceived.
  ///
  /// In en, this message translates to:
  /// **'Amount received'**
  String get amountReceived;

  /// No description provided for @searchCurrency.
  ///
  /// In en, this message translates to:
  /// **'Search currency'**
  String get searchCurrency;

  /// No description provided for @popularCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Popular currencies'**
  String get popularCurrencies;

  /// No description provided for @allCurrencies.
  ///
  /// In en, this message translates to:
  /// **'All currencies'**
  String get allCurrencies;

  /// No description provided for @nativeDigits.
  ///
  /// In en, this message translates to:
  /// **'Native digits'**
  String get nativeDigits;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your household finances in a few steps.'**
  String get onboardingSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose currency'**
  String get chooseCurrency;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero.'**
  String get amountMustBePositive;

  /// No description provided for @convertedApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount}'**
  String convertedApprox(String amount);

  /// No description provided for @inBaseCurrency.
  ///
  /// In en, this message translates to:
  /// **'In base currency'**
  String get inBaseCurrency;

  /// No description provided for @editRate.
  ///
  /// In en, this message translates to:
  /// **'Edit rate'**
  String get editRate;

  /// No description provided for @fromCurrency.
  ///
  /// In en, this message translates to:
  /// **'From currency'**
  String get fromCurrency;

  /// No description provided for @toCurrency.
  ///
  /// In en, this message translates to:
  /// **'To currency'**
  String get toCurrency;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @noExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'No exchange rate available.'**
  String get noExchangeRate;

  /// No description provided for @currencySettings.
  ///
  /// In en, this message translates to:
  /// **'Currency settings'**
  String get currencySettings;

  /// No description provided for @lastUpdatedNever.
  ///
  /// In en, this message translates to:
  /// **'Never updated'**
  String get lastUpdatedNever;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Version, privacy, and credits'**
  String get aboutSubtitle;

  /// No description provided for @phase2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets, recurring, reminders'**
  String get phase2Subtitle;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @jazzcash.
  ///
  /// In en, this message translates to:
  /// **'JazzCash'**
  String get jazzcash;

  /// No description provided for @easypaisa.
  ///
  /// In en, this message translates to:
  /// **'Easypaisa'**
  String get easypaisa;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get creditCard;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @cat_rashan.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get cat_rashan;

  /// No description provided for @cat_sabzi.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get cat_sabzi;

  /// No description provided for @cat_bijli.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get cat_bijli;

  /// No description provided for @cat_gas.
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get cat_gas;

  /// No description provided for @cat_kiraya.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get cat_kiraya;

  /// No description provided for @cat_school.
  ///
  /// In en, this message translates to:
  /// **'School Fees'**
  String get cat_school;

  /// No description provided for @cat_dawai.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get cat_dawai;

  /// No description provided for @cat_petrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get cat_petrol;

  /// No description provided for @cat_internet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get cat_internet;

  /// No description provided for @cat_mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Load'**
  String get cat_mobile;

  /// No description provided for @cat_eid.
  ///
  /// In en, this message translates to:
  /// **'Eid/Shopping'**
  String get cat_eid;

  /// No description provided for @cat_transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get cat_transport;

  /// No description provided for @cat_eating.
  ///
  /// In en, this message translates to:
  /// **'Eating Out'**
  String get cat_eating;

  /// No description provided for @cat_other_expense.
  ///
  /// In en, this message translates to:
  /// **'Other Expense'**
  String get cat_other_expense;

  /// No description provided for @cat_salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get cat_salary;

  /// No description provided for @cat_bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get cat_bonus;

  /// No description provided for @cat_business.
  ///
  /// In en, this message translates to:
  /// **'Business Income'**
  String get cat_business;

  /// No description provided for @cat_other_income.
  ///
  /// In en, this message translates to:
  /// **'Other Income'**
  String get cat_other_income;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @addBudget.
  ///
  /// In en, this message translates to:
  /// **'Add Budget'**
  String get addBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit Budget'**
  String get editBudget;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @rollover.
  ///
  /// In en, this message translates to:
  /// **'Rollover'**
  String get rollover;

  /// No description provided for @rolloverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Carry unused amount from last month'**
  String get rolloverSubtitle;

  /// No description provided for @overallBudget.
  ///
  /// In en, this message translates to:
  /// **'Overall budget'**
  String get overallBudget;

  /// No description provided for @emptyBudgets.
  ///
  /// In en, this message translates to:
  /// **'No budgets for this month yet.'**
  String get emptyBudgets;

  /// No description provided for @budgetAlmostUsed.
  ///
  /// In en, this message translates to:
  /// **'Almost used'**
  String get budgetAlmostUsed;

  /// No description provided for @budgetExceeded.
  ///
  /// In en, this message translates to:
  /// **'Budget exceeded'**
  String get budgetExceeded;

  /// No description provided for @notify80.
  ///
  /// In en, this message translates to:
  /// **'Notify at 80%'**
  String get notify80;

  /// No description provided for @notifyOver.
  ///
  /// In en, this message translates to:
  /// **'Notify when exceeded'**
  String get notifyOver;

  /// No description provided for @allWalletsHint.
  ///
  /// In en, this message translates to:
  /// **'Leave unselected to include every wallet.'**
  String get allWalletsHint;

  /// No description provided for @budgetNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get budgetNameOptional;

  /// No description provided for @deleteBudget.
  ///
  /// In en, this message translates to:
  /// **'Delete budget'**
  String get deleteBudget;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @viewBudgets.
  ///
  /// In en, this message translates to:
  /// **'View budgets'**
  String get viewBudgets;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @addRecurring.
  ///
  /// In en, this message translates to:
  /// **'Add recurring'**
  String get addRecurring;

  /// No description provided for @editRecurring.
  ///
  /// In en, this message translates to:
  /// **'Edit recurring'**
  String get editRecurring;

  /// No description provided for @emptyRecurring.
  ///
  /// In en, this message translates to:
  /// **'No recurring transactions yet.'**
  String get emptyRecurring;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @frequencyDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get frequencyDaily;

  /// No description provided for @frequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get frequencyWeekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get frequencyMonthly;

  /// No description provided for @frequencyYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get frequencyYearly;

  /// No description provided for @frequencyCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get frequencyCustom;

  /// No description provided for @everyInterval.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get everyInterval;

  /// No description provided for @customUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get customUnit;

  /// No description provided for @unitDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get unitDays;

  /// No description provided for @unitWeeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get unitWeeks;

  /// No description provided for @unitMonths.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get unitMonths;

  /// No description provided for @unitYears.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get unitYears;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @noEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get noEndDate;

  /// No description provided for @clearEndDate.
  ///
  /// In en, this message translates to:
  /// **'Clear end date'**
  String get clearEndDate;

  /// No description provided for @recurringMode.
  ///
  /// In en, this message translates to:
  /// **'When due'**
  String get recurringMode;

  /// No description provided for @modeAuto.
  ///
  /// In en, this message translates to:
  /// **'Add automatically'**
  String get modeAuto;

  /// No description provided for @modeAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask me first'**
  String get modeAsk;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @templateStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get templateStandard;

  /// No description provided for @templateCommittee.
  ///
  /// In en, this message translates to:
  /// **'Committee'**
  String get templateCommittee;

  /// No description provided for @templateInstallment.
  ///
  /// In en, this message translates to:
  /// **'Installment'**
  String get templateInstallment;

  /// No description provided for @installmentCount.
  ///
  /// In en, this message translates to:
  /// **'Number of installments'**
  String get installmentCount;

  /// No description provided for @nextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get nextDue;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get addReminder;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get editReminder;

  /// No description provided for @emptyReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet.'**
  String get emptyReminders;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get dueSoon;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get markPaid;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get markDone;

  /// No description provided for @remindDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'Remind days before'**
  String get remindDaysBefore;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderTime;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get reminderTitle;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'Does not repeat'**
  String get repeatNone;

  /// No description provided for @reminderType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get reminderType;

  /// No description provided for @reminderTypeBill.
  ///
  /// In en, this message translates to:
  /// **'Bill'**
  String get reminderTypeBill;

  /// No description provided for @reminderTypeRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get reminderTypeRecurring;

  /// No description provided for @reminderTypeBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get reminderTypeBudget;

  /// No description provided for @reminderTypeDailyExpense.
  ///
  /// In en, this message translates to:
  /// **'Daily expenses'**
  String get reminderTypeDailyExpense;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @viewReminders.
  ///
  /// In en, this message translates to:
  /// **'View reminders'**
  String get viewReminders;

  /// No description provided for @noDueReminders.
  ///
  /// In en, this message translates to:
  /// **'Nothing due right now.'**
  String get noDueReminders;

  /// No description provided for @dailyExpenseReminder.
  ///
  /// In en, this message translates to:
  /// **'Add today\'s expenses'**
  String get dailyExpenseReminder;

  /// No description provided for @dailyExpenseReminderHint.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder to write down what you spent'**
  String get dailyExpenseReminderHint;

  /// No description provided for @overdueByDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days overdue'**
  String overdueByDays(int count);

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {count} days'**
  String dueInDays(int count);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @markPaidNeedsDetails.
  ///
  /// In en, this message translates to:
  /// **'Add an amount, wallet, and category before marking this paid.'**
  String get markPaidNeedsDetails;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get backupNow;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestore;

  /// No description provided for @backupSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get backupSignIn;

  /// No description provided for @backupSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get backupSignOut;

  /// No description provided for @backupSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get backupSignedIn;

  /// No description provided for @backupSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get backupSignedOut;

  /// No description provided for @backupGoogleDrive.
  ///
  /// In en, this message translates to:
  /// **'Google Drive'**
  String get backupGoogleDrive;

  /// No description provided for @backupLocal.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get backupLocal;

  /// No description provided for @backupAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup'**
  String get backupAuto;

  /// No description provided for @backupAutoHint.
  ///
  /// In en, this message translates to:
  /// **'Runs when the app is open, you are signed in, and the chosen time has passed.'**
  String get backupAutoHint;

  /// No description provided for @backupAutoOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get backupAutoOff;

  /// No description provided for @backupAutoDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get backupAutoDaily;

  /// No description provided for @backupAutoWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get backupAutoWeekly;

  /// No description provided for @backupEncryption.
  ///
  /// In en, this message translates to:
  /// **'Encrypt backups'**
  String get backupEncryption;

  /// No description provided for @backupEncryptionOn.
  ///
  /// In en, this message translates to:
  /// **'New backups use this password'**
  String get backupEncryptionOn;

  /// No description provided for @backupEncryptionOff.
  ///
  /// In en, this message translates to:
  /// **'Backups are stored without a password'**
  String get backupEncryptionOff;

  /// No description provided for @backupEncryptionWarning.
  ///
  /// In en, this message translates to:
  /// **'If you forget this password, this backup cannot be decrypted. There is no password reset and no way to recover the file.'**
  String get backupEncryptionWarning;

  /// No description provided for @backupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get backupPassword;

  /// No description provided for @backupConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get backupConfirmPassword;

  /// No description provided for @backupPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get backupPasswordMismatch;

  /// No description provided for @backupPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 4 characters.'**
  String get backupPasswordTooShort;

  /// No description provided for @backupExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get backupExportJson;

  /// No description provided for @backupImportJson.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get backupImportJson;

  /// No description provided for @backupExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get backupExportCsv;

  /// No description provided for @backupLastSummary.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {when} ({size})'**
  String backupLastSummary(String when, String size);

  /// No description provided for @backupNever.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get backupNever;

  /// No description provided for @backupReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace all data'**
  String get backupReplace;

  /// No description provided for @backupMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge by id'**
  String get backupMerge;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreBody.
  ///
  /// In en, this message translates to:
  /// **'A safety copy of your current data is saved on this device before anything changes. Replace removes current data and uses the backup. Merge keeps existing records and adds ones with new ids.'**
  String get backupRestoreBody;

  /// No description provided for @backupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup saved.'**
  String get backupSuccess;

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore finished. A safety copy of your previous data is on this device.'**
  String get backupRestoreSuccess;

  /// No description provided for @backupShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the share sheet. The file was still saved on this device.'**
  String get backupShareFailed;

  /// No description provided for @backupDriveUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google Drive is not available here. Use export on this device.'**
  String get backupDriveUnavailable;

  /// No description provided for @backupErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'You appear to be offline. Check your connection and try again.'**
  String get backupErrorOffline;

  /// No description provided for @backupErrorAuth.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in expired. Sign in again and retry.'**
  String get backupErrorAuth;

  /// No description provided for @backupErrorQuota.
  ///
  /// In en, this message translates to:
  /// **'Google Drive storage is full. Free some space and try again.'**
  String get backupErrorQuota;

  /// No description provided for @backupErrorCorrupt.
  ///
  /// In en, this message translates to:
  /// **'This backup file is corrupted or from a newer version and cannot be opened.'**
  String get backupErrorCorrupt;

  /// No description provided for @backupErrorPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password, or the file is damaged. If you forgot the password, this backup cannot be opened.'**
  String get backupErrorPassword;

  /// No description provided for @backupEmptyList.
  ///
  /// In en, this message translates to:
  /// **'No backups yet.'**
  String get backupEmptyList;

  /// No description provided for @backupChooseBackup.
  ///
  /// In en, this message translates to:
  /// **'Choose a backup'**
  String get backupChooseBackup;

  /// No description provided for @aboutAppName.
  ///
  /// In en, this message translates to:
  /// **'Household Finance Manager'**
  String get aboutAppName;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What this app does'**
  String get aboutWhatTitle;

  /// No description provided for @aboutWhatBody.
  ///
  /// In en, this message translates to:
  /// **'A simple household expense manager. Create unlimited wallets, track income, expenses and transfers, set budgets, schedule recurring payments, get bill reminders, and back up your data safely to Google Drive. Works on mobile and laptop.'**
  String get aboutWhatBody;

  /// No description provided for @aboutFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Key features'**
  String get aboutFeaturesTitle;

  /// No description provided for @aboutFeatureWallets.
  ///
  /// In en, this message translates to:
  /// **'Unlimited wallets in any currency'**
  String get aboutFeatureWallets;

  /// No description provided for @aboutFeatureTransactions.
  ///
  /// In en, this message translates to:
  /// **'Income, expenses, and transfers'**
  String get aboutFeatureTransactions;

  /// No description provided for @aboutFeatureBudgets.
  ///
  /// In en, this message translates to:
  /// **'Monthly budgets with alerts'**
  String get aboutFeatureBudgets;

  /// No description provided for @aboutFeatureRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring payments and bill reminders'**
  String get aboutFeatureRecurring;

  /// No description provided for @aboutFeatureBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup on this device and in your private Google Drive folder'**
  String get aboutFeatureBackup;

  /// No description provided for @aboutFeatureDevices.
  ///
  /// In en, this message translates to:
  /// **'Works offline on phone and laptop'**
  String get aboutFeatureDevices;

  /// No description provided for @aboutPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get aboutPrivacyTitle;

  /// No description provided for @aboutPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored on your device. Backups go only to your own Google Drive private app folder. We do not sell or share your data.'**
  String get aboutPrivacyBody;

  /// No description provided for @aboutDeveloperTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloperTitle;

  /// No description provided for @aboutDeveloperCredit.
  ///
  /// In en, this message translates to:
  /// **'Developed by Unique Roes'**
  String get aboutDeveloperCredit;

  /// No description provided for @aboutFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get aboutFeedback;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get aboutTerms;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'pt',
    'ru',
    'tr',
    'ur',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
