/// ISO 4217 currencies used for display symbols and minor-unit precision.
class CurrencyInfo {
  const CurrencyInfo({
    required this.code,
    required this.name,
    required this.symbol,
    required this.decimalDigits,
  });

  final String code;
  final String name;
  final String symbol;
  final int decimalDigits;
}

class IsoCurrencies {
  IsoCurrencies._();

  static const List<String> popularCodes = [
    'PKR',
    'USD',
    'EUR',
    'GBP',
    'INR',
    'AED',
    'SAR',
    'CAD',
    'AUD',
    'JPY',
    'CNY',
    'TRY',
    'IDR',
    'BRL',
    'RUB',
    'BDT',
    'EGP',
    'MYR',
    'SGD',
    'CHF',
    'NZD',
    'HKD',
    'KRW',
    'THB',
    'PHP',
    'MXN',
    'ZAR',
    'KWD',
    'QAR',
    'OMR',
  ];

  static const List<CurrencyInfo> all = [
    CurrencyInfo(
      code: 'AED',
      name: 'United Arab Emirates Dirham',
      symbol: 'د.إ',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'AFN',
      name: 'Afghan Afghani',
      symbol: '؋',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ALL',
      name: 'Albanian Lek',
      symbol: 'L',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'AMD',
      name: 'Armenian Dram',
      symbol: '֏',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ANG',
      name: 'Netherlands Antillean Guilder',
      symbol: 'ƒ',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'AOA',
      name: 'Angolan Kwanza',
      symbol: 'Kz',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ARS',
      name: 'Argentine Peso',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: r'A$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'AWG',
      name: 'Aruban Florin',
      symbol: 'ƒ',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'AZN',
      name: 'Azerbaijani Manat',
      symbol: '₼',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BAM',
      name: 'Bosnia-Herzegovina Convertible Mark',
      symbol: 'KM',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BBD',
      name: 'Barbadian Dollar',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BDT',
      name: 'Bangladeshi Taka',
      symbol: '৳',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BGN',
      name: 'Bulgarian Lev',
      symbol: 'лв',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BHD',
      name: 'Bahraini Dinar',
      symbol: 'BD',
      decimalDigits: 3,
    ),
    CurrencyInfo(
      code: 'BIF',
      name: 'Burundian Franc',
      symbol: 'FBu',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'BMD',
      name: 'Bermudian Dollar',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BND',
      name: 'Brunei Dollar',
      symbol: r'B$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BOB',
      name: 'Bolivian Boliviano',
      symbol: 'Bs',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BRL',
      name: 'Brazilian Real',
      symbol: r'R$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BSD',
      name: 'Bahamian Dollar',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BTN',
      name: 'Bhutanese Ngultrum',
      symbol: 'Nu.',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BWP',
      name: 'Botswana Pula',
      symbol: 'P',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BYN',
      name: 'Belarusian Ruble',
      symbol: 'Br',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'BZD',
      name: 'Belize Dollar',
      symbol: r'BZ$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: r'C$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CDF',
      name: 'Congolese Franc',
      symbol: 'FC',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'CHF',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CLP',
      name: 'Chilean Peso',
      symbol: r'$',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'COP',
      name: 'Colombian Peso',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CRC',
      name: 'Costa Rican Colón',
      symbol: '₡',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CUP',
      name: 'Cuban Peso',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CVE',
      name: 'Cape Verdean Escudo',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'CZK',
      name: 'Czech Koruna',
      symbol: 'Kč',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'DJF',
      name: 'Djiboutian Franc',
      symbol: 'Fdj',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'DKK',
      name: 'Danish Krone',
      symbol: 'kr',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'DOP',
      name: 'Dominican Peso',
      symbol: r'RD$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'DZD',
      name: 'Algerian Dinar',
      symbol: 'د.ج',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'EGP',
      name: 'Egyptian Pound',
      symbol: 'E£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ERN',
      name: 'Eritrean Nakfa',
      symbol: 'Nfk',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ETB',
      name: 'Ethiopian Birr',
      symbol: 'Br',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'FJD',
      name: 'Fijian Dollar',
      symbol: r'FJ$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'FKP',
      name: 'Falkland Islands Pound',
      symbol: '£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'GBP',
      name: 'British Pound Sterling',
      symbol: '£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'GEL',
      name: 'Georgian Lari',
      symbol: '₾',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'GHS',
      name: 'Ghanaian Cedi',
      symbol: '₵',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'GIP',
      name: 'Gibraltar Pound',
      symbol: '£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'GMD',
      name: 'Gambian Dalasi',
      symbol: 'D',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'GNF',
      name: 'Guinean Franc',
      symbol: 'FG',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'GTQ',
      name: 'Guatemalan Quetzal',
      symbol: 'Q',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'GYD',
      name: 'Guyanese Dollar',
      symbol: r'G$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'HKD',
      name: 'Hong Kong Dollar',
      symbol: r'HK$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'HNL',
      name: 'Honduran Lempira',
      symbol: 'L',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'HTG',
      name: 'Haitian Gourde',
      symbol: 'G',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'HUF',
      name: 'Hungarian Forint',
      symbol: 'Ft',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'IDR',
      name: 'Indonesian Rupiah',
      symbol: 'Rp',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ILS',
      name: 'Israeli New Shekel',
      symbol: '₪',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'IQD',
      name: 'Iraqi Dinar',
      symbol: 'ع.د',
      decimalDigits: 3,
    ),
    CurrencyInfo(
      code: 'IRR',
      name: 'Iranian Rial',
      symbol: '﷼',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ISK',
      name: 'Icelandic Króna',
      symbol: 'kr',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'JMD',
      name: 'Jamaican Dollar',
      symbol: r'J$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'JOD',
      name: 'Jordanian Dinar',
      symbol: 'JD',
      decimalDigits: 3,
    ),
    CurrencyInfo(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'KES',
      name: 'Kenyan Shilling',
      symbol: 'KSh',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'KGS',
      name: 'Kyrgyzstani Som',
      symbol: 'сом',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'KHR',
      name: 'Cambodian Riel',
      symbol: '៛',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'KMF',
      name: 'Comorian Franc',
      symbol: 'CF',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'KPW',
      name: 'North Korean Won',
      symbol: '₩',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'KWD',
      name: 'Kuwaiti Dinar',
      symbol: 'KD',
      decimalDigits: 3,
    ),
    CurrencyInfo(
      code: 'KYD',
      name: 'Cayman Islands Dollar',
      symbol: r'CI$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'KZT',
      name: 'Kazakhstani Tenge',
      symbol: '₸',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'LAK',
      name: 'Lao Kip',
      symbol: '₭',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'LBP',
      name: 'Lebanese Pound',
      symbol: 'L£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'LKR',
      name: 'Sri Lankan Rupee',
      symbol: 'Rs',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'LRD',
      name: 'Liberian Dollar',
      symbol: r'L$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'LSL',
      name: 'Lesotho Loti',
      symbol: 'L',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'LYD',
      name: 'Libyan Dinar',
      symbol: 'LD',
      decimalDigits: 3,
    ),
    CurrencyInfo(
      code: 'MAD',
      name: 'Moroccan Dirham',
      symbol: 'DH',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MDL',
      name: 'Moldovan Leu',
      symbol: 'L',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MGA',
      name: 'Malagasy Ariary',
      symbol: 'Ar',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MKD',
      name: 'Macedonian Denar',
      symbol: 'ден',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MMK',
      name: 'Myanmar Kyat',
      symbol: 'K',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MNT',
      name: 'Mongolian Tögrög',
      symbol: '₮',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MOP',
      name: 'Macanese Pataca',
      symbol: r'MOP$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MRU',
      name: 'Mauritanian Ouguiya',
      symbol: 'UM',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MUR',
      name: 'Mauritian Rupee',
      symbol: '₨',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MVR',
      name: 'Maldivian Rufiyaa',
      symbol: 'Rf',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MWK',
      name: 'Malawian Kwacha',
      symbol: 'MK',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MXN',
      name: 'Mexican Peso',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MYR',
      name: 'Malaysian Ringgit',
      symbol: 'RM',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'MZN',
      name: 'Mozambican Metical',
      symbol: 'MT',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'NAD',
      name: 'Namibian Dollar',
      symbol: r'N$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'NGN',
      name: 'Nigerian Naira',
      symbol: '₦',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'NIO',
      name: 'Nicaraguan Córdoba',
      symbol: r'C$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'NOK',
      name: 'Norwegian Krone',
      symbol: 'kr',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'NPR',
      name: 'Nepalese Rupee',
      symbol: 'Rs',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'NZD',
      name: 'New Zealand Dollar',
      symbol: r'NZ$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'OMR',
      name: 'Omani Rial',
      symbol: 'ر.ع.',
      decimalDigits: 3,
    ),
    CurrencyInfo(
      code: 'PAB',
      name: 'Panamanian Balboa',
      symbol: 'B/.',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'PEN',
      name: 'Peruvian Sol',
      symbol: 'S/',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'PGK',
      name: 'Papua New Guinean Kina',
      symbol: 'K',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'PHP',
      name: 'Philippine Peso',
      symbol: '₱',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'PKR',
      name: 'Pakistani Rupee',
      symbol: 'Rs',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'PLN',
      name: 'Polish Złoty',
      symbol: 'zł',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'PYG',
      name: 'Paraguayan Guaraní',
      symbol: '₲',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'QAR',
      name: 'Qatari Riyal',
      symbol: 'QR',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'RON',
      name: 'Romanian Leu',
      symbol: 'lei',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'RSD',
      name: 'Serbian Dinar',
      symbol: 'din.',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'RUB',
      name: 'Russian Ruble',
      symbol: '₽',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'RWF',
      name: 'Rwandan Franc',
      symbol: 'FRw',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'SAR',
      name: 'Saudi Riyal',
      symbol: '﷼',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SBD',
      name: 'Solomon Islands Dollar',
      symbol: r'SI$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SCR',
      name: 'Seychellois Rupee',
      symbol: '₨',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SDG',
      name: 'Sudanese Pound',
      symbol: '£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SEK',
      name: 'Swedish Krona',
      symbol: 'kr',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SGD',
      name: 'Singapore Dollar',
      symbol: r'S$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SHP',
      name: 'Saint Helena Pound',
      symbol: '£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SLE',
      name: 'Sierra Leonean Leone',
      symbol: 'Le',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SOS',
      name: 'Somali Shilling',
      symbol: 'Sh',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SRD',
      name: 'Surinamese Dollar',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SSP',
      name: 'South Sudanese Pound',
      symbol: '£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'STN',
      name: 'São Tomé and Príncipe Dobra',
      symbol: 'Db',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SVC',
      name: 'Salvadoran Colón',
      symbol: '₡',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SYP',
      name: 'Syrian Pound',
      symbol: '£',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'SZL',
      name: 'Swazi Lilangeni',
      symbol: 'E',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'THB',
      name: 'Thai Baht',
      symbol: '฿',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'TJS',
      name: 'Tajikistani Somoni',
      symbol: 'SM',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'TMT',
      name: 'Turkmenistani Manat',
      symbol: 'T',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'TND',
      name: 'Tunisian Dinar',
      symbol: 'DT',
      decimalDigits: 3,
    ),
    CurrencyInfo(
      code: 'TOP',
      name: 'Tongan Paʻanga',
      symbol: r'T$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'TRY',
      name: 'Turkish Lira',
      symbol: '₺',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'TTD',
      name: 'Trinidad and Tobago Dollar',
      symbol: r'TT$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'TWD',
      name: 'New Taiwan Dollar',
      symbol: r'NT$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'TZS',
      name: 'Tanzanian Shilling',
      symbol: 'TSh',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'UAH',
      name: 'Ukrainian Hryvnia',
      symbol: '₴',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'UGX',
      name: 'Ugandan Shilling',
      symbol: 'USh',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'USD',
      name: 'United States Dollar',
      symbol: r'$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'UYU',
      name: 'Uruguayan Peso',
      symbol: r'$U',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'UZS',
      name: 'Uzbekistani Som',
      symbol: 'soʻm',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'VES',
      name: 'Venezuelan Bolívar',
      symbol: 'Bs',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'VND',
      name: 'Vietnamese Đồng',
      symbol: '₫',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'VUV',
      name: 'Vanuatu Vatu',
      symbol: 'VT',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'WST',
      name: 'Samoan Tālā',
      symbol: r'WS$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'XAF',
      name: 'Central African CFA Franc',
      symbol: 'FCFA',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'XCD',
      name: 'East Caribbean Dollar',
      symbol: r'EC$',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'XCG',
      name: 'Caribbean Guilder',
      symbol: 'Cg',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'XOF',
      name: 'West African CFA Franc',
      symbol: 'F CFA',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'XPF',
      name: 'CFP Franc',
      symbol: '₣',
      decimalDigits: 0,
    ),
    CurrencyInfo(
      code: 'YER',
      name: 'Yemeni Rial',
      symbol: '﷼',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ZMW',
      name: 'Zambian Kwacha',
      symbol: 'ZK',
      decimalDigits: 2,
    ),
    CurrencyInfo(
      code: 'ZWG',
      name: 'Zimbabwe Gold',
      symbol: 'ZiG',
      decimalDigits: 2,
    ),
  ];

