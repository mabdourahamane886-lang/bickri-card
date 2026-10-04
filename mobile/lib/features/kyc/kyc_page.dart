import 'package:file_picker/file_picker.dart';
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
  String status = 'not_started';
  bool saving = false;
  final Map<String, String> uploaded = {};

  Future<void> saveProfile() async {
    setState(() => saving = true);
    try {
      final result = await BickriCardApi(Supabase.instance.client).saveProfile(
        legalName: name.text.trim(), phone: phone.text.trim(), countryCode: country);
      setState(() => status = (result['profile']?['kyc_status'] ?? 'pending').toString());
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil KYC enregistré.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally { if (mounted) setState(() => saving = false); }
  }

  Future<void> pickAndUpload(String documentType) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf'],
    );
    if (file == null) return;
    final length = await file.length();
    if (length == null || length > 6 * 1024 * 1024) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fichier trop volumineux. Maximum: 6 Mo.')));
      return;
    }
    final ext = (file.extension ?? 'bin').toLowerCase();
    final path = user.id + '/' + documentType + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.' + ext;
    try {
      final bytes = await file.readAsBytes();
      await Supabase.instance.client.storage.from('bickri-kyc').uploadBinary(
        path, bytes, fileOptions: FileOptions(contentType: _mime(ext), upsert: false));
      await Supabase.instance.client.from('bickri_kyc_documents').insert({
        'user_id': user.id, 'document_type': documentType, 'storage_path': path, 'status': 'pending',
      });
      setState(() => uploaded[documentType] = path);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(documentType + ' envoyé de façon sécurisée.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de l’envoi: $e')));
    }
  }

  String _mime(String ext) {
    switch (ext) {
      case 'pdf': return 'application/pdf';
      case 'png': return 'image/png';
      case 'webp': return 'image/webp';
      default: return 'image/jpeg';
    }
  }

  Widget documentButton(String type, String label, IconData icon) {
    final done = uploaded.containsKey(type);
    return Card(child: ListTile(
      leading: Icon(icon, color: done ? Colors.green : AppTheme.blue),
      title: Text(label),
      subtitle: Text(done ? 'Document envoyé — en attente de vérification' : 'PDF, JPG, PNG ou WebP — 6 Mo max'),
      trailing: IconButton(
        icon: Icon(done ? Icons.check_circle : Icons.upload_file),
        onPressed: () => pickAndUpload(type),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vérification KYC')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Vérifiez votre identité', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, color: AppTheme.navy)),
      const SizedBox(height: 8),
      const Text('Vos documents sont stockés dans un espace privé et ne sont pas publiquement accessibles.'),
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
      documentButton('national_id', 'Pièce d’identité', Icons.badge_outlined),
      documentButton('proof_of_address', 'Justificatif de domicile', Icons.home_outlined),
      documentButton('selfie', 'Selfie de vérification', Icons.face_outlined),
      const SizedBox(height: 12),
      Text('Statut KYC : $status', style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 18),
      FilledButton(onPressed: saving ? null : saveProfile, child: Text(saving ? 'Enregistrement…' : 'Enregistrer mon profil')),
    ]),
  );
}
