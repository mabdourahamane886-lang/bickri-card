import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  bool signUp = false;

  Future<void> submit() async {
    setState(() => loading = true);
    try {
      final auth = Supabase.instance.client.auth;
      if (signUp) {
        await auth.signUp(email: email.text.trim(), password: password.text);
      } else {
        await auth.signInWithPassword(email: email.text.trim(), password: password.text);
      }
      if (mounted) Navigator.pop(context);
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 42),
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(22)),
            child: const Icon(Icons.credit_card, color: AppTheme.gold, size: 38),
          ),
          const SizedBox(height: 28),
          Text(signUp ? 'Créer votre compte' : 'Bienvenue sur Bickri Card',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.navy)),
          const SizedBox(height: 8),
          Text(signUp ? 'Commencez votre parcours Bickri Card.' : 'Connectez-vous pour accéder à votre portefeuille.'),
          const SizedBox(height: 28),
          TextField(controller: email, keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Adresse e-mail')),
          const SizedBox(height: 14),
          TextField(controller: password, obscureText: true,
            decoration: const InputDecoration(labelText: 'Mot de passe')),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: loading ? null : submit,
            child: Text(loading ? 'Chargement…' : (signUp ? 'Créer mon compte' : 'Se connecter')),
          ),
          TextButton(
            onPressed: loading ? null : () => setState(() => signUp = !signUp),
            child: Text(signUp ? 'J’ai déjà un compte' : 'Créer un compte'),
          ),
        ],
      ),
    ),
  );
}
