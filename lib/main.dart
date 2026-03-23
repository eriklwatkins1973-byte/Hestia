import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 copilot/fetch-resources-by-county-id
import 'services/resource_service.dart';
import 'models/resource.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  runApp(const HestiaApp());
}

/// Returns the globally initialised [SupabaseClient].
SupabaseClient get supabase => Supabase.instance.client;

=======
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

main
class HestiaApp extends StatelessWidget {
  const HestiaApp({super.key});

  @override
  Widget build(BuildContext context) {
 copilot/fetch-resources-by-county-id
    return MaterialApp(
      title: 'Hestia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
        ),
        useMaterial3: true,
      ),
      home: const ResourceListScreen(),
    );
  }
}

/// Displays the list of resources for the currently selected county.
class ResourceListScreen extends StatefulWidget {
  const ResourceListScreen({super.key});

  @override
  State<ResourceListScreen> createState() => _ResourceListScreenState();
}

class _ResourceListScreenState extends State<ResourceListScreen> {
  late final ResourceService _resourceService;
  List<Resource> _resources = [];
  bool _isLoading = false;
  String? _selectedCountyId;

  @override
  void initState() {
    super.initState();
    _resourceService = ResourceService(supabase);
  }

  Future<void> _loadResources(String selectedCountyId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resources =
          await _resourceService.fetchResourcesByCountyId(selectedCountyId);
      setState(() {
        _resources = resources;
        _selectedCountyId = selectedCountyId;
      });
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading resources: ${e.message}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hestia Resources'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _resources.isEmpty
              ? const Center(child: Text('Select a county to view resources.'))
              : ListView.builder(
                  itemCount: _resources.length,
                  itemBuilder: (context, index) {
                    final resource = _resources[index];
                    return ListTile(
                      title: Text(resource.name),
                      subtitle: Text(resource.description),
                      trailing: Text(resource.type),
                    );
                  },
                ),

    return MaterialApp.router(
      title: 'Hestia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
main
    );
  }
}
