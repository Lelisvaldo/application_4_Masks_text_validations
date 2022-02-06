import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo _Blank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mascaras'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (!RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$')
                    .hasMatch(text ?? '')) {
                  return "Write CPF valid.";
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'CPF',
              ),
              inputFormatters: [
                MaskInput('###.###.###-##'),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (text) {
                if (!RegExp(r'[a-zA-Z0-9.-_]+@[a-zA-Z0-9-_]+\..+')
                    .hasMatch(text ?? '')) {
                  return "Write E-mail valid.";
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaskInput extends TextInputFormatter {
  final String mask;

  MaskInput(this.mask);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {

    var value = newValue.text.replaceAll(RegExp(r'\D'), '');
    var formatted = mask;
    for (var i = 0; i < value.length; i++) {
      formatted = formatted.replaceFirst('#', value[i]);
    }
    final lastHash = formatted.indexOf('#');
    if (lastHash != -1) {
      formatted = formatted.characters.getRange(0, lastHash).join();
      if (RegExp(r'\D$').hasMatch(formatted)) {
        formatted =
            formatted.split('').getRange(0, formatted.length - 1).join();
      }
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      ),
    );
  }
}
