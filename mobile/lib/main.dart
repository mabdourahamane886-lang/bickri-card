import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (AppConfig.configured) {
    await Supabase.initialize(url: AppConfig.supabaseUrl, anonKey: AppConfig.supabasePublishableKey);
  }
  runApp(const BickriCardApp());
}

class BickriCardApp extends StatelessWidget {
  const BickriCardApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Bickri Card',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    home: AppConfig.configured ? const HomePage() : const _ConfigurationPage(),
  );
}

class _ConfigurationPage extends StatelessWidget {
  const _ConfigurationPage();
  @override Widget build(BuildContext context) => Scaffold(
    body: Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Icon(Icons.settings, size: 64),
        SizedBox(height: 18),
        Text('Configuration Bickri Card', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Lancez Flutter avec SUPABASE_URL et SUPABASE_PUBLISHABLE_KEY.', textAlign: TextAlign.center),
      ]),
    )),
  );
}
