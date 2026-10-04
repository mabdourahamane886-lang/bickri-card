import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/bickri_card_api.dart';
import '../../core/theme/app_theme.dart';

class KycPage extends StatefulWidget {
  const KycPage({super.key});
  @override State<KycPage> createState() => _KycPageState();
}
class _KycPageState extends State<KycPage> {
  final name = TextEditingController();
  final phone = TextEditingController();
  String country = 'NE';
  bool saving = false;
  String status = 'not_started';

  Future<void> save() async {
    setState(() => saving = true);
    try {
      final result = await BickriCardApi(Supabase.instance.client).saveProfile(
        legalName: name.text.trim(), phone: phone.text.trim(), countryCode: country);
      setState(() => status = (result['profile']?['kyc_status'] ?? 'pending').toString());
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil enregistré. Vous pouvez poursuivre la vérification.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally { if (mounted) setState(() => saving = false); }
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vérification KYC')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Vérifiez votre identité', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppTheme.navy)),
      const SizedBox(height: 8),
      const Text('Ces informations servent à préparer votre compte et votre future carte.'),
      const SizedBox(height: 22),
      TextField(controller: name, decoration: const InputDecoration(labelText: 'Nom légal complet')),
      const SizedBox(height: 14),
      TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Téléphone')),
      const SizedBox(height: 14),
      DropdownButtonFormField<String>(
        value: country,
        decoration: const InputDecoration(labelText: 'Pays'),
        items: const [DropdownMenuItem(value: 'NE', child: Text('🇳🇪 Niger'))],
        onChanged: (v) => setState(() => country = v ?? 'NE'),
      ),
      const SizedBox(height: 18),
      Card(child: Column(children: [
        ListTile(leading: const Icon(Icons.badge_outlined), title: const Text('Pièce d’identité'), subtitle: const Text('À ajouter dans l’étape suivante')),
        ListTile(leading: const Icon(Icons.home_outlined), title: const Text('Justificatif de domicile'), subtitle: const Text('À ajouter dans l’étape suivante')),
        ListTile(leading: const Icon(Icons.face_outlined), title: const Text('Selfie de vérification'), subtitle: const Text('À ajouter dans l’étape suivante')),
      ])),
      const SizedBox(height: 12),
      Text('Statut : $status', style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 18),
      FilledButton(onPressed: saving ? null : save, child: Text(saving ? 'Enregistrement…' : 'Enregistrer mon profil')),
    ]),
  );
}
