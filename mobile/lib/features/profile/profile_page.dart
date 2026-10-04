import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../kyc/kyc_page.dart';
import '../security/security_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Profil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.navy)),
      const SizedBox(height: 20),
      Card(child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(user?.email ?? 'Utilisateur'),
        subtitle: const Text('Compte Bickri Card'),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.verified_user_outlined),
        title: const Text('Vérification KYC'),
        subtitle: const Text('Complétez votre profil pour demander une carte.'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KycPage())),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.security_outlined),
        title: const Text('Sécurité'),
        subtitle: const Text('Sessions et paramètres de sécurité'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityPage())),
      )),
      const SizedBox(height: 20),
      OutlinedButton.icon(
        onPressed: () => Supabase.instance.client.auth.signOut(),
        icon: const Icon(Icons.logout),
        label: const Text('Se déconnecter'),
      ),
    ]));
  }
}
