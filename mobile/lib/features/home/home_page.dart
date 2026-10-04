import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/bickri_card_api.dart';
import '../auth/auth_page.dart';
import '../card/card_page.dart';
import '../profile/profile_page.dart';
import '../money/money_page.dart';
import '../security/security_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int index = 0;
  Map<String, dynamic>? status;
  bool loading = true;
  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    if (Supabase.instance.client.auth.currentSession != null) {
      try { status = await BickriCardApi(Supabase.instance.client).status(); } catch (_) {}
    }
    if (mounted) setState(() => loading = false);
  }
  @override Widget build(BuildContext context) {
    if (Supabase.instance.client.auth.currentSession == null) {
      return Scaffold(body: SafeArea(child: Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 96, height: 96,
            decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(30)),
            child: const Icon(Icons.credit_card, color: AppTheme.gold, size: 52)),
          const SizedBox(height: 24),
          const Text('Bickri Card', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppTheme.navy)),
          const SizedBox(height: 8),
          const Text('Votre carte. Votre portefeuille. Votre liberté.', textAlign: TextAlign.center),
          const SizedBox(height: 30),
          FilledButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthPage())),
            child: const Text('Commencer')),
        ]),
      ))));
    }
    final pages = [
      Dashboard(status: status, loading: loading),
      const CardPage(),
      TransactionsPage(status: status),
      const ProfilePage(),
    ];
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (v) => setState(() => index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.credit_card_outlined), selectedIcon: Icon(Icons.credit_card), label: 'Carte'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Activité'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
class Dashboard extends StatelessWidget {
  final Map<String, dynamic>? status;
  final bool loading;
  const Dashboard({super.key, this.status, required this.loading});
  @override Widget build(BuildContext context) {
    final account = status?['account'] as Map<String, dynamic>?;
    final balance = account?['available_balance'] ?? 0;
    final currency = account?['currency'] ?? 'XOF';
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20,22,20,30), children: [
      const Row(children: [
        CircleAvatar(backgroundColor: AppTheme.navy, child: Icon(Icons.person, color: AppTheme.gold)),
        Spacer(), Icon(Icons.notifications_none),
      ]),
      const SizedBox(height: 24),
      const Text('Bonjour 👋'),
      const Text('Votre espace Bickri Card', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: AppTheme.navy)),
      const SizedBox(height: 22),
      Container(padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppTheme.navy, AppTheme.blue]),
          borderRadius: BorderRadius.circular(26)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Solde disponible', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Text(loading ? '••••••' : balance.toString() + ' ' + currency.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 31, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          const Row(children: [
            Text('Bickri Card', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold)),
            Spacer(), Text('XOF', style: TextStyle(color: Colors.white70)),
          ]),
        ])),
      const SizedBox(height: 22),
      const Text('Actions rapides', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _ActionButton(icon: Icons.add_card, label: 'Recharger', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoneyPage())))),
        const SizedBox(width: 12),
        Expanded(child: _ActionButton(icon: Icons.swap_horiz, label: 'Transférer', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoneyPage(transfer: true))))),
        const SizedBox(width: 12),
        Expanded(child: _ActionButton(icon: Icons.shield_outlined, label: 'Sécurité', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityPage())))),
      ]),
    ]));
  }
}
class _ActionButton extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});
  @override Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
    child: Column(children: [Icon(icon, color: AppTheme.blue), const SizedBox(height: 7), Text(label, textAlign: TextAlign.center)]),
  ));
}
class TransactionsPage extends StatelessWidget {
  final Map<String, dynamic>? status;
  const TransactionsPage({super.key, this.status});
  @override Widget build(BuildContext context) {
    final items = (status?['transactions'] as List?) ?? [];
    return SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Activité', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.navy)),
      const SizedBox(height: 18),
      if (items.isEmpty)
        const Card(child: Padding(padding: EdgeInsets.all(22), child: Text('Aucune transaction pour le moment.')))
      else
        ...items.map((item) {
          final tx = Map<String, dynamic>.from(item as Map);
          return Card(child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
            title: Text((tx['merchant_name'] ?? tx['type'] ?? 'Transaction').toString()),
            subtitle: Text((tx['status'] ?? '').toString()),
            trailing: Text(tx['amount'].toString() + ' ' + (tx['currency'] ?? '').toString()),
          ));
        }),
    ]));
  }
}