  static final Map<String, CurrencyInfo> _byCode = {
    for (final c in all) c.code: c,
  };

  static CurrencyInfo? byCode(String code) => _byCode[code.toUpperCase()];

  static int decimalDigits(String code) => byCode(code)?.decimalDigits ?? 2;

  static List<CurrencyInfo> popular() => [
    for (final code in popularCodes)
      if (byCode(code) case final CurrencyInfo info) info,
  ];

  /// Popular matches first (in [popularCodes] order), then other matches by code.
  /// An empty query returns every currency in that same order.
  static List<CurrencyInfo> search(String query) {
    final normalized = query.trim().toLowerCase();
    final popularRank = <String, int>{
      for (var i = 0; i < popularCodes.length; i++) popularCodes[i]: i,
    };

    bool matches(CurrencyInfo currency) {
      if (normalized.isEmpty) return true;
      return currency.code.toLowerCase().contains(normalized) ||
          currency.name.toLowerCase().contains(normalized) ||
          currency.symbol.toLowerCase().contains(normalized);
    }

    final popularHits = <CurrencyInfo>[];
    final otherHits = <CurrencyInfo>[];
    for (final currency in all) {
      if (!matches(currency)) continue;
      if (popularRank.containsKey(currency.code)) {
        popularHits.add(currency);
      } else {
        otherHits.add(currency);
      }
    }

    popularHits.sort(
      (a, b) => popularRank[a.code]!.compareTo(popularRank[b.code]!),
    );
    otherHits.sort((a, b) => a.code.compareTo(b.code));
    return [...popularHits, ...otherHits];
  }
}
