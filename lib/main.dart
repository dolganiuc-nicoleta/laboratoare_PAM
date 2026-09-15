
import 'package:flutter/material.dart';

// Punctul de intrare al aplicației - orice app Flutter pornește de aici
void main() {
  runApp(const MyApp());
}

// Widget-ul rădăcină al aplicației. E "stateless" pentru că el însuși
// nu se schimbă niciodată - doar definește tema și ce ecran se afișează.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversie Monedă',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const CurrencyConverterPage(),
    );
  }
}

// Acesta e ecranul principal. E "StatefulWidget" pentru că are date
// (suma introdusă, valutele alese, rezultatul) care se SCHIMBĂ în timp,
// de exemplu când utilizatorul apasă butonul sau alege altă valută.
class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

// Aici trăiește toată "starea" (state) a ecranului - variabilele care
// se pot schimba și logica ce reacționează la evenimente (click-uri etc.)
class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  // Controller-ul citește ce a scris utilizatorul în TextField
  final TextEditingController _amountController = TextEditingController();

  // Cursuri valutare fixe, raportate la 1 EUR (le poți schimba cum vrei)
  final Map<String, double> _ratesToEur = {
    'EUR': 1.0,
    'USD': 1.08,
    'MDL': 19.5,
    'RON': 4.97,
    'GBP': 0.84,
  };

  // Lista de valute disponibile în dropdown-uri (cheile din harta de mai sus)
  late List<String> _currencies;

  // Valutele selectate curent - implicit EUR -> USD
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';

  // Rezultatul conversiei, afișat în Text. Începe gol.
  String _result = '';

  @override
  void initState() {
    super.initState();
    _currencies = _ratesToEur.keys.toList();
  }

  // Funcția apelată când se apasă ElevatedButton
  void _convertCurrency() {
    // Citim textul din TextField și încercăm să-l transformăm în număr
    final String inputText = _amountController.text.replaceAll(',', '.');
    final double? amount = double.tryParse(inputText);

    // Validare simplă: dacă nu s-a introdus un număr valid, arătăm un mesaj
    if (amount == null) {
      setState(() {
        _result = 'Introdu o sumă validă.';
      });
      return;
    }

    // Logica de conversie: convertim mai întâi suma în EUR (moneda de bază),
    // apoi din EUR în moneda destinație.
    final double amountInEur = amount / _ratesToEur[_fromCurrency]!;
    final double converted = amountInEur * _ratesToEur[_toCurrency]!;

    // setState() spune Flutter-ului: "s-a schimbat ceva, redesenează ecranul"
    setState(() {
      _result =
      '${amount.toStringAsFixed(2)} $_fromCurrency = ${converted.toStringAsFixed(2)} $_toCurrency';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversie Monedă'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Câmpul pentru sumă ---
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Suma',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // --- Cele două DropdownButton, unul lângă altul ---
            Row(
              children: [
                // Dropdown pentru moneda sursă
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromCurrency,
                    isExpanded: true,
                    items: _currencies.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    // onChanged e evenimentul apelat când utilizatorul alege altă valută
                    onChanged: (String? newValue) {
                      setState(() {
                        _fromCurrency = newValue!;
                      });
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(Icons.arrow_forward),
                ),
                // Dropdown pentru moneda destinație
                Expanded(
                  child: DropdownButton<String>(
                    value: _toCurrency,
                    isExpanded: true,
                    items: _currencies.map((String currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _toCurrency = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- Butonul de conversie ---
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Convertește'),
            ),
            const SizedBox(height: 24),

            // --- Rezultatul ---
            Text(
              _result,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}