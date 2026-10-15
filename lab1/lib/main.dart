import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversie Monedă',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
        ),
        fontFamily: 'Roboto',
      ),
      home: const CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();

  // fiecare valută are un curs (raportat la EUR) și un simbol/emoji de steag
  final Map<String, Map<String, dynamic>> _currencyData = {
    'EUR': {'rate': 1.0, 'flag': '🇪🇺', 'symbol': '€'},
    'USD': {'rate': 1.08, 'flag': '🇺🇸', 'symbol': '\$'},
    'MDL': {'rate': 19.5, 'flag': '🇲🇩', 'symbol': 'L'},
    'RON': {'rate': 4.97, 'flag': '🇷🇴', 'symbol': 'lei'},
    'GBP': {'rate': 0.84, 'flag': '🇬🇧', 'symbol': '£'},
  };

  late List<String> _currencies;
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';
  String _resultValue = '';
  String _resultLine = '';
  bool _hasResult = false;

  @override
  void initState() {
    super.initState();
    _currencies = _currencyData.keys.toList();
  }

  void _convertCurrency() {
    final String inputText = _amountController.text.replaceAll(',', '.');
    final double? amount = double.tryParse(inputText);

    if (amount == null) {
      setState(() {
        _resultValue = '—';
        _resultLine = 'Introdu o sumă validă.';
        _hasResult = true;
      });
      return;
    }

    final double fromRate = _currencyData[_fromCurrency]!['rate'];
    final double toRate = _currencyData[_toCurrency]!['rate'];
    final double amountInEur = amount / fromRate;
    final double converted = amountInEur * toRate;
    final String symbol = _currencyData[_toCurrency]!['symbol'];

    setState(() {
      _resultValue = '$symbol ${converted.toStringAsFixed(2)}';
      _resultLine =
      '${amount.toStringAsFixed(2)} $_fromCurrency = ${converted.toStringAsFixed(2)} $_toCurrency';
      _hasResult = true;
    });
  }

  // Interschimbă valuta sursă cu cea destinație

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      if (_hasResult) _convertCurrency();
    });
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F1FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3DEFF)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
          borderRadius: BorderRadius.circular(16),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          items: _currencies.map((String currency) {
            final flag = _currencyData[currency]!['flag'];
            return DropdownMenuItem<String>(
              value: currency,
              child: Text('$flag  $currency'),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      body: Stack(
        children: [
          // --- Fundal: header gradient cu forme decorative ---
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, const Color(0xFF9B8CFF)],
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                Positioned(
                  left: -30,
                  top: 60,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.currency_exchange_rounded,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conversie Monedă',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Cursuri actualizate manual',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- Cardul principal ---
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.18),
                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'SUMA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                        const Divider(height: 32),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildCurrencyDropdown(
                              value: _fromCurrency,
                              onChanged: (String? newValue) {
                                setState(() => _fromCurrency = newValue!);
                              },
                            ),
                            GestureDetector(
                              onTap: _swapCurrencies,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.35),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.swap_horiz_rounded,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                            _buildCurrencyDropdown(
                              value: _toCurrency,
                              onChanged: (String? newValue) {
                                setState(() => _toCurrency = newValue!);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _convertCurrency,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bolt_rounded, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Convertește',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Rezultat ---
                  if (_hasResult)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: primaryColor.withOpacity(0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: primaryColor, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                'Rezultat',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _resultValue,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _resultLine,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}