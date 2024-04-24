class CurrencyHelper {
  static const Map<String, String> _currencySymbols = {
    'usd': '\$',
    'eur': '€',
  };

  static String getSymbol(String currencyCode) {
    return _currencySymbols[currencyCode] ?? '';
  }
}
