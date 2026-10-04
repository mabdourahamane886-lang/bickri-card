import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});
  @override State<SecurityPage> createState() => _SecurityPageState();
}
class _SecurityPageState extends State<SecurityPage> {
  bool biometric = false;
  bool alerts = true;
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sécurité')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Sécurité du compte', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppTheme.navy)),
      const SizedBox(height: 16),
      Card(child: Column(children: [
        SwitchListTile(
          value: biometric, onChanged: (v) => setState(() => biometric = v),
          title: const Text('Connexion biométrique'), subtitle: const Text('Prévu pour empreinte ou Face ID')),
        SwitchListTile(
          value: alerts, onChanged: (v) => setState(() => alerts = v),
          title: const Text('Alertes de transaction'), subtitle: const Text('Recevoir une alerte pour les opérations')),
      ])),
      const SizedBox(height: 14),
      const Card(child: ListTile(
        leading: Icon(Icons.lock_outline), title: Text('Protection des données'),
        subtitle: Text('Les secrets serveur ne sont jamais stockés dans l’application.'))),
      const Card(child: ListTile(
        leading: Icon(Icons.phonelink_lock), title: Text('Appareil'),
        subtitle: Text('Les sessions doivent rester protégées et révoquées en cas de perte.'))),
    ]),
  );
}
