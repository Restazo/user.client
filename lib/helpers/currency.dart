class CurrencyHelper {
  static const Map<String, String> _currencySymbols = {
    'usd': '\$',
    'eur': '€',
    // Add more currencies here
  };

  static String getSymbol(String currencyCode) {
    return _currencySymbols[currencyCode] ?? '';
  }
}
