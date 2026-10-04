import 'package:flutter/material.dart';

void main() {
  runApp(const BickriCardApp());
}

class BickriCardApp extends StatelessWidget {
  const BickriCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bickri Card',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2A5B)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bickri Card')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.credit_card, size: 72),
              const SizedBox(height: 20),
              const Text(
                'Bienvenue sur Bickri Card',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Votre portefeuille et votre future carte, dans une seule application.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
