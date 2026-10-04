import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MoneyPage extends StatelessWidget {
  final bool transfer;
  const MoneyPage({super.key, this.transfer = false});

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(transfer ? 'Transférer' : 'Recharger')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      Text(transfer ? 'Envoyer de l’argent' : 'Recharger mon compte',
        style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppTheme.navy)),
      const SizedBox(height: 8),
      Text(transfer
        ? 'Les transferts seront exécutés par le partenaire de paiement connecté.'
        : 'Choisissez un moyen de paiement pris en charge par Bickri Card.'),
      const SizedBox(height: 24),
      TextField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Montant', suffixText: 'XOF')),
      const SizedBox(height: 14),
      if (transfer)
        const TextField(decoration: InputDecoration(labelText: 'Destinataire (téléphone ou identifiant)')),
      if (!transfer)
        Card(child: Column(children: const [
          ListTile(leading: Icon(Icons.phone_android), title: Text('Mobile Money'), subtitle: Text('Connexion au prestataire à configurer')),
          ListTile(leading: Icon(Icons.account_balance), title: Text('Virement bancaire'), subtitle: Text('Connexion au partenaire à configurer')),
        ])),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cette opération sera activée après connexion du partenaire de paiement.'))),
        child: Text(transfer ? 'Continuer' : 'Choisir le moyen de paiement'),
      ),
    ]),
  );
}
