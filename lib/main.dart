import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'router.dart';

// TODO: Replace these placeholder values with your Supabase project credentials.
// Find them at: https://supabase.com/dashboard → Settings → API
const _supabaseUrl = 'YOUR_SUPABASE_URL';
const _supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );
  runApp(const HestiaApp());
}

class HestiaApp extends StatelessWidget {
  const HestiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hestia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
