import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/bickri_card_api.dart';
import '../../core/theme/app_theme.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});
  @override State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  bool requesting = false;

  Future<void> request(String type) async {
    setState(() => requesting = true);
    try {
      final result = await BickriCardApi(Supabase.instance.client).requestCard(cardType: type);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']?.toString() ?? 'Demande envoyée.')),
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demande impossible: $e')));
    } finally {
      if (mounted) setState(() => requesting = false);
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Ma carte', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.navy)),
        const SizedBox(height: 20),
        Container(
          height: 220,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [AppTheme.navy, Color(0xFF1261C9)]),
            borderRadius: BorderRadius.circular(28),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('BICKRI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
              Spacer(), Icon(Icons.contactless, color: Colors.white, size: 30),
            ]),
            Spacer(),
            Text('••••  ••••  ••••  ••••', style: TextStyle(color: Colors.white, fontSize: 21, letterSpacing: 2)),
            SizedBox(height: 14),
            Row(children: [
              Text('BICKRI CARD', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
              Spacer(), Text('VISA', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)),
            ]),
          ]),
        ),
        const SizedBox(height: 24),
        const Text('Commander une carte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(child: ListTile(
          leading: const Icon(Icons.phone_android),
          title: const Text('Carte virtuelle'),
          subtitle: const Text('Après validation KYC et émission par un partenaire.'),
          trailing: FilledButton(onPressed: requesting ? null : () => request('virtual'), child: const Text('Demander')),
        )),
        Card(child: ListTile(
          leading: const Icon(Icons.credit_card),
          title: const Text('Carte physique'),
          subtitle: const Text('Émission et livraison selon le partenaire.'),
          trailing: FilledButton(onPressed: requesting ? null : () => request('physical'), child: const Text('Demander')),
        )),
      ],
    ),
  );
}
